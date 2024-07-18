-- Cria uma sequência para gerar os identificadores de pessoa
CREATE SEQUENCE SeqPessoa
    AS INT
    START WITH 1
    INCREMENT BY 1;
GO

-- Tabela de Cadastro de Usuários
CREATE TABLE Usuarios (
    id_usuario INT IDENTITY(1,1) PRIMARY KEY,
    nome NVARCHAR(255) NOT NULL,
    login NVARCHAR(255) NOT NULL UNIQUE,
    senha NVARCHAR(255) NOT NULL
);
GO

-- Tabela de Cadastro de Pessoas (superclasse)
CREATE TABLE Pessoas (
    id_pessoa INT PRIMARY KEY DEFAULT NEXT VALUE FOR SeqPessoa,
    nome NVARCHAR(255) NOT NULL,
    endereco NVARCHAR(255),
    telefone NVARCHAR(20)
);
GO

-- Tabela de Pessoa Física (subclasse de Pessoas)
CREATE TABLE PessoasFisicas (
    id_pessoa_fisica INT PRIMARY KEY,
    cpf CHAR(11) NOT NULL UNIQUE,
    FOREIGN KEY (id_pessoa_fisica) REFERENCES Pessoas(id_pessoa)
);
GO

-- Tabela de Pessoa Jurídica (subclasse de Pessoas)
CREATE TABLE PessoasJuridicas (
    id_pessoa_juridica INT PRIMARY KEY,
    cnpj CHAR(14) NOT NULL UNIQUE,
    FOREIGN KEY (id_pessoa_juridica) REFERENCES Pessoas(id_pessoa)
);
GO

-- Tabela de Cadastro de Produtos
CREATE TABLE Produtos (
    id_produto INT IDENTITY(1,1) PRIMARY KEY,
    nome NVARCHAR(255) NOT NULL,
    quantidade INT NOT NULL,
    preco_venda DECIMAL(10, 2) NOT NULL
);
GO

-- Tabela de Movimentos de Compra
CREATE TABLE MovimentosCompra (
    id_movimento INT IDENTITY(1,1) PRIMARY KEY,
    id_produto INT NOT NULL,
    id_usuario INT NOT NULL,
    id_pessoa_juridica INT NOT NULL,
    quantidade INT NOT NULL,
    preco_unitario DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (id_produto) REFERENCES Produtos(id_produto),
    FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_usuario),
    FOREIGN KEY (id_pessoa_juridica) REFERENCES PessoasJuridicas(id_pessoa_juridica)
);
GO

-- Tabela de Movimentos de Venda
CREATE TABLE MovimentosVenda (
    id_movimento INT IDENTITY(1,1) PRIMARY KEY,
    id_produto INT NOT NULL,
    id_usuario INT NOT NULL,
    id_pessoa_fisica INT NOT NULL,
    quantidade INT NOT NULL,
    preco_venda DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (id_produto) REFERENCES Produtos(id_produto),
    FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_usuario),
    FOREIGN KEY (id_pessoa_fisica) REFERENCES PessoasFisicas(id_pessoa_fisica)
);
GO
