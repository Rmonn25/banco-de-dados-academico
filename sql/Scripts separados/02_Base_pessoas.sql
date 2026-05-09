/* 
Tabela base de pessoas.
*/
CREATE TABLE base.tb_pessoa (

    /* Chave primária da pessoa */
    pk_cpf CHAR(11) NOT NULL PRIMARY KEY,

    /* Dados pessoais */
    nome VARCHAR(255) NOT NULL,
    sobrenome VARCHAR(225) NULL,
    nome_social VARCHAR(225),
    data_nascimento DATE NOT NULL,
    sexo varchar(50) NOT NULL,
    raca_cor varchar(50) NOT NULL,
    nacionalidade VARCHAR(225) NOT NULL,
    naturalidade VARCHAR(255) NOT NULL,

    /* Campos de controle de registro */
    data_cadastro DATETIME NOT NULL,
    data_atualizacao DATETIME NOT NULL,

    /* Restrição para permitir apenas os valores definidos para sexo */
    CONSTRAINT tb_pessoa_sexo
        CHECK (sexo IN ('Masculino', 'Feminino', 'Prefiro não informar')),

    /* Restrição para permitir apenas os valores definidos para raça/cor */
    CONSTRAINT tb_pessoa_raca
        CHECK (raca_cor IN ('Branca', 'Parda', 'Negra', 'Amarela', 'Indigena', 'Prefiro não informar'))
);

/* 
Tabela de endereços.
*/
CREATE TABLE base.tb_enderecos (

    /* Identificador único do endereço */
    id_endereco INT NOT NULL AUTO_INCREMENT PRIMARY KEY,

    /* Dados do endereço */
    cep VARCHAR(9) NOT NULL,
    logradouro VARCHAR(150) NOT NULL,
    numero VARCHAR(10) NOT NULL,
    complemento VARCHAR(100),
    bairro VARCHAR(100) NOT NULL,
    cidade VARCHAR(100) NOT NULL,
    uf CHAR(2) NOT NULL,

    /* Chave estrangeira que relaciona o endereço à pessoa */
    fk_cpf CHAR(11) NOT NULL,

    /* Relacionamento com a tabela de pessoas */
    CONSTRAINT FK_tb_enderecos_tb_pessoa
        FOREIGN KEY (fk_cpf)
        REFERENCES base.tb_pessoa(pk_cpf),

    /* Impede duplicidade do mesmo endereço para a mesma pessoa */
    CONSTRAINT UQ_tb_enderecos
        UNIQUE (fk_cpf, cep, logradouro, numero)
);

/* 
Tabela de telefones.
*/

CREATE TABLE base.tb_telefones (

    /* Chave primária composta do telefone */
    pk_ddd VARCHAR(2) NOT NULL,
    pk_numero VARCHAR(15) NOT NULL,
    fk_cpf CHAR(11) NOT NULL,

    /* Informações complementares do telefone */
    ddi VARCHAR(3) NULL,
    tipo_telefone VARCHAR(20),
    ativo VARCHAR(10) NOT NULL,

    /* Chave primária composta: ddd + número + cpf */
    CONSTRAINT PK_tb_telefones
        PRIMARY KEY (pk_ddd, pk_numero, fk_cpf),

    /* Relacionamento do telefone com a pessoa */
    CONSTRAINT FK_tb_telefones_tb_pessoa
        FOREIGN KEY (fk_cpf)
        REFERENCES base.tb_pessoa(pk_cpf),

    /* Restrição para os tipos de telefone permitidos */
    CONSTRAINT tb_telefones_tipo
        CHECK (tipo_telefone IN ('Celular', 'Residencial', 'Comercial')),

    /* Restrição para indicar se o telefone está ativo ou inativo */
    CONSTRAINT tb_telefones_ativo
        CHECK (ativo IN ('Ativo', 'Inativo'))
);