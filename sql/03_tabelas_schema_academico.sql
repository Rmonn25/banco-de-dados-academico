/* 
Tabelas base do financeiro.
Armazena os dados principais e compartilhados de cada pessoa no sistema.
*/

CREATE TABLE academico.tb_aluno (
    pk_cpf CHAR(11) NOT NULL,
    email_aluno VARCHAR(255) NOT NULL,
    data_ingresso DATE NOT NULL,
    data_saida DATE NULL,
    data_cadastro DATETIME NOT NULL,
    data_atualizacao DATETIME NULL,

    CONSTRAINT PK_tb_aluno
        PRIMARY KEY (pk_cpf),

    CONSTRAINT UQ_tb_aluno_email
        UNIQUE (email_aluno),

    CONSTRAINT FK_tb_aluno_tb_pessoa
        FOREIGN KEY (pk_cpf)
        REFERENCES base.tb_pessoa (pk_cpf)
);
GO


CREATE TABLE academico.tb_turmas (
    pk_nome_turma VARCHAR(20) NOT NULL,
    pk_ano_letivo INT NOT NULL,
    pk_serie VARCHAR(20) NOT NULL,
    pk_turno VARCHAR(10) NOT NULL,
    capacidade_maxima INT NULL,
    num_sala VARCHAR(20) NULL,
    status_turma VARCHAR(10) NOT NULL,

    CONSTRAINT PK_tb_turmas
        PRIMARY KEY (pk_nome_turma, pk_ano_letivo, pk_serie, pk_turno),

    CONSTRAINT CK_tb_turmas_pk_turno
        CHECK (pk_turno IN ('manha', 'tarde')),

    CONSTRAINT CK_tb_turmas_status_turma
        CHECK (status_turma IN ('ativo', 'inativo'))
);
GO


CREATE TABLE academico.tb_disciplinas (
    pk_nome_disciplina VARCHAR(100) NOT NULL,
    carga_horaria INT NULL,

    CONSTRAINT PK_tb_disciplinas
        PRIMARY KEY (pk_nome_disciplina)
);
GO


CREATE TABLE academico.tb_responsavel (
    fk_cpf CHAR(11) NOT NULL,
    profissao VARCHAR(100) NULL,
    status_responsavel VARCHAR(10) NOT NULL,

    CONSTRAINT PK_tb_responsavel
        PRIMARY KEY (fk_cpf),

    CONSTRAINT FK_tb_responsavel_tb_pessoa
        FOREIGN KEY (fk_cpf)
        REFERENCES base.tb_pessoa (pk_cpf),

    CONSTRAINT CK_tb_responsavel_status_responsavel
        CHECK (status_responsavel IN ('ativo', 'inativo'))
);
GO


CREATE TABLE academico.tb_matricula_ano (
    pk_cpf CHAR(11) NOT NULL,
    pk_ano_letivo INT NOT NULL,
    fk_nome_turma VARCHAR(20) NOT NULL,
    fk_serie VARCHAR(20) NOT NULL,
    fk_turno VARCHAR(10) NOT NULL,
    status_matricula VARCHAR(20) NOT NULL,
    data_matricula DATE NOT NULL,

    CONSTRAINT PK_tb_matricula_ano
        PRIMARY KEY (pk_cpf, pk_ano_letivo),

    CONSTRAINT FK_tb_matricula_ano_tb_aluno
        FOREIGN KEY (pk_cpf)
        REFERENCES academico.tb_aluno (pk_cpf),

    CONSTRAINT FK_tb_matricula_ano_tb_turmas
        FOREIGN KEY (fk_nome_turma, pk_ano_letivo, fk_serie, fk_turno)
        REFERENCES academico.tb_turmas (pk_nome_turma, pk_ano_letivo, pk_serie, pk_turno),

    CONSTRAINT CK_tb_matricula_ano_fk_turno
        CHECK (fk_turno IN ('manha', 'tarde')),

    CONSTRAINT CK_tb_matricula_ano_status_matricula
        CHECK (status_matricula IN ('em_andamento', 'aprovado', 'reprovado', 'evadido', 'transferido', 'cancelado', 'expulso'))
);
GO


