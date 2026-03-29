# SisGESC – Sistema de Gestão Escolar

## Sobre o projeto

O **SisGESC** é um projeto acadêmico que está em desenvolvimento na faculdade na materia de Banco de dados com eu e mais 9 alunos, com o objetivo de projetar e estruturar um **Sistema de Gestão Escolar** voltado para o armazenamento, organização e análise de dados de uma **escola pública de bairro do ensino fundamental**.

A proposta do sistema é centralizar informações escolares, acadêmicas, administrativas e financeiras em um banco de dados estruturado, permitindo não apenas o suporte às operações do dia a dia da escola, mas também preparando a base para futuras aplicações em **Business Intelligence (BI)** e **Inteligência Artificial (IA)**.

## Contexto do trabalho

Este trabalho tem como foco principal a construção da base de dados do sistema, pensando não apenas no uso transacional, mas também no uso analítico e preditivo no futuro.

A ideia é que o banco de dados seja modelado de forma que possa, futuramente, apoiar:
- análises gerenciais por meio de **BI**;
- geração de indicadores educacionais;
- identificação de padrões no comportamento escolar;
- aplicação de modelos de **Machine Learning** para prever a probabilidade de um aluno **evadir a escola**.

## Problema que o projeto busca resolver

Muitas escolas públicas ainda possuem dificuldade em centralizar e analisar informações importantes sobre seus alunos, turmas, desempenho acadêmico, frequência, responsáveis, funcionários e recursos administrativos.

Sem uma base de dados bem estruturada, torna-se difícil:
- acompanhar o desempenho escolar de forma eficiente;
- identificar sinais de risco de evasão;
- gerar relatórios e indicadores confiáveis;
- apoiar a tomada de decisão por parte da gestão escolar.

Diante disso, o projeto SisGESC propõe a modelagem de um banco de dados relacional capaz de sustentar tanto as operações escolares quanto análises futuras mais avançadas.

## Objetivo geral

Desenvolver a estrutura inicial de um sistema de gestão escolar para uma escola pública de ensino fundamental, com foco na modelagem de banco de dados transacional preparada para futuras aplicações em BI e IA.

## Objetivos específicos

- Modelar o banco de dados da escola de forma organizada e consistente;
- Estruturar tabelas e relacionamentos que representem alunos, responsáveis, turmas, disciplinas, matrículas, notas, frequência, funcionários e área financeira;
- Criar uma base de dados que permita consultas operacionais e analíticas;
- Preparar a estrutura para uso futuro em dashboards, relatórios e mineração de dados;
- Possibilitar, futuramente, o treinamento de modelos de IA/ML para prever chances de evasão escolar.

## Escopo desta etapa

Nesta etapa do projeto, estão sendo desenvolvidos os seguintes artefatos:

- **Repositório Git** com histórico de desenvolvimento;
- **Documento de requisitos** com a contextualização e definição do problema;
- **Dicionário de dados parcial** com campos, tipos e restrições;
- **Diagrama ER transacional** representando o modelo lógico;
- **Script SQL parcial** com os comandos iniciais de criação da base.

## Estrutura do repositório

```text
sisgesc/
├── docs/
│   ├── contextualizacao_do_trabalho
│   ├── documento_de_requisitos
│   └── dicionario_de_dados
│
├── modelagem/
│   ├── diagrama_er
│   ├── modelo_logico
│   └── arquivo_dbml
│
├── sql/
│   └── script_ddl_inicial
│
└── README.md
