/* 
Tabelas base do financeiro.
Armazena os dados principais e compartilhados de cada pessoa no sistema.
*/

CREATE TABLE financeiro.tb_fontes_recurso (
    pk_nome_fonte VARCHAR(100) NOT NULL,
    tipo_recurso VARCHAR(20) NOT NULL,
    descricao VARCHAR(255) NULL,
    status_fonte VARCHAR(10) NOT NULL,

    CONSTRAINT PK_tb_fontes_recurso
        PRIMARY KEY (pk_nome_fonte),

    CONSTRAINT CK_tb_fontes_recurso_tipo_recurso
        CHECK (tipo_recurso IN ('municipal', 'estadual', 'federal', 'projeto', 'doacao', 'outro')),

    CONSTRAINT CK_tb_fontes_recurso_status_fonte
        CHECK (status_fonte IN ('ativo', 'inativo'))
);
GO

CREATE TABLE financeiro.tb_categorias_despesa (
    pk_nome_categoria VARCHAR(100) NOT NULL,
    descricao VARCHAR(255) NULL,
    status_categoria VARCHAR(10) NOT NULL,

    CONSTRAINT PK_tb_categorias_despesa
        PRIMARY KEY (pk_nome_categoria),

    CONSTRAINT CK_tb_categorias_despesa_status_categoria
        CHECK (status_categoria IN ('ativo', 'inativo'))
);
GO

CREATE TABLE financeiro.tb_centro_custo (
    pk_nome_centro_custo VARCHAR(100) NOT NULL,
    descricao VARCHAR(255) NULL,
    status_centro_custo VARCHAR(10) NOT NULL,

    CONSTRAINT PK_tb_centro_custo
        PRIMARY KEY (pk_nome_centro_custo),

    CONSTRAINT CK_tb_centro_custo_status_centro_custo
        CHECK (status_centro_custo IN ('ativo', 'inativo'))
);
GO

CREATE TABLE financeiro.tb_orcamento (
    pk_ano_exercicio INT NOT NULL,
    pk_nome_fonte VARCHAR(100) NOT NULL,
    valor_total_previsto DECIMAL(12,2) NOT NULL,
    data_cadastro DATETIME NOT NULL,
    data_atualizacao DATETIME NULL,

    CONSTRAINT PK_tb_orcamento
        PRIMARY KEY (pk_ano_exercicio, pk_nome_fonte),

    CONSTRAINT FK_tb_orcamento_tb_fontes_recurso
        FOREIGN KEY (pk_nome_fonte)
        REFERENCES financeiro.tb_fontes_recurso (pk_nome_fonte)
);
GO

CREATE TABLE financeiro.tb_orcamento_item (
    pk_orcamento_item INT NOT NULL IDENTITY(1,1),
    fk_ano_exercicio INT NOT NULL,
    fk_nome_fonte VARCHAR(100) NOT NULL,
    fk_nome_categoria VARCHAR(100) NOT NULL,
    fk_nome_centro_custo VARCHAR(100) NOT NULL,
    valor_previsto DECIMAL(12,2) NOT NULL,
    observacao VARCHAR(255) NULL,

    CONSTRAINT PK_tb_orcamento_item
        PRIMARY KEY (pk_orcamento_item),

    CONSTRAINT UQ_tb_orcamento_item
        UNIQUE (fk_ano_exercicio, fk_nome_fonte, fk_nome_categoria, fk_nome_centro_custo),

    CONSTRAINT FK_tb_orcamento_item_tb_orcamento
        FOREIGN KEY (fk_ano_exercicio, fk_nome_fonte)
        REFERENCES financeiro.tb_orcamento (pk_ano_exercicio, pk_nome_fonte),

    CONSTRAINT FK_tb_orcamento_item_tb_categorias_despesa
        FOREIGN KEY (fk_nome_categoria)
        REFERENCES financeiro.tb_categorias_despesa (pk_nome_categoria),

    CONSTRAINT FK_tb_orcamento_item_tb_centro_custo
        FOREIGN KEY (fk_nome_centro_custo)
        REFERENCES financeiro.tb_centro_custo (pk_nome_centro_custo)
);
GO

CREATE TABLE financeiro.tb_receitas (
    pk_receita INT NOT NULL IDENTITY(1,1),
    fk_nome_centro_custo VARCHAR(100) NULL,
    fk_nome_fonte VARCHAR(100) NOT NULL,
    descricao VARCHAR(255) NOT NULL,
    valor_recebido DECIMAL(12,2) NOT NULL,
    data_recebimento DATE NOT NULL,
    exercicio INT NOT NULL,
    numero_documento VARCHAR(50) NULL,
    data_cadastro DATETIME NOT NULL,
    data_atualizacao DATETIME NULL,

    CONSTRAINT PK_tb_receitas
        PRIMARY KEY (pk_receita),

    CONSTRAINT FK_tb_receitas_tb_centro_custo
        FOREIGN KEY (fk_nome_centro_custo)
        REFERENCES financeiro.tb_centro_custo (pk_nome_centro_custo),

    CONSTRAINT FK_tb_receitas_tb_fontes_recurso
        FOREIGN KEY (fk_nome_fonte)
        REFERENCES financeiro.tb_fontes_recurso (pk_nome_fonte)
);
GO

