USE [Loja];
GO

-- Deletar tabelas antigas, se existirem
IF OBJECT_ID('dbo.MovimentosVenda', 'U') IS NOT NULL
    DROP TABLE dbo.MovimentosVenda;
IF OBJECT_ID('dbo.MovimentosCompra', 'U') IS NOT NULL
    DROP TABLE dbo.MovimentosCompra;
IF OBJECT_ID('dbo.Usuarios', 'U') IS NOT NULL
    DROP TABLE dbo.Usuarios;
IF OBJECT_ID('dbo.Produtos', 'U') IS NOT NULL
    DROP TABLE dbo.Produtos;
IF OBJECT_ID('dbo.PessoasJuridicas', 'U') IS NOT NULL
    DROP TABLE dbo.PessoasJuridicas;
IF OBJECT_ID('dbo.PessoasFisicas', 'U') IS NOT NULL
    DROP TABLE dbo.PessoasFisicas;
IF OBJECT_ID('dbo.Pessoas', 'U') IS NOT NULL
    DROP TABLE dbo.Pessoas;
GO

-- Criar tabela Pessoas
CREATE TABLE dbo.Pessoas (
    id_pessoa INT IDENTITY(1,1) PRIMARY KEY,
    nome NVARCHAR(255) NOT NULL,
    endereco NVARCHAR(255),
    telefone NVARCHAR(20)
);
GO

-- Criar tabela PessoasFisicas
CREATE TABLE dbo.PessoasFisicas (
    id_pessoa_fisica INT PRIMARY KEY,
    cpf CHAR(11) NOT NULL UNIQUE,
    FOREIGN KEY (id_pessoa_fisica) REFERENCES dbo.Pessoas(id_pessoa)
);
GO

-- Criar tabela PessoasJuridicas
CREATE TABLE dbo.PessoasJuridicas (
    id_pessoa_juridica INT PRIMARY KEY,
    cnpj CHAR(14) NOT NULL UNIQUE,
    FOREIGN KEY (id_pessoa_juridica) REFERENCES dbo.Pessoas(id_pessoa)
);
GO

-- Criar tabela Produtos
CREATE TABLE dbo.Produtos (
    id_produto INT IDENTITY(1,1) PRIMARY KEY,
    nome NVARCHAR(100) NOT NULL,
    preco DECIMAL(10, 2) NOT NULL
);
GO

-- Criar tabela Usuarios
CREATE TABLE dbo.Usuarios (
    id_usuario INT IDENTITY(1,1) PRIMARY KEY,
    nome NVARCHAR(100) NOT NULL,
    senha NVARCHAR(100) NOT NULL
);
GO

-- Criar tabela MovimentosCompra
CREATE TABLE dbo.MovimentosCompra (
    id_movimento INT IDENTITY(1,1) PRIMARY KEY,
    id_produto INT NOT NULL,
    id_fornecedor INT NOT NULL,
    quantidade INT NOT NULL,
    preco_unitario DECIMAL(10, 2) NOT NULL,
    data_movimento DATETIME NOT NULL,
    FOREIGN KEY (id_produto) REFERENCES dbo.Produtos(id_produto),
    FOREIGN KEY (id_fornecedor) REFERENCES dbo.PessoasJuridicas(id_pessoa_juridica)
);
GO

-- Criar tabela MovimentosVenda
CREATE TABLE dbo.MovimentosVenda (
    id_movimento INT IDENTITY(1,1) PRIMARY KEY,
    id_produto INT NOT NULL,
    id_cliente INT NOT NULL,
    quantidade INT NOT NULL,
    preco_unitario DECIMAL(10, 2) NOT NULL,
    data_movimento DATETIME NOT NULL,
    FOREIGN KEY (id_produto) REFERENCES dbo.Produtos(id_produto),
    FOREIGN KEY (id_cliente) REFERENCES dbo.PessoasFisicas(id_pessoa_fisica)
);
GO

-- Inserir dados em Pessoas, PessoasFisicas e PessoasJuridicas
INSERT INTO dbo.Pessoas (nome, endereco, telefone) VALUES
('João Silva', 'Rua A, 123', '11999999999'),
('Maria Oliveira', 'Rua B, 456', '11988888888'),
('Empresa XYZ', 'Avenida C, 789', '1133333333');

INSERT INTO dbo.PessoasFisicas (id_pessoa_fisica, cpf) VALUES
((SELECT id_pessoa FROM dbo.Pessoas WHERE nome = 'João Silva'), '12345678901'),
((SELECT id_pessoa FROM dbo.Pessoas WHERE nome = 'Maria Oliveira'), '98765432101');

INSERT INTO dbo.PessoasJuridicas (id_pessoa_juridica, cnpj) VALUES
((SELECT id_pessoa FROM dbo.Pessoas WHERE nome = 'Empresa XYZ'), '12345678000123');

-- Inserir dados em Produtos
INSERT INTO dbo.Produtos (nome, preco) VALUES
('Maçã', 3.50),
('Banana', 2.00),
('Laranja', 4.00);

-- Inserir dados em Usuarios
INSERT INTO dbo.Usuarios (nome, senha) VALUES
('op1', 'op1'),
('op2', 'op2');

-- Inserir dados em MovimentosCompra
INSERT INTO dbo.MovimentosCompra (id_produto, id_fornecedor, quantidade, preco_unitario, data_movimento) VALUES
((SELECT id_produto FROM dbo.Produtos WHERE nome = 'Maçã'), 
 (SELECT id_pessoa_juridica FROM dbo.PessoasJuridicas WHERE cnpj = '12345678000123'), 
 100, 3.00, GETDATE()),
((SELECT id_produto FROM dbo.Produtos WHERE nome = 'Banana'), 
 (SELECT id_pessoa_juridica FROM dbo.PessoasJuridicas WHERE cnpj = '12345678000123'), 
 200, 1.50, GETDATE()),
((SELECT id_produto FROM dbo.Produtos WHERE nome = 'Laranja'), 
 (SELECT id_pessoa_juridica FROM dbo.PessoasJuridicas WHERE cnpj = '12345678000123'), 
 150, 3.50, GETDATE());

-- Inserir dados em MovimentosVenda
INSERT INTO dbo.MovimentosVenda (id_produto, id_cliente, quantidade, preco_unitario, data_movimento) VALUES
((SELECT id_produto FROM dbo.Produtos WHERE nome = 'Maçã'), 
 (SELECT id_pessoa_fisica FROM dbo.PessoasFisicas WHERE cpf = '12345678901'), 
 10, 3.50, GETDATE()),
((SELECT id_produto FROM dbo.Produtos WHERE nome = 'Banana'), 
 (SELECT id_pessoa_fisica FROM dbo.PessoasFisicas WHERE cpf = '98765432101'), 
 20, 2.00, GETDATE()),
((SELECT id_produto FROM dbo.Produtos WHERE nome = 'Laranja'), 
 (SELECT id_pessoa_fisica FROM dbo.PessoasFisicas WHERE cpf = '12345678901'), 
 15, 4.00, GETDATE());
