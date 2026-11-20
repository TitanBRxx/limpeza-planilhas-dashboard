# Limpeza e Padronização de Planilhas com Python

Projeto de preparação de dados de inventário de equipamentos audiovisuais, utilizando Python, Pandas e Google Sheets, com disponibilização dos dados tratados para análise no Looker Studio.

O projeto surgiu de uma necessidade real de melhorar a estrutura e a consistência de planilhas de inventário. O repositório é público e, por isso, contém apenas documentação e exemplos fictícios: não publique dados internos, números de série, IDs de planilhas, credenciais ou valores comerciais sem autorização.

## Objetivo

- Automatizar etapas repetitivas de preparação de dados.
- Padronizar textos e valores.
- Aplicar filtros específicos e documentados.
- Exportar os dados tratados para uma nova planilha no Google Drive.
- Preparar uma fonte mais consistente para dashboards no Looker Studio.
- Documentar a evolução do mapeamento e da modelagem dos dados.

## Fluxo atual

1. Autenticar no Google Colab com a conta que possui acesso às planilhas.
2. Ler uma aba do Google Sheets com `gspread`.
3. Converter os registros em um DataFrame do Pandas.
4. Selecionar as colunas relevantes.
5. Limpar espaços, padronizar textos e aplicar filtros específicos.
6. Converter a coluna de valor monetário para tipo numérico.
7. Criar uma nova planilha diretamente na pasta de destino do Meu Drive e enviar os dados tratados.
8. Conectar a planilha tratada ao Looker Studio.

O fluxo foi testado com a fonte piloto de lentes. O script em `src/etl_google_sheets.py` organiza esse processo em funções reutilizáveis; os nomes da planilha, aba e pasta devem ser configurados no ambiente de execução.

## Estrutura do repositório

```text
docs/
  01_mapeamento_planilhas.md
  02_dicionario_dados.md
src/
  etl_google_sheets.py
sql/
  01_modelo_relacional.sql
  02_modelo_dimensional.sql
data/
  exemplo_ficticio.csv
requirements.txt
.gitignore
README.md
```

## Tecnologias

- Python
- Pandas
- gspread
- Google Colab
- Google Sheets
- Looker Studio
- MySQL (rascunhos de modelagem SQL)

## Como executar

O script atual foi preparado para o Google Colab, pois utiliza a autenticação do próprio Colab.

1. Abra `src/etl_google_sheets.py` em um notebook Colab ou copie seu conteúdo para células do notebook.
2. Configure `PLANILHA_ORIGEM`, `ABA_ORIGEM` e `PASTA_DESTINO_ID` no ambiente autorizado.
3. Instale as dependências de `requirements.txt`, se ainda não estiverem disponíveis.
4. Execute o script com uma conta que tenha acesso à origem e permissão para criar arquivos na pasta de destino.
5. Confira os totais de entrada e saída e valide a planilha criada antes de atualizar o dashboard.

**Importante:** não coloque credenciais, IDs internos ou dados reais no GitHub. O arquivo de exemplo em `data/` contém valores inteiramente fictícios.

## Estrutura e documentação dos dados

- [Mapeamento das planilhas](docs/01_mapeamento_planilhas.md): visão geral inicial das fontes e problemas estruturais.
- [Dicionário de dados](docs/02_dicionario_dados.md): campos conhecidos, regras de qualidade e hipóteses de modelagem.

Os modelos SQL são rascunhos conceituais, não esquemas aprovados para produção:

- [Modelo relacional](sql/01_modelo_relacional.sql)
- [Modelo dimensional](sql/02_modelo_dimensional.sql)

## Status

**Em desenvolvimento — ETL piloto funcional.**

| Componente | Situação |
|---|---|
| Leitura de Google Sheets | Testada na fonte piloto de lentes |
| Seleção e limpeza de colunas | Implementada e testada na fonte piloto |
| Padronização de textos | Implementada na fonte piloto |
| Filtro de kits | Implementado para a fonte piloto; regra não generalizada |
| Conversão de valor monetário | Implementada e testada na fonte piloto |
| Exportação para nova planilha no Drive | Testada; criação em pasta específica via gspread |
| Dashboard no Looker Studio | Já existe, alimentado pela planilha tratada |
| Mapeamento de todas as fontes | Pendente |
| Dicionário completo | Parcial |
| Modelos SQL | Rascunhos para validação |
| Testes automatizados e validações de qualidade | Pendentes |

## Próximos passos

1. Validar o script em outras categorias sem reutilizar filtros de lentes indevidamente.
2. Criar verificações de colunas obrigatórias, tipos, ausências, duplicidades e contagem de registros.
3. Completar o mapeamento das fontes e o dicionário de dados.
4. Definir e validar o modelo relacional com as regras reais da operação.
5. Confirmar o grão e a periodicidade do modelo dimensional.
6. Documentar exemplos de entrada e saída exclusivamente fictícios.

## Confidencialidade

Este projeto utiliza uma necessidade profissional real como contexto, mas o repositório não deve conter informações que identifiquem patrimônio, clientes, fornecedores, colaboradores ou processos internos sensíveis. Use dados fictícios ou expressamente autorizados.
