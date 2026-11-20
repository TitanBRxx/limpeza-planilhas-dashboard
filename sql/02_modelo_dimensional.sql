-- Modelo dimensional analítico — RASCUNHO CONCEITUAL
-- SGBD de referência: MySQL 8+
-- Grão proposto: uma linha por equipamento em cada fotografia (snapshot)
-- do inventário. Validar o grão e a periodicidade antes de implementar.
--
-- Este modelo é uma proposta para análises históricas de inventário.
-- Não representa dados transacionais de reservas/locações.

CREATE TABLE dim_data (
    data_key INT PRIMARY KEY, -- formato YYYYMMDD
    data_calendario DATE NOT NULL,
    ano SMALLINT NOT NULL,
    mes TINYINT NOT NULL,
    dia TINYINT NOT NULL
);

CREATE TABLE dim_categoria (
    categoria_key BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    categoria_origem_id BIGINT UNSIGNED NULL,
    categoria_nome VARCHAR(100) NOT NULL
);

CREATE TABLE dim_equipamento (
    equipamento_key BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    equipamento_origem_id BIGINT UNSIGNED NULL,
    descricao VARCHAR(255) NOT NULL,
    marca VARCHAR(100) NULL,
    modelo VARCHAR(150) NULL,
    numero_serie_hash VARCHAR(128) NULL
);

CREATE TABLE dim_proprietario (
    proprietario_key BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    proprietario_origem_id BIGINT UNSIGNED NULL,
    proprietario_nome VARCHAR(150) NOT NULL
);

CREATE TABLE dim_status (
    status_key BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    status_nome VARCHAR(50) NOT NULL
);

CREATE TABLE fato_inventario (
    data_key INT NOT NULL,
    equipamento_key BIGINT UNSIGNED NOT NULL,
    categoria_key BIGINT UNSIGNED NOT NULL,
    proprietario_key BIGINT UNSIGNED NULL,
    status_key BIGINT UNSIGNED NULL,
    quantidade INT NOT NULL DEFAULT 1,
    valor_registrado DECIMAL(14, 2) NULL,
    CONSTRAINT pk_fato_inventario PRIMARY KEY (
        data_key, equipamento_key
    ),
    CONSTRAINT fk_fato_data
        FOREIGN KEY (data_key) REFERENCES dim_data(data_key),
    CONSTRAINT fk_fato_equipamento
        FOREIGN KEY (equipamento_key) REFERENCES dim_equipamento(equipamento_key),
    CONSTRAINT fk_fato_categoria
        FOREIGN KEY (categoria_key) REFERENCES dim_categoria(categoria_key),
    CONSTRAINT fk_fato_proprietario
        FOREIGN KEY (proprietario_key) REFERENCES dim_proprietario(proprietario_key),
    CONSTRAINT fk_fato_status
        FOREIGN KEY (status_key) REFERENCES dim_status(status_key)
);

-- PENDÊNCIAS:
-- - Confirmar se o inventário será fotografado periodicamente e em qual
--   frequência; sem histórico de snapshots, não há série temporal.
-- - Definir se valor_registrado representa valor de aquisição, reposição,
--   avaliação ou outro conceito.
-- - Definir tratamento de alterações de atributos (SCD) nas dimensões.
-- - Validar o uso de identificadores pseudonimizados; não armazenar números
--   de série reais neste repositório público.
-- - Acrescentar dimensões/medidas somente quando houver necessidade analítica
--   e fonte confiável.
