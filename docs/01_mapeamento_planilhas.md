# 01 — Mapeamento das planilhas

## Objetivo

Registrar a visão geral das fontes de inventário que alimentam o processo de preparação de dados. Este documento é um levantamento inicial: nomes de arquivos, abas, responsáveis e regras específicas devem ser confirmados diretamente com os responsáveis pelos dados.

## Visão geral conhecida

- A operação utiliza aproximadamente **20 planilhas Google Sheets**.
- Cada arquivo pode conter cerca de duas tabelas, mas essa distribuição ainda precisa ser conferida.
- O conteúdo é principalmente relacionado ao **inventário de equipamentos audiovisuais**.
- Entre as categorias já identificadas estão lentes, baterias, monitores, comandos de foco e matteboxes.
- A estrutura e o nível de padronização variam entre as fontes.
- O projeto trata dados de inventário. Dados transacionais de reservas e locações não fazem parte do escopo atual.

## Problemas de estrutura e qualidade observados

| Problema | Exemplo/observação | Tratamento possível |
|---|---|---|
| Cabeçalhos e blocos repetidos | Algumas tabelas antigas organizavam os itens visualmente em blocos por kit | Converter para uma tabela única, com uma linha de cabeçalho |
| Informações misturadas | A descrição de um item pode conter marca ou outra informação que já possui coluna própria | Separar os atributos em suas colunas, após validação |
| Variação de maiúsculas e minúsculas | Ex.: `ARRI`, `Arri` | Aplicar regra de padronização adequada a cada coluna |
| Espaços extras | Espaços repetidos ou nas extremidades | Remover espaços excedentes |
| Valores monetários como texto | Valores com `R$`, ponto de milhar e vírgula decimal | Converter para tipo numérico após validar o padrão |
| Registros fora do escopo | Adaptadores e acessórios específicos podem não integrar a tabela analítica de lentes | Aplicar filtros documentados e aprovados para cada fonte |

## Inventário de fontes — preencher durante o levantamento

Não foram publicados nomes internos de arquivos, links, IDs ou dados da empresa. Complete esta tabela localmente, sem incluir informações confidenciais no repositório público.

| Identificador | Categoria | Arquivo/aba (referência interna) | Quantidade de tabelas | Situação da estrutura | Observações |
|---|---|---|---:|---|---|
| FONTE-01 | Lentes | A preencher | A confirmar | Há uma aba normalizada usada no teste do ETL | Fonte piloto |
| FONTE-02 | Comando de foco | A preencher | A confirmar | A mapear | — |
| FONTE-03 | Mattebox | A preencher | A confirmar | A mapear | — |
| FONTE-04 | Baterias | A preencher | A confirmar | A mapear | — |
| FONTE-05 | Monitores | A preencher | A confirmar | A mapear | — |
| FONTE-06 a FONTE-20 | Outras categorias/fontes | A preencher | A confirmar | A mapear | Não presumir uma fonte por categoria |

## Critérios para concluir o mapeamento

1. Registrar cada arquivo e cada aba que contenha uma tabela de inventário.
2. Identificar a finalidade e a unidade de registro de cada tabela.
3. Conferir se existe uma linha única de cabeçalho e se cada coluna representa um atributo.
4. Identificar campos obrigatórios, valores ausentes, duplicidades e padrões divergentes.
5. Registrar regras de inclusão e exclusão com validação do responsável pelos dados.
6. Manter nomes de arquivos, IDs, números de série, valores comerciais e demais informações internas fora deste repositório público.

## Status

**Levantamento parcial.** A planilha de lentes é a fonte piloto já utilizada no desenvolvimento do script. O mapeamento completo das aproximadamente 20 fontes ainda precisa ser realizado.
