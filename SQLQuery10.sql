USE [Loja];
GO

-- Excluir tabelas, se existirem, para evitar erros de referência
IF OBJECT_ID('dbo.MovimentosVenda', 'U') IS NOT NULL DROP TABLE dbo.MovimentosVenda;
IF OBJECT_ID('dbo.MovimentosCompra', 'U') IS NOT NULL DROP TABLE dbo.MovimentosCompra;
IF OBJECT_ID('dbo.Produtos', 'U') IS NOT NULL DROP TABLE dbo.Produtos;
IF OBJECT_ID('dbo.Usuarios', 'U') IS NOT NULL DROP TABLE dbo.Usuarios;
IF OBJECT_ID('dbo.PessoasFisicas', 'U') IS NOT NULL DROP TABLE dbo.PessoasFisicas;
IF OBJECT_ID('dbo.PessoasJuridicas', 'U') IS NOT NULL DROP TABLE dbo.PessoasJuridicas;
IF OBJECT_ID('dbo.Pessoas', 'U') IS NOT NULL DROP TABLE dbo.Pessoas;
GO

