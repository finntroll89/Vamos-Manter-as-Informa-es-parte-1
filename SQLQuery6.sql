USE [Loja]
GO

-- Inserir dados na tabela de usuários
INSERT INTO [dbo].[Usuarios] (nome, login, senha) 
VALUES 
('Operador 1', 'op1', 'op1'),
('Operador 2', 'op2', 'op2');
GO

-- Inserir dados na tabela de produtos
INSERT INTO [dbo].[Produtos] (nome, quantidade, preco_venda)
VALUES 
('Produto 1', 100, 10.50),
('Produto 2', 200, 20.00);
GO

-- Inserir dados na tabela de pessoas
INSERT INTO [dbo].[Pessoas] (nome, endereco, telefone)
VALUES 
('Pessoa Fisica 1', 'Endereco 1', '123456789'),
('Pessoa Juridica 1', 'Endereco 2', '987654321');
GO

-- Inserir dados na tabela de pessoas físicas
INSERT INTO [dbo].[PessoasFisicas] (id_pessoa_fisica, cpf)
VALUES 
((SELECT id_pessoa FROM [dbo].[Pessoas] WHERE nome = 'Pessoa Fisica 1'), '12345678901');
GO

-- Inserir dados na tabela de pessoas jurídicas
INSERT INTO [dbo].[PessoasJuridicas] (id_pessoa_juridica, cnpj)
VALUES 
((SELECT id_pessoa FROM [dbo].[Pessoas] WHERE nome = 'Pessoa Juridica 1'), '12345678000101');
GO

-- Inserir movimentações de compra
INSERT INTO [dbo].[MovimentosCompra] (id_produto, id_usuario, id_pessoa_juridica, quantidade, preco_unitario)
VALUES 
((SELECT id_produto FROM [dbo].[Produtos] WHERE nome = 'Produto 1'), 
 (SELECT id_usuario FROM [dbo].[Usuarios] WHERE login = 'op1'), 
 (SELECT id_pessoa_juridica FROM [dbo].[PessoasJuridicas] WHERE id_pessoa_juridica = (SELECT id_pessoa FROM [dbo].[Pessoas] WHERE nome = 'Pessoa Juridica 1')), 
 10, 10.50);
GO

-- Inserir movimentações de venda
INSERT INTO [dbo].[MovimentosVenda] (id_produto, id_usuario, id_pessoa_fisica, quantidade, preco_venda)
VALUES 
((SELECT id_produto FROM [dbo].[Produtos] WHERE nome = 'Produto 1'), 
 (SELECT id_usuario FROM [dbo].[Usuarios] WHERE login = 'op1'), 
 (SELECT id_pessoa_fisica FROM [dbo].[PessoasFisicas] WHERE id_pessoa_fisica = (SELECT id_pessoa FROM [dbo].[Pessoas] WHERE nome = 'Pessoa Fisica 1')), 
 5, 10.50);
GO

-- Consultas sobre os dados inseridos
-- Dados completos de pessoas físicas
SELECT * FROM [dbo].[PessoasFisicas]
INNER JOIN [dbo].[Pessoas] ON [PessoasFisicas].id_pessoa_fisica = [Pessoas].id_pessoa;
GO

-- Dados completos de pessoas jurídicas
SELECT * FROM [dbo].[PessoasJuridicas]
INNER JOIN [dbo].[Pessoas] ON [PessoasJuridicas].id_pessoa_juridica = [Pessoas].id_pessoa;
GO

-- Movimentações de entrada, com produto, fornecedor, quantidade, preço unitário e valor total
SELECT 
    [MovimentosCompra].id_movimento,
    [Produtos].nome AS produto,
    [Pessoas].nome AS fornecedor,
    [MovimentosCompra].quantidade,
    [MovimentosCompra].preco_unitario,
    ([MovimentosCompra].quantidade * [MovimentosCompra].preco_unitario) AS valor_total
FROM 
    [dbo].[MovimentosCompra]
