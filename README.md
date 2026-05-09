
# SisGESC — Sistema de Gestão Escolar

> Banco de dados relacional para gestão de escola pública de ensino fundamental, com visão analítica para **BI** e **Inteligência Artificial**.

</div>

## Sobre o Projeto

O **SisGESC** é um projeto acadêmico desenvolvido na disciplina de **Banco de Dados**, por um grupo de 10 alunos. O objetivo é projetar e implementar um **Sistema de Gestão Escolar** completo para uma escola pública de bairro do ensino fundamental.

O sistema centraliza informações **escolares, acadêmicas, administrativas e financeiras** em um banco de dados relacional estruturado, com base preparada para análises avançadas via **BI** e **IA/ML**.

### O que o sistema gerencia?

| Domínio | Dados Cobertos |
|---|---|
|  **Acadêmico** | Alunos, turmas, disciplinas, matrículas, notas |
|  **Frequência** | Presença, faltas, histórico por aluno e turma |
|  **Responsáveis** | Vínculos familiares, contatos, comunicação |
|  **Administrativo** | Funcionários, cargos, lotação |
|  **Financeiro** | Taxas, pagamentos, inadimplência |

---

## Problema Resolvido

Muitas escolas públicas ainda enfrentam dificuldades para centralizar e analisar informações críticas. Sem uma base bem estruturada, torna-se difícil:

- Acompanhar o desempenho escolar com eficiência
- Identificar alunos em risco de evasão precocemente
- Gerar relatórios e indicadores confiáveis
- Apoiar a tomada de decisão da gestão escolar

O **SisGESC** resolve isso propondo um banco de dados relacional capaz de sustentar tanto as **operações do dia a dia** quanto **análises educacionais avançadas** no futuro.

---

## Modelagem do Banco

O diagrama abaixo representa o modelo lógico (ER) do sistema:

[![Modelagem do Banco Acadêmico](./modelagem/Banco%20academico.png)](https://dbdiagram.io/d/Banco-academico-69e236f7a5db712fe57b3376)

> 🔗 Acesse o diagrama interativo completo em: [dbdiagram.io — SisGESC](https://dbdiagram.io/d/Banco-academico-69e236f7a5db712fe57b3376)

---

## Estrutura do Repositório

```
banco-de-dados-academico/
│
├── 📂 docs/              # Documentação do projeto
│   └── 01_documentação_base.pdf  # Documentação completa com dicionarios e informações do banco de dados
│
├── 📂 modelagem/         # Diagrama ER e arquivos de modelagem
│   └── Banco academico.png
│
├── 📂 sql/                 # Scripts SQL do projeto
│   ├── 00_run_all.sql               # Script principal (executa tudo)
│   ├── 01_select_count_tables/      # Executa um Count(*) em todas as tabelas do banco
│   ├── 02_create_olap/              # Estrutura analítica (OLAP)
│   ├── 03_selects_and_subselects/   # selects e subselects testes
│   └── 99_reset_script/             # reseta todos os dados do banco
└── README.md
```

---

## Como Executar

### Pré-requisitos

- **MySQL* 

### Passo a passo

**1. Clone o repositório**

```bash
git clone https://github.com/Rmonn25/banco-de-dados-academico.git
cd banco-de-dados-academico
```

**2. Acesse a pasta SQL**

```
sql/
```

**3. Execute os scripts na ordem correta**

```
1️  00_run_all.sql       → Execução inicial e estruturas das tabelas e as cargas inicias
2  Scripts OLAP         → Camada analítica
```

> **Importante:** Execute sempre respeitando a ordem numérica dos arquivos para garantir a integridade referencial entre as tabelas.

---

## Estrutura OLAP

A camada OLAP foi projetada para suportar análises gerenciais e indicadores educacionais, servindo de base para dashboards e BI. Os principais eixos de análise são:

- Desempenho dos alunos por turma e disciplina
- Frequência e assiduidade escolar
- Monitoramento de risco de evasão
- Indicadores educacionais gerais
- Análise histórica por período letivo

---

## Visão Futura

O projeto foi modelado pensando em escalabilidade. Entre as possibilidades futuras:


- Dashboards e relatórios gerenciais (BI)
- Modelos de Machine Learning para prever evasão escolar
- API para consumo dos dados por aplicações externas
- Interface web/mobile integrada ao banco
- Sistema de alertas para gestores (frequência crítica, notas baixas)


---

## Integrantes

Projeto desenvolvido por 10 alunos na disciplina de **Banco de Dados**:

| | Nome | GitHub |
|---|---|---|
| 1 | Ramon Oliveira | [@Rmonn25](https://github.com/Rmonn25) |
| 2 | Gustavo Vaz | [@Gustavo-Vaz-Gasparoto](https://github.com/Gustavo-Vaz-Gasparoto) |
| 3 | Igor Sant'ana | [@IgorMedeiros-cpu](https://github.com/IgorMedeiros-cpu) |
| 4 | Douglas Leal | [@douglaslealgzs](https://github.com/douglaslealgzs) |
| 5 | Gabriel Luiz | [@GabrielBorges1234](https://github.com/GabrielBorges1234) |
| 6 | Vitor Santana | [@vitorsfz](https://github.com/vitorsfz) |
| 7 | Luigi Borges | [@Luigi-Loc](https://github.com/Luigi-Loc) |
| 8 | Miguel Alves | [@Miguel-Lima26](https://github.com/Miguel-Lima26) |
| 9 | Edson Murilo | [@Muriloss21](https://github.com/Muriloss21) |
| 10 | Daniel Perederko | [@perederko90000](https://github.com/perederko90000) |

---

<div align="center">

Projeto acadêmico — Disciplina de Banco de Dados · 2025

</div>
