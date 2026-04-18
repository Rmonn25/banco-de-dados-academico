/* 
Tabelas base do rh.
Armazena os dados principais e compartilhados de cada pessoa no sistema.
*/

CREATE TABLE rh.tb_cargos (
    pk_nome_cargo VARCHAR(50) NOT NULL,
    salario_base DECIMAL(10,2) NOT NULL,
    status_cargo VARCHAR(10) NOT NULL,

    CONSTRAINT PK_tb_cargos
        PRIMARY KEY (pk_nome_cargo),

    CONSTRAINT CK_tb_cargos_status_cargo
        CHECK (status_cargo IN ('ativo', 'inativo'))
);
GO

CREATE TABLE rh.tb_departamentos (
    pk_nome_departamento VARCHAR(50) NOT NULL,
    status_departamento VARCHAR(10) NOT NULL,

    CONSTRAINT PK_tb_departamentos
        PRIMARY KEY (pk_nome_departamento),

    CONSTRAINT CK_tb_departamentos_status_departamento
        CHECK (status_departamento IN ('ativo', 'inativo'))
);
GO

CREATE TABLE rh.tb_funcionario (
    pk_cpf CHAR(11) NOT NULL,
    fk_nome_cargo VARCHAR(50) NOT NULL,
    status_funcionario VARCHAR(20) NOT NULL,
    data_admissao DATE NOT NULL,
    data_desligamento DATE NULL,
    data_cadastro DATETIME NOT NULL,
    data_atualizacao DATETIME NULL,

    CONSTRAINT PK_tb_funcionario
        PRIMARY KEY (pk_cpf),

    CONSTRAINT FK_tb_funcionario_tb_pessoa
        FOREIGN KEY (pk_cpf)
        REFERENCES base.tb_pessoa (pk_cpf),

    CONSTRAINT FK_tb_funcionario_tb_cargos
        FOREIGN KEY (fk_nome_cargo)
        REFERENCES rh.tb_cargos (pk_nome_cargo),

    CONSTRAINT CK_tb_funcionario_status_funcionario
        CHECK (status_funcionario IN ('ativo', 'inativo', 'afastado'))
);
GO

CREATE TABLE rh.tb_professor (
    pk_cpf CHAR(11) NOT NULL,
    registro_docente VARCHAR(50) NULL,
    especialidade VARCHAR(100) NULL,
    ativo BIT NOT NULL
        CONSTRAINT DF_tb_professor_ativo DEFAULT 1,

    CONSTRAINT PK_tb_professor
        PRIMARY KEY (pk_cpf),

    CONSTRAINT FK_tb_professor_tb_funcionario
        FOREIGN KEY (pk_cpf)
        REFERENCES rh.tb_funcionario (pk_cpf)
);
GO

CREATE TABLE rh.tb_coordenacao (
    pk_cpf CHAR(11) NOT NULL,
    area_responsavel VARCHAR(100) NULL,
    ativo BIT NOT NULL
        CONSTRAINT DF_tb_coordenacao_ativo DEFAULT 1,

    CONSTRAINT PK_tb_coordenacao
        PRIMARY KEY (pk_cpf),

    CONSTRAINT FK_tb_coordenacao_tb_funcionario
        FOREIGN KEY (pk_cpf)
        REFERENCES rh.tb_funcionario (pk_cpf)
);
GO

CREATE TABLE rh.tb_lotacao_funcionario (
    pk_lotacao INT NOT NULL IDENTITY(1,1),
    fk_cpf CHAR(11) NOT NULL,
    fk_nome_departamento VARCHAR(50) NOT NULL,
    data_inicio DATE NOT NULL,
    data_fim DATE NULL,
    lotacao_principal BIT NOT NULL
        CONSTRAINT DF_tb_lotacao_funcionario_lotacao_principal DEFAULT 1,
    data_cadastro DATETIME NOT NULL,
    data_atualizacao DATETIME NULL,

    CONSTRAINT PK_tb_lotacao_funcionario
        PRIMARY KEY (pk_lotacao),

    CONSTRAINT FK_tb_lotacao_funcionario_tb_funcionario
        FOREIGN KEY (fk_cpf)
        REFERENCES rh.tb_funcionario (pk_cpf),

    CONSTRAINT FK_tb_lotacao_funcionario_tb_departamentos
        FOREIGN KEY (fk_nome_departamento)
        REFERENCES rh.tb_departamentos (pk_nome_departamento)
);
GO

CREATE TABLE rh.tb_folha_pagamento (
    pk_cpf CHAR(11) NOT NULL,
    pk_competencia CHAR(7) NOT NULL,
    salario_base DECIMAL(10,2) NULL,
    descontos DECIMAL(10,2) NULL,
    beneficios DECIMAL(10,2) NULL,
    data_cadastro DATETIME NOT NULL,
    data_atualizacao DATETIME NULL,

    CONSTRAINT PK_tb_folha_pagamento
        PRIMARY KEY (pk_cpf, pk_competencia),

    CONSTRAINT FK_tb_folha_pagamento_tb_funcionario
        FOREIGN KEY (pk_cpf)
        REFERENCES rh.tb_funcionario (pk_cpf)
);
GO

CREATE TABLE rh.tb_folha_ponto (
    pk_cpf CHAR(11) NOT NULL,
    pk_data_referencia DATE NOT NULL,
    hora_entrada TIME NULL,
    hora_inicio_intervalo TIME NOT NULL,
    hora_fim_intervalo TIME NOT NULL,
    hora_saida TIME NULL,
    hora_extra DECIMAL(5,2) NULL,
    atrasos DECIMAL(5,2) NULL,
    data_cadastro DATETIME NOT NULL,
    data_atualizacao DATETIME NULL,

    CONSTRAINT PK_tb_folha_ponto
        PRIMARY KEY (pk_cpf, pk_data_referencia),

    CONSTRAINT FK_tb_folha_ponto_tb_funcionario
        FOREIGN KEY (pk_cpf)
        REFERENCES rh.tb_funcionario (pk_cpf)
);
GO

CREATE TABLE rh.tb_ferias (
    pk_cpf CHAR(11) NOT NULL,
    pk_data_inicio DATE NOT NULL,
    data_fim DATE NOT NULL,
    data_cadastro DATETIME NOT NULL,
    data_atualizacao DATETIME NULL,

    CONSTRAINT PK_tb_ferias
        PRIMARY KEY (pk_cpf, pk_data_inicio),

    CONSTRAINT FK_tb_ferias_tb_funcionario
        FOREIGN KEY (pk_cpf)
        REFERENCES rh.tb_funcionario (pk_cpf)
);
GO