-- Deletar as tabelas na ordem correta para evitar problemas de depend�ncia

-- Deletar tabelas de Movimentos de Venda e Compra
DROP TABLE IF EXISTS MovimentosVenda;
DROP TABLE IF EXISTS MovimentosCompra;
GO

-- Deletar tabelas de Produtos e Usuarios
DROP TABLE IF EXISTS Produtos;
DROP TABLE IF EXISTS Usuarios;
GO

-- Deletar tabelas de Pessoa F�sica e Jur�dica
DROP TABLE IF EXISTS PessoasFisicas;
DROP TABLE IF EXISTS PessoasJuridicas;
GO

-- Deletar a tabela de Pessoas
DROP TABLE IF EXISTS Pessoas;
GO

-- Deletar a sequ�ncia
DROP SEQUENCE IF EXISTS SeqPessoa;
GO

