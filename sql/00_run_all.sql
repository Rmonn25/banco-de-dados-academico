/*SCRIPT DDL COMPLETO*/

/*RESET DOS BANCOS*/
SET FOREIGN_KEY_CHECKS = 0;

DROP DATABASE IF EXISTS financeiro;
DROP DATABASE IF EXISTS academico;
DROP DATABASE IF EXISTS rh;
DROP DATABASE IF EXISTS base;

/* Criação dos bancos de dados */
SET FOREIGN_KEY_CHECKS = 1;

CREATE DATABASE base;
CREATE DATABASE academico;
CREATE DATABASE rh;
CREATE DATABASE financeiro;

/* 
Tabela base de pessoas.
Armazena os dados cadastrais principais das pessoas do sistema.
*/
CREATE TABLE base.tb_pessoa (

    pk_cpf CHAR(11) NOT NULL PRIMARY KEY,

    nome VARCHAR(255) NOT NULL,
    sobrenome VARCHAR(225) NULL,
    nome_social VARCHAR(225),
    data_nascimento DATE NOT NULL,
    sexo varchar(50) NOT NULL,
    raca_cor varchar(50) NOT NULL,
    nacionalidade VARCHAR(225) NOT NULL,
    naturalidade VARCHAR(255) NOT NULL,

    data_cadastro DATETIME NOT NULL,
    data_atualizacao DATETIME NOT NULL,

    CONSTRAINT tb_pessoa_sexo
        CHECK (sexo IN ('Masculino', 'Feminino', 'Prefiro não informar')),

    CONSTRAINT tb_pessoa_raca
        CHECK (raca_cor IN ('Branca', 'Parda', 'Negra', 'Amarela', 'Indigena', 'Prefiro não informar'))
);

/* 
Tabela base de endereços.
Armazena os endereços vinculados às pessoas cadastradas.
*/
CREATE TABLE base.tb_enderecos (

    id_endereco INT NOT NULL AUTO_INCREMENT PRIMARY KEY,

    cep VARCHAR(9) NOT NULL,
    logradouro VARCHAR(150) NOT NULL,
    numero VARCHAR(10) NOT NULL,
    complemento VARCHAR(100),
    bairro VARCHAR(100) NOT NULL,
    cidade VARCHAR(100) NOT NULL,
    uf CHAR(2) NOT NULL,

    fk_cpf CHAR(11) NOT NULL,

    CONSTRAINT FK_tb_enderecos_tb_pessoa
        FOREIGN KEY (fk_cpf)
        REFERENCES base.tb_pessoa(pk_cpf),

    CONSTRAINT UQ_tb_enderecos
        UNIQUE (fk_cpf, cep, logradouro, numero)
);

/* 
Tabela base de telefones.
Armazena os telefones vinculados às pessoas cadastradas.
*/
CREATE TABLE base.tb_telefones (

    pk_ddd VARCHAR(2) NOT NULL,
    pk_numero VARCHAR(15) NOT NULL,
    fk_cpf CHAR(11) NOT NULL,

    ddi VARCHAR(3) NULL,
    tipo_telefone VARCHAR(20),
    ativo VARCHAR(10) NOT NULL,

    CONSTRAINT PK_tb_telefones
        PRIMARY KEY (pk_ddd, pk_numero, fk_cpf),

    CONSTRAINT FK_tb_telefones_tb_pessoa
        FOREIGN KEY (fk_cpf)
        REFERENCES base.tb_pessoa(pk_cpf),

    CONSTRAINT tb_telefones_tipo
        CHECK (tipo_telefone IN ('Celular', 'Residencial', 'Comercial')),

    CONSTRAINT tb_telefones_ativo
        CHECK (ativo IN ('Ativo', 'Inativo'))
);

/* 
Tabelas base do rh.
Armazena os dados principais e compartilhados de cada pessoa no sistema.
*/

/* 
Tabela de cargos.
Armazena os cargos disponíveis para os funcionários.
*/
CREATE TABLE rh.tb_cargos (
    pk_nome_cargo VARCHAR(50) NOT NULL,
    salario_base DECIMAL(10,2) NOT NULL,
    status_cargo VARCHAR(10) NOT NULL,

    CONSTRAINT PK_tb_cargos
        PRIMARY KEY (pk_nome_cargo),

    CONSTRAINT CK_tb_cargos_status_cargo
        CHECK (status_cargo IN ('Ativo', 'Inativo'))
);

/* 
Tabela de departamentos.
Armazena os departamentos existentes na instituição.
*/
CREATE TABLE rh.tb_departamentos (
    pk_nome_departamento VARCHAR(50) NOT NULL,
    status_departamento VARCHAR(10) NOT NULL,

    CONSTRAINT PK_tb_departamentos
        PRIMARY KEY (pk_nome_departamento),

    CONSTRAINT CK_tb_departamentos_status_departamento
        CHECK (status_departamento IN ('Ativo', 'Inativo'))
);

/* 
Tabela de funcionários.
Armazena os dados funcionais das pessoas contratadas.
*/
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
        CHECK (status_funcionario IN ('Ativo', 'Inativo', 'Afastado'))
);

/* 
Tabela de professores.
Armazena os dados específicos dos funcionários que atuam como professores.
*/
CREATE TABLE rh.tb_professor (
    pk_cpf CHAR(11) NOT NULL,
    registro_docente VARCHAR(50) NULL,
    especialidade VARCHAR(100) NULL,
    ativo VARCHAR(10) NOT NULL DEFAULT 'Ativo',

    CONSTRAINT PK_tb_professor
        PRIMARY KEY (pk_cpf),

    CONSTRAINT FK_tb_professor_tb_funcionario
        FOREIGN KEY (pk_cpf)
        REFERENCES rh.tb_funcionario (pk_cpf),

    CONSTRAINT CK_tb_professor_ativo
        CHECK (ativo IN ('Ativo', 'Inativo'))
);

/* 
Tabela de coordenação.
Armazena os dados específicos dos funcionários que atuam na coordenação.
*/
CREATE TABLE rh.tb_coordenacao (
    pk_cpf CHAR(11) NOT NULL,
    area_responsavel VARCHAR(100) NULL,
    ativo VARCHAR(10) NOT NULL DEFAULT 'Ativo',

    CONSTRAINT PK_tb_coordenacao
        PRIMARY KEY (pk_cpf),

    CONSTRAINT FK_tb_coordenacao_tb_funcionario
        FOREIGN KEY (pk_cpf)
        REFERENCES rh.tb_funcionario (pk_cpf),

    CONSTRAINT CK_tb_coordenacao_ativo
        CHECK (ativo IN ('Ativo', 'Inativo'))
);

/* 
Tabela de lotação de funcionários.
Armazena o vínculo dos funcionários com seus respectivos departamentos.
*/
CREATE TABLE rh.tb_lotacao_funcionario (
    pk_lotacao INT NOT NULL AUTO_INCREMENT,
    fk_cpf CHAR(11) NOT NULL,
    fk_nome_departamento VARCHAR(50) NOT NULL,
    data_inicio DATE NOT NULL,
    data_fim DATE,
    lotacao_principal BOOLEAN NOT NULL DEFAULT 1,
    data_cadastro DATETIME NOT NULL,
    data_atualizacao DATETIME,

    CONSTRAINT PK_tb_lotacao_funcionario
        PRIMARY KEY (pk_lotacao),

    CONSTRAINT FK_tb_lotacao_funcionario_tb_funcionario
        FOREIGN KEY (fk_cpf)
        REFERENCES rh.tb_funcionario (pk_cpf),

    CONSTRAINT FK_tb_lotacao_funcionario_tb_departamentos
        FOREIGN KEY (fk_nome_departamento)
        REFERENCES rh.tb_departamentos (pk_nome_departamento)
);

/* 
Tabela de folha de pagamento.
Armazena os dados de pagamento dos funcionários por competência.
*/
CREATE TABLE rh.tb_folha_pagamento (
    pk_cpf CHAR(11) NOT NULL,
    pk_competencia CHAR(7) NOT NULL,
    salario_base DECIMAL(10,2),
    descontos DECIMAL(10,2),
    beneficios DECIMAL(10,2),
    data_cadastro DATETIME NOT NULL,
    data_atualizacao DATETIME,

    CONSTRAINT PK_tb_folha_pagamento
        PRIMARY KEY (pk_cpf, pk_competencia),

    CONSTRAINT FK_tb_folha_pagamento_tb_funcionario
        FOREIGN KEY (pk_cpf)
        REFERENCES rh.tb_funcionario (pk_cpf)
);

/* 
Tabela de folha de ponto.
Armazena os registros de jornada, atrasos e horas extras dos funcionários.
*/
CREATE TABLE rh.tb_folha_ponto (
    pk_cpf CHAR(11) NOT NULL,
    pk_data_referencia DATE NOT NULL,
    hora_entrada TIME,
    hora_inicio_intervalo TIME NOT NULL,
    hora_fim_intervalo TIME NOT NULL,
    hora_saida TIME NULL,
    hora_extra DECIMAL(5,2),
    atrasos DECIMAL(5,2),
    data_cadastro DATETIME NOT NULL,
    data_atualizacao DATETIME,

    CONSTRAINT PK_tb_folha_ponto
        PRIMARY KEY (pk_cpf, pk_data_referencia),

    CONSTRAINT FK_tb_folha_ponto_tb_funcionario
        FOREIGN KEY (pk_cpf)
        REFERENCES rh.tb_funcionario (pk_cpf)
);

/* 
Tabela de férias.
Armazena os períodos de férias dos funcionários.
*/
CREATE TABLE rh.tb_ferias (
    pk_cpf CHAR(11) NOT NULL,
    pk_data_inicio DATE NOT NULL,
    data_fim DATE NOT NULL,
    data_cadastro DATETIME NOT NULL,
    data_atualizacao DATETIME,

    CONSTRAINT PK_tb_ferias
        PRIMARY KEY (pk_cpf, pk_data_inicio),

    CONSTRAINT FK_tb_ferias_tb_funcionario
        FOREIGN KEY (pk_cpf)
        REFERENCES rh.tb_funcionario (pk_cpf)
);

/* 
Tabelas base do academico.
Armazena os dados principais e compartilhados de cada pessoa no sistema.
*/

/* 
Tabela de alunos.
Armazena os dados acadêmicos dos alunos cadastrados.
*/
CREATE TABLE academico.tb_aluno (
    pk_cpf CHAR(11) NOT NULL,
    email_aluno VARCHAR(255) NOT NULL,
    data_ingresso DATE NOT NULL,
    data_saida DATE,
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

/* 
Tabela de turmas.
Armazena as turmas por ano letivo, série e turno.
*/
CREATE TABLE academico.tb_turmas (
    pk_nome_turma VARCHAR(20) NOT NULL,
    pk_ano_letivo INT NOT NULL,
    pk_serie VARCHAR(20) NOT NULL,
    pk_turno VARCHAR(10) NOT NULL,
    capacidade_maxima INT,
    num_sala VARCHAR(20),
    status_turma VARCHAR(10) NOT NULL,

    CONSTRAINT PK_tb_turmas
        PRIMARY KEY (pk_nome_turma, pk_ano_letivo, pk_serie, pk_turno),

    CONSTRAINT CK_tb_turmas_pk_turno
        CHECK (pk_turno IN ('Manha', 'Tarde')),

    CONSTRAINT CK_tb_turmas_status_turma
        CHECK (status_turma IN ('Ativo', 'Inativo'))
);

/* 
Tabela de disciplinas.
Armazena as disciplinas oferecidas pela instituição.
*/
CREATE TABLE academico.tb_disciplinas (
    pk_nome_disciplina VARCHAR(100) NOT NULL,
    carga_horaria INT,

    CONSTRAINT PK_tb_disciplinas
        PRIMARY KEY (pk_nome_disciplina)
);

/* 
Tabela de responsáveis.
Armazena os dados dos responsáveis pelos alunos.
*/
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

/* 
Tabela de matrícula anual.
Armazena a matrícula do aluno em uma turma durante o ano letivo.
*/
CREATE TABLE academico.tb_matricula_ano (
    pk_cpf CHAR(11) NOT NULL,
    pk_ano_letivo INT NOT NULL,
    fk_nome_turma VARCHAR(20) NOT NULL,
    fk_serie VARCHAR(20) NOT NULL,
    fk_turno VARCHAR(10) NOT NULL,
    status_matricula VARCHAR(20) NOT NULL,
    data_matricula DATE NOT NULL,
    status_turma VARCHAR(20) NOT NULL,

    CONSTRAINT PK_tb_matricula_ano
        PRIMARY KEY (pk_cpf, pk_ano_letivo),

    CONSTRAINT FK_tb_matricula_ano_tb_aluno
        FOREIGN KEY (pk_cpf)
        REFERENCES academico.tb_aluno (pk_cpf),

    CONSTRAINT FK_tb_matricula_ano_tb_turmas
        FOREIGN KEY (fk_nome_turma, pk_ano_letivo, fk_serie, fk_turno)
        REFERENCES academico.tb_turmas (pk_nome_turma, pk_ano_letivo, pk_serie, pk_turno),

    CONSTRAINT CK_tb_turmas_status_turma_ano
        CHECK (status_turma IN ('Ativo', 'Inativo')),
        
    CONSTRAINT CK_tb_matricula_ano_fk_turno
        CHECK (fk_turno IN ('Manha', 'Tarde')),

    CONSTRAINT CK_tb_matricula_ano_status_matricula
        CHECK (status_matricula IN ('Em andamento', 'Aprovado', 'Reprovado', 'Evadido', 'Transferido', 'Cancelado', 'Expulso'))
);

/* 
Tabela de histórico de turma.
Armazena o histórico de movimentação dos alunos entre turmas.
*/
CREATE TABLE academico.tb_historico_turma (
    pk_id_historico_turma INT NOT NULL AUTO_INCREMENT,
    fk_cpf CHAR(11) NOT NULL,
    fk_ano_letivo INT NOT NULL,
    fk_nome_turma VARCHAR(20) NOT NULL,
    fk_serie VARCHAR(20) NOT NULL,
    fk_turno VARCHAR(10) NOT NULL,
    data_inicio DATETIME NOT NULL,
    data_fim DATETIME,
    motivo_movimentacao VARCHAR(100),

    CONSTRAINT PK_tb_historico_turma
        PRIMARY KEY (pk_id_historico_turma),

    CONSTRAINT FK_tb_historico_turma_tb_matricula_ano
        FOREIGN KEY (fk_cpf, fk_ano_letivo)
        REFERENCES academico.tb_matricula_ano (pk_cpf, pk_ano_letivo),

    CONSTRAINT FK_tb_historico_turma_tb_turmas
        FOREIGN KEY (fk_nome_turma, fk_ano_letivo, fk_serie, fk_turno)
        REFERENCES academico.tb_turmas (pk_nome_turma, pk_ano_letivo, pk_serie, pk_turno),

    CONSTRAINT CK_tb_historico_turma_fk_turno
        CHECK (fk_turno IN ('Manha', 'Tarde'))
);

/* 
Tabela de turma e disciplina.
Armazena o vínculo entre turmas, disciplinas e professores.
*/
CREATE TABLE academico.tb_turma_disciplina (
    pk_nome_turma VARCHAR(20) NOT NULL,
    pk_ano_letivo INT NOT NULL,
    pk_serie VARCHAR(20) NOT NULL,
    pk_turno VARCHAR(10) NOT NULL,
    pk_nome_disciplina VARCHAR(100) NOT NULL,
    fk_cpf_professor CHAR(11) NOT NULL,
    ativo VARCHAR(10) NOT NULL DEFAULT 'Ativo',

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
        CHECK (pk_turno IN ('Manha', 'Tarde')),

    CONSTRAINT CK_tb_turma_disciplina_ativo
        CHECK (ativo IN ('Ativo', 'Inativo'))
);

/* 
Tabela de aluno e responsável.
Armazena o vínculo entre alunos e seus responsáveis.
*/
CREATE TABLE academico.tb_aluno_responsavel (
    fk_cpf CHAR(11) NOT NULL,
    fk_cpf_responsavel CHAR(11) NOT NULL,
    grau_parentesco VARCHAR(20) NULL,
    responsavel_principal BIT NOT NULL DEFAULT 0,

    CONSTRAINT PK_tb_aluno_responsavel
        PRIMARY KEY (fk_cpf, fk_cpf_responsavel),

    CONSTRAINT FK_tb_aluno_responsavel_tb_aluno
        FOREIGN KEY (fk_cpf)
        REFERENCES academico.tb_aluno (pk_cpf),

    CONSTRAINT FK_tb_aluno_responsavel_tb_responsavel
        FOREIGN KEY (fk_cpf_responsavel)
        REFERENCES academico.tb_responsavel (fk_cpf),

    CONSTRAINT CK_tb_aluno_responsavel_grau_parentesco
        CHECK (grau_parentesco IN ('Mãe', 'Pai', 'Avô', 'Avó', 'Tio', 'Tia', 'Irmao', 'Irma', 'Responsavel legal') OR grau_parentesco IS NULL)
);

/* 
Tabela de ocorrências dos alunos.
Armazena registros pedagógicos, disciplinares e atendimentos dos alunos.
*/
CREATE TABLE academico.tb_ocorrencias_aluno (
    pk_id_ocorrencia INT NOT NULL AUTO_INCREMENT,
    fk_cpf CHAR(11) NOT NULL,
    fk_ano_letivo INT NOT NULL,
    fk_nome_turma VARCHAR(20) NOT NULL,
    fk_serie VARCHAR(20) NOT NULL,
    fk_turno VARCHAR(10) NOT NULL,
    data_ocorrencia DATETIME NOT NULL,
    tipo_ocorrencia VARCHAR(20) NOT NULL,
    gravidade VARCHAR(10) NOT NULL,
    descricao VARCHAR(255) NOT NULL,
    resolvida BIT NOT NULL DEFAULT 0,
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
        CHECK (fk_turno IN ('Manha', 'Tarde') OR fk_turno IS NULL),

    CONSTRAINT CK_tb_ocorrencias_aluno_tipo_ocorrencia
        CHECK (tipo_ocorrencia IN ('Pedagogica', 'Disciplinar', 'Atendimento', 'Elogio', 'Outro')),

    CONSTRAINT CK_tb_ocorrencias_aluno_gravidade
        CHECK (gravidade IN ('Baixa', 'Media', 'Alta') OR gravidade IS NULL)
);

/* 
Tabela de matrícula em disciplina.
Armazena a matrícula do aluno nas disciplinas da turma.
*/
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
        CHECK (pk_turno IN ('Manha', 'Tarde')),

    CONSTRAINT CK_tb_matricula_disciplina_status_matricula
        CHECK (status_matricula IN ('Cursando', 'Aprovado', 'Reprovado'))
);

/* 
Tabela de boletim.
Armazena o fechamento de desempenho e presença do aluno por disciplina.
*/
CREATE TABLE academico.tb_boletim (
    pk_cpf CHAR(11) NOT NULL,
    pk_ano_letivo INT NOT NULL,
    pk_nome_turma VARCHAR(20) NOT NULL,
    pk_serie VARCHAR(20) NOT NULL,
    pk_turno VARCHAR(10) NOT NULL,
    pk_nome_disciplina VARCHAR(100) NOT NULL,

    percentual_presenca DECIMAL(5,2),
    situacao_final VARCHAR(20),
    data_fechamento DATE,
    data_cadastro DATETIME NOT NULL,
    data_atualizacao DATETIME,

    CONSTRAINT PK_tb_boletim
        PRIMARY KEY (pk_cpf, pk_ano_letivo, pk_nome_turma, pk_serie, pk_turno, pk_nome_disciplina),

    CONSTRAINT FK_tb_boletim_tb_matricula_disciplina
        FOREIGN KEY (pk_cpf, pk_ano_letivo, pk_nome_turma, pk_serie, pk_turno, pk_nome_disciplina)
        REFERENCES academico.tb_matricula_disciplina (pk_cpf, pk_ano_letivo, pk_nome_turma, pk_serie, pk_turno, pk_nome_disciplina),

    CONSTRAINT CK_tb_boletim_pk_turno
        CHECK (pk_turno IN ('Manha', 'Tarde')),

    CONSTRAINT CK_tb_boletim_situacao_final
        CHECK (
            situacao_final IN ('Aprovado', 'Reprovado', 'Recuperação')
            OR situacao_final IS NULL
        )
);

/* 
Tabela de avaliações.
Armazena as avaliações aplicadas por disciplina, turma e bimestre.
*/
CREATE TABLE academico.tb_avaliacoes (
    pk_id_avaliacao INT NOT NULL AUTO_INCREMENT,
    fk_nome_turma VARCHAR(20) NOT NULL,
    fk_ano_letivo INT NOT NULL,
    fk_serie VARCHAR(20) NOT NULL,
    fk_turno VARCHAR(10) NOT NULL,
    fk_nome_disciplina VARCHAR(100) NOT NULL,
    tipo_avaliacao VARCHAR(20) NOT NULL,
    data_avaliacao DATE NOT NULL,
    peso DECIMAL(4,2) NOT NULL,
    bimestre INT NOT NULL,
    descricao VARCHAR(100),
    data_cadastro DATETIME NOT NULL,
    data_atualizacao DATETIME,

    CONSTRAINT PK_tb_avaliacoes
        PRIMARY KEY (pk_id_avaliacao),

    CONSTRAINT FK_tb_avaliacoes_tb_turma_disciplina
        FOREIGN KEY (fk_nome_turma, fk_ano_letivo, fk_serie, fk_turno, fk_nome_disciplina)
        REFERENCES academico.tb_turma_disciplina (pk_nome_turma, pk_ano_letivo, pk_serie, pk_turno, pk_nome_disciplina),

    CONSTRAINT CK_tb_avaliacoes_fk_turno
        CHECK (fk_turno IN ('Manha', 'Tarde')),

    CONSTRAINT CK_tb_avaliacoes_tipo_avaliacao
        CHECK (
            tipo_avaliacao IN ('Prova','Trabalho','Seminario','Atividade'))
);