CREATE TABLE academico.tb_historico_turma (
    pk_id_historico_turma INT NOT NULL IDENTITY(1,1),
    fk_cpf CHAR(11) NOT NULL,
    fk_ano_letivo INT NOT NULL,
    fk_nome_turma VARCHAR(20) NOT NULL,
    fk_serie VARCHAR(20) NOT NULL,
    fk_turno VARCHAR(10) NOT NULL,
    data_inicio DATETIME NOT NULL,
    data_fim DATETIME NULL,
    motivo_movimentacao VARCHAR(100) NULL,

    CONSTRAINT PK_tb_historico_turma
        PRIMARY KEY (pk_id_historico_turma),

    CONSTRAINT FK_tb_historico_turma_tb_matricula_ano
        FOREIGN KEY (fk_cpf, fk_ano_letivo)
        REFERENCES academico.tb_matricula_ano (pk_cpf, pk_ano_letivo),

    CONSTRAINT FK_tb_historico_turma_tb_turmas
        FOREIGN KEY (fk_nome_turma, fk_ano_letivo, fk_serie, fk_turno)
        REFERENCES academico.tb_turmas (pk_nome_turma, pk_ano_letivo, pk_serie, pk_turno),

    CONSTRAINT CK_tb_historico_turma_fk_turno
        CHECK (fk_turno IN ('manha', 'tarde'))
);
GO


CREATE TABLE academico.tb_turma_disciplina (
    pk_nome_turma VARCHAR(20) NOT NULL,
    pk_ano_letivo INT NOT NULL,
    pk_serie VARCHAR(20) NOT NULL,
    pk_turno VARCHAR(10) NOT NULL,
    pk_nome_disciplina VARCHAR(100) NOT NULL,
    fk_cpf_professor CHAR(11) NOT NULL,
    ativo BIT NOT NULL
        CONSTRAINT DF_tb_turma_disciplina_ativo DEFAULT 1,

    CONSTRAINT PK_tb_turma_disciplina
        PRIMARY KEY (pk_nome_turma, pk_ano_letivo, pk_serie, pk_turno, pk_nome_disciplina),

    CONSTRAINT FK_tb_turma_disciplina_tb_turmas
        FOREIGN KEY (pk_nome_turma, pk_ano_letivo, pk_serie, pk_turno)
        REFERENCES academico.tb_turmas (pk_nome_turma, pk_ano_letivo, pk_serie, pk_turno),

    CONSTRAINT FK_tb_turma_disciplina_tb_disciplinas
        FOREIGN KEY (pk_nome_disciplina)
        REFERENCES academico.tb_disciplinas (pk_nome_disciplina),

    CONSTRAINT FK_tb_turma_disciplina_tb_professor
        FOREIGN KEY (fk_cpf_professor)
        REFERENCES rh.tb_professor (pk_cpf),

    CONSTRAINT CK_tb_turma_disciplina_pk_turno
        CHECK (pk_turno IN ('manha', 'tarde'))
);
GO


CREATE TABLE academico.tb_aluno_responsavel (
    fk_cpf CHAR(11) NOT NULL,
    fk_cpf_responsavel CHAR(11) NOT NULL,
    grau_parentesco VARCHAR(20) NULL,
    responsavel_principal BIT NOT NULL
        CONSTRAINT DF_tb_aluno_responsavel_responsavel_principal DEFAULT 0,

    CONSTRAINT PK_tb_aluno_responsavel
        PRIMARY KEY (fk_cpf, fk_cpf_responsavel),

    CONSTRAINT FK_tb_aluno_responsavel_tb_aluno
        FOREIGN KEY (fk_cpf)
        REFERENCES academico.tb_aluno (pk_cpf),

    CONSTRAINT FK_tb_aluno_responsavel_tb_responsavel
        FOREIGN KEY (fk_cpf_responsavel)
        REFERENCES academico.tb_responsavel (fk_cpf),

    CONSTRAINT CK_tb_aluno_responsavel_grau_parentesco
        CHECK (grau_parentesco IN ('mae', 'pai', 'avo', 'ava', 'tio', 'tia', 'irmao', 'irma', 'responsavel_legal', 'outro') OR grau_parentesco IS NULL)
);
GO


