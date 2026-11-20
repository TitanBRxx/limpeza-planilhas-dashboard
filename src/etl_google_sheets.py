"""ETL inicial de inventário: Google Sheets -> Pandas -> Google Sheets.

Este arquivo documenta o fluxo testado no Google Colab com a fonte piloto
de lentes. Antes de executar, configure os nomes da planilha/aba de origem
e o ID da pasta de destino. Não versionar credenciais nem dados reais.
"""

from datetime import datetime
from zoneinfo import ZoneInfo
import re

import gspread
import pandas as pd
from google.colab import auth
from google.auth import default


# ---------------------------------------------------------------------
# CONFIGURAÇÃO — preencher no ambiente de execução, não com dados
# confidenciais no repositório público.
# ---------------------------------------------------------------------
PLANILHA_ORIGEM = "NOME_DA_PLANILHA"
ABA_ORIGEM = "NOME_DA_ABA"
PASTA_DESTINO_ID = "ID_DA_PASTA_DO_DRIVE"

COLUNAS = ["Marca", "Proprietário", "Kit", "Lente", "Valor"]

# Regra específica da fonte piloto de lentes. Validar antes de reutilizar
# esta lista em outras categorias.
KITS_REMOVER = [
    "adaptador de bocal",
    "bocal de câmera",
    "bocal de lente",
    "step-up",
    "step-down",
]


def limpar_texto(valor):
    """Remove espaços excedentes sem transformar ausência em texto."""
    if pd.isna(valor):
        return pd.NA
    texto = re.sub(r"\s+", " ", str(valor)).strip()
    return texto if texto else pd.NA


def converter_valor_brl(valor):
    """Converte valores no padrão brasileiro para número decimal.

    Exemplos aceitos: 'R$ 1.234,56', '1234,56' e valores numéricos.
    Valores vazios ou não interpretáveis retornam pd.NA, não zero.
    """
    if pd.isna(valor):
        return pd.NA

    if isinstance(valor, (int, float)) and not isinstance(valor, bool):
        return float(valor)

    texto = str(valor).strip()
    if not texto:
        return pd.NA

    texto = texto.replace("R$", "").replace(" ", "")
    if "," in texto:
        texto = texto.replace(".", "").replace(",", ".")

    try:
        return float(texto)
    except ValueError:
        return pd.NA


def transformar_dados(df):
    """Seleciona e transforma os campos da fonte piloto de lentes."""
    ausentes = [col for col in COLUNAS if col not in df.columns]
    if ausentes:
        raise ValueError(f"Colunas obrigatórias ausentes na origem: {ausentes}")

    tratado = df.loc[:, COLUNAS].copy()

    for coluna in ["Marca", "Proprietário", "Kit", "Lente"]:
        tratado[coluna] = tratado[coluna].map(limpar_texto)

    tratado["Kit"] = tratado["Kit"].str.lower()
    tratado["Lente"] = tratado["Lente"].str.lower()
    tratado["Marca"] = tratado["Marca"].str.title()
    tratado["Proprietário"] = tratado["Proprietário"].str.title()

    tratado = tratado[
        ~tratado["Kit"].isin(KITS_REMOVER)
    ].copy()

    tratado["Valor"] = tratado["Valor"].map(converter_valor_brl)
    tratado["Valor"] = pd.to_numeric(tratado["Valor"], errors="coerce")

    tratado.reset_index(drop=True, inplace=True)
    return tratado


def exportar_para_drive(df, gc, folder_id):
    """Cria uma planilha no Meu Drive e envia os dados tratados."""
    data_hora = datetime.now(ZoneInfo("America/Sao_Paulo")).strftime(
        "%d-%m-%Y_%H-%M-%S"
    )
    nome = f"Lentes_Tratadas_{data_hora}"

    planilha_saida = gc.create(nome, folder_id=folder_id)
    aba_saida = planilha_saida.sheet1

    # Nesta fonte, Valor é o único campo numérico da seleção.
    # Mantém campos textuais ausentes vazios e preenche Valor ausente
    # com zero somente se essa regra for aprovada para o uso analítico.
    dados_saida = df.copy()
    dados_saida["Valor"] = dados_saida["Valor"].fillna(0.0)

    valores = [dados_saida.columns.tolist()] + dados_saida.astype(object).where(
        pd.notna(dados_saida), ""
    ).values.tolist()

    aba_saida.update(valores, value_input_option="USER_ENTERED")
    return planilha_saida.url


def executar():
    """Autentica no Colab, lê a fonte, transforma e exporta."""
    auth.authenticate_user()
    credenciais, _ = default()
    gc = gspread.authorize(credenciais)

    origem = gc.open(PLANILHA_ORIGEM)
    aba_origem = origem.worksheet(ABA_ORIGEM)
    df_origem = pd.DataFrame(aba_origem.get_all_records())

    df_tratado = transformar_dados(df_origem)
    url_saida = exportar_para_drive(df_tratado, gc, PASTA_DESTINO_ID)

    print(f"Registros de entrada: {len(df_origem)}")
    print(f"Registros de saída: {len(df_tratado)}")
    print(f"Planilha criada: {url_saida}")


if __name__ == "__main__":
    executar()
