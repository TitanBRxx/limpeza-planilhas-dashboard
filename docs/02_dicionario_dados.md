# 02 — Dicionário de dados

## Objetivo

Documentar os campos utilizados na preparação dos dados e estabelecer regras de interpretação. O dicionário abaixo começa pela fonte piloto de lentes; os campos das demais categorias devem ser acrescentados somente após inspeção das respectivas planilhas.

## Campos da fonte piloto — lentes

| Campo | Significado conhecido | Tipo esperado na saída | Regra inicial | Observações |
|---|---|---|---|---|
| `Marca` | Marca do equipamento | Texto | Remover espaços excedentes e padronizar capitalização | Confirmar exceções de grafia e marcas com siglas |
| `Proprietário` | Proprietário associado ao item | Texto | Remover espaços excedentes e padronizar capitalização | Confirmar domínio de valores |
| `Kit` | Identificação ou descrição do kit | Texto | Remover espaços excedentes e converter para minúsculas | Filtros de exclusão são específicos da fonte piloto |
| `Lente` | Descrição/modelo da lente | Texto | Remover espaços excedentes e converter para minúsculas | A descrição deve conter somente informação própria do campo |
| `Valor` | Valor registrado para o item | Numérico decimal | Converter representação monetária brasileira para número | Definir política para valores ausentes e inválidos |

## Outros atributos identificados no levantamento

Os campos abaixo apareceram no contexto das planilhas de inventário, mas ainda precisam ser confirmados quanto ao nome exato, significado, domínio e presença em cada fonte.

| Atributo | Aplicação conhecida | Validação pendente |
|---|---|---|
| Número de série | Identificação individual de equipamentos | Formato, unicidade e política de confidencialidade |
| Diâmetro frontal | Característica de lentes, relevante para compatibilidade com acessórios | Unidade, tipo numérico e valores válidos |
| Kit | Agrupamento de itens | Se representa um agrupamento físico, comercial ou ambos |
| Proprietário | Identificação da propriedade do item | Domínio de valores e relacionamento com cadastro próprio |
| Marca | Fabricante/marca do item | Cadastro padronizado e tratamento de siglas |
| Valor | Informação monetária do inventário | Moeda, data de referência e significado do valor |

## Regras de qualidade propostas

1. **Texto:** remover espaços no início/fim e reduzir sequências de espaços internos.
2. **Capitalização:** aplicar regra por coluna, sem assumir que `title()` é adequada a siglas, marcas ou códigos.
3. **Valores monetários:** interpretar o padrão brasileiro (por exemplo, `1.234,56`) e converter para número decimal.
4. **Valores ausentes:** não substituir automaticamente todos os campos ausentes por zero. Zero deve representar um valor real; ausência deve continuar identificável, salvo regra de negócio aprovada.
5. **Identificadores:** números de série e códigos devem ser tratados como texto, preservando zeros à esquerda.
6. **Filtros:** manter listas de exclusão específicas por fonte e documentar sua justificativa.

## Exemplo de regra de compatibilidade: lente × mattebox

O diâmetro frontal da lente pode ser utilizado para apoiar a identificação de matteboxes compatíveis. Para transformar essa ideia em regra de dados, ainda é necessário validar:

- a unidade e o significado do diâmetro informado na lente;
- qual dimensão da mattebox representa a interface compatível;
- se existem anéis/adaptadores que alteram a compatibilidade;
- como representar múltiplas opções compatíveis e exceções.

**Não implementar uma associação automática apenas comparando números antes de validar essas regras com a equipe técnica.**

## Entidades conceituais candidatas

Estas entidades são hipóteses de modelagem, não um modelo aprovado:

- **Equipamento:** cadastro comum de itens inventariados.
- **Lente:** atributos específicos de lentes, como diâmetro frontal.
- **Câmera:** atributos específicos de câmeras.
- **Categoria:** classificação do tipo de equipamento.
- **Proprietário:** cadastro de proprietários, se houver necessidade de normalização.
- **Kit:** agrupamento de equipamentos, caso a regra operacional confirme essa relação.

A cardinalidade entre equipamento, kit, proprietário e categoria deve ser validada antes da implementação física.

## Confidencialidade

Este repositório é público. Não inserir números de série reais, nomes de clientes, IDs/URLs de planilhas internas, valores comerciais reais, credenciais ou outros dados confidenciais. Utilize apenas dados fictícios ou expressamente autorizados.