/* 
Tabela de notas das avaliações.
Armazena as notas obtidas pelos alunos nas avaliações.
*/
CREATE TABLE academico.tb_notas_avaliacao (
    pk_id_nota_avaliacao INT NOT NULL AUTO_INCREMENT,
    fk_cpf CHAR(11) NOT NULL,
    fk_ano_letivo INT NOT NULL,
    fk_nome_turma VARCHAR(20) NOT NULL,
    fk_serie VARCHAR(20) NOT NULL,
    fk_turno VARCHAR(10) NOT NULL,
    fk_nome_disciplina VARCHAR(100) NOT NULL,
    fk_id_avaliacao INT NOT NULL,
    nota_obtida DECIMAL(5,2) NOT NULL,
    data_lancamento DATETIME NOT NULL,
    data_atualizacao DATETIME,

    CONSTRAINT PK_tb_notas_avaliacao
        PRIMARY KEY (pk_id_nota_avaliacao),

    CONSTRAINT UQ_tb_notas_avaliacao
        UNIQUE (fk_cpf, fk_ano_letivo, fk_nome_turma, fk_serie, fk_turno, fk_nome_disciplina, fk_id_avaliacao),

    CONSTRAINT FK_tb_notas_avaliacao_tb_matricula_disciplina
        FOREIGN KEY (fk_cpf, fk_ano_letivo, fk_nome_turma, fk_serie, fk_turno, fk_nome_disciplina)
        REFERENCES academico.tb_matricula_disciplina (pk_cpf, pk_ano_letivo, pk_nome_turma, pk_serie, pk_turno,pk_nome_disciplina),

    CONSTRAINT FK_tb_notas_avaliacao_tb_avaliacoes
        FOREIGN KEY (fk_id_avaliacao)
        REFERENCES academico.tb_avaliacoes (pk_id_avaliacao),

    CONSTRAINT CK_tb_notas_avaliacao_fk_turno
        CHECK (fk_turno IN ('Manha', 'Tarde'))
);

/* 
Tabela de aulas.
Armazena as aulas ministradas por turma e disciplina.
*/
CREATE TABLE academico.tb_aulas (
    pk_id_aula INT NOT NULL AUTO_INCREMENT,
    fk_nome_turma VARCHAR(20) NOT NULL,
    fk_ano_letivo INT NOT NULL,
    fk_serie VARCHAR(20) NOT NULL,
    fk_turno VARCHAR(10) NOT NULL,
    fk_nome_disciplina VARCHAR(100) NOT NULL,
    data_aula DATE NOT NULL,
    conteudo_ministrado VARCHAR(255),
    quantidade_horas DECIMAL(4,2) NOT NULL DEFAULT 1.00,
    bimestre INT NOT NULL,
    data_cadastro DATETIME NOT NULL,

    CONSTRAINT PK_tb_aulas
        PRIMARY KEY (pk_id_aula),

    CONSTRAINT FK_tb_aulas_tb_turma_disciplina
        FOREIGN KEY (fk_nome_turma, fk_ano_letivo, fk_serie, fk_turno,fk_nome_disciplina)
        REFERENCES academico.tb_turma_disciplina (pk_nome_turma, pk_ano_letivo, pk_serie, pk_turno, pk_nome_disciplina),

    CONSTRAINT CK_tb_aulas_fk_turno
        CHECK (fk_turno IN ('Manha', 'Tarde'))
);

/* 
Tabela de frequência.
Armazena a presença, ausência ou justificativa dos alunos nas aulas.
*/
CREATE TABLE academico.tb_frequencia (
    pk_id_frequencia INT NOT NULL AUTO_INCREMENT,
    fk_cpf CHAR(11) NOT NULL,
    fk_ano_letivo INT NOT NULL,
    fk_nome_turma VARCHAR(20) NOT NULL,
    fk_serie VARCHAR(20) NOT NULL,
    fk_turno VARCHAR(10) NOT NULL,
    fk_nome_disciplina VARCHAR(100) NOT NULL,
    fk_id_aula INT NOT NULL,
    status_frequencia VARCHAR(20) NOT NULL,
    carga_horaria_faltada DECIMAL(4,2) NOT NULL DEFAULT 0.00,
    observacao VARCHAR(255),
    data_cadastro DATETIME NOT NULL,

    CONSTRAINT PK_tb_frequencia
        PRIMARY KEY (pk_id_frequencia),

    CONSTRAINT UQ_tb_frequencia
        UNIQUE (fk_cpf, fk_ano_letivo, fk_nome_turma, fk_serie, fk_turno, fk_nome_disciplina, fk_id_aula ),

    CONSTRAINT FK_tb_frequencia_tb_matricula_disciplina
        FOREIGN KEY (
            fk_cpf, fk_ano_letivo, fk_nome_turma, fk_serie, fk_turno, fk_nome_disciplina)
        REFERENCES academico.tb_matricula_disciplina (pk_cpf, pk_ano_letivo, pk_nome_turma, pk_serie, pk_turno, pk_nome_disciplina),

    CONSTRAINT FK_tb_frequencia_tb_aulas
        FOREIGN KEY (fk_id_aula)
        REFERENCES academico.tb_aulas (pk_id_aula),

    CONSTRAINT CK_tb_frequencia_fk_turno
        CHECK (fk_turno IN ('Manha', 'Tarde')),

    CONSTRAINT CK_tb_frequencia_status_frequencia
        CHECK (status_frequencia IN ('Presente', 'Ausente', 'Justificada'))
);

/* 
Tabelas base do financeiro.
Armazena os dados principais e compartilhados de cada pessoa no sistema.
*/

/* 
Tabela de fontes de recurso.
Armazena as origens dos recursos financeiros da instituição.
*/
CREATE TABLE financeiro.tb_fontes_recurso (
    pk_nome_fonte VARCHAR(100) NOT NULL,
    tipo_recurso VARCHAR(20) NOT NULL,
    descricao VARCHAR(255) NULL,
    status_fonte VARCHAR(10) NOT NULL,

    CONSTRAINT PK_tb_fontes_recurso
        PRIMARY KEY (pk_nome_fonte),

    CONSTRAINT CK_tb_fontes_recurso_tipo_recurso
        CHECK (tipo_recurso IN ('Municipal', 'Estadual', 'Federal', 'Projeto', 'Doacao', 'Outro')),

    CONSTRAINT CK_tb_fontes_recurso_status_fonte
        CHECK (status_fonte IN ('Ativo', 'Inativo'))
);

/* 
Tabela de categorias de despesa.
Armazena as categorias utilizadas para classificar despesas.
*/
CREATE TABLE financeiro.tb_categorias_despesa (
    pk_nome_categoria VARCHAR(100) NOT NULL,
    descricao VARCHAR(255) NULL,
    status_categoria VARCHAR(10) NOT NULL,

    CONSTRAINT PK_tb_categorias_despesa
        PRIMARY KEY (pk_nome_categoria),

    CONSTRAINT CK_tb_categorias_despesa_status_categoria
        CHECK (status_categoria IN ('Ativo', 'Inativo'))
);

/* 
Tabela de centro de custo.
Armazena os centros de custo utilizados no controle financeiro.
*/
CREATE TABLE financeiro.tb_centro_custo (
    pk_nome_centro_custo VARCHAR(100) NOT NULL,
    descricao VARCHAR(255) NULL,
    status_centro_custo VARCHAR(10) NOT NULL,

    CONSTRAINT PK_tb_centro_custo
        PRIMARY KEY (pk_nome_centro_custo),

    CONSTRAINT CK_tb_centro_custo_status_centro_custo
        CHECK (status_centro_custo IN ('Ativo', 'Inativo'))
);

/* 
Tabela de orçamento.
Armazena o orçamento previsto por exercício e fonte de recurso.
*/
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

