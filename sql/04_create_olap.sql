/* =========================================================
   FASE 4 - BUSINESS INTELLIGENCE (OLAP + ETL)
   ========================================================= */

/* =========================================================
   1. CRIAÇÃO DO BANCO OLAP
   ========================================================= */
DROP DATABASE IF EXISTS olap_escolar;

CREATE DATABASE olap_escolar;
USE olap_escolar;

/* =========================================================
   2. DIMENSÕES (STAR SCHEMA)
   ========================================================= */

/* -------------------------
   DIMENSÃO TEMPO
------------------------- */

CREATE TABLE dim_tempo (
    sk_tempo INT AUTO_INCREMENT PRIMARY KEY,
    data_completa DATE NOT NULL,
    ano INT NOT NULL,
    mes INT NOT NULL,
    nome_mes VARCHAR(20) NOT NULL,
    trimestre INT NOT NULL,
    semestre INT NOT NULL
);

/* -------------------------
   DIMENSÃO ALUNO
------------------------- */

CREATE TABLE dim_aluno (
    sk_aluno INT AUTO_INCREMENT PRIMARY KEY,
    cpf_aluno CHAR(11) NOT NULL,
    nome_completo VARCHAR(255) NOT NULL,
    sexo VARCHAR(50),
    raca_cor VARCHAR(50),
    cidade VARCHAR(100),
    uf CHAR(2)
);

/* -------------------------
   DIMENSÃO CURSO / DISCIPLINA
------------------------- */

CREATE TABLE dim_curso (
    sk_curso INT AUTO_INCREMENT PRIMARY KEY,
    nome_disciplina VARCHAR(100) NOT NULL,
    carga_horaria INT
);

/* -------------------------
   DIMENSÃO UNIDADE / TURMA
------------------------- */

CREATE TABLE dim_unidade (
    sk_unidade INT AUTO_INCREMENT PRIMARY KEY,
    nome_turma VARCHAR(20),
    serie VARCHAR(20),
    turno VARCHAR(10),
    sala VARCHAR(20),
    ano_letivo INT
);

/* =========================================================
   3. TABELA FATO
   ========================================================= */

CREATE TABLE fato_desempenho_aluno (
    sk_fato INT AUTO_INCREMENT PRIMARY KEY,

    sk_tempo INT NOT NULL,
    sk_aluno INT NOT NULL,
    sk_curso INT NOT NULL,
    sk_unidade INT NOT NULL,

    nota DECIMAL(5,2),
    percentual_presenca DECIMAL(5,2),
    quantidade_faltas INT,
    quantidade_aulas INT,

    FOREIGN KEY (sk_tempo)
        REFERENCES dim_tempo(sk_tempo),

    FOREIGN KEY (sk_aluno)
        REFERENCES dim_aluno(sk_aluno),

    FOREIGN KEY (sk_curso)
        REFERENCES dim_curso(sk_curso),

    FOREIGN KEY (sk_unidade)
        REFERENCES dim_unidade(sk_unidade)
);

/* =========================================================
   4. PROCESSO ETL
   ========================================================= */

/* =========================================================
   ETAPA 1 - EXTRAÇÃO E CARGA DA DIMENSÃO TEMPO
   ========================================================= */

INSERT INTO dim_tempo (
    data_completa,
    ano,
    mes,
    nome_mes,
    trimestre,
    semestre
)
SELECT DISTINCT
    a.data_avaliacao,
    YEAR(a.data_avaliacao),
    MONTH(a.data_avaliacao),

    CASE MONTH(a.data_avaliacao)
        WHEN 1 THEN 'Janeiro'
        WHEN 2 THEN 'Fevereiro'
        WHEN 3 THEN 'Marco'
        WHEN 4 THEN 'Abril'
        WHEN 5 THEN 'Maio'
        WHEN 6 THEN 'Junho'
        WHEN 7 THEN 'Julho'
        WHEN 8 THEN 'Agosto'
        WHEN 9 THEN 'Setembro'
        WHEN 10 THEN 'Outubro'
        WHEN 11 THEN 'Novembro'
        WHEN 12 THEN 'Dezembro'
    END,

    QUARTER(a.data_avaliacao),

    CASE
        WHEN MONTH(a.data_avaliacao) <= 6 THEN 1
        ELSE 2
    END

FROM academico.tb_avaliacoes a;

/* =========================================================
   ETAPA 2 - DIMENSÃO ALUNO
   ========================================================= */

INSERT INTO dim_aluno (
    cpf_aluno,
    nome_completo,
    sexo,
    raca_cor,
    cidade,
    uf
)
SELECT
    p.pk_cpf,
    CONCAT(p.nome, ' ', COALESCE(p.sobrenome,'')),
    p.sexo,
    p.raca_cor,
    e.cidade,
    e.uf

FROM base.tb_pessoa p

INNER JOIN academico.tb_aluno a
    ON a.pk_cpf = p.pk_cpf

LEFT JOIN base.tb_enderecos e
    ON e.fk_cpf = p.pk_cpf;

/* =========================================================
   ETAPA 3 - DIMENSÃO CURSO
   ========================================================= */

INSERT INTO dim_curso (
    nome_disciplina,
    carga_horaria
)
SELECT DISTINCT
    pk_nome_disciplina,
    carga_horaria