CREATE TABLE academico.tb_ocorrencias_aluno (
    pk_id_ocorrencia INT NOT NULL IDENTITY(1,1),
    fk_cpf CHAR(11) NOT NULL,
    fk_ano_letivo INT NOT NULL,
    fk_nome_turma VARCHAR(20) NULL,
    fk_serie VARCHAR(20) NULL,
    fk_turno VARCHAR(10) NULL,
    data_ocorrencia DATETIME NOT NULL,
    tipo_ocorrencia VARCHAR(20) NOT NULL,
    gravidade VARCHAR(10) NULL,
    descricao VARCHAR(255) NOT NULL,
    resolvida BIT NOT NULL
        CONSTRAINT DF_tb_ocorrencias_aluno_resolvida DEFAULT 0,
    data_resolucao DATETIME NULL,
    data_cadastro DATETIME NOT NULL,
    data_atualizacao DATETIME NULL,

    CONSTRAINT PK_tb_ocorrencias_aluno
        PRIMARY KEY (pk_id_ocorrencia),

    CONSTRAINT FK_tb_ocorrencias_aluno_tb_matricula_ano
        FOREIGN KEY (fk_cpf, fk_ano_letivo)
        REFERENCES academico.tb_matricula_ano (pk_cpf, pk_ano_letivo),

    CONSTRAINT FK_tb_ocorrencias_aluno_tb_turmas
        FOREIGN KEY (fk_nome_turma, fk_ano_letivo, fk_serie, fk_turno)
        REFERENCES academico.tb_turmas (pk_nome_turma, pk_ano_letivo, pk_serie, pk_turno),

    CONSTRAINT CK_tb_ocorrencias_aluno_fk_turno
        CHECK (fk_turno IN ('manha', 'tarde') OR fk_turno IS NULL),

    CONSTRAINT CK_tb_ocorrencias_aluno_tipo_ocorrencia
        CHECK (tipo_ocorrencia IN ('pedagogica', 'disciplinar', 'atendimento', 'elogio', 'outro')),

    CONSTRAINT CK_tb_ocorrencias_aluno_gravidade
        CHECK (gravidade IN ('baixa', 'media', 'alta') OR gravidade IS NULL)
);
GO


CREATE TABLE academico.tb_matricula_disciplina (
    pk_cpf CHAR(11) NOT NULL,
    pk_ano_letivo INT NOT NULL,
    pk_nome_turma VARCHAR(20) NOT NULL,
    pk_serie VARCHAR(20) NOT NULL,
    pk_turno VARCHAR(10) NOT NULL,
    pk_nome_disciplina VARCHAR(100) NOT NULL,
    data_matricula DATE NOT NULL,
    status_matricula VARCHAR(20) NOT NULL,

    CONSTRAINT PK_tb_matricula_disciplina
        PRIMARY KEY (pk_cpf, pk_ano_letivo, pk_nome_turma, pk_serie, pk_turno, pk_nome_disciplina),

    CONSTRAINT FK_tb_matricula_disciplina_tb_matricula_ano
        FOREIGN KEY (pk_cpf, pk_ano_letivo)
        REFERENCES academico.tb_matricula_ano (pk_cpf, pk_ano_letivo),

    CONSTRAINT FK_tb_matricula_disciplina_tb_turma_disciplina
        FOREIGN KEY (pk_nome_turma, pk_ano_letivo, pk_serie, pk_turno, pk_nome_disciplina)
        REFERENCES academico.tb_turma_disciplina (pk_nome_turma, pk_ano_letivo, pk_serie, pk_turno, pk_nome_disciplina),

    CONSTRAINT CK_tb_matricula_disciplina_pk_turno
        CHECK (pk_turno IN ('manha', 'tarde')),

    CONSTRAINT CK_tb_matricula_disciplina_status_matricula
        CHECK (status_matricula IN ('cursando', 'aprovado', 'reprovado'))
);
GO


