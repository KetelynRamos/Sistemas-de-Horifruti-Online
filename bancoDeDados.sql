-- Criação do banco de dados hortifrut
CREATE DATABASE hortifrut;

-- Usar o banco de dados hortifrut
USE hortifrut;

-- Criação da tabela usuarios
CREATE TABLE usuarios (
    id INT AUTO_INCREMENT PRIMARY KEY,   -- ID único para cada usuário
    usuario VARCHAR(50) NOT NULL,        -- Nome de usuário
    cpf VARCHAR(14) NOT NULL UNIQUE,     -- CPF com máscara
    cep VARCHAR(9) NOT NULL,             -- CEP
    endereco VARCHAR(255) NOT NULL,      -- Endereço completo
    numero VARCHAR(10) NOT NULL,         -- Número da residência
    bairro VARCHAR(50) NOT NULL,         -- Bairro
    complemento VARCHAR(100),            -- Complemento (opcional)
    cidade VARCHAR(50) NOT NULL,         -- Cidade
    estado VARCHAR(2) NOT NULL,          -- Estado (sigla)
    telefone VARCHAR(15) NOT NULL,       -- Telefone
    senha VARCHAR(255) NOT NULL,         -- Senha (armazenada como hash para segurança)
    data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP -- Data de criação do registro
);


INSERT INTO usuarios (usuario, cpf, cep, endereco, numero, bairro, complemento, cidade, estado, telefone, senha)
VALUES ('João Silva', '123.456.789-10', '12345-678', 'Rua das Flores', '100', 'Centro', '', 'São Paulo', 'SP', '(11) 98765-4321', 'hash_da_senha_aqui');


--criando tabela produtos
CREATE TABLE produtos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    preco DECIMAL(10, 2) NOT NULL,
    qtdKg DECIMAL(10, 2) NOT NULL,
    imagem VARCHAR(255)  -- Coluna para armazenar o caminho da imagem
);

INSERT INTO produtos (nome, preco, qtdKg, imagem) VALUES
('Laranja', 2.80, 1, 'http://localhost:3300/src/laranja.jpeg'),
('Maçã', 1.90, 1, 'http://localhost:3300/src/maca.jpeg'),
('Uva', 5.99, 0.5, 'http://localhost:3300/src/uva.jpeg'),
('Abacaxi', 3.90, 1, 'http://localhost:3300/src/abacaxi.jpg');


-- Criação da tabela pagamentos
CREATE TABLE pagamentos (
    id INT AUTO_INCREMENT PRIMARY KEY,               -- ID único para cada pagamento
    id_usuario INT NOT NULL,                          -- ID do usuário que realiza o pagamento
    id_produto INT NOT NULL,                          -- ID do produto comprado
    metodo_pagamento ENUM('Cartão de Crédito', 'Boleto') NOT NULL, -- Método de pagamento
    status_pagamento ENUM('Concluído', 'Pendente') NOT NULL, -- Status do pagamento
    data_hora TIMESTAMP DEFAULT CURRENT_TIMESTAMP,    -- Data e hora do pagamento
    FOREIGN KEY (id_usuario) REFERENCES usuarios(id), -- Relacionamento com a tabela de usuários
    FOREIGN KEY (id_produto) REFERENCES produtos(id)  -- Relacionamento com a tabela de produtos
);

INSERT INTO pagamentos (id_usuario, id_produto, metodo_pagamento, status_pagamento)
VALUES (1, 1, 'Cartão de Crédito', 'Concluído');
--para uso no terminal executar db
npm init -y
npm install express mysql2 bcryptjs body-parser

--rodar servidor com node
node server.js

--teste
curl -X POST http://localhost:4000/register -H "Content-Type: application/json" -d '{
    "usuario": "usuarioTeste",
    "cpf": "123.456.789-00",
    "cep": "12345-678",
    "endereco": "Rua Teste",
    "numero": "123",
    "bairro": "Bairro Teste",
    "complemento": "Apto 1",
    "cidade": "Cidade Teste",
    "estado": "Estado Teste",
    "telefone": "11987654321",
    "senha": "senhaSegura"
}'

--realiza login
curl -X POST http://localhost:4000/login -H "Content-Type: application/json" -d '{
    "cpf": "123.456.789-00", 
    "senha": "senhaSegura"
}'


DELETE FROM usuarios WHERE cpf = '123.456.789-00';
SELECT * FROM usuarios;
DROP TABLE IF EXISTS produtos;

--link para acessar servidor
http://localhost:3000