FROM academico.tb_disciplinas;

/* =========================================================
   ETAPA 4 - DIMENSÃO UNIDADE
   ========================================================= */

INSERT INTO dim_unidade (
    nome_turma,
    serie,
    turno,
    sala,
    ano_letivo
)
SELECT DISTINCT
    pk_nome_turma,
    pk_serie,
    pk_turno,
    num_sala,
    pk_ano_letivo
FROM academico.tb_turmas;

/* =========================================================
   ETAPA 5 - CARGA DA TABELA FATO
   ========================================================= */

INSERT INTO fato_desempenho_aluno (
    sk_tempo,
    sk_aluno,
    sk_curso,
    sk_unidade,
    nota,
    percentual_presenca,
    quantidade_faltas,
    quantidade_aulas
)

SELECT
    dt.sk_tempo,
    da.sk_aluno,
    dc.sk_curso,
    du.sk_unidade,
    na.nota_obtida,
    b.percentual_presenca,
    SUM(CASE
            WHEN f.status_frequencia = 'Ausente'
            THEN 1
            ELSE 0
        END)AS quantidade_faltas,
    COUNT(f.pk_id_frequencia) AS quantidade_aulas
FROM academico.tb_notas_avaliacao na

INNER JOIN academico.tb_avaliacoes av
    ON av.pk_id_avaliacao = na.fk_id_avaliacao
    
INNER JOIN dim_tempo dt
    ON dt.data_completa = av.data_avaliacao
    
INNER JOIN dim_aluno da
    ON da.cpf_aluno = na.fk_cpf
    
INNER JOIN dim_curso dc
    ON dc.nome_disciplina = na.fk_nome_disciplina
    
INNER JOIN dim_unidade du
    ON du.nome_turma = na.fk_nome_turma
    AND du.serie = na.fk_serie
    AND du.turno = na.fk_turno
    AND du.ano_letivo = na.fk_ano_letivo
    
LEFT JOIN academico.tb_boletim b
    ON b.pk_cpf = na.fk_cpf
    AND b.pk_nome_disciplina = na.fk_nome_disciplina
    AND b.pk_ano_letivo = na.fk_ano_letivo
    
LEFT JOIN academico.tb_frequencia f
    ON f.fk_cpf = na.fk_cpf
    AND f.fk_nome_disciplina = na.fk_nome_disciplina
    AND f.fk_ano_letivo = na.fk_ano_letivo
GROUP BY
    dt.sk_tempo,
    da.sk_aluno,
    dc.sk_curso,
    du.sk_unidade,
    na.nota_obtida,
    b.percentual_presenca;

/* =========================================================
   5. VALIDAÇÃO OLTP vs OLAP
   ========================================================= */

/* -------------------------
   TOTAL DE NOTAS - OLTP
------------------------- */

SELECT
    'OLTP' AS origem,
    SUM(nota_obtida) AS soma_notas
FROM academico.tb_notas_avaliacao;

/* -------------------------
   TOTAL DE NOTAS - OLAP
------------------------- */

SELECT
    'OLAP' AS origem,
    SUM(nota) AS soma_notas
FROM olap_escolar.fato_desempenho_aluno;

/* =========================================================
   VALIDAÇÃO FINAL COMPARATIVA
   ========================================================= */

SELECT
    oltp.soma_oltp,
    olap.soma_olap,
    CASE
        WHEN oltp.soma_oltp = olap.soma_olap
        THEN 'VALIDACAO OK'
        ELSE 'ERRO DE INTEGRIDADE'
    END AS validacao
FROM
(
    SELECT
        SUM(nota_obtida) AS soma_oltp
    FROM academico.tb_notas_avaliacao
) oltp,
(
    SELECT
        SUM(nota) AS soma_olap
    FROM olap_escolar.fato_desempenho_aluno
) olap;

/* =========================================================
   6. CONSULTAS OLAP (ANALÍTICAS)
   ========================================================= */

/* Média de notas por disciplina */

SELECT
    dc.nome_disciplina,
    ROUND(AVG(f.nota),2) AS media_notas
FROM fato_desempenho_aluno f
INNER JOIN dim_curso dc
    ON dc.sk_curso = f.sk_curso
GROUP BY dc.nome_disciplina;

/* Média por turma */

SELECT
    du.nome_turma,
    ROUND(AVG(f.nota),2) AS media_turma
FROM fato_desempenho_aluno f
INNER JOIN dim_unidade du
    ON du.sk_unidade = f.sk_unidade
GROUP BY du.nome_turma;

/* Frequência média por disciplina */

SELECT
    dc.nome_disciplina,
    ROUND(AVG(f.percentual_presenca),2) AS frequencia_media
FROM fato_desempenho_aluno f
INNER JOIN dim_curso dc
    ON dc.sk_curso = f.sk_curso
GROUP BY dc.nome_disciplina;

/* Top 10 alunos com maiores notas */

SELECT
    da.nome_completo,
    ROUND(AVG(f.nota),2) AS media_final
FROM fato_desempenho_aluno f
INNER JOIN dim_aluno da
    ON da.sk_aluno = f.sk_aluno
GROUP BY da.nome_completo
ORDER BY media_final DESC
LIMIT 10;