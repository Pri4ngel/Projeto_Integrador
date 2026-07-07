CREATE DATABASE bebidas_db;
USE bebidas_db;

CREATE TABLE setores (
    id_setor INT AUTO_INCREMENT PRIMARY KEY,
    nome_setor VARCHAR(100) NOT NULL,
    responsavel VARCHAR(100) NOT NULL -- Adicionado conforme o DER
);

CREATE TABLE fornecedores (
    id_fornecedor INT AUTO_INCREMENT PRIMARY KEY,
    razao_social VARCHAR(150) NOT NULL, -- Alterado conforme o DER
    cnpj VARCHAR(18) NOT NULL UNIQUE,   -- Alterado conforme o DER
    telefone VARCHAR(15) NOT NULL
    -- Email removido pois não consta no DER
);

CREATE TABLE usuarios (
    id_usuario INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    login VARCHAR(50) NOT NULL UNIQUE,
    senha VARCHAR(255) NOT NULL,
    cargo VARCHAR(50) NOT NULL -- Adicionado conforme o DER
    -- id_setor removido daqui, pois no DER o usuário não pertence a um setor fixo
);

CREATE TABLE insumos (
    id_insumo INT AUTO_INCREMENT PRIMARY KEY,
    nome_insumo VARCHAR(100) NOT NULL,    -- Alterado conforme o DER
    lote VARCHAR(50) NOT NULL,
    data_validade DATE NULL,             -- Alterado conforme o DER
    quantidade_atual DECIMAL(10,2) NOT NULL, -- Alterado conforme o DER
    quantidade_minima DECIMAL(10,2) NOT NULL, -- Alterado conforme o DER
    unidade_medida VARCHAR(10) NOT NULL,  -- Alterado para VARCHAR(10) conforme DER
    id_fornecedor INT NOT NULL,
    FOREIGN KEY (id_fornecedor) REFERENCES fornecedores(id_fornecedor)
    -- Categoria removida pois não consta no DER
);

CREATE TABLE movimentacoes (
    id_movimentacao INT AUTO_INCREMENT PRIMARY KEY, 
    tipo_movimentacao ENUM('REPOSICAO', 'RETIRADA') NOT NULL, -- Alterado conforme ordem do DER
    quantidade DECIMAL(10,2) NOT NULL,
    data_operacao DATETIME DEFAULT CURRENT_TIMESTAMP, -- Alterado para DATETIME conforme DER
    id_insumo INT NOT NULL,
    id_usuario INT NOT NULL,
    id_setor INT NOT NULL,
    observacao VARCHAR(255) NULL, -- Adicionado para bater com o Diagrama de Classes
    FOREIGN KEY (id_insumo) REFERENCES insumos(id_insumo),
    FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario),
    FOREIGN KEY (id_setor) REFERENCES setores(id_setor)
);

-- As tabelas abaixo não estão no DER, mas atendem aos Casos de Uso. 
-- Foram mantidas e atualizadas com os novos nomes de campos para não quebrar o sistema:

CREATE TABLE alertas_estoque (
    id_alerta INT AUTO_INCREMENT PRIMARY KEY,
    id_insumo INT NOT NULL,
    data_alerta DATETIME DEFAULT CURRENT_TIMESTAMP,
    mensagem VARCHAR(255) NOT NULL,
    status_alerta ENUM('PENDENTE','VISUALIZADO') DEFAULT 'PENDENTE',
    FOREIGN KEY (id_insumo) REFERENCES insumos(id_insumo)
);

CREATE TABLE auditoria (
    id_auditoria INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT NOT NULL,
    acao VARCHAR(100) NOT NULL,
    tabela_afetada VARCHAR(50) NOT NULL,
    data_acao DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario)
);

CREATE TABLE lotes_producao (
    id_lote INT AUTO_INCREMENT PRIMARY KEY,
    codigo_lote VARCHAR(50) NOT NULL UNIQUE,
    quantidade_produzida DECIMAL(10,2) NOT NULL,
    data_producao DATE NOT NULL,
    status_lote ENUM('EM_PRODUCAO','FINALIZADO','REPROVADO') DEFAULT 'EM_PRODUCAO'
);

CREATE TABLE lote_insumos (
    id_lote INT NOT NULL,
    id_insumo INT NOT NULL,
    quantidade_utilizada DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (id_lote, id_insumo),
    FOREIGN KEY (id_lote) REFERENCES lotes_producao(id_lote),
    FOREIGN KEY (id_insumo) REFERENCES insumos(id_insumo)
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
    FOREIGN KEY (id_lote) REFERENCES lotes_producao(id_lote),
    FOREIGN KEY (id_produto) REFERENCES produtos(id_produto)
);

-- ====================================================
-- INSERÇÃO DE DADOS AJUSTADA AO DER E DIAGRAMAS
-- ====================================================