INNER JOIN [dbo].[Produtos] ON [MovimentosCompra].id_produto = [Produtos].id_produto
INNER JOIN [dbo].[PessoasJuridicas] ON [MovimentosCompra].id_pessoa_juridica = [PessoasJuridicas].id_pessoa_juridica
INNER JOIN [dbo].[Pessoas] ON [PessoasJuridicas].id_pessoa_juridica = [Pessoas].id_pessoa;
GO

-- Movimentações de saída, com produto, comprador, quantidade, preço unitário e valor total
SELECT 
    [MovimentosVenda].id_movimento,
    [Produtos].nome AS produto,
    [Pessoas].nome AS comprador,
    [MovimentosVenda].quantidade,
    [MovimentosVenda].preco_venda,
    ([MovimentosVenda].quantidade * [MovimentosVenda].preco_venda) AS valor_total
FROM 
    [dbo].[MovimentosVenda]
INNER JOIN [dbo].[Produtos] ON [MovimentosVenda].id_produto = [Produtos].id_produto
INNER JOIN [dbo].[PessoasFisicas] ON [MovimentosVenda].id_pessoa_fisica = [PessoasFisicas].id_pessoa_fisica
INNER JOIN [dbo].[Pessoas] ON [PessoasFisicas].id_pessoa_fisica = [Pessoas].id_pessoa;
GO

-- Valor total das entradas agrupadas por produto
SELECT 
    [Produtos].nome AS produto,
    SUM([MovimentosCompra].quantidade * [MovimentosCompra].preco_unitario) AS valor_total_entrada
FROM 
    [dbo].[MovimentosCompra]
INNER JOIN [dbo].[Produtos] ON [MovimentosCompra].id_produto = [Produtos].id_produto
GROUP BY 
    [Produtos].nome;
GO

-- Valor total das saídas agrupadas por produto
SELECT 
    [Produtos].nome AS produto,
    SUM([MovimentosVenda].quantidade * [MovimentosVenda].preco_venda) AS valor_total_saida
FROM 
    [dbo].[MovimentosVenda]
INNER JOIN [dbo].[Produtos] ON [MovimentosVenda].id_produto = [Produtos].id_produto
GROUP BY 
    [Produtos].nome;
GO

-- Operadores que não efetuaram movimentações de entrada (compra)
SELECT 
    [Usuarios].nome AS operador
FROM 
    [dbo].[Usuarios]
LEFT JOIN [dbo].[MovimentosCompra] ON [Usuarios].id_usuario = [MovimentosCompra].id_usuario
WHERE 
    [MovimentosCompra].id_usuario IS NULL;
GO

-- Valor total de entrada, agrupado por operador
SELECT 
    [Usuarios].nome AS operador,
    SUM([MovimentosCompra].quantidade * [MovimentosCompra].preco_unitario) AS valor_total_entrada
FROM 
    [dbo].[MovimentosCompra]
INNER JOIN [dbo].[Usuarios] ON [MovimentosCompra].id_usuario = [Usuarios].id_usuario
GROUP BY 
    [Usuarios].nome;
GO

-- Valor total de saída, agrupado por operador
SELECT 
    [Usuarios].nome AS operador,
    SUM([MovimentosVenda].quantidade * [MovimentosVenda].preco_venda) AS valor_total_saida
FROM 
    [dbo].[MovimentosVenda]
INNER JOIN [dbo].[Usuarios] ON [MovimentosVenda].id_usuario = [Usuarios].id_usuario
GROUP BY 
    [Usuarios].nome;
GO

-- Valor médio de venda por produto, utilizando média ponderada
SELECT 
    [Produtos].nome AS produto,
    SUM([MovimentosVenda].quantidade * [MovimentosVenda].preco_venda) / SUM([MovimentosVenda].quantidade) AS preco_medio_venda
FROM 
    [dbo].[MovimentosVenda]
INNER JOIN [dbo].[Produtos] ON [MovimentosVenda].id_produto = [Produtos].id_produto
GROUP BY 
    [Produtos].nome;
GO