CREATE TABLE academico.tb_boletim (
    pk_cpf CHAR(11) NOT NULL,
    pk_ano_letivo INT NOT NULL,
    pk_nome_turma VARCHAR(20) NOT NULL,
    pk_serie VARCHAR(20) NOT NULL,
    pk_turno VARCHAR(10) NOT NULL,
    pk_nome_disciplina VARCHAR(100) NOT NULL,
    nota_final DECIMAL(5,2) NULL,
    faltas_total INT NOT NULL
        CONSTRAINT DF_tb_boletim_faltas_total DEFAULT 0,
    percentual_presenca DECIMAL(5,2) NULL,
    situacao_final VARCHAR(20) NULL,
    data_fechamento DATE NULL,
    data_cadastro DATETIME NOT NULL,
    data_atualizacao DATETIME NULL,

    CONSTRAINT PK_tb_boletim
        PRIMARY KEY (pk_cpf, pk_ano_letivo, pk_nome_turma, pk_serie, pk_turno, pk_nome_disciplina),

    CONSTRAINT FK_tb_boletim_tb_matricula_disciplina
        FOREIGN KEY (pk_cpf, pk_ano_letivo, pk_nome_turma, pk_serie, pk_turno, pk_nome_disciplina)
        REFERENCES academico.tb_matricula_disciplina (pk_cpf, pk_ano_letivo, pk_nome_turma, pk_serie, pk_turno, pk_nome_disciplina),

    CONSTRAINT CK_tb_boletim_pk_turno
        CHECK (pk_turno IN ('manha', 'tarde')),

    CONSTRAINT CK_tb_boletim_situacao_final
        CHECK (situacao_final IN ('aprovado', 'reprovado', 'recuperação') OR situacao_final IS NULL)
);
GO


CREATE TABLE academico.tb_avaliacoes (
    pk_id_avaliacao INT NOT NULL IDENTITY(1,1),
    fk_nome_turma VARCHAR(20) NOT NULL,
    fk_ano_letivo INT NOT NULL,
    fk_serie VARCHAR(20) NOT NULL,
    fk_turno VARCHAR(10) NOT NULL,
    fk_nome_disciplina VARCHAR(100) NOT NULL,
    tipo_avaliacao VARCHAR(20) NOT NULL,
    data_avaliacao DATE NOT NULL,
    peso DECIMAL(4,2) NOT NULL,
    bimestre INT NOT NULL,
    descricao VARCHAR(100) NULL,
    data_cadastro DATETIME NOT NULL,
    data_atualizacao DATETIME NULL,

    CONSTRAINT PK_tb_avaliacoes
        PRIMARY KEY (pk_id_avaliacao),

    CONSTRAINT FK_tb_avaliacoes_tb_turma_disciplina
        FOREIGN KEY (fk_nome_turma, fk_ano_letivo, fk_serie, fk_turno, fk_nome_disciplina)
        REFERENCES academico.tb_turma_disciplina (pk_nome_turma, pk_ano_letivo, pk_serie, pk_turno, pk_nome_disciplina),

    CONSTRAINT CK_tb_avaliacoes_fk_turno
        CHECK (fk_turno IN ('manha', 'tarde')),

    CONSTRAINT CK_tb_avaliacoes_tipo_avaliacao
        CHECK (tipo_avaliacao IN ('prova', 'trabalho', 'seminario', 'atividade'))
);
GO


CREATE TABLE academico.tb_notas_avaliacao (
    pk_id_nota_avaliacao INT NOT NULL IDENTITY(1,1),
    fk_cpf CHAR(11) NOT NULL,
    fk_ano_letivo INT NOT NULL,
    fk_nome_turma VARCHAR(20) NOT NULL,
    fk_serie VARCHAR(20) NOT NULL,
    fk_turno VARCHAR(10) NOT NULL,
    fk_nome_disciplina VARCHAR(100) NOT NULL,
    fk_id_avaliacao INT NOT NULL,
    nota_obtida DECIMAL(5,2) NOT NULL,
    data_lancamento DATETIME NOT NULL,
    data_atualizacao DATETIME NULL,

    CONSTRAINT PK_tb_notas_avaliacao
        PRIMARY KEY (pk_id_nota_avaliacao),

    CONSTRAINT UQ_tb_notas_avaliacao
        UNIQUE (fk_cpf, fk_ano_letivo, fk_nome_turma, fk_serie, fk_turno, fk_nome_disciplina, fk_id_avaliacao),

    CONSTRAINT FK_tb_notas_avaliacao_tb_matricula_disciplina
        FOREIGN KEY (fk_cpf, fk_ano_letivo, fk_nome_turma, fk_serie, fk_turno, fk_nome_disciplina)
        REFERENCES academico.tb_matricula_disciplina (pk_cpf, pk_ano_letivo, pk_nome_turma, pk_serie, pk_turno, pk_nome_disciplina),

    CONSTRAINT FK_tb_notas_avaliacao_tb_avaliacoes
        FOREIGN KEY (fk_id_avaliacao)
        REFERENCES academico.tb_avaliacoes (pk_id_avaliacao),

    CONSTRAINT CK_tb_notas_avaliacao_fk_turno
        CHECK (fk_turno IN ('manha', 'tarde'))
);
GO


