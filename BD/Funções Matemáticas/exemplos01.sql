create database if not exists sprint3;

use sprint3;

create table cliente(
id_cliente  int not null auto_increment,
nome   varchar(100),
endereco    varchar(100),
cep   char(9),
numEnd      varchar(45),
genero char(1),
salario decimal(10,2),
primary key(id));

create table produto(
id int not null auto_increment,
nome varchar(100),
preco_unitario  decimal(10,2),
primary key(id)
);

create table pedido(
id   int not null auto_increment,
data_pedido   date,
fkcliente     int,
primary key(id),
foreign key (fkcliente) references cliente(id)
) auto_increment=1000;

create table pedido_item(
fkpedido    int not null,
fkproduto   int not null,
quantidade  decimal(10,3),
valor_unitario  decimal(10,2),
primary key(fkpedido, fkproduto),
foreign key(fkpedido) references pedido(id),
foreign key(fkproduto) references produto(id)
);


INSERT INTO cliente (nome) VALUES
		('Empresa ABC LTDA'),
		('Companhia XYZ S.A.'),
		('Serviços de Tecnologia EFG Ltda.'),
		('Comércio de Alimentos GHI Ltda.'),
		('Transportadora JKL S.A.'),
		('Consultoria MNO LTDA'),
		('Fabricação de Produtos PQR S.A.'),
		('Agropecuária STU LTDA'),
		('Indústria de Cosméticos VWX S.A.'),
		('Construtora YZ Ltda.');
        
INSERT INTO produto (nome, preco_unitario) VALUES
	('Tênis de Skate', 129.99),
	('Camiseta Estampada', 49.99),
	('Boné de Marca', 39.99),
	('Celular Gamer', 999.99),
	('Fone de Ouvido Bluetooth', 79.99),
	('Mochila Escolar com Estampa', 69.99),
	('Skate Completo', 149.99),
	('Calça Jeans Rasgada', 79.99),
	('Sneakers de Marca', 89.99),
	('Pulseira Inteligente', 59.99);     
  
INSERT INTO pedido (data_pedido, fkcliente) VALUES
	('2024-04-01', 1),
	('2024-04-02', 2),
	('2024-04-03', 3),
	('2024-04-04', 4),
	('2024-04-05', 5),
	('2024-04-06', 6);    

INSERT INTO pedido_item (fkpedido, fkproduto, quantidade, valor_unitario) VALUES
		(1000, 1, 2, 129.99), 
		(1000, 2, 1, 49.99),  
		(1001, 4, 1, 999.99), 
		(1001, 5, 1, 79.99),  
		(1002, 7, 1, 149.99),
		(1002, 8, 1, 79.99),
		(1003, 9, 1, 89.99),
		(1003, 10, 1, 59.99),
		(1004, 2, 2, 49.99),
		(1004, 6, 1, 69.99),
		(1005, 1, 1, 129.99),
		(1005, 4, 1, 999.99);
  
-- funções matematicas


update cliente set genero = 'm', salario = 100.99
	where id = 1;

update cliente set genero = 'm', salario = 79.99
	where id = 2;
 
update cliente set genero = 'f', salario = 99.99
	where id = 3;
    
update cliente set genero = 'f', salario = 9.99
	where id = 4;
    

-- contar quantos registros existem na tabela pedido item 
select count(*) from pedido_item;

-- contar quantos registros distintos existem na table pedido item 
select count(distinct fkproduto) from pedido_item;

-- max / min preco unitario na tabela pedido item 
select max(valor_unitario) maior, min(valor_unitario) menor
from pedido_item;

-- max preco unitario na tabela pedido item exibindo o produto
select fkproduto, max(valor_unitario) maior
from pedido_item
group by fkproduto;

-- selecionar com o nome dos pedidos
select nome, max(valor_unitario) maior
from pedido_item pi 
inner join produto pr on pr.id = pi.fkproduto
group by nome;

select fkproduto, nome, max(valor_unitario) maior
from pedido_item pi 
inner join produto pr on pr.id = pi.fkproduto
group by fkproduto, nome;

-- retorna somente items com max preco unitario 
select fkpedido, fkproduto, nome, valor_unitario
from pedido_item pi 
inner join produto pr on pr.id = pi.fkproduto
where valor_unitario = (select max(valor_unitario) from pedido_item);

-- valor total de cada pedido
select fkpedido, sum(valor_unitario*quantidade) valor_total
from pedido_item pi
inner join produto pr on pr.id = pi.fkproduto
group by fkpedido;

-- valor total de cada pedido arredondamento para 2 casas decimais 
select fkpedido, round(sum(valor_unitario*quantidade),2) valor_total
from pedido_item pi
inner join produto pr on pr.id = pi.fkproduto
group by fkpedido;

