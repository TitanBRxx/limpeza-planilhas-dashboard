-- Modelo relacional operacional — RASCUNHO CONCEITUAL
-- SGBD de referência: MySQL 8+
-- Não executar em produção antes de validar entidades, atributos,
-- cardinalidades, regras de negócio e requisitos de identificação.
--
-- O inventário conhecido ainda não fornece todos os campos necessários
-- para um modelo físico definitivo. Os campos abaixo são uma proposta
-- mínima e genérica para discussão.

CREATE TABLE categoria (
    categoria_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE proprietario (
    proprietario_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(150) NOT NULL UNIQUE
);

CREATE TABLE equipamento (
    equipamento_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    categoria_id BIGINT UNSIGNED NOT NULL,
    proprietario_id BIGINT UNSIGNED NULL,
    descricao VARCHAR(255) NOT NULL,
    marca VARCHAR(100) NULL,
    modelo VARCHAR(150) NULL,
    numero_serie VARCHAR(150) NULL,
    valor DECIMAL(14, 2) NULL,
    status VARCHAR(50) NULL,
    CONSTRAINT fk_equipamento_categoria
        FOREIGN KEY (categoria_id) REFERENCES categoria(categoria_id),
    CONSTRAINT fk_equipamento_proprietario
        FOREIGN KEY (proprietario_id) REFERENCES proprietario(proprietario_id)
);

-- Extensão de equipamento: atributos específicos de lentes.
CREATE TABLE lente (
    equipamento_id BIGINT UNSIGNED PRIMARY KEY,
    diametro_frontal_mm DECIMAL(8, 2) NULL,
    CONSTRAINT fk_lente_equipamento
        FOREIGN KEY (equipamento_id) REFERENCES equipamento(equipamento_id)
);

-- Extensão de equipamento: atributos específicos de câmeras.
-- Atributos técnicos adicionais devem ser definidos após o mapeamento.
CREATE TABLE camera (
    equipamento_id BIGINT UNSIGNED PRIMARY KEY,
    CONSTRAINT fk_camera_equipamento
        FOREIGN KEY (equipamento_id) REFERENCES equipamento(equipamento_id)
);

-- PENDÊNCIAS DE MODELAGEM:
-- 1. Confirmar se um equipamento pertence a exatamente um kit ou se kits
--    podem conter vários equipamentos e um equipamento pode mudar de kit.
-- 2. Definir tabela de kit e tabela associativa caso a relação seja N:N
--    ou possua histórico.
-- 3. Definir política de unicidade e proteção para número de série.
-- 4. Confirmar domínios de status, categorias e proprietários.
-- 5. Validar unidades e regra de compatibilidade lente x mattebox.
