/* =========================================================
   RESET DO BANCO DE DADOS
   Remove os dados respeitando a ordem das foreign keys
   ========================================================= */

SET FOREIGN_KEY_CHECKS = 0;

/*Limpa os dados do schema financeiro*/
TRUNCATE TABLE financeiro.tb_pagamentos;
TRUNCATE TABLE financeiro.tb_despesas;
TRUNCATE TABLE financeiro.tb_contratos;
TRUNCATE TABLE financeiro.tb_fornecedores;
TRUNCATE TABLE financeiro.tb_receitas;
TRUNCATE TABLE financeiro.tb_orcamento_item;
TRUNCATE TABLE financeiro.tb_orcamento;
TRUNCATE TABLE financeiro.tb_centro_custo;
TRUNCATE TABLE financeiro.tb_categorias_despesa;
TRUNCATE TABLE financeiro.tb_fontes_recurso;

/*Limpa os dados do schema academico*/
TRUNCATE TABLE academico.tb_frequencia;
TRUNCATE TABLE academico.tb_aulas;
TRUNCATE TABLE academico.tb_notas_avaliacao;
TRUNCATE TABLE academico.tb_avaliacoes;
TRUNCATE TABLE academico.tb_boletim;
TRUNCATE TABLE academico.tb_matricula_disciplina;
TRUNCATE TABLE academico.tb_ocorrencias_aluno;
TRUNCATE TABLE academico.tb_aluno_responsavel;
TRUNCATE TABLE academico.tb_turma_disciplina;
TRUNCATE TABLE academico.tb_historico_turma;
TRUNCATE TABLE academico.tb_matricula_ano;
TRUNCATE TABLE academico.tb_responsavel;
TRUNCATE TABLE academico.tb_disciplinas;
TRUNCATE TABLE academico.tb_turmas;
TRUNCATE TABLE academico.tb_aluno;

/*Limpa os dados do schema rh*/
TRUNCATE TABLE rh.tb_ferias;
TRUNCATE TABLE rh.tb_folha_ponto;
TRUNCATE TABLE rh.tb_folha_pagamento;
TRUNCATE TABLE rh.tb_lotacao_funcionario;
TRUNCATE TABLE rh.tb_coordenacao;
TRUNCATE TABLE rh.tb_professor;
TRUNCATE TABLE rh.tb_funcionario;
TRUNCATE TABLE rh.tb_departamentos;
TRUNCATE TABLE rh.tb_cargos;

/*Limpa os dados do schema base pessoas*/
TRUNCATE TABLE base.tb_telefones;
TRUNCATE TABLE base.tb_enderecos;
TRUNCATE TABLE base.tb_pessoa;

SET FOREIGN_KEY_CHECKS = 1;