CREATE TABLE financeiro.tb_fornecedores (
    pk_documento_fornecedor VARCHAR(14) NOT NULL,
    nome_fornecedor VARCHAR(150) NOT NULL,
    tipo_fornecedor VARCHAR(20) NOT NULL,
    email VARCHAR(255) NULL,
    telefone VARCHAR(20) NULL,
    cidade VARCHAR(100) NULL,
    uf CHAR(2) NULL,
    status_fornecedor VARCHAR(10) NOT NULL,

    CONSTRAINT PK_tb_fornecedores
        PRIMARY KEY (pk_documento_fornecedor),

    CONSTRAINT CK_tb_fornecedores_tipo_fornecedor
        CHECK (tipo_fornecedor IN ('pessoa_fisica', 'pessoa_juridica')),

    CONSTRAINT CK_tb_fornecedores_status_fornecedor
        CHECK (status_fornecedor IN ('ativo', 'inativo'))
);
GO

CREATE TABLE financeiro.tb_contratos (
    pk_numero_contrato VARCHAR(50) NOT NULL,
    fk_nome_centro_custo VARCHAR(100) NOT NULL,
    fk_documento_fornecedor VARCHAR(14) NOT NULL,
    objeto_contrato VARCHAR(255) NOT NULL,
    valor_total DECIMAL(12,2) NULL,
    data_inicio DATE NOT NULL,
    data_fim DATE NULL,
    situacao_contrato VARCHAR(20) NOT NULL,
    data_cadastro DATETIME NOT NULL,
    data_atualizacao DATETIME NULL,

    CONSTRAINT PK_tb_contratos
        PRIMARY KEY (pk_numero_contrato),

    CONSTRAINT FK_tb_contratos_tb_centro_custo
        FOREIGN KEY (fk_nome_centro_custo)
        REFERENCES financeiro.tb_centro_custo (pk_nome_centro_custo),

    CONSTRAINT FK_tb_contratos_tb_fornecedores
        FOREIGN KEY (fk_documento_fornecedor)
        REFERENCES financeiro.tb_fornecedores (pk_documento_fornecedor),

    CONSTRAINT CK_tb_contratos_situacao_contrato
        CHECK (situacao_contrato IN ('ativo', 'encerrado', 'suspenso', 'cancelado'))
);
GO

CREATE TABLE financeiro.tb_despesas (
    pk_despesa INT NOT NULL IDENTITY(1,1),
    fk_nome_categoria VARCHAR(100) NOT NULL,
    fk_orcamento_item INT NULL,
    fk_nome_centro_custo VARCHAR(100) NOT NULL,
    fk_nome_fonte VARCHAR(100) NOT NULL,
    fk_numero_contrato VARCHAR(50) NULL,
    fk_documento_fornecedor VARCHAR(14) NULL,
    fk_cpf_funcionario CHAR(11) NULL,
    descricao VARCHAR(255) NOT NULL,
    valor_despesa DECIMAL(12,2) NOT NULL,
    data_vencimento DATE NULL,
    data_emissao DATE NULL,
    exercicio INT NOT NULL,
    numero_documento VARCHAR(50) NULL,
    status_despesa VARCHAR(20) NOT NULL,
    data_cadastro DATETIME NOT NULL,
    data_atualizacao DATETIME NULL,

    CONSTRAINT PK_tb_despesas
        PRIMARY KEY (pk_despesa),

    CONSTRAINT FK_tb_despesas_tb_categorias_despesa
        FOREIGN KEY (fk_nome_categoria)
        REFERENCES financeiro.tb_categorias_despesa (pk_nome_categoria),

    CONSTRAINT FK_tb_despesas_tb_orcamento_item
        FOREIGN KEY (fk_orcamento_item)
        REFERENCES financeiro.tb_orcamento_item (pk_orcamento_item),

    CONSTRAINT FK_tb_despesas_tb_centro_custo
        FOREIGN KEY (fk_nome_centro_custo)
        REFERENCES financeiro.tb_centro_custo (pk_nome_centro_custo),

    CONSTRAINT FK_tb_despesas_tb_fontes_recurso
        FOREIGN KEY (fk_nome_fonte)
        REFERENCES financeiro.tb_fontes_recurso (pk_nome_fonte),

    CONSTRAINT FK_tb_despesas_tb_contratos
        FOREIGN KEY (fk_numero_contrato)
        REFERENCES financeiro.tb_contratos (pk_numero_contrato),

    CONSTRAINT FK_tb_despesas_tb_fornecedores
        FOREIGN KEY (fk_documento_fornecedor)
        REFERENCES financeiro.tb_fornecedores (pk_documento_fornecedor),

    CONSTRAINT FK_tb_despesas_tb_funcionario
        FOREIGN KEY (fk_cpf_funcionario)
        REFERENCES rh.tb_funcionario (pk_cpf),

    CONSTRAINT CK_tb_despesas_status_despesa
        CHECK (status_despesa IN ('prevista', 'empenhada', 'paga', 'cancelada'))
);
GO

CREATE TABLE financeiro.tb_pagamentos (
    pk_numero_comprovante VARCHAR(50) NOT NULL,
    fk_despesa INT NOT NULL,
    data_pagamento DATE NOT NULL,
    valor_pago DECIMAL(12,2) NOT NULL,
    forma_pagamento VARCHAR(50) NULL,
    data_cadastro DATETIME NOT NULL,

    CONSTRAINT PK_tb_pagamentos
        PRIMARY KEY (pk_numero_comprovante),

    CONSTRAINT FK_tb_pagamentos_tb_despesas
        FOREIGN KEY (fk_despesa)
        REFERENCES financeiro.tb_despesas (pk_despesa)
);
GO