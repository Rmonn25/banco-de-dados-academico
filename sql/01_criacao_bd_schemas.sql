/* Criação do banco de dados */
CREATE DATABASE SISGESC;

/* Seleciona o banco de dados que será utilizado */
USE SISGESC;

/* Criação do schema base, que contém tabelas compartilhadas com os demais módulos do banco */
CREATE SCHEMA base;

/* Criação do schema academico, que contém tabelas relacionadas a alunos, aulas, notas e turmas */
CREATE SCHEMA academico;

/* Criação do schema rh, que contém tabelas relacionadas a funcionários, cargos e folha de pagamento */
CREATE SCHEMA rh;

/* Criação do schema financeiro, que contém tabelas relacionadas a salários, contratos e fornecedores */
CREATE SCHEMA financeiro;