-- 1. SETORES (Adicionado o campo 'responsavel' do DER)
INSERT INTO setores (nome_setor, responsavel) VALUES
('Produção', 'Carlos Souza'), 
('Envase', 'Juliana Lima'), 
('Almoxarifado', 'Marcos Rocha');

-- 2. USUÁRIOS (Removido 'id_setor' e adicionado 'cargo' do DER)
INSERT INTO usuarios (nome, login, senha, cargo) VALUES
('Maria Silva', 'maria', '123456', 'Operador de Produção'),
('Thiago Souza', 'thiago', '123456', 'Supervisor de Qualidade'),
('João Santos', 'joao', '123456', 'Auxiliar de Envase'),
('David Oto', 'david', '123456', 'Técnico de Manutenção'),
('Ana Costa', 'ana', '123456', 'Almoxarife'),
('Cristina Oliveira', 'cristiana', '123456', 'Conferente de Estoque');

-- 3. FORNECEDORES (Mudou para 'razao_social', adicionou 'cnpj' e removeu 'email' conforme o DER)
INSERT INTO fornecedores (razao_social, cnpj, telefone) VALUES
('DoceBrasil Ltda', '12.345.678/0001-01', '71999990001'),
('PlastickPack Indústria', '23.456.789/0001-02', '71999990002'),
('Embalagem Bahia Eireli', '34.567.890/0001-03', '71999990005'),
('Essências Tropicais Ltda', '45.678.901/0001-04', '71999990003'),
('Aroma Sul Distribuidora', '56.789.012/0001-05', '71999990094');

-- 4. INSUMOS (Colunas renomeadas, removida 'categoria' e removido o ID textual 'IN001' que quebrava o INT)
INSERT INTO insumos (nome_insumo, lote, data_validade, quantidade_atual, quantidade_minima, unidade_medida, id_fornecedor) VALUES
('Açúcar Refinado', 'LT2026001', '2027-12-10', 1250, 200, 'kg', 1),
('Adoçante Sucralose', 'LT2026015', '2027-09-15', 45, 10, 'kg', 1),
('Concentrado de Guaraná', 'lt2026041', '2027-04-02', 55, 10, 'litros', 1),
('Essência de Limão', 'LT202632', '2027-07-15', 8, 5, 'litros', 5),
('Garrafa PET 2L', 'LT2026009', NULL, 2000, 500, 'unidades', 2),
('Tempa Plástica', 'LT2026012', NULL, 1800, 200, 'unidades', 3);

-- 5. MOVIMENTAÇÕES (Coluna alterada para 'data_operacao' e incluída a hora no DATETIME)
INSERT INTO movimentacoes (tipo_movimentacao, quantidade, data_operacao, id_insumo, id_usuario, id_setor, observacao) VALUES
('RETIRADA', 100.00, '2026-06-10 14:30:00', 1, 1, 1, 'Separação para o lote LT001'),
('RETIRADA', 50.00, '2026-06-11 09:15:00', 2, 2, 2, 'Retirada para testes de envase'),
('REPOSICAO', 1000.00, '2026-06-12 16:00:00', 3, 3, 3, 'Recebimento de carga regular');

-- 6. ALERTAS ESTOQUE
INSERT INTO alertas_estoque (id_insumo, mensagem, status_alerta) VALUES
(1, 'Estoque de açúcar próximo do mínimo.', 'PENDENTE'),
(2, 'Concentrado de guaraná abaixo do nível ideal.', 'PENDENTE');

-- 7. AUDITORIA
INSERT INTO auditoria (id_usuario, acao, tabela_afetada) VALUES
(1, 'Cadastro de insumo', 'insumos'),
(2, 'Retirada de material', 'movimentacoes'),
(3, 'Reposição de estoque', 'movimentacoes');

-- 8. PRODUTOS
INSERT INTO produtos (nome_produto, categoria, unidade_medida, estoque_atual) VALUES
('Refrigerante de Guaraná 2L', 'Refrigerantes', 'unidades', 1000);

-- 9. LOTES PRODUÇÃO
INSERT INTO lotes_producao (codigo_lote, quantidade_produzida, data_producao, status_lote) VALUES
('LT001', 1000, '2026-06-10', 'FINALIZADO'),
('LT002', 1200, '2026-06-12', 'EM_PRODUCAO');

-- 10. PRODUÇÃO PRODUTOS (Associação do Lote com o Produto)
INSERT INTO producao_produtos (id_lote, id_produto, quantidade) VALUES
(1, 1, 1000),
(2, 1, 1200);

-- 11. LOTE INSUMOS (Consumo de insumos por Lote)
INSERT INTO lote_insumos (id_lote, id_insumo, quantidade_utilizada) VALUES
(1, 1, 200),
(1, 2, 50),
(2, 1, 250),
(2, 2, 60),
(2, 3, 1200);





 
