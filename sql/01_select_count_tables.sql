/* 
Consulta de validação geral das tabelas.
Exibe a quantidade total de registros em cada tabela dos módulos base, RH, acadêmico e financeiro.
Utilizada para conferir se os INSERTS foram executados corretamente.
*/
SELECT 'base.tb_pessoa' AS tabela, COUNT(*) AS total FROM base.tb_pessoa
UNION ALL
SELECT 'base.tb_enderecos', COUNT(*) FROM base.tb_enderecos
UNION ALL
SELECT 'base.tb_telefones', COUNT(*) FROM base.tb_telefones
UNION ALL
SELECT 'rh.tb_cargos', COUNT(*) FROM rh.tb_cargos
UNION ALL
SELECT 'rh.tb_departamentos', COUNT(*) FROM rh.tb_departamentos
UNION ALL
SELECT 'rh.tb_funcionario', COUNT(*) FROM rh.tb_funcionario
UNION ALL
SELECT 'rh.tb_professor', COUNT(*) FROM rh.tb_professor
UNION ALL
SELECT 'rh.tb_coordenacao', COUNT(*) FROM rh.tb_coordenacao
UNION ALL
SELECT 'rh.tb_lotacao_funcionario', COUNT(*) FROM rh.tb_lotacao_funcionario
UNION ALL
SELECT 'rh.tb_folha_pagamento', COUNT(*) FROM rh.tb_folha_pagamento
UNION ALL
SELECT 'rh.tb_folha_ponto', COUNT(*) FROM rh.tb_folha_ponto
UNION ALL
SELECT 'rh.tb_ferias', COUNT(*) FROM rh.tb_ferias
UNION ALL
SELECT 'academico.tb_aluno', COUNT(*) FROM academico.tb_aluno
UNION ALL
SELECT 'academico.tb_turmas', COUNT(*) FROM academico.tb_turmas
UNION ALL
SELECT 'academico.tb_disciplinas', COUNT(*) FROM academico.tb_disciplinas
UNION ALL
SELECT 'academico.tb_responsavel', COUNT(*) FROM academico.tb_responsavel
UNION ALL
SELECT 'academico.tb_matricula_ano', COUNT(*) FROM academico.tb_matricula_ano
UNION ALL
SELECT 'academico.tb_historico_turma', COUNT(*) FROM academico.tb_historico_turma
UNION ALL
SELECT 'academico.tb_turma_disciplina', COUNT(*) FROM academico.tb_turma_disciplina
UNION ALL
SELECT 'academico.tb_aluno_responsavel', COUNT(*) FROM academico.tb_aluno_responsavel
UNION ALL
SELECT 'academico.tb_ocorrencias_aluno', COUNT(*) FROM academico.tb_ocorrencias_aluno
UNION ALL
SELECT 'academico.tb_matricula_disciplina', COUNT(*) FROM academico.tb_matricula_disciplina
UNION ALL
SELECT 'academico.tb_boletim', COUNT(*) FROM academico.tb_boletim
UNION ALL
SELECT 'academico.tb_avaliacoes', COUNT(*) FROM academico.tb_avaliacoes
UNION ALL
SELECT 'academico.tb_notas_avaliacao', COUNT(*) FROM academico.tb_notas_avaliacao
UNION ALL
SELECT 'academico.tb_aulas', COUNT(*) FROM academico.tb_aulas
UNION ALL
SELECT 'academico.tb_frequencia', COUNT(*) FROM academico.tb_frequencia
UNION ALL
SELECT 'financeiro.tb_fontes_recurso', COUNT(*) FROM financeiro.tb_fontes_recurso
UNION ALL
SELECT 'financeiro.tb_categorias_despesa', COUNT(*) FROM financeiro.tb_categorias_despesa
UNION ALL
SELECT 'financeiro.tb_centro_custo', COUNT(*) FROM financeiro.tb_centro_custo
UNION ALL
SELECT 'financeiro.tb_orcamento', COUNT(*) FROM financeiro.tb_orcamento
UNION ALL
SELECT 'financeiro.tb_orcamento_item', COUNT(*) FROM financeiro.tb_orcamento_item
UNION ALL
SELECT 'financeiro.tb_receitas', COUNT(*) FROM financeiro.tb_receitas
UNION ALL
SELECT 'financeiro.tb_fornecedores', COUNT(*) FROM financeiro.tb_fornecedores
UNION ALL
SELECT 'financeiro.tb_contratos', COUNT(*) FROM financeiro.tb_contratos
UNION ALL
SELECT 'financeiro.tb_despesas', COUNT(*) FROM financeiro.tb_despesas
UNION ALL
SELECT 'financeiro.tb_pagamentos', COUNT(*) FROM financeiro.tb_pagamentos
ORDER BY tabela;