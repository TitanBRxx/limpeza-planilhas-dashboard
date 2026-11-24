# 02 — Dicionário de dados

## Objetivo

Definir o contrato de estrutura, tipagem SQL e regras de higienização (ETL) aplicadas às planilhas brutas antes da carga no banco de dados relacional.

> **Nota de confidencialidade:** Todos os exemplos e valores abaixo são 100% fictícios e ilustrativos. Nenhum dado comercial real, número de série ou nome interno da operação foi utilizado.

## 1. Estrutura de Campos e Tipagem SQL (Piloto: Lentes)

A modelagem separa atributos comuns a todo o inventário (tabela mãe `equipamento`) e atributos técnicos exclusivos (tabela filha `lente`).

### Identificação (Tabela `equipamento`)
| Coluna (SQL) | Tipo SQL | Regra | O que extrair da planilha | Exemplo fictício |
| :--- | :--- | :---: | :--- | :--- |
| `id_equipamento` | `VARCHAR(20)` | `PK / NOT NULL` | Código único gerado no pipeline (garante chave para itens sem série) | `LNT-001` |
| `numero_serie` | `VARCHAR(50)` | `NULL` | Identificação física do item (opcional, pois nem todo item possui) | `SN-0001` |
| `marca` | `VARCHAR(50)` | `NOT NULL` | Fabricante padronizado | `ARRI` |
| `kit` | `VARCHAR(100)` | `NULL` | Nome do jogo/conjunto ao qual pertence (`NULL` se for avulsa) | `Signature Prime` |
| `modelo` | `VARCHAR(100)` | `NOT NULL` | Nome específico da lente (coluna *Lente*) | `18mm Distagon T1.3` |

### Ficha Técnica (Tabela `lente`)
| Coluna (SQL) | Tipo SQL | Regra | O que extrair da planilha | Exemplo fictício |
| :--- | :--- | :---: | :--- | :--- |
| `foco_minimo_mm` | `INT` | `NULL` | Distância mínima de foco (apenas número em mm) | `350` |
| `diametro_frontal_mm` | `INT` | `NOT NULL` | Medida frontal em mm (chave de encaixe com mattebox) | `95` |

### Patrimônio (Tabela `equipamento`)
| Coluna (SQL) | Tipo SQL | Regra | O que extrair da planilha | Exemplo fictício |
| :--- | :--- | :---: | :--- | :--- |
| `valor_reposicao` | `DECIMAL(10,2)` | `NOT NULL` | Valor unitário de inventário limpo | `50000.00` |
| `proprietario` | `VARCHAR(100)` | `NOT NULL` | Dono do ativo (casa ou parceiro consignado) | `Parceiro A` |

## 2. Regras de Negócio e Higienização (ETL)

1. **Filtro de escopo:** Remover linhas de *step-up rings*, adaptadores de mount, tampas e suportes misturados na aba de lentes.
2. **Geração de ID:** Criar `id_equipamento` sequencial no pipeline Python para permitir carga segura de itens sem `numero_serie`.
3. **Limpeza textual:** Aplicar `strip()` para remover espaços nas extremidades, eliminar espaços duplos e padronizar o nome das marcas.
4. **Conversão de medidas:** Extrair apenas os dígitos de `foco_minimo_mm` e `diametro_frontal_mm`, convertendo para inteiro (`INT`).
5. **Conversão monetária:** Remover `"R$"`, pontos de milhar e substituir vírgula por ponto antes de converter para `DECIMAL(10,2)`.
6. **Tratamento de nulos (`NaN`):** Campos opcionais vazios assumem `None`/`NULL` no banco (e `""` ou `"Não informado"` caso haja exportação auxiliar via `gspread`).
7. **Regra de compatibilidade (Lente × Mattebox):** Lentes com `diametro_frontal_mm` igual ao encaixe traseiro (`back`) do mattebox possuem encaixe direto; diâmetros menores exigem anel redutor.

## 3. Exemplo De / Para (dados fictícios)

| Campo | Entrada bruta (Planilha) | Saída tratada (Python → SQL) |
| :--- | :--- | :--- |
| `id_equipamento` | *(Gerado no pipeline)* | `LNT-001` |
| `numero_serie` | *(célula vazia)* | `NULL` |
| `marca` | `"  arri "` | `"ARRI"` |
| `kit` | `"Signature Prime  "` | `"Signature Prime"` |
| `modelo` | `"18mm Distagon  T1.3"` | `"18mm Distagon T1.3"` |
| `foco_minimo_mm` | `"350 mm"` | `350` |
| `diametro_frontal_mm` | `"95mm"` | `95` |
| `valor_reposicao` | `"R$ 50.000,00"` | `50000.00` |
| `proprietario` | `"Parceiro A"` | `"Parceiro A"` |
| *(Item fora de escopo)* | `"Anel Step-Up 82-95mm"` | *(Descartado no filtro de lentes)* |

## Status

*Concluído para o piloto de Lentes.* Estrutura pronta para orientar o script ETL (`src/`) e a criação das tabelas relacionais (`sql/`), com expansão prevista para as demais categorias mapeadas.