CREATE TABLE academico.tb_aulas (
    pk_id_aula INT NOT NULL IDENTITY(1,1),
    fk_nome_turma VARCHAR(20) NOT NULL,
    fk_ano_letivo INT NOT NULL,
    fk_serie VARCHAR(20) NOT NULL,
    fk_turno VARCHAR(10) NOT NULL,
    fk_nome_disciplina VARCHAR(100) NOT NULL,
    data_aula DATE NOT NULL,
    conteudo_ministrado VARCHAR(255) NULL,
    quantidade_horas DECIMAL(4,2) NOT NULL
        CONSTRAINT DF_tb_aulas_quantidade_horas DEFAULT 1.00,
    bimestre INT NOT NULL,
    data_cadastro DATETIME NOT NULL,

    CONSTRAINT PK_tb_aulas
        PRIMARY KEY (pk_id_aula),

    CONSTRAINT FK_tb_aulas_tb_turma_disciplina
        FOREIGN KEY (fk_nome_turma, fk_ano_letivo, fk_serie, fk_turno, fk_nome_disciplina)
        REFERENCES academico.tb_turma_disciplina (pk_nome_turma, pk_ano_letivo, pk_serie, pk_turno, pk_nome_disciplina),

    CONSTRAINT CK_tb_aulas_fk_turno
        CHECK (fk_turno IN ('manha', 'tarde'))
);
GO


CREATE TABLE academico.tb_frequencia (
    pk_id_frequencia INT NOT NULL IDENTITY(1,1),
    fk_cpf CHAR(11) NOT NULL,
    fk_ano_letivo INT NOT NULL,
    fk_nome_turma VARCHAR(20) NOT NULL,
    fk_serie VARCHAR(20) NOT NULL,
    fk_turno VARCHAR(10) NOT NULL,
    fk_nome_disciplina VARCHAR(100) NOT NULL,
    fk_id_aula INT NOT NULL,
    status_frequencia VARCHAR(20) NOT NULL,
    carga_horaria_faltada DECIMAL(4,2) NOT NULL
        CONSTRAINT DF_tb_frequencia_carga_horaria_faltada DEFAULT 0.00,
    observacao VARCHAR(255) NULL,
    data_cadastro DATETIME NOT NULL,

    CONSTRAINT PK_tb_frequencia
        PRIMARY KEY (pk_id_frequencia),

    CONSTRAINT UQ_tb_frequencia
        UNIQUE (fk_cpf, fk_ano_letivo, fk_nome_turma, fk_serie, fk_turno, fk_nome_disciplina, fk_id_aula),

    CONSTRAINT FK_tb_frequencia_tb_matricula_disciplina
        FOREIGN KEY (fk_cpf, fk_ano_letivo, fk_nome_turma, fk_serie, fk_turno, fk_nome_disciplina)
        REFERENCES academico.tb_matricula_disciplina (pk_cpf, pk_ano_letivo, pk_nome_turma, pk_serie, pk_turno, pk_nome_disciplina),

    CONSTRAINT FK_tb_frequencia_tb_aulas
        FOREIGN KEY (fk_id_aula)
        REFERENCES academico.tb_aulas (pk_id_aula),

    CONSTRAINT CK_tb_frequencia_fk_turno
        CHECK (fk_turno IN ('manha', 'tarde')),

    CONSTRAINT CK_tb_frequencia_status_frequencia
        CHECK (status_frequencia IN ('presente', 'ausente', 'justificada'))
);
GO