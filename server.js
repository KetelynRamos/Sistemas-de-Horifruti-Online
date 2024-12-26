const express = require('express');
const mysql = require('mysql2');
const bcrypt = require('bcryptjs');
const bodyParser = require('body-parser');
const path = require('path'); // Importa o módulo 'path' para manipulação de caminhos

const app = express();
app.use(bodyParser.json());  // Para ler o corpo das requisições em JSON
app.use(bodyParser.urlencoded({ extended: true })); // Para ler o corpo das requisições de formulários

// Configurar conexão com o MySQL
const db = mysql.createConnection({
    host: 'localhost',
    user: 'root',       // Seu usuário do MySQL
    password: '4242', // Sua senha do MySQL
    database: 'hortifrut' // Nome do banco de dados
});

db.connect(err => {
    if (err) {
        console.error('Erro ao conectar ao banco de dados:', err);
        return;
    }
    console.log('Conectado ao banco de dados MySQL');
});

// Servir arquivos estáticos da pasta atual
app.use(express.static(path.join(__dirname)));


// Rota para cadastro de usuário
app.post('/register', async (req, res) => {
    const { usuario, cpf, cep, endereco, numero, bairro, complemento, cidade, estado, telefone, senha } = req.body;

    try {
        // Verificar se o CPF já existe no banco de dados
        const [existingUser] = await db.promise().query('SELECT * FROM usuarios WHERE cpf = ?', [cpf]);
        if (existingUser.length > 0) {
            return res.status(400).json({ message: 'CPF já cadastrado!' });
        }

        // Criptografar a senha
        const hashedPassword = await bcrypt.hash(senha, 10);

        // Inserir o usuário no banco de dados
        await db.promise().query('INSERT INTO usuarios (usuario, cpf, cep, endereco, numero, bairro, complemento, cidade, estado, telefone, senha) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)',
            [usuario, cpf, cep, endereco, numero, bairro, complemento, cidade, estado, telefone, hashedPassword]);

        // Redirecionar para a página de confirmação
        res.redirect('/cadastroconfirmado.html'); 
    } catch (error) {
        console.error('Erro ao cadastrar usuário:', error);
        res.status(500).send('Erro ao cadastrar usuário');
    }
});

// Rota para login de usuário
app.post('/login', (req, res) => {
    const { cpf, senha } = req.body;

    // Verificar se o usuário com o CPF existe
    db.query('SELECT * FROM usuarios WHERE cpf = ?', [cpf], async (err, result) => {
        if (err) {
            return res.status(500).json({ message: 'Erro ao consultar usuário', error: err });
        }

        if (result.length === 0) {
            return res.status(400).json({ message: 'CPF ou senha inválidos!' });
        }

        const user = result[0];

        // Comparar a senha fornecida com a senha armazenada
        const isMatch = await bcrypt.compare(senha, user.senha);
        if (!isMatch) {
            return res.status(400).json({ message: 'CPF ou senha inválidos!' });
        }

        // Retorna o nome, cpf e telefone do usuário em JSON
        res.json({
            success: true,
            nome: user.usuario,     // Substitua por `user.nome` se o campo for assim no banco de dados
            cpf: user.cpf,
            telefone: user.telefone
        });
    });
});




// Endpoint para obter produtos
app.get('/api/produtos', (req, res) => {
    res.set('Cache-Control', 'no-store'); // Adiciona cabeçalho para evitar cache
    db.query('SELECT * FROM produtos', (err, results) => {
        if (err) {
            console.error('Erro ao consultar produtos:', err);
            res.status(500).send('Erro ao consultar produtos');
            return;
        }
        res.json(results);
    });
});

// Endpoint para obter um produto específico por ID
app.get('/api/produtos/:id', (req, res) => {
    const produtoId = parseInt(req.params.id); // Converte o ID para um número

    // Consulta ao banco de dados para obter o produto com o ID específico
    db.query('SELECT * FROM produtos WHERE id = ?', [produtoId], (err, results) => {
        if (err) {
            console.error('Erro ao consultar produto:', err);
            res.status(500).send('Erro ao consultar produto');
            return;
        }
        if (results.length > 0) {
            res.json(results[0]); // Retorna o primeiro produto encontrado
        } else {
            res.status(404).send('Produto não encontrado');
        }
    });
});


app.listen(3300, () => {
    console.log('Servidor rodando na porta 3300');
});
