create database bebidas_db;
use bebidas_db;

create table setores(
id_setor int auto_increment primary key,
nome_setor varchar(100) not null
);

create table fornecedores(
id_fornecedor int auto_increment primary key,
nome varchar(100) not null,
telefone varchar(20) not null,
email varchar(100) 
);

create table usuarios (
id_usuario int auto_increment primary key,
nome varchar(100) not null,
login varchar(50) not null unique,
senha varchar(255) not null,
id_setor int,
FOREIGN KEY (id_setor) references setores(id_setor)
);


create table insumos(
id_insumo int auto_increment primary key,
nome varchar(100) not null,
categoria varchar(50) not null,
lote varchar(50) not null,
validade date not null,
unidade_medida varchar(20) not null,
quantidade decimal(10,2) not null,
estoque_minimo decimal(10,2) not null,
id_fornecedor int not null,

foreign key (id_fornecedor)
references fornecedores(id_fornecedor)
);

create table movimentacoes (
id_movimentacao int auto_increment primary key, 
id_insumo int not null,
id_usuario int not null,
id_setor int not null,
tipo_movimentacao ENUM ('RETIRADA', 'REPOSICAO') not null,
quantidade decimal (10,2) not null,
data_movimentacao date not null,

FOREIGN KEY (id_insumo)
        REFERENCES insumos(id_insumo),
        
    FOREIGN KEY (id_usuario)
        REFERENCES usuarios(id_usuario),
        
    FOREIGN KEY (id_setor)
        REFERENCES setores(id_setor)
);

CREATE TABLE alertas_estoque (
    id_alerta INT AUTO_INCREMENT PRIMARY KEY,
    id_insumo INT NOT NULL,
    data_alerta DATETIME DEFAULT CURRENT_TIMESTAMP,
    mensagem VARCHAR(255) NOT NULL,
    status_alerta ENUM('PENDENTE','VISUALIZADO') DEFAULT 'PENDENTE',

    FOREIGN KEY (id_insumo)
        REFERENCES insumos(id_insumo)
);

CREATE TABLE auditoria (
    id_auditoria INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT NOT NULL,
    acao VARCHAR(100) NOT NULL,
    tabela_afetada VARCHAR(50) NOT NULL,
    data_acao DATETIME DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (id_usuario)
        REFERENCES usuarios(id_usuario)
);

CREATE TABLE lotes_producao (
    id_lote INT AUTO_INCREMENT PRIMARY KEY,
    codigo_lote VARCHAR(50) NOT NULL UNIQUE,
    produto VARCHAR(100) NOT NULL,
    quantidade_produzida DECIMAL(10,2) NOT NULL,
    data_producao DATE NOT NULL,
    status_lote ENUM('EM_PRODUCAO','FINALIZADO','REPROVADO')
        DEFAULT 'EM_PRODUCAO'
);

CREATE TABLE lote_insumos (
    id_lote INT NOT NULL,
    id_insumo INT NOT NULL,
    quantidade_utilizada DECIMAL(10,2) NOT NULL,

    PRIMARY KEY (id_lote, id_insumo),

    FOREIGN KEY (id_lote)
        REFERENCES lotes_producao(id_lote),

    FOREIGN KEY (id_insumo)
        REFERENCES insumos(id_insumo)
);

CREATE TABLE produtos (
    id_produto INT AUTO_INCREMENT PRIMARY KEY,
    nome_produto VARCHAR(100) NOT NULL,
    categoria VARCHAR(50),
    unidade_medida VARCHAR(20),
    estoque_atual DECIMAL(10,2) DEFAULT 0
);

CREATE TABLE producao_produtos (
    id_producao INT AUTO_INCREMENT PRIMARY KEY,
    id_lote INT NOT NULL,
    id_produto INT NOT NULL,
    quantidade DECIMAL(10,2) NOT NULL,

    FOREIGN KEY (id_lote)
        REFERENCES lotes_producao(id_lote),

    FOREIGN KEY (id_produto)
        REFERENCES produtos(id_produto)
);

INSERT INTO setores (nome_setor) 
VALUES
('Produção'), 
('Envase'), 
('Almoxarifado');

INSERT INTO usuarios 
(nome, login, senha, id_setor)
VALUES
('Maria Silva', 'maria', '123456', 1),
('João Santos', 'joao', '123456', 2),
('Ana Costa', 'ana', '123456', 3);

INSERT INTO fornecedores (nome, telefone, email)
VALUES
('Açúcar Nordeste', '71999990001', 'contato@acucarnordeste.com'),
('PET Brasil', '71999990002', 'vendas@petbrasil.com'),
('Essências Tropicais', '71999990003', 'comercial@essencias.com');

INSERT INTO insumos
(nome, categoria, lote, validade, unidade_medida,
quantidade, estoque_minimo, id_fornecedor)
VALUES

('Açúcar Refinado', 'Matéria-Prima', 'AC001', '2027-12-31', 'kg', 1000, 200, 1),
('Concentrado de Guaraná', 'Matéria-Prima', 'CG001', '2027-08-15', 'litros', 300, 50, 3),
('Garrafa PET 2L', 'Embalagem', 'PET001', '2029-01-01', 'unidades', 5000, 1000, 2);


INSERT INTO movimentacoes
(id_insumo,id_usuario,id_setor,
tipo_movimentacao,quantidade,data_movimentacao)
VALUES
(1,1,1,'RETIRADA',100,'2026-06-10'),
(2,2,2,'RETIRADA',50,'2026-06-11'),
(3,3,3,'REPOSICAO',1000,'2026-06-12');

INSERT INTO alertas_estoque
(id_insumo, mensagem, status_alerta)
VALUES
(1, 'Estoque de açúcar próximo do mínimo.', 'PENDENTE'),
(2, 'Concentrado de guaraná abaixo do nível ideal.', 'PENDENTE');

INSERT INTO auditoria
(id_usuario, acao, tabela_afetada)
VALUES
(1, 'Cadastro de insumo', 'insumos'),
(2, 'Retirada de material', 'movimentacoes'),
(3, 'Reposição de estoque', 'movimentacoes');

INSERT INTO lotes_producao
(codigo_lote, produto, quantidade_produzida,
data_producao, status_lote)
VALUES
('LT001', 'Refrigerante de Guaraná 2L', 1000,
'2026-06-10', 'FINALIZADO'),

('LT002', 'Refrigerante de Guaraná 2L', 1200,
'2026-06-12', 'EM_PRODUCAO');

INSERT INTO lote_insumos
(id_lote, id_insumo, quantidade_utilizada)
VALUES
(1, 1, 200),
(1, 2, 50),

(2, 1, 250),
(2, 2, 60),
(2, 3, 1200);





 
