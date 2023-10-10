drop database farmacia;
create database farmacia;
use farmacia;

create table tipoProduto(
	id int primary key auto_increment,
    nome varchar(150) not null
);

create table fabricante(
	id int primary key auto_increment,
    nome varchar(150) not null,
    cnpj varchar(50) not null
);

create table produto(
	id int primary key auto_increment,
    tipoProduto_fk int not null,
    designacao text not null,
    fabricante_fk int not null,
    precoVenda double(10,2) not null,
    foreign key (tipoProduto_fk) references tipoProduto(id),
    foreign key (fabricante_fk) references fabricante(id)
);

create table composto(
	id int primary key auto_increment,
    composto text not null
);

create table composicao_produto(
	id int primary key auto_increment,
    produto_fk int not null,
    composto_fk int not null,
    foreign key (produto_fk) references produto(id),
    foreign key (composto_fk) references composto(id)
);

create table contribuinte(
	id int primary key auto_increment,
    nome varchar(200) not null,
    cpf text not null
);

create table cliente(
	id int primary key auto_increment,
    nome varchar(200) not null,
    cep text not null,
    numCasa text not null,
    complemento text null,
    cpf text not null,
    codPostal text not null,
    localidade text not null,
    contribuinte_fk int not null,
    foreign key (contribuinte_fk) references contribuinte(id)
);

create table telefone(
	id int primary key auto_increment,
    telefone text not null,
    cliente_fk int not null,
    foreign key (cliente_fk) references cliente(id)
);

create table medico(
	id int primary key auto_increment,
    nome varchar(150) not null,
    crm text not null
);

create table compra(
	id int primary key auto_increment,
	cliente_fk int not null,
    dataCompra date not null,
    medico_fk int null,
    totalVenda double(10,2) not null,
    cancelada bool default(false),
    foreign key (cliente_fk) references cliente(id),
    foreign key (medico_fk) references medico(id)
);

create table compra_produto(
	id int primary key auto_increment,
    produto_fk int not null,
    compra_fk int not null,
    foreign key (produto_fk) references produto(id),
    foreign key (compra_fk) references compra(id)
);

insert into tipoProduto(nome) values ('Shampoo'),('Condicionador'),('Xarope'),('Anti-alérgico');
insert into fabricante(nome,cnpj) values ('MangeLab','23789457820'),('RobertoChem','3458964390');
insert into produto(tipoProduto_fk,designacao,fabricante_fk,precoVenda) values
(1,'Ótimo shampoo',1,18.90),(2,'Condicionador mágico',2,19.99),(3,'Xarope sabor uva',1,12.50),(4,'100% necessário',2,32.90);
insert into composto(composto) values ('Sal, pimenta e tudo que há de bom'),('óleo de anão, crina de sapopemba indiano');
insert into composicao_produto(produto_fk, composto_fk)values
(1,1),(2,2),(3,1),(4,2);
insert into contribuinte(nome,cpf)value('Benonga','27848923');
insert into cliente(nome,cep,numCasa,complemento,cpf,codPostal,localidade,contribuinte_fk) 
values ('Matheus Fuzari','10102321931','32','Apto 42','12315115154','2256426246','Campinas',1),
('Henrique Balieiro','349568306','99',null,'7456745745677','0989080780','Americana',1);
insert into telefone(telefone, cliente_fk) values
('62464564642',1),('6786868686',1),('23424242389',2);
insert into medico(nome,crm) values ('Drauzio','8676jf453'),('Muzy','4f12356127fd');
insert into compra(cliente_fk,dataCompra,medico_fk,totalVenda)
values(1, '2023-10-10',1,(select sum(precoVenda) from produto where id in (1,2))),
(2,'2023-10-10',1,(select sum(precoVenda) from produto where id=3)),
(2,'2023-10-15',2,(select sum(precoVenda) from produto where id=4));
insert into compra_produto(compra_fk,produto_fk)
values (1,1),(1,2),(2,3);

select c.nome,c.cpf,t.telefone from cliente c join telefone t on c.id=t.cliente_fk;
select ct.nome,c.* from compra c join cliente ct on c.cliente_fk=ct.id where ct.nome = "Matheus Fuzari" and c.cancelada=0;
select ct.nome,c.*,p.designacao,p.precoVenda from compra c join cliente ct on c.cliente_fk=ct.id join compra_produto cp on c.id=cp.compra_fk join produto p on cp.produto_fk=p.id where ct.nome = "Matheus Fuzari" and c.cancelada = 0;
select ct.nome,c.* from compra c join cliente ct on c.cliente_fk=ct.id where cancelada = 0  order by c.totalVenda asc;
select ct.nome,c.* from compra c join cliente ct on c.cliente_fk=ct.id where cancelada = 0  order by c.totalVenda desc;
select sum(totalVenda) as FaturamentoDiario,dataCompra from compra where cancelada = 0 group by dataCompra;
select sum(totalVenda) as FaturamentoGeral from compra where cancelada = 0 and dataCompra BETWEEN '2023-10-01' and '2023-10-30';

update produto set precoVenda = 42.90 where id = 4;
update compra set cancelada=true where id = 5;