-- valor total de cada pedido truncado para 1 casas decimais 
select fkpedido, truncate(sum(valor_unitario*quantidade),1) valor_total
from pedido_item pi
inner join produto pr on pr.id = pi.fkproduto
group by fkpedido;


-- AVG irá fazer a média aritmética(se usa como por exemplo em calculo de energia)

select fkpedido, AVG(valor_unitario*0.35*quantidade) valor_medio,
round(AVG(valor_unitario*0.35*quantidade),1) valor_arredondado,
truncate (AVG(valor_unitario*0.35*quantidade),1) valor_truncate01,
round(truncate (AVG(valor_unitario*0.35*quantidade),3),2) valor_truncate02
from pedido_item pi
inner join produto pr on pr.id = pi.fkproduto
group by fkpedido;



select fkpedido, round(AVG(valor_unitario*0.35*quantidade),1) valor_medio
from pedido_item pi
inner join produto pr on pr.id = pi.fkproduto
group by fkpedido;


-- nome do cliente, numero, numero do pedido, valor total do pedido
-- valor medio do pedido, qtde itens comprados no produto
-- pedidos 
select 
    cli.nome as cliente, 
    ped.id as pedido,
    SUM(pei.quantidade * pei.valor_unitario) as vl_total,
    AVG(pei.quantidade * pei.valor_unitario) as vl_medio,
    COUNT(pei.fkpedido) as qtde
from cliente cli
inner join pedido ped ON ped.fkcliente = cli.id
INNER JOIN pedido_item pei ON pei.fkpedido = ped.id
where pei.valor_unitario > 90
GROUP BY cliente, pedido;

select fkpedido, count(*)
from pedido_item
group by fkpedido
having count(*) = 2;

-- selecionando com o having
select
    cli.nome as cliente, 
    ped.id as pedido,
    sum(pei.quantidade * pei.valor_unitario) as vl_total,
    avg(pei.quantidade * pei.valor_unitario) as vl_medio,
    count(pei.fkpedido) as qtde
from cliente cli
inner join pedido ped on ped.fkcliente = cli.id
inner join pedido_item pei on pei.fkpedido = ped.id
group by cli.nome, ped.id
having vl_medio > 90;


-- where com having 
select 
    cli.nome as cliente, 
    ped.id as pedido,
    SUM(pei.quantidade * pei.valor_unitario) as vl_total,
    AVG(pei.quantidade * pei.valor_unitario) as vl_medio,
    COUNT(pei.fkpedido) as qtde
from cliente cli
inner join pedido ped on ped.fkcliente = cli.id
inner join pedido_item pei on pei.fkpedido = ped.id
where pei.valor_unitario > 60
group by cliente, pedido
having vl_medio <90;

-- Selecionar nome do cliente, numero pedido, valor total pedido, valor medido pedido, qtde itens comprados 
-- calculando somente produtos cujo valor unitario seja maior que a media de valores unitarios de todos os 
-- produtos com ou sem vendas 
select 
    cli.nome as cliente, 
    ped.id as pedido,
    SUM(pei.quantidade * pei.valor_unitario) as vl_total,
    AVG(pei.quantidade * pei.valor_unitario) as vl_medio,
    COUNT(pei.fkpedido) as qtde
from cliente cli
inner join pedido ped on ped.fkcliente = cli.id
inner join pedido_item pei on pei.fkpedido = ped.id
where (pei.quantidade*pei.valor_unitario) > (select avg(preco_unitario) from produto)
group by cli.nome, ped.id;

select * from produto;
update produto set preco_unitario = 700 where id = 4;


-- update com inner join (hmmm interessante...)
update pedido_item pei
inner join produto pro on pro.id = pei.fkproduto
set pei.valor_unitario = pro.preco_unitario;

/*
desafioo
*/

select 
    cli.nome as nome_cliente, 
    ped.id as numero_pedido,
    SUM(pei.quantidade * pei.valor_unitario) as valor_total,
    AVG(pei.quantidade * pei.valor_unitario) as valor_medio,
    COUNT(pei.fkpedido) as qtde,
    aqui
from cliente cli
inner join pedido ped on ped.fkcliente = cli.id
inner join pedido_item pei on pei.fkpedido = ped.id
group by cli.nome, ped.id
having aqui;

select AVG(pei.quantidade * pei.valor_unitario) as x from pedido_item pei;


-- select @@sql_mode;

-- ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION

-- Incluir a restrição na variável sql_mode

-- SET sql_mode = concat('ONLY_FULL_GROUP_BY, ',@@sql_mode);

-- Retirar a restrição na variável sql_mode
