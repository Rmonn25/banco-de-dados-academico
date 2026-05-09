/*Esta consulta retorna os alunos matriculados e suas respectivas turmas, 
relacionando os módulos acadêmico e base.*/
SELECT 
    p.nome,
    m.fk_nome_turma
FROM academico.tb_matricula_ano m
INNER JOIN base.tb_pessoa p
    ON p.pk_cpf = m.pk_cpf;
    

/*Listagem de professores com suas disciplinas */    
SELECT  
	p.nome, 
	td.pk_nome_disciplina 
FROM rh.tb_professor pr 
INNER JOIN base.tb_pessoa p 
	ON p.pk_cpf = pr.pk_cpf 
INNER JOIN academico.tb_turma_disciplina td 
	ON td.fk_cpf_professor = pr.pk_cpf; 
    
/*Listagem de funcionários com cargo e salário*/
SELECT 
    p.nome,
    f.fk_nome_cargo,
    c.salario_base
FROM rh.tb_funcionario f
INNER JOIN base.tb_pessoa p
    ON p.pk_cpf = f.pk_cpf
INNER JOIN rh.tb_cargos c
    ON c.pk_nome_cargo = f.fk_nome_cargo;

/*Subselect mostrando nome, sobrenome, quantidade de disciplinas e quais 
disciplinas*/
SELECT 
    p.nome,
    p.sobrenome,
    (SELECT COUNT(*)
		FROM academico.tb_turma_disciplina td
        WHERE td.fk_cpf_professor = pr.pk_cpf) AS quantidade_disciplinas,

    (SELECT GROUP_CONCAT(td.pk_nome_disciplina SEPARATOR ', ') 
		FROM academico.tb_turma_disciplina td
        WHERE td.fk_cpf_professor = pr.pk_cpf) AS disciplinas
FROM rh.tb_professor pr
INNER JOIN base.tb_pessoa p
    ON p.pk_cpf = pr.pk_cpf;
    
/*Nesta operação foi simulada uma falha após a inserção de um pagamento.
Ao executar ROLLBACK, todas as alterações realizadas durante a transação foram desfeitas.
O SELECT executado posteriormente comprovou que o registro não permaneceu salvo no banco de dados. 
*/    
START TRANSACTION;
INSERT INTO financeiro.tb_pagamentos (
    pk_numero_comprovante,
    fk_despesa,
    data_pagamento,
    valor_pago,
    forma_pagamento,
    data_cadastro )
    VALUES ('COMP123', 1, '2026-05-08', 1500.00, 'PIX', NOW());
ROLLBACK;
SELECT *
FROM financeiro.tb_pagamentos
WHERE pk_numero_comprovante = 'COMP123';

/*Nesta operação foi realizada a inserção de um pagamento seguida da confirmação definitiva utilizando COMMIT.
Após a confirmação da transação, o registro permaneceu armazenado permanentemente no banco de dados.*/
START TRANSACTION;
INSERT INTO financeiro.tb_pagamentos (
    pk_numero_comprovante,
    fk_despesa,
    data_pagamento,
    valor_pago,
    forma_pagamento,
    data_cadastro)
VALUES ('COMP999', 1, '2026-05-08', 2500.00, 'Cartao', NOW());
COMMIT;
SELECT *
FROM financeiro.tb_pagamentos
WHERE pk_numero_comprovante = 'COMP999';