/* 
Tabela de itens do orçamento.
Armazena a distribuição do orçamento por categoria e centro de custo.
*/
CREATE TABLE financeiro.tb_orcamento_item (
    pk_orcamento_item INT NOT NULL AUTO_INCREMENT,
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

/* 
Tabela de receitas.
Armazena os valores recebidos pela instituição.
*/
CREATE TABLE financeiro.tb_receitas (
    pk_receita INT NOT NULL AUTO_INCREMENT,
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

/* 
Tabela de fornecedores.
Armazena os fornecedores vinculados às despesas e contratos.
*/
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
        CHECK (tipo_fornecedor IN ('Pessoa Fisica', 'Pessoa Juridica')),

    CONSTRAINT CK_tb_fornecedores_status_fornecedor
        CHECK (status_fornecedor IN ('Ativo', 'Inativo'))
);

/* 
Tabela de contratos.
Armazena os contratos firmados com fornecedores.
*/
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

/* 
Tabela de despesas.
Armazena os gastos, vencimentos e status das despesas.
*/
CREATE TABLE financeiro.tb_despesas (
    pk_despesa INT NOT NULL AUTO_INCREMENT,
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
        CHECK (status_despesa IN ('Prevista', 'Empenhada', 'Paga', 'Cancelada'))
);

/* 
Tabela de pagamentos.
Armazena os pagamentos realizados para as despesas cadastradas.
*/
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

-- ============================================================
-- SCRIPT DE INSERTS - BANCO DE DADOS ESCOLAR
-- ============================================================

-- ============================================================
-- FINANCEIRO: Fontes de Recurso
-- ============================================================
INSERT INTO financeiro.tb_fontes_recurso (pk_nome_fonte, tipo_recurso, descricao, status_fonte) VALUES
('FNDE - PDDE',          'Federal',   'Programa Dinheiro Direto na Escola',         'Ativo'),
('FUNDEB Estadual',      'Estadual',  'Fundo de Manutenção da Educação Básica',      'Ativo'),
('Prefeitura Municipal', 'Municipal', 'Repasse da Prefeitura para custeio geral',    'Ativo'),
('Projeto Ler e Aprender','Projeto',  'Projeto de incentivo à leitura',              'Ativo'),
('Doação Empresa X',     'Doacao',    'Doação da Indústria Têxtil São Luiz Ltda',    'Ativo');

-- ============================================================
-- FINANCEIRO: Categorias de Despesa
-- ============================================================
INSERT INTO financeiro.tb_categorias_despesa (pk_nome_categoria, descricao, status_categoria) VALUES
('Material Didático',    'Livros, apostilas e materiais pedagógicos',   'Ativo'),
('Manutenção Predial',   'Reparos e conservação das instalações',        'Ativo'),
('Tecnologia',           'Equipamentos e softwares educacionais',        'Ativo'),
('Serviços Terceirizados','Limpeza, segurança e serviços gerais',        'Ativo'),
('Alimentação Escolar',  'Merenda e insumos da cozinha',                 'Ativo'),
('Capacitação Docente',  'Cursos e formações para professores',          'Ativo');

-- ============================================================
-- FINANCEIRO: Centros de Custo
-- ============================================================
INSERT INTO financeiro.tb_centro_custo (pk_nome_centro_custo, descricao, status_centro_custo) VALUES
('Ensino Fundamental I',  'Anos iniciais - 1º ao 5º ano',      'Ativo'),
('Ensino Fundamental II', 'Anos finais - 6º ao 9º ano',        'Ativo'),
('Administração',         'Gestão administrativa da escola',   'Ativo'),
('Laboratório',           'Laboratório de informática e ciências', 'Ativo'),
('Biblioteca',            'Acervo e manutenção da biblioteca', 'Ativo');

-- ============================================================
-- FINANCEIRO: Orçamento
-- ============================================================
INSERT INTO financeiro.tb_orcamento (pk_ano_exercicio, pk_nome_fonte, valor_total_previsto, data_cadastro, data_atualizacao) VALUES
(2025, 'FNDE - PDDE',          85000.00, '2025-01-05 08:00:00', '2025-01-05 08:00:00'),
(2025, 'FUNDEB Estadual',      320000.00,'2025-01-05 08:00:00', '2025-01-05 08:00:00'),
(2025, 'Prefeitura Municipal', 150000.00,'2025-01-05 08:00:00', '2025-01-05 08:00:00'),
(2025, 'Projeto Ler e Aprender',18000.00,'2025-01-10 09:00:00', '2025-01-10 09:00:00');

-- ============================================================
-- FINANCEIRO: Itens de Orçamento
-- ============================================================
INSERT INTO financeiro.tb_orcamento_item (fk_ano_exercicio, fk_nome_fonte, fk_nome_categoria, fk_nome_centro_custo, valor_previsto, observacao) VALUES
(2025, 'FNDE - PDDE',          'Material Didático',     'Ensino Fundamental I',  25000.00, 'Aquisição de livros didáticos'),
(2025, 'FNDE - PDDE',          'Tecnologia',            'Laboratório',           30000.00, 'Notebooks e projetores'),
(2025, 'FNDE - PDDE',          'Manutenção Predial',    'Administração',         30000.00, 'Reforma de banheiros'),
(2025, 'FUNDEB Estadual',      'Serviços Terceirizados','Administração',         80000.00, 'Contrato de limpeza anual'),
(2025, 'FUNDEB Estadual',      'Alimentação Escolar',   'Ensino Fundamental I',  90000.00, 'Merenda escolar'),
(2025, 'FUNDEB Estadual',      'Capacitação Docente',   'Ensino Fundamental II', 40000.00, 'Formação continuada'),
(2025, 'Prefeitura Municipal', 'Material Didático',     'Ensino Fundamental II', 60000.00, 'Material complementar'),
(2025, 'Prefeitura Municipal', 'Tecnologia',            'Laboratório',           90000.00, 'Ampliação do laboratório'),
(2025, 'Projeto Ler e Aprender','Material Didático',    'Biblioteca',            18000.00, 'Novos títulos para o acervo');

-- ============================================================
-- FINANCEIRO: Fornecedores
-- ============================================================
INSERT INTO financeiro.tb_fornecedores (pk_documento_fornecedor, nome_fornecedor, tipo_fornecedor, email, telefone, cidade, uf, status_fornecedor) VALUES
('12345678000195', 'Distribuidora Saber Ltda',        'Pessoa Juridica', 'contato@distribuidorasaber.com.br', '1133445566', 'São Paulo',   'SP', 'Ativo'),
('98765432000118', 'TecnoEdu Equipamentos ME',        'Pessoa Juridica', 'vendas@tecnoedu.com.br',            '1199887766', 'Campinas',    'SP', 'Ativo'),
('11223344000150', 'Serviços e Limpeza Limpo Total',  'Pessoa Juridica', 'financeiro@limpototal.com.br',      '1132109876', 'Guarulhos',   'SP', 'Ativo'),
('55667788000172', 'Nutrição Escolar Bem Nutrir Ltda','Pessoa Juridica', 'nutrir@bemnutrir.com.br',           '1155443322', 'Osasco',      'SP', 'Ativo'),
('33445566000189', 'Reforma e Construção JB Obras',  'Pessoa Juridica', 'orcamentos@jbobras.com.br',         '1177889900', 'São Bernardo','SP', 'Ativo');

-- ============================================================
-- FINANCEIRO: Contratos
-- ============================================================
INSERT INTO financeiro.tb_contratos (pk_numero_contrato, fk_nome_centro_custo, fk_documento_fornecedor, objeto_contrato, valor_total, data_inicio, data_fim, situacao_contrato, data_cadastro, data_atualizacao) VALUES
('CONT-2025-001', 'Administração',         '11223344000150', 'Prestação de serviços de limpeza e conservação', 72000.00, '2025-02-01', '2025-12-31', 'ativo',     '2025-01-28 10:00:00', '2025-01-28 10:00:00'),
('CONT-2025-002', 'Ensino Fundamental I',  '55667788000172', 'Fornecimento de merenda escolar',                 88000.00, '2025-02-01', '2025-12-31', 'ativo',     '2025-01-28 10:30:00', '2025-01-28 10:30:00'),
('CONT-2025-003', 'Laboratório',           '98765432000118', 'Aquisição de equipamentos de informática',        28500.00, '2025-03-01', '2025-06-30', 'encerrado', '2025-02-20 14:00:00', '2025-07-10 09:00:00'),
('CONT-2025-004', 'Administração',         '33445566000189', 'Reforma e pintura de salas de aula',              29800.00, '2025-04-01', '2025-07-31', 'encerrado', '2025-03-15 11:00:00', '2025-08-05 10:00:00');

-- ============================================================
-- FINANCEIRO: Receitas
-- ============================================================
INSERT INTO financeiro.tb_receitas (fk_nome_centro_custo, fk_nome_fonte, descricao, valor_recebido, data_recebimento, exercicio, numero_documento, data_cadastro, data_atualizacao) VALUES
('Administração',        'FNDE - PDDE',          'Repasse PDDE 1ª parcela 2025',         42500.00, '2025-03-15', 2025, 'PDDE-2025-001', '2025-03-15 09:00:00', '2025-03-15 09:00:00'),
('Administração',        'FNDE - PDDE',          'Repasse PDDE 2ª parcela 2025',         42500.00, '2025-08-20', 2025, 'PDDE-2025-002', '2025-08-20 09:00:00', '2025-08-20 09:00:00'),
('Ensino Fundamental I', 'FUNDEB Estadual',       'Repasse FUNDEB março/2025',            26666.67, '2025-03-31', 2025, 'FUND-2025-03',  '2025-03-31 10:00:00', '2025-03-31 10:00:00'),
('Ensino Fundamental I', 'FUNDEB Estadual',       'Repasse FUNDEB abril/2025',            26666.67, '2025-04-30', 2025, 'FUND-2025-04',  '2025-04-30 10:00:00', '2025-04-30 10:00:00'),
('Administração',        'Prefeitura Municipal',  'Repasse municipal 1º semestre 2025',   75000.00, '2025-02-10', 2025, 'PREF-2025-01',  '2025-02-10 11:00:00', '2025-02-10 11:00:00'),
('Biblioteca',           'Projeto Ler e Aprender','Verba do projeto - aquisição de livros',18000.00,'2025-04-05', 2025, 'PROJ-LA-2025',  '2025-04-05 14:00:00', '2025-04-05 14:00:00');

-- ============================================================
-- FINANCEIRO: Despesas
-- ============================================================
INSERT INTO financeiro.tb_despesas (fk_nome_categoria, fk_orcamento_item, fk_nome_centro_custo, fk_nome_fonte, fk_numero_contrato, fk_documento_fornecedor, descricao, valor_despesa, data_vencimento, data_emissao, exercicio, numero_documento, status_despesa, data_cadastro, data_atualizacao) VALUES
('Serviços Terceirizados', 4, 'Administração',         'FUNDEB Estadual',      'CONT-2025-001', '11223344000150', 'Serviço de limpeza fevereiro/2025',    6000.00, '2025-02-28', '2025-02-01', 2025, 'NF-LT-0234', 'Paga',      '2025-02-01 09:00:00', '2025-03-02 10:00:00'),
('Serviços Terceirizados', 4, 'Administração',         'FUNDEB Estadual',      'CONT-2025-001', '11223344000150', 'Serviço de limpeza março/2025',        6000.00, '2025-03-31', '2025-03-01', 2025, 'NF-LT-0258', 'Paga',      '2025-03-01 09:00:00', '2025-04-02 10:00:00'),
('Alimentação Escolar',    5, 'Ensino Fundamental I',  'FUNDEB Estadual',      'CONT-2025-002', '55667788000172', 'Merenda escolar fevereiro/2025',       7200.00, '2025-02-28', '2025-02-01', 2025, 'NF-BN-1102', 'Paga',      '2025-02-01 10:00:00', '2025-03-02 11:00:00'),
('Alimentação Escolar',    5, 'Ensino Fundamental I',  'FUNDEB Estadual',      'CONT-2025-002', '55667788000172', 'Merenda escolar março/2025',           7200.00, '2025-03-31', '2025-03-01', 2025, 'NF-BN-1130', 'Paga',      '2025-03-01 10:00:00', '2025-04-02 11:00:00'),
('Tecnologia',             2, 'Laboratório',           'FNDE - PDDE',          'CONT-2025-003', '98765432000118', 'Aquisição de 15 notebooks',           22500.00, '2025-04-15', '2025-03-10', 2025, 'NF-TE-0089', 'Paga',      '2025-03-10 14:00:00', '2025-04-18 09:00:00'),
('Tecnologia',             2, 'Laboratório',           'FNDE - PDDE',          'CONT-2025-003', '98765432000118', 'Aquisição de 4 projetores multimídia',  6000.00, '2025-05-10', '2025-04-05', 2025, 'NF-TE-0102', 'Paga',      '2025-04-05 14:00:00', '2025-05-12 09:00:00'),
('Manutenção Predial',     3, 'Administração',         'FNDE - PDDE',          'CONT-2025-004', '33445566000189', 'Reforma de banheiros bloco A',        14900.00, '2025-06-30', '2025-04-10', 2025, 'NF-JB-0501', 'Paga',      '2025-04-10 11:00:00', '2025-07-05 14:00:00'),
('Manutenção Predial',     3, 'Administração',         'FNDE - PDDE',          'CONT-2025-004', '33445566000189', 'Pintura de 8 salas de aula',          14900.00, '2025-07-31', '2025-05-15', 2025, 'NF-JB-0522', 'Paga',      '2025-05-15 11:00:00', '2025-08-05 14:00:00'),
('Material Didático',      1, 'Ensino Fundamental I',  'FNDE - PDDE',          NULL,            '12345678000195', 'Livros didáticos 1º ao 3º ano',       12400.00, '2025-03-20', '2025-03-01', 2025, 'NF-DS-2231', 'Paga',      '2025-03-01 09:00:00', '2025-03-22 10:00:00'),
('Material Didático',      9, 'Biblioteca',            'Projeto Ler e Aprender',NULL,           '12345678000195', 'Acervo literário infantojuvenil',     17800.00, '2025-05-05', '2025-04-10', 2025, 'NF-DS-2290', 'Paga',      '2025-04-10 09:00:00', '2025-05-07 10:00:00');

-- ============================================================
-- FINANCEIRO: Pagamentos
-- ============================================================
INSERT INTO financeiro.tb_pagamentos (pk_numero_comprovante, fk_despesa, data_pagamento, valor_pago, forma_pagamento, data_cadastro) VALUES
('COMP-2025-0001', 1,  '2025-03-02', 6000.00,  'Transferência Bancária', '2025-03-02 10:30:00'),
('COMP-2025-0002', 2,  '2025-04-02', 6000.00,  'Transferência Bancária', '2025-04-02 10:30:00'),
('COMP-2025-0003', 3,  '2025-03-02', 7200.00,  'Transferência Bancária', '2025-03-02 11:00:00'),
('COMP-2025-0004', 4,  '2025-04-02', 7200.00,  'Transferência Bancária', '2025-04-02 11:00:00'),
('COMP-2025-0005', 5,  '2025-04-18', 22500.00, 'Transferência Bancária', '2025-04-18 09:30:00'),
('COMP-2025-0006', 6,  '2025-05-12', 6000.00,  'Transferência Bancária', '2025-05-12 09:30:00'),
('COMP-2025-0007', 7,  '2025-07-05', 14900.00, 'Transferência Bancária', '2025-07-05 14:30:00'),
('COMP-2025-0008', 8,  '2025-08-05', 14900.00, 'Transferência Bancária', '2025-08-05 14:30:00'),
('COMP-2025-0009', 9,  '2025-03-22', 12400.00, 'Transferência Bancária', '2025-03-22 10:00:00'),
('COMP-2025-0010', 10, '2025-05-07', 17800.00, 'Transferência Bancária', '2025-05-07 10:00:00');

-- ============================================================
-- RH: Departamentos
-- ============================================================
INSERT INTO rh.tb_departamentos (pk_nome_departamento, status_departamento) VALUES
('Pedagogia',              'Ativo'),
('Administração Escolar',  'Ativo'),
('Coordenação Pedagógica', 'Ativo'),
('Secretaria',             'Ativo'),
('Serviços Gerais',        'Ativo');

-- ============================================================
-- RH: Cargos
-- ============================================================
INSERT INTO rh.tb_cargos (pk_nome_cargo, salario_base, status_cargo) VALUES
('Professor',             4500.00,  'Ativo'),
('Coordenador Pedagógico',6800.00,  'Ativo'),
('Diretor',               9500.00,  'Ativo'),
('Secretário Escolar',    3200.00,  'Ativo'),
('Auxiliar Administrativo',2800.00, 'Ativo'),
('Zelador',               2200.00,  'Ativo');

-- ============================================================
-- BASE: Pessoas (Funcionários)
-- ============================================================
INSERT INTO base.tb_pessoa (pk_cpf, nome, sobrenome, nome_social, data_nascimento, sexo, raca_cor, nacionalidade, naturalidade, data_cadastro, data_atualizacao) VALUES
-- Coordenadores
('30122198740', 'Márcia',    'Fernandes Souza',   NULL, '1978-05-12', 'Feminino',  'Parda',   'Brasileira', 'Belo Horizonte - MG', '2019-01-10 08:00:00', '2019-01-10 08:00:00'),
('41233298751', 'Roberto',   'Alves Teixeira',    NULL, '1975-09-03', 'Masculino', 'Branca',  'Brasileira', 'São Paulo - SP',       '2018-02-05 08:00:00', '2018-02-05 08:00:00'),
-- Professores
('52344398762', 'Luciana',   'Mendes Carvalho',   NULL, '1982-03-20', 'Feminino',  'Branca',  'Brasileira', 'Curitiba - PR',        '2020-02-10 08:00:00', '2020-02-10 08:00:00'),
('63455498773', 'Paulo',     'Henrique Nascimento',NULL,'1980-07-15', 'Masculino', 'Parda',   'Brasileira', 'Recife - PE',          '2020-02-10 08:00:00', '2020-02-10 08:00:00'),
('74566598784', 'Ana',       'Paula Lima',        NULL, '1985-11-28', 'Feminino',  'Negra',   'Brasileira', 'Salvador - BA',        '2021-03-01 08:00:00', '2021-03-01 08:00:00'),
('85677698795', 'Marcelo',   'Santos Oliveira',   NULL, '1979-04-07', 'Masculino', 'Branca',  'Brasileira', 'Porto Alegre - RS',    '2019-07-15 08:00:00', '2019-07-15 08:00:00'),
('96788798806', 'Fernanda',  'Costa Rodrigues',   NULL, '1987-02-14', 'Feminino',  'Parda',   'Brasileira', 'Fortaleza - CE',       '2022-02-07 08:00:00', '2022-02-07 08:00:00'),
('07899898817', 'Thiago',    'Batista Morais',    NULL, '1983-08-30', 'Masculino', 'Negra',   'Brasileira', 'Manaus - AM',          '2021-02-10 08:00:00', '2021-02-10 08:00:00'),
('18900998828', 'Simone',    'Araújo Pereira',    NULL, '1986-12-01', 'Feminino',  'Branca',  'Brasileira', 'Goiânia - GO',        '2020-07-20 08:00:00', '2020-07-20 08:00:00'),
-- Secretária
('29011098839', 'Carla',     'Ribeiro Dias',      NULL, '1990-06-18', 'Feminino',  'Parda',   'Brasileira', 'São Paulo - SP',       '2022-08-01 08:00:00', '2022-08-01 08:00:00');

-- ============================================================
-- BASE: Endereços (Funcionários)
-- ============================================================
INSERT INTO base.tb_enderecos (cep, logradouro, numero, complemento, bairro, cidade, uf, fk_cpf) VALUES
('01310100', 'Avenida Paulista',       '1500', 'Apto 42', 'Bela Vista',     'São Paulo',       'SP', '30122198740'),
('01415001', 'Rua Oscar Freire',       '320',  NULL,      'Jardins',        'São Paulo',       'SP', '41233298751'),
('80010020', 'Rua XV de Novembro',     '800',  'Sala 3',  'Centro',         'Curitiba',        'PR', '52344398762'),
('50010220', 'Avenida Boa Viagem',     '220',  'Apto 12', 'Boa Viagem',     'Recife',          'PE', '63455498773'),
('40020080', 'Rua Chile',              '450',  NULL,      'Centro',         'Salvador',        'BA', '74566598784'),
('90010150', 'Rua dos Andradas',       '980',  'Ap 201',  'Centro Histórico','Porto Alegre',   'RS', '85677698795'),
('60175300', 'Avenida Bezerra de Menezes','700',NULL,     'São Gerardo',    'Fortaleza',       'CE', '96788798806'),
('69025010', 'Avenida Djalma Batista', '1240', 'Bl B',    'Chapada',        'Manaus',          'AM', '07899898817'),
('74805380', 'Rua 68',                 '155',  NULL,      'Setor Sul',      'Goiânia',         'GO', '18900998828'),
('04552050', 'Rua Domingos de Morais', '2100', 'Apto 74', 'Vila Mariana',   'São Paulo',       'SP', '29011098839');

-- ============================================================
-- BASE: Telefones (Funcionários)
-- ============================================================
INSERT INTO base.tb_telefones (pk_ddd, pk_numero, fk_cpf, ddi, tipo_telefone, ativo) VALUES
('11', '991230001', '30122198740', '55', 'Celular',      'Ativo'),
('11', '992340002', '41233298751', '55', 'Celular',      'Ativo'),
('41', '993450003', '52344398762', '55', 'Celular',      'Ativo'),
('81', '994560004', '63455498773', '55', 'Celular',      'Ativo'),
('71', '995670005', '74566598784', '55', 'Celular',      'Ativo'),
('51', '996780006', '85677698795', '55', 'Celular',      'Ativo'),
('85', '997890007', '96788798806', '55', 'Celular',      'Ativo'),
('92', '998900008', '07899898817', '55', 'Celular',      'Ativo'),
('62', '999010009', '18900998828', '55', 'Celular',      'Ativo'),
('11', '990120010', '29011098839', '55', 'Celular',      'Ativo');

-- ============================================================
-- RH: Funcionários
-- ============================================================
INSERT INTO rh.tb_funcionario (pk_cpf, fk_nome_cargo, status_funcionario, data_admissao, data_desligamento, data_cadastro, data_atualizacao) VALUES
('30122198740', 'Coordenador Pedagógico', 'Ativo', '2019-01-10', NULL, '2019-01-10 08:00:00', '2019-01-10 08:00:00'),
('41233298751', 'Coordenador Pedagógico', 'Ativo', '2018-02-05', NULL, '2018-02-05 08:00:00', '2018-02-05 08:00:00'),
('52344398762', 'Professor',              'Ativo', '2020-02-10', NULL, '2020-02-10 08:00:00', '2020-02-10 08:00:00'),
('63455498773', 'Professor',              'Ativo', '2020-02-10', NULL, '2020-02-10 08:00:00', '2020-02-10 08:00:00'),
('74566598784', 'Professor',              'Ativo', '2021-03-01', NULL, '2021-03-01 08:00:00', '2021-03-01 08:00:00'),
('85677698795', 'Professor',              'Ativo', '2019-07-15', NULL, '2019-07-15 08:00:00', '2019-07-15 08:00:00'),
('96788798806', 'Professor',              'Ativo', '2022-02-07', NULL, '2022-02-07 08:00:00', '2022-02-07 08:00:00'),
('07899898817', 'Professor',              'Ativo', '2021-02-10', NULL, '2021-02-10 08:00:00', '2021-02-10 08:00:00'),
('18900998828', 'Professor',              'Ativo', '2020-07-20', NULL, '2020-07-20 08:00:00', '2020-07-20 08:00:00'),
('29011098839', 'Secretário Escolar',     'Ativo', '2022-08-01', NULL, '2022-08-01 08:00:00', '2022-08-01 08:00:00');

-- ============================================================
-- RH: Professores
-- ============================================================
INSERT INTO rh.tb_professor (pk_cpf, registro_docente, especialidade, ativo) VALUES
('52344398762', 'REG-SP-0023441', 'Língua Portuguesa e Literatura',  'Ativo'),
('63455498773', 'REG-PE-0031552', 'Matemática e Estatística',        'Ativo'),
('74566598784', 'REG-BA-0042663', 'Ciências e Biologia',             'Ativo'),
('85677698795', 'REG-RS-0053774', 'História e Geografia',            'Ativo'),
('96788798806', 'REG-CE-0064885', 'Educação Física',                 'Ativo'),
('07899898817', 'REG-AM-0075996', 'Arte e Música',                   'Ativo'),
('18900998828', 'REG-GO-0087107', 'Inglês e Espanhol',               'Ativo');

-- ============================================================
-- RH: Coordenação
-- ============================================================
INSERT INTO rh.tb_coordenacao (pk_cpf, area_responsavel, ativo) VALUES
('30122198740', 'Ensino Fundamental I',  'Ativo'),
('41233298751', 'Ensino Fundamental II', 'Ativo');

-- ============================================================
-- RH: Lotação de Funcionários
-- ============================================================
INSERT INTO rh.tb_lotacao_funcionario (fk_cpf, fk_nome_departamento, data_inicio, data_fim, lotacao_principal, data_cadastro, data_atualizacao) VALUES
('30122198740', 'Coordenação Pedagógica', '2019-01-10', NULL, 1, '2019-01-10 08:00:00', NULL),
('41233298751', 'Coordenação Pedagógica', '2018-02-05', NULL, 1, '2018-02-05 08:00:00', NULL),
('52344398762', 'Pedagogia',              '2020-02-10', NULL, 1, '2020-02-10 08:00:00', NULL),
('63455498773', 'Pedagogia',              '2020-02-10', NULL, 1, '2020-02-10 08:00:00', NULL),
('74566598784', 'Pedagogia',              '2021-03-01', NULL, 1, '2021-03-01 08:00:00', NULL),
('85677698795', 'Pedagogia',              '2019-07-15', NULL, 1, '2019-07-15 08:00:00', NULL),
('96788798806', 'Pedagogia',              '2022-02-07', NULL, 1, '2022-02-07 08:00:00', NULL),
('07899898817', 'Pedagogia',              '2021-02-10', NULL, 1, '2021-02-10 08:00:00', NULL),
('18900998828', 'Pedagogia',              '2020-07-20', NULL, 1, '2020-07-20 08:00:00', NULL),
('29011098839', 'Secretaria',             '2022-08-01', NULL, 1, '2022-08-01 08:00:00', NULL);

-- ============================================================
-- RH: Folha de Pagamento (amostra - 3 meses para professores e coord.)
-- ============================================================
INSERT INTO rh.tb_folha_pagamento (pk_cpf, pk_competencia, salario_base, descontos, beneficios, data_cadastro, data_atualizacao) VALUES
('30122198740', '2025-02', 6800.00, 952.00, 450.00, '2025-02-28 18:00:00', '2025-02-28 18:00:00'),
('30122198740', '2025-03', 6800.00, 952.00, 450.00, '2025-03-31 18:00:00', '2025-03-31 18:00:00'),
('30122198740', '2025-04', 6800.00, 952.00, 450.00, '2025-04-30 18:00:00', '2025-04-30 18:00:00'),
('41233298751', '2025-02', 6800.00, 952.00, 450.00, '2025-02-28 18:00:00', '2025-02-28 18:00:00'),
('41233298751', '2025-03', 6800.00, 952.00, 450.00, '2025-03-31 18:00:00', '2025-03-31 18:00:00'),
('52344398762', '2025-02', 4500.00, 630.00, 300.00, '2025-02-28 18:00:00', '2025-02-28 18:00:00'),
('52344398762', '2025-03', 4500.00, 630.00, 300.00, '2025-03-31 18:00:00', '2025-03-31 18:00:00'),
('63455498773', '2025-02', 4500.00, 630.00, 300.00, '2025-02-28 18:00:00', '2025-02-28 18:00:00'),
('63455498773', '2025-03', 4500.00, 630.00, 300.00, '2025-03-31 18:00:00', '2025-03-31 18:00:00'),
('74566598784', '2025-02', 4500.00, 630.00, 300.00, '2025-02-28 18:00:00', '2025-02-28 18:00:00'),
('85677698795', '2025-02', 4500.00, 630.00, 300.00, '2025-02-28 18:00:00', '2025-02-28 18:00:00'),
('96788798806', '2025-02', 4500.00, 630.00, 300.00, '2025-02-28 18:00:00', '2025-02-28 18:00:00'),
('07899898817', '2025-02', 4500.00, 630.00, 300.00, '2025-02-28 18:00:00', '2025-02-28 18:00:00'),
('18900998828', '2025-02', 4500.00, 630.00, 300.00, '2025-02-28 18:00:00', '2025-02-28 18:00:00'),
('29011098839', '2025-02', 3200.00, 448.00, 200.00, '2025-02-28 18:00:00', '2025-02-28 18:00:00');

-- ============================================================
-- RH: Folha Ponto (amostra - 3 dias para cada funcionário)
-- ============================================================
INSERT INTO rh.tb_folha_ponto (pk_cpf, pk_data_referencia, hora_entrada, hora_inicio_intervalo, hora_fim_intervalo, hora_saida, hora_extra, atrasos, data_cadastro) VALUES
('52344398762', '2025-03-03', '07:55:00', '12:00:00', '13:00:00', '17:00:00', 0.00, 0.00, '2025-03-03 17:05:00'),
('52344398762', '2025-03-04', '08:00:00', '12:00:00', '13:00:00', '17:10:00', 0.17, 0.00, '2025-03-04 17:15:00'),
('52344398762', '2025-03-05', '08:15:00', '12:00:00', '13:00:00', '17:00:00', 0.00, 0.25, '2025-03-05 17:05:00'),
('63455498773', '2025-03-03', '07:50:00', '12:00:00', '13:00:00', '17:00:00', 0.00, 0.00, '2025-03-03 17:05:00'),
('63455498773', '2025-03-04', '08:00:00', '12:00:00', '13:00:00', '17:00:00', 0.00, 0.00, '2025-03-04 17:05:00'),
('74566598784', '2025-03-03', '08:00:00', '12:00:00', '13:00:00', '17:30:00', 0.50, 0.00, '2025-03-03 17:35:00'),
('85677698795', '2025-03-03', '08:00:00', '12:00:00', '13:00:00', '17:00:00', 0.00, 0.00, '2025-03-03 17:05:00'),
('96788798806', '2025-03-03', '07:45:00', '12:00:00', '13:00:00', '17:00:00', 0.00, 0.00, '2025-03-03 17:05:00'),
('30122198740', '2025-03-03', '07:30:00', '12:00:00', '13:00:00', '18:00:00', 1.00, 0.00, '2025-03-03 18:05:00'),
('29011098839', '2025-03-03', '08:00:00', '12:00:00', '13:00:00', '17:00:00', 0.00, 0.00, '2025-03-03 17:05:00');

-- ============================================================
-- RH: Férias
-- ============================================================
INSERT INTO rh.tb_ferias (pk_cpf, pk_data_inicio, data_fim, data_cadastro) VALUES
('52344398762', '2025-07-07', '2025-07-25', '2025-06-01 09:00:00'),
('63455498773', '2025-07-07', '2025-07-25', '2025-06-01 09:00:00'),
('74566598784', '2025-07-07', '2025-07-25', '2025-06-01 09:00:00'),
('85677698795', '2025-07-14', '2025-08-01', '2025-06-01 09:00:00'),
('30122198740', '2025-07-07', '2025-07-25', '2025-06-01 09:00:00');

-- ============================================================
-- BASE: Pessoas (Responsáveis pelos Alunos)
-- ============================================================
INSERT INTO base.tb_pessoa (pk_cpf, nome, sobrenome, nome_social, data_nascimento, sexo, raca_cor, nacionalidade, naturalidade, data_cadastro, data_atualizacao) VALUES
('11100011100', 'Rosangela',  'Ferreira Lima',     NULL, '1978-04-10', 'Feminino',  'Parda',   'Brasileira', 'São Paulo - SP',     '2023-01-20 08:00:00', '2023-01-20 08:00:00'),
('22200022200', 'Jorge',      'Luis Andrade',      NULL, '1975-11-22', 'Masculino', 'Branca',  'Brasileira', 'Campinas - SP',      '2023-01-20 08:00:00', '2023-01-20 08:00:00'),
('33300033300', 'Vanessa',    'Moreira Santos',    NULL, '1982-07-05', 'Feminino',  'Negra',   'Brasileira', 'São Paulo - SP',     '2023-01-20 08:00:00', '2023-01-20 08:00:00'),
('44400044400', 'Eduardo',    'Pinto Cavalcante',  NULL, '1980-02-18', 'Masculino', 'Parda',   'Brasileira', 'Santos - SP',        '2023-01-20 08:00:00', '2023-01-20 08:00:00'),
('55500055500', 'Patricia',   'Silva Gomes',       NULL, '1979-09-30', 'Feminino',  'Branca',  'Brasileira', 'São Paulo - SP',     '2023-01-20 08:00:00', '2023-01-20 08:00:00'),
('66600066600', 'Marcos',     'Vieira Nunes',      NULL, '1977-06-14', 'Masculino', 'Parda',   'Brasileira', 'Sorocaba - SP',      '2023-01-20 08:00:00', '2023-01-20 08:00:00'),
('77700077700', 'Cláudia',    'Ramos Sousa',       NULL, '1984-03-25', 'Feminino',  'Branca',  'Brasileira', 'São Paulo - SP',     '2023-01-20 08:00:00', '2023-01-20 08:00:00'),
('88800088800', 'Ricardo',    'Barbosa Freitas',   NULL, '1976-12-09', 'Masculino', 'Negra',   'Brasileira', 'Osasco - SP',        '2023-01-20 08:00:00', '2023-01-20 08:00:00'),
('99900099900', 'Juliana',    'Torres Meireles',   NULL, '1983-08-16', 'Feminino',  'Amarela', 'Brasileira', 'São Paulo - SP',     '2023-01-20 08:00:00', '2023-01-20 08:00:00'),
('10010010010', 'Anderson',   'Lopes Cardoso',     NULL, '1981-05-27', 'Masculino', 'Parda',   'Brasileira', 'Guarulhos - SP',     '2023-01-20 08:00:00', '2023-01-20 08:00:00');

-- ============================================================
-- BASE: Endereços (Responsáveis)
-- ============================================================
INSERT INTO base.tb_enderecos (cep, logradouro, numero, complemento, bairro, cidade, uf, fk_cpf) VALUES
('08150000', 'Rua das Acácias',        '45',  NULL,     'Itaquera',     'São Paulo', 'SP', '11100011100'),
('09040000', 'Rua Santo André',        '210', 'Ap 31',  'Centro',       'São Paulo', 'SP', '22200022200'),
('04870000', 'Rua Coronel Melo',       '88',  NULL,     'Jardim Ângela','São Paulo', 'SP', '33300033300'),
('11050000', 'Avenida Ana Costa',      '550', 'Apto 12','Gonzaga',      'Santos',    'SP', '44400044400'),
('01310000', 'Rua Augusta',            '1800','Cj 42',  'Consolação',   'São Paulo', 'SP', '55500055500'),
('18010000', 'Rua Dr. Braguinha',      '320', NULL,     'Centro',       'Sorocaba',  'SP', '66600066600'),
('05335000', 'Rua Tenente Pena',       '65',  NULL,     'Lapa',         'São Paulo', 'SP', '77700077700'),
('06018000', 'Rua Ari Barroso',        '730', 'Bl 2',   'Centro',       'Osasco',    'SP', '88800088800'),
('04552000', 'Rua Domingos de Morais', '800', 'Ap 55',  'Vila Mariana', 'São Paulo', 'SP', '99900099900'),
('07180000', 'Rua Barão de Mauá',      '190', NULL,     'Centro',       'Guarulhos', 'SP', '10010010010');

-- ============================================================
-- BASE: Telefones (Responsáveis)
-- ============================================================
INSERT INTO base.tb_telefones (pk_ddd, pk_numero, fk_cpf, ddi, tipo_telefone, ativo) VALUES
('11', '981110011', '11100011100', '55', 'Celular', 'Ativo'),
('11', '982220022', '22200022200', '55', 'Celular', 'Ativo'),
('11', '983330033', '33300033300', '55', 'Celular', 'Ativo'),
('13', '984440044', '44400044400', '55', 'Celular', 'Ativo'),
('11', '985550055', '55500055500', '55', 'Celular', 'Ativo'),
('15', '986660066', '66600066600', '55', 'Celular', 'Ativo'),
('11', '987770077', '77700077700', '55', 'Celular', 'Ativo'),
('11', '988880088', '88800088800', '55', 'Celular', 'Ativo'),
('11', '989990099', '99900099900', '55', 'Celular', 'Ativo'),
('11', '980100100', '10010010010', '55', 'Celular', 'Ativo');

-- ============================================================
-- ACADÊMICO: Responsáveis
-- ============================================================
INSERT INTO academico.tb_responsavel (fk_cpf, profissao, status_responsavel) VALUES
('11100011100', 'Auxiliar de Escritório', 'ativo'),
('22200022200', 'Técnico em Eletrônica',  'ativo'),
('33300033300', 'Enfermeira',             'ativo'),
('44400044400', 'Comerciante',            'ativo'),
('55500055500', 'Professora',             'ativo'),
('66600066600', 'Motorista',              'ativo'),
('77700077700', 'Administradora',         'ativo'),
('88800088800', 'Mecânico',               'ativo'),
('99900099900', 'Analista de Sistemas',   'ativo'),
('10010010010', 'Operador de Logística',  'ativo');

-- ============================================================
-- BASE: Pessoas (Alunos - 20 alunos únicos)
-- ============================================================
INSERT INTO base.tb_pessoa (pk_cpf, nome, sobrenome, nome_social, data_nascimento, sexo, raca_cor, nacionalidade, naturalidade, data_cadastro, data_atualizacao) VALUES
('12311100001', 'Gabriel',    'Ferreira Lima',      NULL, '2010-03-15', 'Masculino', 'Parda',   'Brasileira', 'São Paulo - SP',   '2023-01-20 09:00:00', '2023-01-20 09:00:00'),
('23422200002', 'Isabela',    'Andrade Santos',     NULL, '2010-07-22', 'Feminino',  'Branca',  'Brasileira', 'São Paulo - SP',   '2023-01-20 09:00:00', '2023-01-20 09:00:00'),
('34533300003', 'Lucas',      'Moreira Silva',      NULL, '2011-01-10', 'Masculino', 'Negra',   'Brasileira', 'Guarulhos - SP',   '2023-01-20 09:00:00', '2023-01-20 09:00:00'),
('45644400004', 'Larissa',    'Cavalcante Alves',   NULL, '2011-05-30', 'Feminino',  'Parda',   'Brasileira', 'Osasco - SP',      '2023-01-20 09:00:00', '2023-01-20 09:00:00'),
('56755500005', 'Matheus',    'Gomes Pereira',      NULL, '2010-09-08', 'Masculino', 'Branca',  'Brasileira', 'São Paulo - SP',   '2023-01-20 09:00:00', '2023-01-20 09:00:00'),
('67866600006', 'Vitória',    'Nunes Rocha',        NULL, '2011-11-25', 'Feminino',  'Negra',   'Brasileira', 'São Paulo - SP',   '2023-01-20 09:00:00', '2023-01-20 09:00:00'),
('78977700007', 'Felipe',     'Sousa Martins',      NULL, '2012-02-14', 'Masculino', 'Parda',   'Brasileira', 'Santo André - SP', '2023-01-20 09:00:00', '2023-01-20 09:00:00'),
('89088800008', 'Amanda',     'Freitas Cardoso',    NULL, '2012-06-03', 'Feminino',  'Branca',  'Brasileira', 'São Paulo - SP',   '2023-01-20 09:00:00', '2023-01-20 09:00:00'),
('90199900009', 'Rafael',     'Meireles Torres',    NULL, '2012-10-19', 'Masculino', 'Amarela', 'Brasileira', 'São Paulo - SP',   '2023-01-20 09:00:00', '2023-01-20 09:00:00'),
('01200000010', 'Camila',     'Cardoso Lopes',      NULL, '2013-04-07', 'Feminino',  'Parda',   'Brasileira', 'São Paulo - SP',   '2023-01-20 09:00:00', '2023-01-20 09:00:00'),
('13311111111', 'Breno',      'Alves Brito',        NULL, '2010-08-21', 'Masculino', 'Parda',   'Brasileira', 'Diadema - SP',     '2023-01-20 09:00:00', '2023-01-20 09:00:00'),
('24422222222', 'Letícia',    'Santos Cunha',       NULL, '2010-12-14', 'Feminino',  'Branca',  'Brasileira', 'São Paulo - SP',   '2023-01-20 09:00:00', '2023-01-20 09:00:00'),
('35533333333', 'Diego',      'Oliveira Barbosa',   NULL, '2011-03-28', 'Masculino', 'Negra',   'Brasileira', 'Mauá - SP',        '2023-01-20 09:00:00', '2023-01-20 09:00:00'),
('46644444444', 'Mariana',    'Ribeiro Teixeira',   NULL, '2011-09-16', 'Feminino',  'Parda',   'Brasileira', 'São Paulo - SP',   '2023-01-20 09:00:00', '2023-01-20 09:00:00'),
('57755555555', 'Victor',     'Cruz Pimentel',      NULL, '2012-01-05', 'Masculino', 'Branca',  'Brasileira', 'São Paulo - SP',   '2023-01-20 09:00:00', '2023-01-20 09:00:00'),
('68866666666', 'Fernanda',   'Dias Monteiro',      NULL, '2012-07-23', 'Feminino',  'Indigena','Brasileira', 'São Paulo - SP',   '2023-01-20 09:00:00', '2023-01-20 09:00:00'),
('79977777777', 'Gustavo',    'Melo Correia',       NULL, '2013-02-11', 'Masculino', 'Parda',   'Brasileira', 'São Paulo - SP',   '2023-01-20 09:00:00', '2023-01-20 09:00:00'),
('80088888888', 'Beatriz',    'Nascimento Faria',   NULL, '2013-06-29', 'Feminino',  'Negra',   'Brasileira', 'Guarulhos - SP',   '2023-01-20 09:00:00', '2023-01-20 09:00:00'),
('91199999999', 'Leonardo',   'Carvalho Duarte',    NULL, '2013-10-08', 'Masculino', 'Branca',  'Brasileira', 'São Paulo - SP',   '2023-01-20 09:00:00', '2023-01-20 09:00:00'),
('02200000001', 'Sophia',     'Azevedo Campos',     NULL, '2014-03-17', 'Feminino',  'Parda',   'Brasileira', 'São Paulo - SP',   '2023-01-20 09:00:00', '2023-01-20 09:00:00');

-- ============================================================
-- BASE: Endereços (Alunos)
-- ============================================================
INSERT INTO base.tb_enderecos (cep, logradouro, numero, complemento, bairro, cidade, uf, fk_cpf) VALUES
('08155000', 'Rua das Garças',          '12',  NULL,      'Itaquera',        'São Paulo',   'SP', '12311100001'),
('08155001', 'Rua Doutor Coutinho',     '54',  NULL,      'Itaquera',        'São Paulo',   'SP', '23422200002'),
('07194000', 'Rua dos Ipês',            '200', NULL,      'Jardim Tranquilidade','Guarulhos','SP', '34533300003'),
('06083000', 'Rua Florencio de Abreu',  '330', 'Ap 4',    'Centro',          'Osasco',      'SP', '45644400004'),
('02710000', 'Rua Voluntários da Pátria','780', NULL,     'Santana',         'São Paulo',   'SP', '56755500005'),
('02710001', 'Rua Voluntários da Pátria','780', 'Ap 11',  'Santana',         'São Paulo',   'SP', '67866600006'),
('09080000', 'Rua Coronel Oliveira Lima','90', NULL,      'Centro',          'Santo André', 'SP', '78977700007'),
('04675000', 'Rua Arizona',             '450', 'Apto 22', 'Brooklyn',        'São Paulo',   'SP', '89088800008'),
('04552001', 'Rua Domingos de Morais',  '400', 'Bl A',    'Vila Mariana',    'São Paulo',   'SP', '90199900009'),
('05437000', 'Rua Amador Bueno',        '22',  NULL,      'Campo Limpo',     'São Paulo',   'SP', '01200000010'),
('09950000', 'Rua Manoel da Nóbrega',   '67',  NULL,      'Centro',          'Diadema',     'SP', '13311111111'),
('01327000', 'Rua Bela Cintra',         '1100','Ap 34',   'Consolação',      'São Paulo',   'SP', '24422222222'),
('09390000', 'Rua Antônio de Barros',   '510', NULL,      'Centro',          'Mauá',        'SP', '35533333333'),
('03307000', 'Avenida Celso Garcia',    '680', 'Ap 7',    'Tatuapé',         'São Paulo',   'SP', '46644444444'),
('04547000', 'Rua Vergueiro',           '3200','Ap 105',  'Vila Mariana',    'São Paulo',   'SP', '57755555555'),
('03803000', 'Rua Tuiuti',              '220', NULL,      'Tatuapé',         'São Paulo',   'SP', '68866666666'),
('02040000', 'Rua Luís Murat',          '50',  NULL,      'Jardim São Paulo', 'São Paulo',  'SP', '79977777777'),
('07181000', 'Rua Marechal Deodoro',    '333', 'Ap 22',   'Centro',          'Guarulhos',   'SP', '80088888888'),
('05435000', 'Rua Piraporinha',         '110', NULL,      'Campo Limpo',     'São Paulo',   'SP', '91199999999'),
('04721000', 'Rua Pedroso Alvarenga',   '220', 'Cj 3',    'Itaim Bibi',      'São Paulo',   'SP', '02200000001');

-- ============================================================
-- BASE: Telefones (Alunos)
-- ============================================================
INSERT INTO base.tb_telefones (pk_ddd, pk_numero, fk_cpf, ddi, tipo_telefone, ativo) VALUES
('11', '910001001', '12311100001', '55', 'Residencial', 'Ativo'),
('11', '920002002', '23422200002', '55', 'Residencial', 'Ativo'),
('11', '930003003', '34533300003', '55', 'Residencial', 'Ativo'),
('11', '940004004', '45644400004', '55', 'Residencial', 'Ativo'),
('11', '950005005', '56755500005', '55', 'Residencial', 'Ativo'),
('11', '960006006', '67866600006', '55', 'Residencial', 'Ativo'),
('11', '970007007', '78977700007', '55', 'Residencial', 'Ativo'),
('11', '980008008', '89088800008', '55', 'Residencial', 'Ativo'),
('11', '990009009', '90199900009', '55', 'Residencial', 'Ativo'),
('11', '900010010', '01200000010', '55', 'Residencial', 'Ativo'),
('11', '911011011', '13311111111', '55', 'Residencial', 'Ativo'),
('11', '922022022', '24422222222', '55', 'Residencial', 'Ativo'),
('11', '933033033', '35533333333', '55', 'Residencial', 'Ativo'),
('11', '944044044', '46644444444', '55', 'Residencial', 'Ativo'),
('11', '955055055', '57755555555', '55', 'Residencial', 'Ativo'),
('11', '966066066', '68866666666', '55', 'Residencial', 'Ativo'),
('11', '977077077', '79977777777', '55', 'Residencial', 'Ativo'),
('11', '988088088', '80088888888', '55', 'Residencial', 'Ativo'),
('11', '999099099', '91199999999', '55', 'Residencial', 'Ativo'),
('11', '900100100', '02200000001', '55', 'Residencial', 'Ativo');

-- ============================================================
-- ACADÊMICO: Alunos
-- ============================================================
INSERT INTO academico.tb_aluno (pk_cpf, email_aluno, data_ingresso, data_saida, data_cadastro, data_atualizacao) VALUES
('12311100001', 'gabriel.ferreira2025@alunoescola.edu.br',   '2023-02-01', NULL, '2023-01-20 09:00:00', '2023-01-20 09:00:00'),
('23422200002', 'isabela.andrade2025@alunoescola.edu.br',    '2023-02-01', NULL, '2023-01-20 09:00:00', '2023-01-20 09:00:00'),
('34533300003', 'lucas.moreira2025@alunoescola.edu.br',      '2023-02-01', NULL, '2023-01-20 09:00:00', '2023-01-20 09:00:00'),
('45644400004', 'larissa.cavalcante2025@alunoescola.edu.br', '2023-02-01', NULL, '2023-01-20 09:00:00', '2023-01-20 09:00:00'),
('56755500005', 'matheus.gomes2025@alunoescola.edu.br',      '2023-02-01', NULL, '2023-01-20 09:00:00', '2023-01-20 09:00:00'),
('67866600006', 'vitoria.nunes2025@alunoescola.edu.br',      '2023-02-01', NULL, '2023-01-20 09:00:00', '2023-01-20 09:00:00'),
('78977700007', 'felipe.sousa2025@alunoescola.edu.br',       '2024-02-01', NULL, '2024-01-20 09:00:00', '2024-01-20 09:00:00'),
('89088800008', 'amanda.freitas2025@alunoescola.edu.br',     '2024-02-01', NULL, '2024-01-20 09:00:00', '2024-01-20 09:00:00'),
('90199900009', 'rafael.meireles2025@alunoescola.edu.br',    '2024-02-01', NULL, '2024-01-20 09:00:00', '2024-01-20 09:00:00'),
('01200000010', 'camila.cardoso2025@alunoescola.edu.br',     '2024-02-01', NULL, '2024-01-20 09:00:00', '2024-01-20 09:00:00'),
('13311111111', 'breno.alves2025@alunoescola.edu.br',        '2023-02-01', NULL, '2023-01-20 09:00:00', '2023-01-20 09:00:00'),
('24422222222', 'leticia.santos2025@alunoescola.edu.br',     '2023-02-01', NULL, '2023-01-20 09:00:00', '2023-01-20 09:00:00'),
('35533333333', 'diego.oliveira2025@alunoescola.edu.br',     '2023-02-01', NULL, '2023-01-20 09:00:00', '2023-01-20 09:00:00'),
('46644444444', 'mariana.ribeiro2025@alunoescola.edu.br',    '2023-02-01', NULL, '2023-01-20 09:00:00', '2023-01-20 09:00:00'),
('57755555555', 'victor.cruz2025@alunoescola.edu.br',        '2024-02-01', NULL, '2024-01-20 09:00:00', '2024-01-20 09:00:00'),
('68866666666', 'fernanda.dias2025@alunoescola.edu.br',      '2024-02-01', NULL, '2024-01-20 09:00:00', '2024-01-20 09:00:00'),
('79977777777', 'gustavo.melo2025@alunoescola.edu.br',       '2025-02-01', NULL, '2025-01-20 09:00:00', '2025-01-20 09:00:00'),
('80088888888', 'beatriz.nascimento2025@alunoescola.edu.br', '2025-02-01', NULL, '2025-01-20 09:00:00', '2025-01-20 09:00:00'),
('91199999999', 'leonardo.carvalho2025@alunoescola.edu.br',  '2025-02-01', NULL, '2025-01-20 09:00:00', '2025-01-20 09:00:00'),
('02200000001', 'sophia.azevedo2025@alunoescola.edu.br',     '2025-02-01', NULL, '2025-01-20 09:00:00', '2025-01-20 09:00:00');

-- ============================================================
-- ACADÊMICO: Aluno x Responsável
-- ============================================================
INSERT INTO academico.tb_aluno_responsavel (fk_cpf, fk_cpf_responsavel, grau_parentesco, responsavel_principal) VALUES
('12311100001', '11100011100', 'Mãe',  1),
('23422200002', '22200022200', 'Pai',  1),
('34533300003', '33300033300', 'Mãe',  1),
('45644400004', '44400044400', 'Pai',  1),
('56755500005', '55500055500', 'Mãe',  1),
('67866600006', '66600066600', 'Pai',  1),
('78977700007', '77700077700', 'Mãe',  1),
('89088800008', '88800088800', 'Pai',  1),
('90199900009', '99900099900', 'Mãe',  1),
('01200000010', '10010010010', 'Pai',  1),
('13311111111', '11100011100', 'Mãe',  1),
('24422222222', '22200022200', 'Pai',  1),
('35533333333', '33300033300', 'Mãe',  1),
('46644444444', '44400044400', 'Pai',  1),
('57755555555', '55500055500', 'Mãe',  1),
('68866666666', '66600066600', 'Pai',  1),
('79977777777', '77700077700', 'Mãe',  1),
('80088888888', '88800088800', 'Pai',  1),
('91199999999', '99900099900', 'Mãe',  1),
('02200000001', '10010010010', 'Pai',  1);

-- ============================================================
-- ACADÊMICO: Disciplinas
-- ============================================================
INSERT INTO academico.tb_disciplinas (pk_nome_disciplina, carga_horaria) VALUES
('Língua Portuguesa', 160),
('Matemática',        160),
('Ciências',          120),
('História',          120),
('Geografia',         120),
('Educação Física',    80),
('Arte',               80),
('Língua Inglesa',    120);

-- ============================================================
-- ACADÊMICO: Turmas (ano letivo 2025)
-- ============================================================
INSERT INTO academico.tb_turmas (pk_nome_turma, pk_ano_letivo, pk_serie, pk_turno, capacidade_maxima, num_sala, status_turma) VALUES
('6A', 2025, '6 ano', 'Manha', 30, 'Sala 01', 'Ativo'),
('6B', 2025, '6 ano', 'Tarde', 30, 'Sala 02', 'Ativo'),
('7A', 2025, '7 ano', 'Manha', 30, 'Sala 03', 'Ativo'),
('8A', 2025, '8 ano', 'Tarde', 30, 'Sala 04', 'Ativo');

-- ============================================================
-- Turma 6A Manhã

INSERT INTO academico.tb_turma_disciplina (pk_nome_turma, pk_ano_letivo, pk_serie, pk_turno, pk_nome_disciplina, fk_cpf_professor, ativo) VALUES
('6A', 2025, '6 ano', 'Manha', 'Língua Portuguesa', '52344398762', 'Ativo'),
('6A', 2025, '6 ano', 'Manha', 'Matemática',        '63455498773', 'Ativo'),
('6A', 2025, '6 ano', 'Manha', 'Ciências',          '74566598784', 'Ativo'),
('6A', 2025, '6 ano', 'Manha', 'História',          '85677698795', 'Ativo'),
('6A', 2025, '6 ano', 'Manha', 'Geografia',         '85677698795', 'Ativo'),
('6A', 2025, '6 ano', 'Manha', 'Educação Física',   '96788798806', 'Ativo'),
('6A', 2025, '6 ano', 'Manha', 'Arte',              '07899898817', 'Ativo'),
('6A', 2025, '6 ano', 'Manha', 'Língua Inglesa',    '18900998828', 'Ativo'),

-- Turma 6B Tarde
('6B', 2025, '6 ano', 'Tarde', 'Língua Portuguesa', '52344398762', 'Ativo'),
('6B', 2025, '6 ano', 'Tarde', 'Matemática',        '63455498773', 'Ativo'),
('6B', 2025, '6 ano', 'Tarde', 'Ciências',          '74566598784', 'Ativo'),
('6B', 2025, '6 ano', 'Tarde', 'História',          '85677698795', 'Ativo'),
('6B', 2025, '6 ano', 'Tarde', 'Geografia',         '85677698795', 'Ativo'),
('6B', 2025, '6 ano', 'Tarde', 'Educação Física',   '96788798806', 'Ativo'),
('6B', 2025, '6 ano', 'Tarde', 'Arte',              '07899898817', 'Ativo'),
('6B', 2025, '6 ano', 'Tarde', 'Língua Inglesa',    '18900998828', 'Ativo'),

-- Turma 7A Manhã
('7A', 2025, '7 ano', 'Manha', 'Língua Portuguesa', '52344398762', 'Ativo'),
('7A', 2025, '7 ano', 'Manha', 'Matemática',        '63455498773', 'Ativo'),
('7A', 2025, '7 ano', 'Manha', 'Ciências',          '74566598784', 'Ativo'),
('7A', 2025, '7 ano', 'Manha', 'História',          '85677698795', 'Ativo'),
('7A', 2025, '7 ano', 'Manha', 'Geografia',         '85677698795', 'Ativo'),
('7A', 2025, '7 ano', 'Manha', 'Educação Física',   '96788798806', 'Ativo'),
('7A', 2025, '7 ano', 'Manha', 'Arte',              '07899898817', 'Ativo'),
('7A', 2025, '7 ano', 'Manha', 'Língua Inglesa',    '18900998828', 'Ativo'),

-- Turma 8A Tarde
('8A', 2025, '8 ano', 'Tarde', 'Língua Portuguesa', '52344398762', 'Ativo'),
('8A', 2025, '8 ano', 'Tarde', 'Matemática',        '63455498773', 'Ativo'),
('8A', 2025, '8 ano', 'Tarde', 'Ciências',          '74566598784', 'Ativo'),
('8A', 2025, '8 ano', 'Tarde', 'História',          '85677698795', 'Ativo'),
('8A', 2025, '8 ano', 'Tarde', 'Geografia',         '85677698795', 'Ativo'),
('8A', 2025, '8 ano', 'Tarde', 'Educação Física',   '96788798806', 'Ativo'),
('8A', 2025, '8 ano', 'Tarde', 'Arte',              '07899898817', 'Ativo'),
('8A', 2025, '8 ano', 'Tarde', 'Língua Inglesa',    '18900998828', 'Ativo');

-- ============================================================
-- ACADÊMICO: Matrículas Ano
-- ============================================================

INSERT INTO academico.tb_matricula_ano (pk_cpf, pk_ano_letivo, fk_nome_turma, fk_serie, fk_turno, status_matricula, data_matricula, status_turma) VALUES
-- Turma 6A
('12311100001', 2025, '6A', '6 ano', 'Manha', 'Em andamento', '2025-01-28', 'Ativo'),
('23422200002', 2025, '6A', '6 ano', 'Manha', 'Em andamento', '2025-01-28', 'Ativo'),
('34533300003', 2025, '6A', '6 ano', 'Manha', 'Em andamento', '2025-01-28', 'Ativo'),
('45644400004', 2025, '6A', '6 ano', 'Manha', 'Em andamento', '2025-01-28', 'Ativo'),
('56755500005', 2025, '6A', '6 ano', 'Manha', 'Em andamento', '2025-01-28', 'Ativo'),

-- Turma 6B
('67866600006', 2025, '6B', '6 ano', 'Tarde', 'Em andamento', '2025-01-28', 'Ativo'),
('78977700007', 2025, '6B', '6 ano', 'Tarde', 'Em andamento', '2025-01-28', 'Ativo'),
('89088800008', 2025, '6B', '6 ano', 'Tarde', 'Em andamento', '2025-01-28', 'Ativo'),
('90199900009', 2025, '6B', '6 ano', 'Tarde', 'Em andamento', '2025-01-28', 'Ativo'),
('01200000010', 2025, '6B', '6 ano', 'Tarde', 'Em andamento', '2025-01-28', 'Ativo'),
('13311111111', 2025, '6B', '6 ano', 'Tarde', 'Em andamento', '2025-01-28', 'Ativo'),

-- Turma 7A
('24422222222', 2025, '7A', '7 ano', 'Manha', 'Em andamento', '2025-01-28', 'Ativo'),
('35533333333', 2025, '7A', '7 ano', 'Manha', 'Em andamento', '2025-01-28', 'Ativo'),
('46644444444', 2025, '7A', '7 ano', 'Manha', 'Em andamento', '2025-01-28', 'Ativo'),
('57755555555', 2025, '7A', '7 ano', 'Manha', 'Em andamento', '2025-01-28', 'Ativo'),
('68866666666', 2025, '7A', '7 ano', 'Manha', 'Em andamento', '2025-01-28', 'Ativo'),

-- Turma 8A
('79977777777', 2025, '8A', '8 ano', 'Tarde', 'Em andamento', '2025-01-28', 'Ativo'),
('80088888888', 2025, '8A', '8 ano', 'Tarde', 'Em andamento', '2025-01-28', 'Ativo'),
('91199999999', 2025, '8A', '8 ano', 'Tarde', 'Em andamento', '2025-01-28', 'Ativo'),
('02200000001', 2025, '8A', '8 ano', 'Tarde', 'Em andamento', '2025-01-28', 'Ativo');

-- ============================================================
-- ACADÊMICO: Histórico de Turma
-- ============================================================
INSERT INTO academico.tb_historico_turma (fk_cpf, fk_ano_letivo, fk_nome_turma, fk_serie, fk_turno, data_inicio, data_fim, motivo_movimentacao) VALUES
('12311100001', 2025, '6A', '6 ano', 'Manha', '2025-01-28 00:00:00', NULL, 'Matrícula inicial'),
('23422200002', 2025, '6A', '6 ano', 'Manha', '2025-01-28 00:00:00', NULL, 'Matrícula inicial'),
('34533300003', 2025, '6A', '6 ano', 'Manha', '2025-01-28 00:00:00', NULL, 'Matrícula inicial'),
('45644400004', 2025, '6A', '6 ano', 'Manha', '2025-01-28 00:00:00', NULL, 'Matrícula inicial'),
('56755500005', 2025, '6A', '6 ano', 'Manha', '2025-01-28 00:00:00', NULL, 'Matrícula inicial'),
('67866600006', 2025, '6B', '6 ano', 'Tarde', '2025-01-28 00:00:00', NULL, 'Matrícula inicial'),
('78977700007', 2025, '6B', '6 ano', 'Tarde', '2025-01-28 00:00:00', NULL, 'Matrícula inicial'),
('89088800008', 2025, '6B', '6 ano', 'Tarde', '2025-01-28 00:00:00', NULL, 'Matrícula inicial'),
('90199900009', 2025, '6B', '6 ano', 'Tarde', '2025-01-28 00:00:00', NULL, 'Matrícula inicial'),
('01200000010', 2025, '6B', '6 ano', 'Tarde', '2025-01-28 00:00:00', NULL, 'Matrícula inicial'),
('13311111111', 2025, '6B', '6 ano', 'Tarde', '2025-01-28 00:00:00', NULL, 'Matrícula inicial'),
('24422222222', 2025, '7A', '7 ano', 'Manha', '2025-01-28 00:00:00', NULL, 'Matrícula inicial'),
('35533333333', 2025, '7A', '7 ano', 'Manha', '2025-01-28 00:00:00', NULL, 'Matrícula inicial'),
('46644444444', 2025, '7A', '7 ano', 'Manha', '2025-01-28 00:00:00', NULL, 'Matrícula inicial'),
('57755555555', 2025, '7A', '7 ano', 'Manha', '2025-01-28 00:00:00', NULL, 'Matrícula inicial'),
('68866666666', 2025, '7A', '7 ano', 'Manha', '2025-01-28 00:00:00', NULL, 'Matrícula inicial'),
('79977777777', 2025, '8A', '8 ano', 'Tarde', '2025-01-28 00:00:00', NULL, 'Matrícula inicial'),
('80088888888', 2025, '8A', '8 ano', 'Tarde', '2025-01-28 00:00:00', NULL, 'Matrícula inicial'),
('91199999999', 2025, '8A', '8 ano', 'Tarde', '2025-01-28 00:00:00', NULL, 'Matrícula inicial'),
('02200000001', 2025, '8A', '8 ano', 'Tarde', '2025-01-28 00:00:00', NULL, 'Matrícula inicial');

-- ============================================================
-- ACADÊMICO: Matrículas por Disciplina
-- ============================================================
-- Turma 6A - Língua Portuguesa
INSERT INTO academico.tb_matricula_disciplina (pk_cpf, pk_ano_letivo, pk_nome_turma, pk_serie, pk_turno, pk_nome_disciplina, data_matricula, status_matricula) VALUES
('12311100001', 2025, '6A', '6 ano', 'Manha', 'Língua Portuguesa', '2025-01-28', 'Cursando'),
('23422200002', 2025, '6A', '6 ano', 'Manha', 'Língua Portuguesa', '2025-01-28', 'Cursando'),
('34533300003', 2025, '6A', '6 ano', 'Manha', 'Língua Portuguesa', '2025-01-28', 'Cursando'),
('45644400004', 2025, '6A', '6 ano', 'Manha', 'Língua Portuguesa', '2025-01-28', 'Cursando'),
('56755500005', 2025, '6A', '6 ano', 'Manha', 'Língua Portuguesa', '2025-01-28', 'Cursando'),

-- Turma 6A - Matemática
('12311100001', 2025, '6A', '6 ano', 'Manha', 'Matemática', '2025-01-28', 'Cursando'),
('23422200002', 2025, '6A', '6 ano', 'Manha', 'Matemática', '2025-01-28', 'Cursando'),
('34533300003', 2025, '6A', '6 ano', 'Manha', 'Matemática', '2025-01-28', 'Cursando'),
('45644400004', 2025, '6A', '6 ano', 'Manha', 'Matemática', '2025-01-28', 'Cursando'),
('56755500005', 2025, '6A', '6 ano', 'Manha', 'Matemática', '2025-01-28', 'Cursando'),

-- Turma 6A - Ciências
('12311100001', 2025, '6A', '6 ano', 'Manha', 'Ciências', '2025-01-28', 'Cursando'),
('23422200002', 2025, '6A', '6 ano', 'Manha', 'Ciências', '2025-01-28', 'Cursando'),
('34533300003', 2025, '6A', '6 ano', 'Manha', 'Ciências', '2025-01-28', 'Cursando'),
('45644400004', 2025, '6A', '6 ano', 'Manha', 'Ciências', '2025-01-28', 'Cursando'),
('56755500005', 2025, '6A', '6 ano', 'Manha', 'Ciências', '2025-01-28', 'Cursando'),

-- Turma 6A - História
('12311100001', 2025, '6A', '6 ano', 'Manha', 'História', '2025-01-28', 'Cursando'),
('23422200002', 2025, '6A', '6 ano', 'Manha', 'História', '2025-01-28', 'Cursando'),
('34533300003', 2025, '6A', '6 ano', 'Manha', 'História', '2025-01-28', 'Cursando'),
('45644400004', 2025, '6A', '6 ano', 'Manha', 'História', '2025-01-28', 'Cursando'),
('56755500005', 2025, '6A', '6 ano', 'Manha', 'História', '2025-01-28', 'Cursando'),

-- Turma 6B - Língua Portuguesa
('67866600006', 2025, '6B', '6 ano', 'Tarde', 'Língua Portuguesa', '2025-01-28', 'Cursando'),
('78977700007', 2025, '6B', '6 ano', 'Tarde', 'Língua Portuguesa', '2025-01-28', 'Cursando'),
('89088800008', 2025, '6B', '6 ano', 'Tarde', 'Língua Portuguesa', '2025-01-28', 'Cursando'),
('90199900009', 2025, '6B', '6 ano', 'Tarde', 'Língua Portuguesa', '2025-01-28', 'Cursando'),
('01200000010', 2025, '6B', '6 ano', 'Tarde', 'Língua Portuguesa', '2025-01-28', 'Cursando'),
('13311111111', 2025, '6B', '6 ano', 'Tarde', 'Língua Portuguesa', '2025-01-28', 'Cursando'),

-- Turma 6B - Matemática
('67866600006', 2025, '6B', '6 ano', 'Tarde', 'Matemática', '2025-01-28', 'Cursando'),
('78977700007', 2025, '6B', '6 ano', 'Tarde', 'Matemática', '2025-01-28', 'Cursando'),
('89088800008', 2025, '6B', '6 ano', 'Tarde', 'Matemática', '2025-01-28', 'Cursando'),
('90199900009', 2025, '6B', '6 ano', 'Tarde', 'Matemática', '2025-01-28', 'Cursando'),
('01200000010', 2025, '6B', '6 ano', 'Tarde', 'Matemática', '2025-01-28', 'Cursando'),
('13311111111', 2025, '6B', '6 ano', 'Tarde', 'Matemática', '2025-01-28', 'Cursando'),

-- Turma 6B - Ciências
('67866600006', 2025, '6B', '6 ano', 'Tarde', 'Ciências', '2025-01-28', 'Cursando'),
('78977700007', 2025, '6B', '6 ano', 'Tarde', 'Ciências', '2025-01-28', 'Cursando'),
('89088800008', 2025, '6B', '6 ano', 'Tarde', 'Ciências', '2025-01-28', 'Cursando'),
('90199900009', 2025, '6B', '6 ano', 'Tarde', 'Ciências', '2025-01-28', 'Cursando'),
('01200000010', 2025, '6B', '6 ano', 'Tarde', 'Ciências', '2025-01-28', 'Cursando'),
('13311111111', 2025, '6B', '6 ano', 'Tarde', 'Ciências', '2025-01-28', 'Cursando'),

-- Turma 7A - Língua Portuguesa
('24422222222', 2025, '7A', '7 ano', 'Manha', 'Língua Portuguesa', '2025-01-28', 'Cursando'),
('35533333333', 2025, '7A', '7 ano', 'Manha', 'Língua Portuguesa', '2025-01-28', 'Cursando'),
('46644444444', 2025, '7A', '7 ano', 'Manha', 'Língua Portuguesa', '2025-01-28', 'Cursando'),
('57755555555', 2025, '7A', '7 ano', 'Manha', 'Língua Portuguesa', '2025-01-28', 'Cursando'),
('68866666666', 2025, '7A', '7 ano', 'Manha', 'Língua Portuguesa', '2025-01-28', 'Cursando'),

-- Turma 7A - Matemática
('24422222222', 2025, '7A', '7 ano', 'Manha', 'Matemática', '2025-01-28', 'Cursando'),
('35533333333', 2025, '7A', '7 ano', 'Manha', 'Matemática', '2025-01-28', 'Cursando'),
('46644444444', 2025, '7A', '7 ano', 'Manha', 'Matemática', '2025-01-28', 'Cursando'),
('57755555555', 2025, '7A', '7 ano', 'Manha', 'Matemática', '2025-01-28', 'Cursando'),
('68866666666', 2025, '7A', '7 ano', 'Manha', 'Matemática', '2025-01-28', 'Cursando'),

-- Turma 7A - Ciências
('24422222222', 2025, '7A', '7 ano', 'Manha', 'Ciências', '2025-01-28', 'Cursando'),
('35533333333', 2025, '7A', '7 ano', 'Manha', 'Ciências', '2025-01-28', 'Cursando'),
('46644444444', 2025, '7A', '7 ano', 'Manha', 'Ciências', '2025-01-28', 'Cursando'),
('57755555555', 2025, '7A', '7 ano', 'Manha', 'Ciências', '2025-01-28', 'Cursando'),
('68866666666', 2025, '7A', '7 ano', 'Manha', 'Ciências', '2025-01-28', 'Cursando'),

-- Turma 8A - Língua Portuguesa
('79977777777', 2025, '8A', '8 ano', 'Tarde', 'Língua Portuguesa', '2025-01-28', 'Cursando'),
('80088888888', 2025, '8A', '8 ano', 'Tarde', 'Língua Portuguesa', '2025-01-28', 'Cursando'),
('91199999999', 2025, '8A', '8 ano', 'Tarde', 'Língua Portuguesa', '2025-01-28', 'Cursando'),
('02200000001', 2025, '8A', '8 ano', 'Tarde', 'Língua Portuguesa', '2025-01-28', 'Cursando'),

-- Turma 8A - Matemática
('79977777777', 2025, '8A', '8 ano', 'Tarde', 'Matemática', '2025-01-28', 'Cursando'),
('80088888888', 2025, '8A', '8 ano', 'Tarde', 'Matemática', '2025-01-28', 'Cursando'),
('91199999999', 2025, '8A', '8 ano', 'Tarde', 'Matemática', '2025-01-28', 'Cursando'),
('02200000001', 2025, '8A', '8 ano', 'Tarde', 'Matemática', '2025-01-28', 'Cursando'),

-- Turma 8A - Ciências
('79977777777', 2025, '8A', '8 ano', 'Tarde', 'Ciências', '2025-01-28', 'Cursando'),
('80088888888', 2025, '8A', '8 ano', 'Tarde', 'Ciências', '2025-01-28', 'Cursando'),
('91199999999', 2025, '8A', '8 ano', 'Tarde', 'Ciências', '2025-01-28', 'Cursando'),
('02200000001', 2025, '8A', '8 ano', 'Tarde', 'Ciências', '2025-01-28', 'Cursando');

-- ============================================================
-- ACADÊMICO: Avaliações (por turma/disciplina, 2 bimestres)
-- ============================================================
-- 6A - Língua Portuguesa
INSERT INTO academico.tb_avaliacoes (fk_nome_turma, fk_ano_letivo, fk_serie, fk_turno, fk_nome_disciplina, tipo_avaliacao, data_avaliacao, peso, bimestre, descricao, data_cadastro, data_atualizacao) VALUES
('6A', 2025, '6 ano', 'Manha', 'Língua Portuguesa', 'Prova',     '2025-03-28', 7.00, 1, 'Prova 1 Bimestre - Port 6A',    '2025-01-28 10:00:00', NULL), 
('6A', 2025, '6 ano', 'Manha', 'Língua Portuguesa', 'Trabalho',  '2025-04-18', 3.00, 1, 'Trabalho 1 Bimestre - Port 6A', '2025-01-28 10:00:00', NULL), 
('6A', 2025, '6 ano', 'Manha', 'Língua Portuguesa', 'Prova',     '2025-06-06', 7.00, 2, 'Prova 2 Bimestre - Port 6A',    '2025-01-28 10:00:00', NULL), 
('6A', 2025, '6 ano', 'Manha', 'Língua Portuguesa', 'Atividade', '2025-06-20', 3.00, 2, 'Atividade 2 Bimestre - Port 6A','2025-01-28 10:00:00', NULL), 

-- 6A - Matemática
('6A', 2025, '6 ano', 'Manha', 'Matemática', 'Prova',     '2025-03-28', 7.00, 1, 'Prova 1 Bimestre - Mat 6A',    '2025-01-28 10:00:00', NULL),
('6A', 2025, '6 ano', 'Manha', 'Matemática', 'Trabalho',  '2025-04-18', 3.00, 1, 'Trabalho 1 Bimestre - Mat 6A', '2025-01-28 10:00:00', NULL),
('6A', 2025, '6 ano', 'Manha', 'Matemática', 'Prova',     '2025-06-06', 7.00, 2, 'Prova 2 Bimestre - Mat 6A',    '2025-01-28 10:00:00', NULL), 
('6A', 2025, '6 ano', 'Manha', 'Matemática', 'Atividade', '2025-06-20', 3.00, 2, 'Atividade 2 Bimestre - Mat 6A','2025-01-28 10:00:00', NULL), 

-- 6A - Ciências
('6A', 2025, '6 ano', 'Manha', 'Ciências', 'Prova',     '2025-03-28', 7.00, 1, 'Prova 1 Bimestre - Cie 6A',    '2025-01-28 10:00:00', NULL), 
('6A', 2025, '6 ano', 'Manha', 'Ciências', 'Trabalho',  '2025-04-18', 3.00, 1, 'Trabalho 1 Bimestre - Cie 6A', '2025-01-28 10:00:00', NULL), 

-- 6B - Língua Portuguesa
('6B', 2025, '6 ano', 'Tarde', 'Língua Portuguesa', 'Prova',     '2025-03-28', 7.00, 1, 'Prova 1 Bimestre - Port 6B',    '2025-01-28 10:00:00', NULL), 
('6B', 2025, '6 ano', 'Tarde', 'Língua Portuguesa', 'Trabalho',  '2025-04-18', 3.00, 1, 'Trabalho 1 Bimestre - Port 6B', '2025-01-28 10:00:00', NULL), 
('6B', 2025, '6 ano', 'Tarde', 'Língua Portuguesa', 'Prova',     '2025-06-06', 7.00, 2, 'Prova 2 Bimestre - Port 6B',    '2025-01-28 10:00:00', NULL), 
('6B', 2025, '6 ano', 'Tarde', 'Língua Portuguesa', 'Atividade', '2025-06-20', 3.00, 2, 'Atividade 2 Bimestre - Port 6B','2025-01-28 10:00:00', NULL), 

-- 6B - Matemática
('6B', 2025, '6 ano', 'Tarde', 'Matemática', 'Prova',     '2025-03-28', 7.00, 1, 'Prova 1 Bimestre - Mat 6B',    '2025-01-28 10:00:00', NULL), 
('6B', 2025, '6 ano', 'Tarde', 'Matemática', 'Trabalho',  '2025-04-18', 3.00, 1, 'Trabalho 1 Bimestre - Mat 6B', '2025-01-28 10:00:00', NULL), 
('6B', 2025, '6 ano', 'Tarde', 'Matemática', 'Prova',     '2025-06-06', 7.00, 2, 'Prova 2 Bimestre - Mat 6B',    '2025-01-28 10:00:00', NULL), 
('6B', 2025, '6 ano', 'Tarde', 'Matemática', 'Atividade', '2025-06-20', 3.00, 2, 'Atividade 2 Bimestre - Mat 6B','2025-01-28 10:00:00', NULL), 

-- 7A - Língua Portuguesa
('7A', 2025, '7 ano', 'Manha', 'Língua Portuguesa', 'Prova',     '2025-03-28', 7.00, 1, 'Prova 1 Bimestre - Port 7A',    '2025-01-28 10:00:00', NULL), 
('7A', 2025, '7 ano', 'Manha', 'Língua Portuguesa', 'Seminario', '2025-04-18', 3.00, 1, 'Seminário 1 Bimestre - Port 7A','2025-01-28 10:00:00', NULL), 
('7A', 2025, '7 ano', 'Manha', 'Língua Portuguesa', 'Prova',     '2025-06-06', 7.00, 2, 'Prova 2 Bimestre - Port 7A',    '2025-01-28 10:00:00', NULL),
 
-- 7A - Matemática
('7A', 2025, '7 ano', 'Manha', 'Matemática', 'Prova',     '2025-03-28', 7.00, 1, 'Prova 1 Bimestre - Mat 7A',    '2025-01-28 10:00:00', NULL),
('7A', 2025, '7 ano', 'Manha', 'Matemática', 'Trabalho',  '2025-04-18', 3.00, 1, 'Trabalho 1 Bimestre - Mat 7A', '2025-01-28 10:00:00', NULL), 
('7A', 2025, '7 ano', 'Manha', 'Matemática', 'Prova',     '2025-06-06', 7.00, 2, 'Prova 2 Bimestre - Mat 7A',    '2025-01-28 10:00:00', NULL), 

-- 8A - Língua Portuguesa
('8A', 2025, '8 ano', 'Tarde', 'Língua Portuguesa', 'Prova',     '2025-03-28', 7.00, 1, 'Prova 1 Bimestre - Port 8A',    '2025-01-28 10:00:00', NULL),
('8A', 2025, '8 ano', 'Tarde', 'Língua Portuguesa', 'Trabalho',  '2025-04-18', 3.00, 1, 'Trabalho 1 Bimestre - Port 8A', '2025-01-28 10:00:00', NULL), 
('8A', 2025, '8 ano', 'Tarde', 'Língua Portuguesa', 'Prova',     '2025-06-06', 7.00, 2, 'Prova 2 Bimestre - Port 8A',    '2025-01-28 10:00:00', NULL), 

-- 8A - Matemática
('8A', 2025, '8 ano', 'Tarde', 'Matemática', 'Prova',     '2025-03-28', 7.00, 1, 'Prova 1 Bimestre - Mat 8A',    '2025-01-28 10:00:00', NULL),
('8A', 2025, '8 ano', 'Tarde', 'Matemática', 'Trabalho',  '2025-04-18', 3.00, 1, 'Trabalho 1 Bimestre - Mat 8A', '2025-01-28 10:00:00', NULL), 
('8A', 2025, '8 ano', 'Tarde', 'Matemática', 'Prova',     '2025-06-06', 7.00, 2, 'Prova 2 Bimestre - Mat 8A',    '2025-01-28 10:00:00', NULL); 

-- ============================================================
-- ACADÊMICO: Notas
-- ============================================================
-- Notas 6A - Língua Portuguesa (avaliações 1,2,3,4)
INSERT INTO academico.tb_notas_avaliacao (fk_cpf, fk_ano_letivo, fk_nome_turma, fk_serie, fk_turno, fk_nome_disciplina, fk_id_avaliacao, nota_obtida, data_lancamento) VALUES
-- Gabriel - bom desempenho
('12311100001', 2025, '6A', '6 ano', 'Manha', 'Língua Portuguesa', 1, 8.50, '2025-04-02 10:00:00'),
('12311100001', 2025, '6A', '6 ano', 'Manha', 'Língua Portuguesa', 2, 9.00, '2025-04-22 10:00:00'),
('12311100001', 2025, '6A', '6 ano', 'Manha', 'Língua Portuguesa', 3, 8.00, '2025-06-10 10:00:00'),
('12311100001', 2025, '6A', '6 ano', 'Manha', 'Língua Portuguesa', 4, 9.50, '2025-06-24 10:00:00'),

-- Isabela - bom desempenho
('23422200002', 2025, '6A', '6 ano', 'Manha', 'Língua Portuguesa', 1, 9.00, '2025-04-02 10:00:00'),
('23422200002', 2025, '6A', '6 ano', 'Manha', 'Língua Portuguesa', 2, 9.50, '2025-04-22 10:00:00'),
('23422200002', 2025, '6A', '6 ano', 'Manha', 'Língua Portuguesa', 3, 9.00, '2025-06-10 10:00:00'),
('23422200002', 2025, '6A', '6 ano', 'Manha', 'Língua Portuguesa', 4, 10.00,'2025-06-24 10:00:00'),

-- Lucas - notas baixas (reprovação)
('34533300003', 2025, '6A', '6 ano', 'Manha', 'Língua Portuguesa', 1, 3.50, '2025-04-02 10:00:00'),
('34533300003', 2025, '6A', '6 ano', 'Manha', 'Língua Portuguesa', 2, 4.00, '2025-04-22 10:00:00'),
('34533300003', 2025, '6A', '6 ano', 'Manha', 'Língua Portuguesa', 3, 3.00, '2025-06-10 10:00:00'),
('34533300003', 2025, '6A', '6 ano', 'Manha', 'Língua Portuguesa', 4, 4.50, '2025-06-24 10:00:00'),

-- Larissa - recuperação (medianas)
('45644400004', 2025, '6A', '6 ano', 'Manha', 'Língua Portuguesa', 1, 5.50, '2025-04-02 10:00:00'),
('45644400004', 2025, '6A', '6 ano', 'Manha', 'Língua Portuguesa', 2, 6.00, '2025-04-22 10:00:00'),
('45644400004', 2025, '6A', '6 ano', 'Manha', 'Língua Portuguesa', 3, 5.50, '2025-06-10 10:00:00'),
('45644400004', 2025, '6A', '6 ano', 'Manha', 'Língua Portuguesa', 4, 6.50, '2025-06-24 10:00:00'),

-- Matheus - bom desempenho
('56755500005', 2025, '6A', '6 ano', 'Manha', 'Língua Portuguesa', 1, 8.00, '2025-04-02 10:00:00'),
('56755500005', 2025, '6A', '6 ano', 'Manha', 'Língua Portuguesa', 2, 8.50, '2025-04-22 10:00:00'),
('56755500005', 2025, '6A', '6 ano', 'Manha', 'Língua Portuguesa', 3, 7.50, '2025-06-10 10:00:00'),
('56755500005', 2025, '6A', '6 ano', 'Manha', 'Língua Portuguesa', 4, 9.00, '2025-06-24 10:00:00'),

-- Notas 6A - Matemática (avaliações 5,6,7,8)
-- Gabriel
('12311100001', 2025, '6A', '6 ano', 'Manha', 'Matemática', 5, 7.50, '2025-04-02 10:00:00'),
('12311100001', 2025, '6A', '6 ano', 'Manha', 'Matemática', 6, 8.00, '2025-04-22 10:00:00'),
('12311100001', 2025, '6A', '6 ano', 'Manha', 'Matemática', 7, 8.50, '2025-06-10 10:00:00'),
('12311100001', 2025, '6A', '6 ano', 'Manha', 'Matemática', 8, 9.00, '2025-06-24 10:00:00'),

-- Isabela
('23422200002', 2025, '6A', '6 ano', 'Manha', 'Matemática', 5, 9.50, '2025-04-02 10:00:00'),
('23422200002', 2025, '6A', '6 ano', 'Manha', 'Matemática', 6, 10.00,'2025-04-22 10:00:00'),
('23422200002', 2025, '6A', '6 ano', 'Manha', 'Matemática', 7, 9.00, '2025-06-10 10:00:00'),
('23422200002', 2025, '6A', '6 ano', 'Manha', 'Matemática', 8, 9.50, '2025-06-24 10:00:00'),

-- Lucas - reprovação em Mat
('34533300003', 2025, '6A', '6 ano', 'Manha', 'Matemática', 5, 2.50, '2025-04-02 10:00:00'),
('34533300003', 2025, '6A', '6 ano', 'Manha', 'Matemática', 6, 3.00, '2025-04-22 10:00:00'),
('34533300003', 2025, '6A', '6 ano', 'Manha', 'Matemática', 7, 2.00, '2025-06-10 10:00:00'),
('34533300003', 2025, '6A', '6 ano', 'Manha', 'Matemática', 8, 3.50, '2025-06-24 10:00:00'),

-- Larissa - recuperação
('45644400004', 2025, '6A', '6 ano', 'Manha', 'Matemática', 5, 5.00, '2025-04-02 10:00:00'),
('45644400004', 2025, '6A', '6 ano', 'Manha', 'Matemática', 6, 6.00, '2025-04-22 10:00:00'),
('45644400004', 2025, '6A', '6 ano', 'Manha', 'Matemática', 7, 5.50, '2025-06-10 10:00:00'),
('45644400004', 2025, '6A', '6 ano', 'Manha', 'Matemática', 8, 6.50, '2025-06-24 10:00:00'),

-- Matheus
('56755500005', 2025, '6A', '6 ano', 'Manha', 'Matemática', 5, 8.00, '2025-04-02 10:00:00'),
('56755500005', 2025, '6A', '6 ano', 'Manha', 'Matemática', 6, 8.50, '2025-04-22 10:00:00'),
('56755500005', 2025, '6A', '6 ano', 'Manha', 'Matemática', 7, 8.00, '2025-06-10 10:00:00'),
('56755500005', 2025, '6A', '6 ano', 'Manha', 'Matemática', 8, 9.00, '2025-06-24 10:00:00'),

-- Notas 6B - Língua Portuguesa (avaliações 11,12,13,14)
-- Vitória - boa
('67866600006', 2025, '6B', '6 ano', 'Tarde', 'Língua Portuguesa', 11, 8.50, '2025-04-02 10:00:00'),
('67866600006', 2025, '6B', '6 ano', 'Tarde', 'Língua Portuguesa', 12, 9.00, '2025-04-22 10:00:00'),
('67866600006', 2025, '6B', '6 ano', 'Tarde', 'Língua Portuguesa', 13, 8.50, '2025-06-10 10:00:00'),
('67866600006', 2025, '6B', '6 ano', 'Tarde', 'Língua Portuguesa', 14, 9.00, '2025-06-24 10:00:00'),

-- Felipe - recuperação
('78977700007', 2025, '6B', '6 ano', 'Tarde', 'Língua Portuguesa', 11, 5.50, '2025-04-02 10:00:00'),
('78977700007', 2025, '6B', '6 ano', 'Tarde', 'Língua Portuguesa', 12, 6.50, '2025-04-22 10:00:00'),
('78977700007', 2025, '6B', '6 ano', 'Tarde', 'Língua Portuguesa', 13, 5.50, '2025-06-10 10:00:00'),
('78977700007', 2025, '6B', '6 ano', 'Tarde', 'Língua Portuguesa', 14, 6.00, '2025-06-24 10:00:00'),

-- Amanda - boa
('89088800008', 2025, '6B', '6 ano', 'Tarde', 'Língua Portuguesa', 11, 9.00, '2025-04-02 10:00:00'),
('89088800008', 2025, '6B', '6 ano', 'Tarde', 'Língua Portuguesa', 12, 9.50, '2025-04-22 10:00:00'),
('89088800008', 2025, '6B', '6 ano', 'Tarde', 'Língua Portuguesa', 13, 8.50, '2025-06-10 10:00:00'),
('89088800008', 2025, '6B', '6 ano', 'Tarde', 'Língua Portuguesa', 14, 9.00, '2025-06-24 10:00:00'),

-- Rafael - baixa presença + baixas notas
('90199900009', 2025, '6B', '6 ano', 'Tarde', 'Língua Portuguesa', 11, 3.00, '2025-04-02 10:00:00'),
('90199900009', 2025, '6B', '6 ano', 'Tarde', 'Língua Portuguesa', 12, 4.00, '2025-04-22 10:00:00'),
('90199900009', 2025, '6B', '6 ano', 'Tarde', 'Língua Portuguesa', 13, 3.50, '2025-06-10 10:00:00'),
('90199900009', 2025, '6B', '6 ano', 'Tarde', 'Língua Portuguesa', 14, 4.00, '2025-06-24 10:00:00'),

-- Camila - boa
('01200000010', 2025, '6B', '6 ano', 'Tarde', 'Língua Portuguesa', 11, 8.00, '2025-04-02 10:00:00'),
('01200000010', 2025, '6B', '6 ano', 'Tarde', 'Língua Portuguesa', 12, 8.50, '2025-04-22 10:00:00'),
('01200000010', 2025, '6B', '6 ano', 'Tarde', 'Língua Portuguesa', 13, 8.00, '2025-06-10 10:00:00'),
('01200000010', 2025, '6B', '6 ano', 'Tarde', 'Língua Portuguesa', 14, 9.00, '2025-06-24 10:00:00'),

-- Breno - baixa presença + baixas notas
('13311111111', 2025, '6B', '6 ano', 'Tarde', 'Língua Portuguesa', 11, 3.50, '2025-04-02 10:00:00'),
('13311111111', 2025, '6B', '6 ano', 'Tarde', 'Língua Portuguesa', 12, 4.50, '2025-04-22 10:00:00'),
('13311111111', 2025, '6B', '6 ano', 'Tarde', 'Língua Portuguesa', 13, 3.00, '2025-06-10 10:00:00'),
('13311111111', 2025, '6B', '6 ano', 'Tarde', 'Língua Portuguesa', 14, 4.00, '2025-06-24 10:00:00'),

-- Notas 6B - Matemática (avaliações 15,16,17,18)
('67866600006', 2025, '6B', '6 ano', 'Tarde', 'Matemática', 15, 8.00, '2025-04-02 10:00:00'),
('67866600006', 2025, '6B', '6 ano', 'Tarde', 'Matemática', 16, 9.00, '2025-04-22 10:00:00'),
('67866600006', 2025, '6B', '6 ano', 'Tarde', 'Matemática', 17, 8.50, '2025-06-10 10:00:00'),
('67866600006', 2025, '6B', '6 ano', 'Tarde', 'Matemática', 18, 9.50, '2025-06-24 10:00:00'),
('78977700007', 2025, '6B', '6 ano', 'Tarde', 'Matemática', 15, 5.00, '2025-04-02 10:00:00'),
('78977700007', 2025, '6B', '6 ano', 'Tarde', 'Matemática', 16, 6.00, '2025-04-22 10:00:00'),
('78977700007', 2025, '6B', '6 ano', 'Tarde', 'Matemática', 17, 5.50, '2025-06-10 10:00:00'),
('78977700007', 2025, '6B', '6 ano', 'Tarde', 'Matemática', 18, 6.50, '2025-06-24 10:00:00'),
('89088800008', 2025, '6B', '6 ano', 'Tarde', 'Matemática', 15, 9.00, '2025-04-02 10:00:00'),
('89088800008', 2025, '6B', '6 ano', 'Tarde', 'Matemática', 16, 9.00, '2025-04-22 10:00:00'),
('89088800008', 2025, '6B', '6 ano', 'Tarde', 'Matemática', 17, 8.50, '2025-06-10 10:00:00'),
('89088800008', 2025, '6B', '6 ano', 'Tarde', 'Matemática', 18, 9.50, '2025-06-24 10:00:00'),
('90199900009', 2025, '6B', '6 ano', 'Tarde', 'Matemática', 15, 2.50, '2025-04-02 10:00:00'),
('90199900009', 2025, '6B', '6 ano', 'Tarde', 'Matemática', 16, 3.50, '2025-04-22 10:00:00'),
('90199900009', 2025, '6B', '6 ano', 'Tarde', 'Matemática', 17, 2.50, '2025-06-10 10:00:00'),
('90199900009', 2025, '6B', '6 ano', 'Tarde', 'Matemática', 18, 3.00, '2025-06-24 10:00:00'),
('01200000010', 2025, '6B', '6 ano', 'Tarde', 'Matemática', 15, 7.50, '2025-04-02 10:00:00'),
('01200000010', 2025, '6B', '6 ano', 'Tarde', 'Matemática', 16, 8.00, '2025-04-22 10:00:00'),
('01200000010', 2025, '6B', '6 ano', 'Tarde', 'Matemática', 17, 7.50, '2025-06-10 10:00:00'),
('01200000010', 2025, '6B', '6 ano', 'Tarde', 'Matemática', 18, 8.50, '2025-06-24 10:00:00'),
('13311111111', 2025, '6B', '6 ano', 'Tarde', 'Matemática', 15, 3.00, '2025-04-02 10:00:00'),
('13311111111', 2025, '6B', '6 ano', 'Tarde', 'Matemática', 16, 4.00, '2025-04-22 10:00:00'),
('13311111111', 2025, '6B', '6 ano', 'Tarde', 'Matemática', 17, 2.50, '2025-06-10 10:00:00'),
('13311111111', 2025, '6B', '6 ano', 'Tarde', 'Matemática', 18, 3.50, '2025-06-24 10:00:00'),

-- Notas 7A - Língua Portuguesa (avaliações 19,20,21)
('24422222222', 2025, '7A', '7 ano', 'Manha', 'Língua Portuguesa', 19, 9.00, '2025-04-02 10:00:00'),
('24422222222', 2025, '7A', '7 ano', 'Manha', 'Língua Portuguesa', 20, 9.50, '2025-04-22 10:00:00'),
('24422222222', 2025, '7A', '7 ano', 'Manha', 'Língua Portuguesa', 21, 9.00, '2025-06-10 10:00:00'),
('35533333333', 2025, '7A', '7 ano', 'Manha', 'Língua Portuguesa', 19, 3.50, '2025-04-02 10:00:00'),
('35533333333', 2025, '7A', '7 ano', 'Manha', 'Língua Portuguesa', 20, 4.00, '2025-04-22 10:00:00'),
('35533333333', 2025, '7A', '7 ano', 'Manha', 'Língua Portuguesa', 21, 3.00, '2025-06-10 10:00:00'),
('46644444444', 2025, '7A', '7 ano', 'Manha', 'Língua Portuguesa', 19, 8.50, '2025-04-02 10:00:00'),
('46644444444', 2025, '7A', '7 ano', 'Manha', 'Língua Portuguesa', 20, 9.00, '2025-04-22 10:00:00'),
('46644444444', 2025, '7A', '7 ano', 'Manha', 'Língua Portuguesa', 21, 8.50, '2025-06-10 10:00:00'),
('57755555555', 2025, '7A', '7 ano', 'Manha', 'Língua Portuguesa', 19, 5.50, '2025-04-02 10:00:00'),
('57755555555', 2025, '7A', '7 ano', 'Manha', 'Língua Portuguesa', 20, 6.50, '2025-04-22 10:00:00'),
('57755555555', 2025, '7A', '7 ano', 'Manha', 'Língua Portuguesa', 21, 6.00, '2025-06-10 10:00:00'),

-- Fernanda - baixa presença, baixas notas
('68866666666', 2025, '7A', '7 ano', 'Manha', 'Língua Portuguesa', 19, 3.00, '2025-04-02 10:00:00'),
('68866666666', 2025, '7A', '7 ano', 'Manha', 'Língua Portuguesa', 20, 3.50, '2025-04-22 10:00:00'),
('68866666666', 2025, '7A', '7 ano', 'Manha', 'Língua Portuguesa', 21, 2.50, '2025-06-10 10:00:00'),

-- Notas 7A - Matemática (avaliações 22,23,24)
('24422222222', 2025, '7A', '7 ano', 'Manha', 'Matemática', 22, 8.50, '2025-04-02 10:00:00'),
('24422222222', 2025, '7A', '7 ano', 'Manha', 'Matemática', 23, 9.00, '2025-04-22 10:00:00'),
('24422222222', 2025, '7A', '7 ano', 'Manha', 'Matemática', 24, 9.00, '2025-06-10 10:00:00'),
('35533333333', 2025, '7A', '7 ano', 'Manha', 'Matemática', 22, 3.00, '2025-04-02 10:00:00'),
('35533333333', 2025, '7A', '7 ano', 'Manha', 'Matemática', 23, 3.50, '2025-04-22 10:00:00'),
('35533333333', 2025, '7A', '7 ano', 'Manha', 'Matemática', 24, 2.50, '2025-06-10 10:00:00'),
('46644444444', 2025, '7A', '7 ano', 'Manha', 'Matemática', 22, 8.00, '2025-04-02 10:00:00'),
('46644444444', 2025, '7A', '7 ano', 'Manha', 'Matemática', 23, 8.50, '2025-04-22 10:00:00'),
('46644444444', 2025, '7A', '7 ano', 'Manha', 'Matemática', 24, 8.00, '2025-06-10 10:00:00'),
('57755555555', 2025, '7A', '7 ano', 'Manha', 'Matemática', 22, 5.00, '2025-04-02 10:00:00'),
('57755555555', 2025, '7A', '7 ano', 'Manha', 'Matemática', 23, 6.00, '2025-04-22 10:00:00'),
('57755555555', 2025, '7A', '7 ano', 'Manha', 'Matemática', 24, 5.50, '2025-06-10 10:00:00'),
('68866666666', 2025, '7A', '7 ano', 'Manha', 'Matemática', 22, 2.00, '2025-04-02 10:00:00'),
('68866666666', 2025, '7A', '7 ano', 'Manha', 'Matemática', 23, 3.00, '2025-04-22 10:00:00'),
('68866666666', 2025, '7A', '7 ano', 'Manha', 'Matemática', 24, 2.50, '2025-06-10 10:00:00'),

-- Notas 8A - Língua Portuguesa (avaliações 25,26,27)
('79977777777', 2025, '8A', '8 ano', 'Tarde', 'Língua Portuguesa', 25, 8.50, '2025-04-02 10:00:00'),
('79977777777', 2025, '8A', '8 ano', 'Tarde', 'Língua Portuguesa', 26, 9.00, '2025-04-22 10:00:00'),
('79977777777', 2025, '8A', '8 ano', 'Tarde', 'Língua Portuguesa', 27, 8.50, '2025-06-10 10:00:00'),
('80088888888', 2025, '8A', '8 ano', 'Tarde', 'Língua Portuguesa', 25, 6.00, '2025-04-02 10:00:00'),
('80088888888', 2025, '8A', '8 ano', 'Tarde', 'Língua Portuguesa', 26, 6.50, '2025-04-22 10:00:00'),
('80088888888', 2025, '8A', '8 ano', 'Tarde', 'Língua Portuguesa', 27, 5.50, '2025-06-10 10:00:00'),
('91199999999', 2025, '8A', '8 ano', 'Tarde', 'Língua Portuguesa', 25, 9.00, '2025-04-02 10:00:00'),
('91199999999', 2025, '8A', '8 ano', 'Tarde', 'Língua Portuguesa', 26, 9.50, '2025-04-22 10:00:00'),
('91199999999', 2025, '8A', '8 ano', 'Tarde', 'Língua Portuguesa', 27, 9.00, '2025-06-10 10:00:00'),
('02200000001', 2025, '8A', '8 ano', 'Tarde', 'Língua Portuguesa', 25, 8.00, '2025-04-02 10:00:00'),
('02200000001', 2025, '8A', '8 ano', 'Tarde', 'Língua Portuguesa', 26, 8.50, '2025-04-22 10:00:00'),
('02200000001', 2025, '8A', '8 ano', 'Tarde', 'Língua Portuguesa', 27, 8.50, '2025-06-10 10:00:00'),

-- Notas 8A - Matemática (avaliações 28,29,30)
('79977777777', 2025, '8A', '8 ano', 'Tarde', 'Matemática', 28, 8.00, '2025-04-02 10:00:00'),
('79977777777', 2025, '8A', '8 ano', 'Tarde', 'Matemática', 29, 8.50, '2025-04-22 10:00:00'),
('79977777777', 2025, '8A', '8 ano', 'Tarde', 'Matemática', 30, 8.00, '2025-06-10 10:00:00'),
('80088888888', 2025, '8A', '8 ano', 'Tarde', 'Matemática', 28, 5.50, '2025-04-02 10:00:00'),
('80088888888', 2025, '8A', '8 ano', 'Tarde', 'Matemática', 29, 6.00, '2025-04-22 10:00:00'),
('80088888888', 2025, '8A', '8 ano', 'Tarde', 'Matemática', 30, 5.00, '2025-06-10 10:00:00'),
('91199999999', 2025, '8A', '8 ano', 'Tarde', 'Matemática', 28, 9.00, '2025-04-02 10:00:00'),
('91199999999', 2025, '8A', '8 ano', 'Tarde', 'Matemática', 29, 9.50, '2025-04-22 10:00:00'),
('91199999999', 2025, '8A', '8 ano', 'Tarde', 'Matemática', 30, 9.00, '2025-06-10 10:00:00'),
('02200000001', 2025, '8A', '8 ano', 'Tarde', 'Matemática', 28, 8.50, '2025-04-02 10:00:00'),
('02200000001', 2025, '8A', '8 ano', 'Tarde', 'Matemática', 29, 9.00, '2025-04-22 10:00:00'),
('02200000001', 2025, '8A', '8 ano', 'Tarde', 'Matemática', 30, 8.50, '2025-06-10 10:00:00');

-- ============================================================
-- ACADÊMICO: Boletim
-- ============================================================
INSERT INTO academico.tb_boletim (pk_cpf, pk_ano_letivo, pk_nome_turma, pk_serie, pk_turno, pk_nome_disciplina, percentual_presenca, situacao_final, data_fechamento, data_cadastro, data_atualizacao) VALUES
-- 6A - Língua Portuguesa
('12311100001', 2025, '6A', '6 ano', 'Manha', 'Língua Portuguesa', 96.00, 'Aprovado',    '2025-07-04', '2025-07-04 10:00:00', '2025-07-04 10:00:00'),
('23422200002', 2025, '6A', '6 ano', 'Manha', 'Língua Portuguesa', 97.00, 'Aprovado',    '2025-07-04', '2025-07-04 10:00:00', '2025-07-04 10:00:00'),
('34533300003', 2025, '6A', '6 ano', 'Manha', 'Língua Portuguesa', 55.00, 'Reprovado',   '2025-07-04', '2025-07-04 10:00:00', '2025-07-04 10:00:00'),
('45644400004', 2025, '6A', '6 ano', 'Manha', 'Língua Portuguesa', 88.00, 'Recuperação', '2025-07-04', '2025-07-04 10:00:00', '2025-07-04 10:00:00'),
('56755500005', 2025, '6A', '6 ano', 'Manha', 'Língua Portuguesa', 94.00, 'Aprovado',    '2025-07-04', '2025-07-04 10:00:00', '2025-07-04 10:00:00'),
-- 6A - Matemática
('12311100001', 2025, '6A', '6 ano', 'Manha', 'Matemática', 96.00, 'Aprovado',    '2025-07-04', '2025-07-04 10:00:00', '2025-07-04 10:00:00'),
('23422200002', 2025, '6A', '6 ano', 'Manha', 'Matemática', 97.00, 'Aprovado',    '2025-07-04', '2025-07-04 10:00:00', '2025-07-04 10:00:00'),
('34533300003', 2025, '6A', '6 ano', 'Manha', 'Matemática', 55.00, 'Reprovado',   '2025-07-04', '2025-07-04 10:00:00', '2025-07-04 10:00:00'),
('45644400004', 2025, '6A', '6 ano', 'Manha', 'Matemática', 88.00, 'Recuperação', '2025-07-04', '2025-07-04 10:00:00', '2025-07-04 10:00:00'),
('56755500005', 2025, '6A', '6 ano', 'Manha', 'Matemática', 94.00, 'Aprovado',    '2025-07-04', '2025-07-04 10:00:00', '2025-07-04 10:00:00'),
-- 6A - Ciências (sem fechamento ainda)
('12311100001', 2025, '6A', '6 ano', 'Manha', 'Ciências', 96.00, NULL, NULL, '2025-07-04 10:00:00', NULL),
('23422200002', 2025, '6A', '6 ano', 'Manha', 'Ciências', 97.00, NULL, NULL, '2025-07-04 10:00:00', NULL),
('34533300003', 2025, '6A', '6 ano', 'Manha', 'Ciências', 55.00, NULL, NULL, '2025-07-04 10:00:00', NULL),
('45644400004', 2025, '6A', '6 ano', 'Manha', 'Ciências', 88.00, NULL, NULL, '2025-07-04 10:00:00', NULL),
('56755500005', 2025, '6A', '6 ano', 'Manha', 'Ciências', 94.00, NULL, NULL, '2025-07-04 10:00:00', NULL),
-- 6A - História
('12311100001', 2025, '6A', '6 ano', 'Manha', 'História', 96.00, NULL, NULL, '2025-07-04 10:00:00', NULL),
('23422200002', 2025, '6A', '6 ano', 'Manha', 'História', 97.00, NULL, NULL, '2025-07-04 10:00:00', NULL),
('34533300003', 2025, '6A', '6 ano', 'Manha', 'História', 55.00, NULL, NULL, '2025-07-04 10:00:00', NULL),
('45644400004', 2025, '6A', '6 ano', 'Manha', 'História', 88.00, NULL, NULL, '2025-07-04 10:00:00', NULL),
('56755500005', 2025, '6A', '6 ano', 'Manha', 'História', 94.00, NULL, NULL, '2025-07-04 10:00:00', NULL),
-- 6B - Língua Portuguesa
('67866600006', 2025, '6B', '6 ano', 'Tarde', 'Língua Portuguesa', 95.00, 'Aprovado',    '2025-07-04', '2025-07-04 10:00:00', '2025-07-04 10:00:00'),
('78977700007', 2025, '6B', '6 ano', 'Tarde', 'Língua Portuguesa', 90.00, 'Recuperação', '2025-07-04', '2025-07-04 10:00:00', '2025-07-04 10:00:00'),
('89088800008', 2025, '6B', '6 ano', 'Tarde', 'Língua Portuguesa', 97.00, 'Aprovado',    '2025-07-04', '2025-07-04 10:00:00', '2025-07-04 10:00:00'),
('90199900009', 2025, '6B', '6 ano', 'Tarde', 'Língua Portuguesa', 48.00, 'Reprovado',   '2025-07-04', '2025-07-04 10:00:00', '2025-07-04 10:00:00'),
('01200000010', 2025, '6B', '6 ano', 'Tarde', 'Língua Portuguesa', 93.00, 'Aprovado',    '2025-07-04', '2025-07-04 10:00:00', '2025-07-04 10:00:00'),
('13311111111', 2025, '6B', '6 ano', 'Tarde', 'Língua Portuguesa', 45.00, 'Reprovado',   '2025-07-04', '2025-07-04 10:00:00', '2025-07-04 10:00:00'),
-- 6B - Matemática
('67866600006', 2025, '6B', '6 ano', 'Tarde', 'Matemática', 95.00, 'Aprovado',    '2025-07-04', '2025-07-04 10:00:00', '2025-07-04 10:00:00'),
('78977700007', 2025, '6B', '6 ano', 'Tarde', 'Matemática', 90.00, 'Recuperação', '2025-07-04', '2025-07-04 10:00:00', '2025-07-04 10:00:00'),
('89088800008', 2025, '6B', '6 ano', 'Tarde', 'Matemática', 97.00, 'Aprovado',    '2025-07-04', '2025-07-04 10:00:00', '2025-07-04 10:00:00'),
('90199900009', 2025, '6B', '6 ano', 'Tarde', 'Matemática', 48.00, 'Reprovado',   '2025-07-04', '2025-07-04 10:00:00', '2025-07-04 10:00:00'),
('01200000010', 2025, '6B', '6 ano', 'Tarde', 'Matemática', 93.00, 'Aprovado',    '2025-07-04', '2025-07-04 10:00:00', '2025-07-04 10:00:00'),
('13311111111', 2025, '6B', '6 ano', 'Tarde', 'Matemática', 45.00, 'Reprovado',   '2025-07-04', '2025-07-04 10:00:00', '2025-07-04 10:00:00'),
-- 6B - Ciências
('67866600006', 2025, '6B', '6 ano', 'Tarde', 'Ciências', 95.00, NULL, NULL, '2025-07-04 10:00:00', NULL),
('78977700007', 2025, '6B', '6 ano', 'Tarde', 'Ciências', 90.00, NULL, NULL, '2025-07-04 10:00:00', NULL),
('89088800008', 2025, '6B', '6 ano', 'Tarde', 'Ciências', 97.00, NULL, NULL, '2025-07-04 10:00:00', NULL),
('90199900009', 2025, '6B', '6 ano', 'Tarde', 'Ciências', 48.00, NULL, NULL, '2025-07-04 10:00:00', NULL),
('01200000010', 2025, '6B', '6 ano', 'Tarde', 'Ciências', 93.00, NULL, NULL, '2025-07-04 10:00:00', NULL),
('13311111111', 2025, '6B', '6 ano', 'Tarde', 'Ciências', 45.00, NULL, NULL, '2025-07-04 10:00:00', NULL),
-- 7A - Língua Portuguesa
('24422222222', 2025, '7A', '7 ano', 'Manha', 'Língua Portuguesa', 98.00, 'Aprovado',    '2025-07-04', '2025-07-04 10:00:00', '2025-07-04 10:00:00'),
('35533333333', 2025, '7A', '7 ano', 'Manha', 'Língua Portuguesa', 58.00, 'Reprovado',   '2025-07-04', '2025-07-04 10:00:00', '2025-07-04 10:00:00'),
('46644444444', 2025, '7A', '7 ano', 'Manha', 'Língua Portuguesa', 95.00, 'Aprovado',    '2025-07-04', '2025-07-04 10:00:00', '2025-07-04 10:00:00'),
('57755555555', 2025, '7A', '7 ano', 'Manha', 'Língua Portuguesa', 89.00, 'Recuperação', '2025-07-04', '2025-07-04 10:00:00', '2025-07-04 10:00:00'),
('68866666666', 2025, '7A', '7 ano', 'Manha', 'Língua Portuguesa', 42.00, 'Reprovado',   '2025-07-04', '2025-07-04 10:00:00', '2025-07-04 10:00:00'),
-- 7A - Matemática
('24422222222', 2025, '7A', '7 ano', 'Manha', 'Matemática', 98.00, 'Aprovado',    '2025-07-04', '2025-07-04 10:00:00', '2025-07-04 10:00:00'),
('35533333333', 2025, '7A', '7 ano', 'Manha', 'Matemática', 58.00, 'Reprovado',   '2025-07-04', '2025-07-04 10:00:00', '2025-07-04 10:00:00'),
('46644444444', 2025, '7A', '7 ano', 'Manha', 'Matemática', 95.00, 'Aprovado',    '2025-07-04', '2025-07-04 10:00:00', '2025-07-04 10:00:00'),
('57755555555', 2025, '7A', '7 ano', 'Manha', 'Matemática', 89.00, 'Recuperação', '2025-07-04', '2025-07-04 10:00:00', '2025-07-04 10:00:00'),
('68866666666', 2025, '7A', '7 ano', 'Manha', 'Matemática', 42.00, 'Reprovado',   '2025-07-04', '2025-07-04 10:00:00', '2025-07-04 10:00:00'),
-- 7A - Ciências
('24422222222', 2025, '7A', '7 ano', 'Manha', 'Ciências', 98.00, NULL, NULL, '2025-07-04 10:00:00', NULL),
('35533333333', 2025, '7A', '7 ano', 'Manha', 'Ciências', 58.00, NULL, NULL, '2025-07-04 10:00:00', NULL),
('46644444444', 2025, '7A', '7 ano', 'Manha', 'Ciências', 95.00, NULL, NULL, '2025-07-04 10:00:00', NULL),
('57755555555', 2025, '7A', '7 ano', 'Manha', 'Ciências', 89.00, NULL, NULL, '2025-07-04 10:00:00', NULL),
('68866666666', 2025, '7A', '7 ano', 'Manha', 'Ciências', 42.00, NULL, NULL, '2025-07-04 10:00:00', NULL),
-- 8A - Língua Portuguesa
('79977777777', 2025, '8A', '8 ano', 'Tarde', 'Língua Portuguesa', 96.00, 'Aprovado',    '2025-07-04', '2025-07-04 10:00:00', '2025-07-04 10:00:00'),
('80088888888', 2025, '8A', '8 ano', 'Tarde', 'Língua Portuguesa', 87.00, 'Recuperação', '2025-07-04', '2025-07-04 10:00:00', '2025-07-04 10:00:00'),
('91199999999', 2025, '8A', '8 ano', 'Tarde', 'Língua Portuguesa', 98.00, 'Aprovado',    '2025-07-04', '2025-07-04 10:00:00', '2025-07-04 10:00:00'),
('02200000001', 2025, '8A', '8 ano', 'Tarde', 'Língua Portuguesa', 95.00, 'Aprovado',    '2025-07-04', '2025-07-04 10:00:00', '2025-07-04 10:00:00'),
-- 8A - Matemática
('79977777777', 2025, '8A', '8 ano', 'Tarde', 'Matemática', 96.00, 'Aprovado',    '2025-07-04', '2025-07-04 10:00:00', '2025-07-04 10:00:00'),
('80088888888', 2025, '8A', '8 ano', 'Tarde', 'Matemática', 87.00, 'Recuperação', '2025-07-04', '2025-07-04 10:00:00', '2025-07-04 10:00:00'),
('91199999999', 2025, '8A', '8 ano', 'Tarde', 'Matemática', 98.00, 'Aprovado',    '2025-07-04', '2025-07-04 10:00:00', '2025-07-04 10:00:00'),
('02200000001', 2025, '8A', '8 ano', 'Tarde', 'Matemática', 95.00, 'Aprovado',    '2025-07-04', '2025-07-04 10:00:00', '2025-07-04 10:00:00'),
-- 8A - Ciências
('79977777777', 2025, '8A', '8 ano', 'Tarde', 'Ciências', 96.00, NULL, NULL, '2025-07-04 10:00:00', NULL),
('80088888888', 2025, '8A', '8 ano', 'Tarde', 'Ciências', 87.00, NULL, NULL, '2025-07-04 10:00:00', NULL),
('91199999999', 2025, '8A', '8 ano', 'Tarde', 'Ciências', 98.00, NULL, NULL, '2025-07-04 10:00:00', NULL),
('02200000001', 2025, '8A', '8 ano', 'Tarde', 'Ciências', 95.00, NULL, NULL, '2025-07-04 10:00:00', NULL);

-- ============================================================
-- ACADÊMICO: Aulas (para registro de frequência)
-- ============================================================
INSERT INTO academico.tb_aulas (fk_nome_turma, fk_ano_letivo, fk_serie, fk_turno, fk_nome_disciplina, data_aula, conteudo_ministrado, quantidade_horas, bimestre, data_cadastro) VALUES
-- 6A - Língua Portuguesa
('6A', 2025, '6 ano', 'Manha', 'Língua Portuguesa', '2025-02-10', 'Apresentação e diagnóstico inicial',       1.00, 1, '2025-02-10 12:00:00'), -- id 1
('6A', 2025, '6 ano', 'Manha', 'Língua Portuguesa', '2025-02-17', 'Gêneros textuais - narração',              1.00, 1, '2025-02-17 12:00:00'), -- id 2
('6A', 2025, '6 ano', 'Manha', 'Língua Portuguesa', '2025-02-24', 'Gêneros textuais - dissertação',           1.00, 1, '2025-02-24 12:00:00'), -- id 3
('6A', 2025, '6 ano', 'Manha', 'Língua Portuguesa', '2025-03-03', 'Ortografia e gramática básica',            1.00, 1, '2025-03-03 12:00:00'), -- id 4
('6A', 2025, '6 ano', 'Manha', 'Língua Portuguesa', '2025-03-10', 'Revisão para prova',                       1.00, 1, '2025-03-10 12:00:00'), -- id 5
-- 6B - Língua Portuguesa
('6B', 2025, '6 ano', 'Tarde', 'Língua Portuguesa', '2025-02-10', 'Apresentação e diagnóstico inicial',       1.00, 1, '2025-02-10 17:00:00'), -- id 6
('6B', 2025, '6 ano', 'Tarde', 'Língua Portuguesa', '2025-02-17', 'Gêneros textuais - narração',              1.00, 1, '2025-02-17 17:00:00'), -- id 7
('6B', 2025, '6 ano', 'Tarde', 'Língua Portuguesa', '2025-02-24', 'Gêneros textuais - dissertação',           1.00, 1, '2025-02-24 17:00:00'), -- id 8
('6B', 2025, '6 ano', 'Tarde', 'Língua Portuguesa', '2025-03-03', 'Ortografia e gramática básica',            1.00, 1, '2025-03-03 17:00:00'), -- id 9
('6B', 2025, '6 ano', 'Tarde', 'Língua Portuguesa', '2025-03-10', 'Revisão para prova',                       1.00, 1, '2025-03-10 17:00:00'), -- id 10
-- 7A - Língua Portuguesa
('7A', 2025, '7 ano', 'Manha', 'Língua Portuguesa', '2025-02-10', 'Retomada: tipos de textos',                1.00, 1, '2025-02-10 12:00:00'), -- id 11
('7A', 2025, '7 ano', 'Manha', 'Língua Portuguesa', '2025-02-17', 'Figuras de linguagem',                     1.00, 1, '2025-02-17 12:00:00'), -- id 12
('7A', 2025, '7 ano', 'Manha', 'Língua Portuguesa', '2025-03-03', 'Análise sintática',                        1.00, 1, '2025-03-03 12:00:00'), -- id 13
-- 8A - Língua Portuguesa
('8A', 2025, '8 ano', 'Tarde', 'Língua Portuguesa', '2025-02-10', 'Retomada: morfologia',                     1.00, 1, '2025-02-10 17:00:00'), -- id 14
('8A', 2025, '8 ano', 'Tarde', 'Língua Portuguesa', '2025-02-17', 'Redação dissertativo-argumentativa',       1.00, 1, '2025-02-17 17:00:00'), -- id 15
('8A', 2025, '8 ano', 'Tarde', 'Língua Portuguesa', '2025-03-03', 'Interpretação de texto - ENEM',            1.00, 1, '2025-03-03 17:00:00'), -- id 16
-- 6A - Matemática
('6A', 2025, '6 ano', 'Manha', 'Matemática', '2025-02-11', 'Números naturais e operações',    1.00, 1, '2025-02-11 12:00:00'), -- id 17
('6A', 2025, '6 ano', 'Manha', 'Matemática', '2025-02-18', 'Frações',                         1.00, 1, '2025-02-18 12:00:00'), -- id 18
('6A', 2025, '6 ano', 'Manha', 'Matemática', '2025-02-25', 'Decimais',                        1.00, 1, '2025-02-25 12:00:00'), -- id 19
('6A', 2025, '6 ano', 'Manha', 'Matemática', '2025-03-04', 'Geometria plana',                 1.00, 1, '2025-03-04 12:00:00'), -- id 20
-- 6B - Matemática
('6B', 2025, '6 ano', 'Tarde', 'Matemática', '2025-02-11', 'Números naturais e operações',    1.00, 1, '2025-02-11 17:00:00'), -- id 21
('6B', 2025, '6 ano', 'Tarde', 'Matemática', '2025-02-18', 'Frações',                         1.00, 1, '2025-02-18 17:00:00'), -- id 22
('6B', 2025, '6 ano', 'Tarde', 'Matemática', '2025-02-25', 'Decimais',                        1.00, 1, '2025-02-25 17:00:00'), -- id 23
('6B', 2025, '6 ano', 'Tarde', 'Matemática', '2025-03-04', 'Geometria plana',                 1.00, 1, '2025-03-04 17:00:00'), -- id 24
-- 7A - Matemática
('7A', 2025, '7 ano', 'Manha', 'Matemática', '2025-02-11', 'Equações de 1º grau',             1.00, 1, '2025-02-11 12:00:00'), -- id 25
('7A', 2025, '7 ano', 'Manha', 'Matemática', '2025-02-18', 'Sistemas de equações',            1.00, 1, '2025-02-18 12:00:00'), -- id 26
-- 8A - Matemática
('8A', 2025, '8 ano', 'Tarde', 'Matemática', '2025-02-11', 'Potências e raízes',              1.00, 1, '2025-02-11 17:00:00'), -- id 27
('8A', 2025, '8 ano', 'Tarde', 'Matemática', '2025-02-18', 'Equações de 2º grau',             1.00, 1, '2025-02-18 17:00:00'), -- id 28
-- 6A - Ciências
('6A', 2025, '6 ano', 'Manha', 'Ciências', '2025-02-12', 'Introdução às ciências naturais',   1.00, 1, '2025-02-12 12:00:00'), -- id 29
('6A', 2025, '6 ano', 'Manha', 'Ciências', '2025-02-19', 'Células e seres vivos',             1.00, 1, '2025-02-19 12:00:00'), -- id 30
-- 6B - Ciências
('6B', 2025, '6 ano', 'Tarde', 'Ciências', '2025-02-12', 'Introdução às ciências naturais',   1.00, 1, '2025-02-12 17:00:00'), -- id 31
('6B', 2025, '6 ano', 'Tarde', 'Ciências', '2025-02-19', 'Células e seres vivos',             1.00, 1, '2025-02-19 17:00:00'), -- id 32
-- 7A - Ciências
('7A', 2025, '7 ano', 'Manha', 'Ciências', '2025-02-12', 'Ecossistemas',                      1.00, 1, '2025-02-12 12:00:00'), -- id 33
('7A', 2025, '7 ano', 'Manha', 'Ciências', '2025-02-19', 'Cadeia alimentar',                  1.00, 1, '2025-02-19 12:00:00'), -- id 34
-- 8A - Ciências
('8A', 2025, '8 ano', 'Tarde', 'Ciências', '2025-02-12', 'Química orgânica básica',           1.00, 1, '2025-02-12 17:00:00'), -- id 35
('8A', 2025, '8 ano', 'Tarde', 'Ciências', '2025-02-19', 'Reações químicas',                  1.00, 1, '2025-02-19 17:00:00'), -- id 36
-- 6A - História
('6A', 2025, '6 ano', 'Manha', 'História', '2025-02-13', 'Pré-história',                      1.00, 1, '2025-02-13 12:00:00'), -- id 37
('6A', 2025, '6 ano', 'Manha', 'História', '2025-02-20', 'Antiguidade Oriental',              1.00, 1, '2025-02-20 12:00:00'); -- id 38

-- ============================================================
-- ACADÊMICO: Frequência
-- Perfil coerente: alunos com baixa presença no boletim
--   Rafael(90199900009) e Breno(13311111111): muitas ausências
--   Fernanda(68866666666): muitas ausências na 7A
--   Demais: presença alta, com poucas ausências
-- ============================================================
-- 6A - Língua Portuguesa - Aulas 1 a 5 para 5 alunos
INSERT INTO academico.tb_frequencia (fk_cpf, fk_ano_letivo, fk_nome_turma, fk_serie, fk_turno, fk_nome_disciplina, fk_id_aula, status_frequencia, carga_horaria_faltada, data_cadastro) VALUES
-- Aula 1 (id=1) - todos presentes exceto Lucas
('12311100001', 2025, '6A', '6 ano', 'Manha', 'Língua Portuguesa', 1, 'Presente',   0.00, '2025-02-10 12:10:00'),
('23422200002', 2025, '6A', '6 ano', 'Manha', 'Língua Portuguesa', 1, 'Presente',   0.00, '2025-02-10 12:10:00'),
('34533300003', 2025, '6A', '6 ano', 'Manha', 'Língua Portuguesa', 1, 'Ausente',    1.00, '2025-02-10 12:10:00'),
('45644400004', 2025, '6A', '6 ano', 'Manha', 'Língua Portuguesa', 1, 'Presente',   0.00, '2025-02-10 12:10:00'),
('56755500005', 2025, '6A', '6 ano', 'Manha', 'Língua Portuguesa', 1, 'Presente',   0.00, '2025-02-10 12:10:00'),
-- Aula 2 (id=2)
('12311100001', 2025, '6A', '6 ano', 'Manha', 'Língua Portuguesa', 2, 'Presente',   0.00, '2025-02-17 12:10:00'),
('23422200002', 2025, '6A', '6 ano', 'Manha', 'Língua Portuguesa', 2, 'Presente',   0.00, '2025-02-17 12:10:00'),
('34533300003', 2025, '6A', '6 ano', 'Manha', 'Língua Portuguesa', 2, 'Ausente',    1.00, '2025-02-17 12:10:00'),
('45644400004', 2025, '6A', '6 ano', 'Manha', 'Língua Portuguesa', 2, 'Justificada',0.00, '2025-02-17 12:10:00'),
('56755500005', 2025, '6A', '6 ano', 'Manha', 'Língua Portuguesa', 2, 'Presente',   0.00, '2025-02-17 12:10:00'),
-- Aula 3 (id=3)
('12311100001', 2025, '6A', '6 ano', 'Manha', 'Língua Portuguesa', 3, 'Presente',   0.00, '2025-02-24 12:10:00'),
('23422200002', 2025, '6A', '6 ano', 'Manha', 'Língua Portuguesa', 3, 'Presente',   0.00, '2025-02-24 12:10:00'),
('34533300003', 2025, '6A', '6 ano', 'Manha', 'Língua Portuguesa', 3, 'Ausente',    1.00, '2025-02-24 12:10:00'),
('45644400004', 2025, '6A', '6 ano', 'Manha', 'Língua Portuguesa', 3, 'Presente',   0.00, '2025-02-24 12:10:00'),
('56755500005', 2025, '6A', '6 ano', 'Manha', 'Língua Portuguesa', 3, 'Presente',   0.00, '2025-02-24 12:10:00'),
-- Aula 4 (id=4)
('12311100001', 2025, '6A', '6 ano', 'Manha', 'Língua Portuguesa', 4, 'Presente',   0.00, '2025-03-03 12:10:00'),
('23422200002', 2025, '6A', '6 ano', 'Manha', 'Língua Portuguesa', 4, 'Presente',   0.00, '2025-03-03 12:10:00'),
('34533300003', 2025, '6A', '6 ano', 'Manha', 'Língua Portuguesa', 4, 'Presente',   0.00, '2025-03-03 12:10:00'),
('45644400004', 2025, '6A', '6 ano', 'Manha', 'Língua Portuguesa', 4, 'Ausente',    1.00, '2025-03-03 12:10:00'),
('56755500005', 2025, '6A', '6 ano', 'Manha', 'Língua Portuguesa', 4, 'Presente',   0.00, '2025-03-03 12:10:00'),
-- Aula 5 (id=5)
('12311100001', 2025, '6A', '6 ano', 'Manha', 'Língua Portuguesa', 5, 'Presente',   0.00, '2025-03-10 12:10:00'),
('23422200002', 2025, '6A', '6 ano', 'Manha', 'Língua Portuguesa', 5, 'Presente',   0.00, '2025-03-10 12:10:00'),
('34533300003', 2025, '6A', '6 ano', 'Manha', 'Língua Portuguesa', 5, 'Ausente',    1.00, '2025-03-10 12:10:00'),
('45644400004', 2025, '6A', '6 ano', 'Manha', 'Língua Portuguesa', 5, 'Presente',   0.00, '2025-03-10 12:10:00'),
('56755500005', 2025, '6A', '6 ano', 'Manha', 'Língua Portuguesa', 5, 'Presente',   0.00, '2025-03-10 12:10:00'),
-- 6B - Língua Portuguesa - Aulas 6 a 10 para 6 alunos
-- Rafael(90199900009) e Breno(13311111111): muitas ausências
('67866600006', 2025, '6B', '6 ano', 'Tarde', 'Língua Portuguesa', 6,  'Presente',   0.00, '2025-02-10 17:10:00'),
('78977700007', 2025, '6B', '6 ano', 'Tarde', 'Língua Portuguesa', 6,  'Presente',   0.00, '2025-02-10 17:10:00'),
('89088800008', 2025, '6B', '6 ano', 'Tarde', 'Língua Portuguesa', 6,  'Presente',   0.00, '2025-02-10 17:10:00'),
('90199900009', 2025, '6B', '6 ano', 'Tarde', 'Língua Portuguesa', 6,  'Ausente',    1.00, '2025-02-10 17:10:00'),
('01200000010', 2025, '6B', '6 ano', 'Tarde', 'Língua Portuguesa', 6,  'Presente',   0.00, '2025-02-10 17:10:00'),
('13311111111', 2025, '6B', '6 ano', 'Tarde', 'Língua Portuguesa', 6,  'Ausente',    1.00, '2025-02-10 17:10:00'),
('67866600006', 2025, '6B', '6 ano', 'Tarde', 'Língua Portuguesa', 7,  'Presente',   0.00, '2025-02-17 17:10:00'),
('78977700007', 2025, '6B', '6 ano', 'Tarde', 'Língua Portuguesa', 7,  'Presente',   0.00, '2025-02-17 17:10:00'),
('89088800008', 2025, '6B', '6 ano', 'Tarde', 'Língua Portuguesa', 7,  'Presente',   0.00, '2025-02-17 17:10:00'),
('90199900009', 2025, '6B', '6 ano', 'Tarde', 'Língua Portuguesa', 7,  'Ausente',    1.00, '2025-02-17 17:10:00'),
('01200000010', 2025, '6B', '6 ano', 'Tarde', 'Língua Portuguesa', 7,  'Presente',   0.00, '2025-02-17 17:10:00'),
('13311111111', 2025, '6B', '6 ano', 'Tarde', 'Língua Portuguesa', 7,  'Ausente',    1.00, '2025-02-17 17:10:00'),
('67866600006', 2025, '6B', '6 ano', 'Tarde', 'Língua Portuguesa', 8,  'Presente',   0.00, '2025-02-24 17:10:00'),
('78977700007', 2025, '6B', '6 ano', 'Tarde', 'Língua Portuguesa', 8,  'Ausente',    1.00, '2025-02-24 17:10:00'),
('89088800008', 2025, '6B', '6 ano', 'Tarde', 'Língua Portuguesa', 8,  'Presente',   0.00, '2025-02-24 17:10:00'),
('90199900009', 2025, '6B', '6 ano', 'Tarde', 'Língua Portuguesa', 8,  'Ausente',    1.00, '2025-02-24 17:10:00'),
('01200000010', 2025, '6B', '6 ano', 'Tarde', 'Língua Portuguesa', 8,  'Presente',   0.00, '2025-02-24 17:10:00'),
('13311111111', 2025, '6B', '6 ano', 'Tarde', 'Língua Portuguesa', 8,  'Ausente',    1.00, '2025-02-24 17:10:00'),
('67866600006', 2025, '6B', '6 ano', 'Tarde', 'Língua Portuguesa', 9,  'Presente',   0.00, '2025-03-03 17:10:00'),
('78977700007', 2025, '6B', '6 ano', 'Tarde', 'Língua Portuguesa', 9,  'Presente',   0.00, '2025-03-03 17:10:00'),
('89088800008', 2025, '6B', '6 ano', 'Tarde', 'Língua Portuguesa', 9,  'Presente',   0.00, '2025-03-03 17:10:00'),
('90199900009', 2025, '6B', '6 ano', 'Tarde', 'Língua Portuguesa', 9,  'Ausente',    1.00, '2025-03-03 17:10:00'),
('01200000010', 2025, '6B', '6 ano', 'Tarde', 'Língua Portuguesa', 9,  'Presente',   0.00, '2025-03-03 17:10:00'),
('13311111111', 2025, '6B', '6 ano', 'Tarde', 'Língua Portuguesa', 9,  'Ausente',    1.00, '2025-03-03 17:10:00'),
('67866600006', 2025, '6B', '6 ano', 'Tarde', 'Língua Portuguesa', 10, 'Presente',   0.00, '2025-03-10 17:10:00'),
('78977700007', 2025, '6B', '6 ano', 'Tarde', 'Língua Portuguesa', 10, 'Presente',   0.00, '2025-03-10 17:10:00'),
('89088800008', 2025, '6B', '6 ano', 'Tarde', 'Língua Portuguesa', 10, 'Presente',   0.00, '2025-03-10 17:10:00'),
('90199900009', 2025, '6B', '6 ano', 'Tarde', 'Língua Portuguesa', 10, 'Ausente',    1.00, '2025-03-10 17:10:00'),
('01200000010', 2025, '6B', '6 ano', 'Tarde', 'Língua Portuguesa', 10, 'Presente',   0.00, '2025-03-10 17:10:00'),
('13311111111', 2025, '6B', '6 ano', 'Tarde', 'Língua Portuguesa', 10, 'Presente',   0.00, '2025-03-10 17:10:00'),
-- 7A - Língua Portuguesa - Aulas 11,12,13
-- Fernanda(68866666666): ausente na maioria
('24422222222', 2025, '7A', '7 ano', 'Manha', 'Língua Portuguesa', 11, 'Presente',   0.00, '2025-02-10 12:10:00'),
('35533333333', 2025, '7A', '7 ano', 'Manha', 'Língua Portuguesa', 11, 'Presente',   0.00, '2025-02-10 12:10:00'),
('46644444444', 2025, '7A', '7 ano', 'Manha', 'Língua Portuguesa', 11, 'Presente',   0.00, '2025-02-10 12:10:00'),
('57755555555', 2025, '7A', '7 ano', 'Manha', 'Língua Portuguesa', 11, 'Presente',   0.00, '2025-02-10 12:10:00'),
('68866666666', 2025, '7A', '7 ano', 'Manha', 'Língua Portuguesa', 11, 'Ausente',    1.00, '2025-02-10 12:10:00'),
('24422222222', 2025, '7A', '7 ano', 'Manha', 'Língua Portuguesa', 12, 'Presente',   0.00, '2025-02-17 12:10:00'),
('35533333333', 2025, '7A', '7 ano', 'Manha', 'Língua Portuguesa', 12, 'Ausente',    1.00, '2025-02-17 12:10:00'),
('46644444444', 2025, '7A', '7 ano', 'Manha', 'Língua Portuguesa', 12, 'Presente',   0.00, '2025-02-17 12:10:00'),
('57755555555', 2025, '7A', '7 ano', 'Manha', 'Língua Portuguesa', 12, 'Presente',   0.00, '2025-02-17 12:10:00'),
('68866666666', 2025, '7A', '7 ano', 'Manha', 'Língua Portuguesa', 12, 'Ausente',    1.00, '2025-02-17 12:10:00'),
('24422222222', 2025, '7A', '7 ano', 'Manha', 'Língua Portuguesa', 13, 'Presente',   0.00, '2025-03-03 12:10:00'),
('35533333333', 2025, '7A', '7 ano', 'Manha', 'Língua Portuguesa', 13, 'Presente',   0.00, '2025-03-03 12:10:00'),
('46644444444', 2025, '7A', '7 ano', 'Manha', 'Língua Portuguesa', 13, 'Presente',   0.00, '2025-03-03 12:10:00'),
('57755555555', 2025, '7A', '7 ano', 'Manha', 'Língua Portuguesa', 13, 'Ausente',    1.00, '2025-03-03 12:10:00'),
('68866666666', 2025, '7A', '7 ano', 'Manha', 'Língua Portuguesa', 13, 'Ausente',    1.00, '2025-03-03 12:10:00'),
-- 8A - Língua Portuguesa - Aulas 14,15,16
('79977777777', 2025, '8A', '8 ano', 'Tarde', 'Língua Portuguesa', 14, 'Presente',   0.00, '2025-02-10 17:10:00'),
('80088888888', 2025, '8A', '8 ano', 'Tarde', 'Língua Portuguesa', 14, 'Presente',   0.00, '2025-02-10 17:10:00'),
('91199999999', 2025, '8A', '8 ano', 'Tarde', 'Língua Portuguesa', 14, 'Presente',   0.00, '2025-02-10 17:10:00'),
('02200000001', 2025, '8A', '8 ano', 'Tarde', 'Língua Portuguesa', 14, 'Presente',   0.00, '2025-02-10 17:10:00'),
('79977777777', 2025, '8A', '8 ano', 'Tarde', 'Língua Portuguesa', 15, 'Presente',   0.00, '2025-02-17 17:10:00'),
('80088888888', 2025, '8A', '8 ano', 'Tarde', 'Língua Portuguesa', 15, 'Ausente',    1.00, '2025-02-17 17:10:00'),
('91199999999', 2025, '8A', '8 ano', 'Tarde', 'Língua Portuguesa', 15, 'Presente',   0.00, '2025-02-17 17:10:00'),
('02200000001', 2025, '8A', '8 ano', 'Tarde', 'Língua Portuguesa', 15, 'Presente',   0.00, '2025-02-17 17:10:00'),
('79977777777', 2025, '8A', '8 ano', 'Tarde', 'Língua Portuguesa', 16, 'Presente',   0.00, '2025-03-03 17:10:00'),
('80088888888', 2025, '8A', '8 ano', 'Tarde', 'Língua Portuguesa', 16, 'Presente',   0.00, '2025-03-03 17:10:00'),
('91199999999', 2025, '8A', '8 ano', 'Tarde', 'Língua Portuguesa', 16, 'Presente',   0.00, '2025-03-03 17:10:00'),
('02200000001', 2025, '8A', '8 ano', 'Tarde', 'Língua Portuguesa', 16, 'Presente',   0.00, '2025-03-03 17:10:00');

-- ============================================================
-- ACADÊMICO: Ocorrências de Alunos
-- ============================================================
INSERT INTO academico.tb_ocorrencias_aluno (fk_cpf, fk_ano_letivo, fk_nome_turma, fk_serie, fk_turno, data_ocorrencia, tipo_ocorrencia, gravidade, descricao, resolvida, data_resolucao, data_cadastro, data_atualizacao) VALUES
-- Lucas: disciplinar por faltas excessivas
('34533300003', 2025, '6A', '6 ano', 'Manha', '2025-03-12 10:00:00', 'Disciplinar',  'Media', 'Aluno apresenta excesso de faltas e comportamento desinteressado em sala.',                         0, NULL,                   '2025-03-12 10:30:00', NULL),
-- Rafael: disciplinar por faltas
('90199900009', 2025, '6B', '6 ano', 'Tarde', '2025-03-15 14:00:00', 'Disciplinar',  'Alta',  'Aluno ausentou-se sem justificativa por 3 semanas consecutivas. Família foi notificada.',           1, '2025-04-05 09:00:00', '2025-03-15 14:30:00', '2025-04-05 09:00:00'),
-- Breno: pedagógica
('13311111111', 2025, '6B', '6 ano', 'Tarde', '2025-04-07 15:00:00', 'Pedagogica',   'Media', 'Aluno com dificuldades acentuadas em leitura e interpretação. Indicado para reforço.',             0, NULL,                   '2025-04-07 15:30:00', NULL),
-- Fernanda: faltas
('68866666666', 2025, '7A', '7 ano', 'Manha', '2025-04-10 09:00:00', 'Disciplinar',  'Alta',  'Aluna com frequência crítica (abaixo de 50%). Comunicação enviada aos responsáveis.',              0, NULL,                   '2025-04-10 09:30:00', NULL),
-- Isabela: elogio
('23422200002', 2025, '6A', '6 ano', 'Manha', '2025-05-05 10:00:00', 'Elogio',       'Baixa', 'Aluna destacou-se no concurso de redação municipal, obtendo 2º lugar.',                            1, '2025-05-05 10:00:00', '2025-05-05 10:30:00', '2025-05-05 10:30:00'),
-- Diego: disciplinar
('35533333333', 2025, '7A', '7 ano', 'Manha', '2025-05-08 11:00:00', 'Disciplinar',  'Media', 'Conflito verbal com colega durante aula de Matemática. Conversa com coordenação realizada.',       1, '2025-05-09 10:00:00', '2025-05-08 11:30:00', '2025-05-09 10:30:00'),
-- Larissa: pedagógica
('45644400004', 2025, '6A', '6 ano', 'Manha', '2025-05-14 09:00:00', 'Pedagogica',   'Baixa', 'Aluna demonstra dificuldades em matemática. Encaminhada para aulas de reforço às terças.',         0, NULL,                   '2025-05-14 09:30:00', NULL);

-- ============================================================
-- FIM DO SCRIPT DE INSERTS
-- ============================================================
