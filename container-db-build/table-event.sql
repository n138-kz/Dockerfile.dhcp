-- FUNCTION
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';
-- TABLE/TRIGGER
CREATE TABLE discord_webhook_messages (
    id                BIGINT PRIMARY KEY, -- Snowflake ID (18-19桁の数値文字列)
    type              INTEGER NOT NULL,
    content           TEXT NOT NULL,
    channel_id        BIGINT NOT NULL,
    webhook_id        BIGINT NOT NULL,
    
    -- 日時型（ISO 8601 UTC文字列は TIMESTAMP WITH TIME ZONE にマッピング）
    timestamp         TIMESTAMP WITH TIME ZONE NOT NULL,
    edited_timestamp  TIMESTAMP WITH TIME ZONE NULL,
    
    -- フラグ・ブーリアン
    flags             INTEGER NOT NULL DEFAULT 0,
    pinned            BOOLEAN NOT NULL DEFAULT FALSE,
    mention_everyone  BOOLEAN NOT NULL DEFAULT FALSE,
    tts               BOOLEAN NOT NULL DEFAULT FALSE,
    
    -- Author (ネストオブジェクト)
    author_id            BIGINT NOT NULL,
    author_username      VARCHAR(255) NOT NULL,
    author_discriminator VARCHAR(4) NOT NULL,
    author_avatar        VARCHAR(255) NULL,
    author_bot           BOOLEAN NOT NULL DEFAULT TRUE,
    
    -- 構造が変わる可能性がある配列や拡張オブジェクトは JSONB に格納
    mentions          JSONB NOT NULL DEFAULT '[]'::jsonb,
    mention_roles     JSONB NOT NULL DEFAULT '[]'::jsonb,
    attachments       JSONB NOT NULL DEFAULT '[]'::jsonb,
    embeds            JSONB NOT NULL DEFAULT '[]'::jsonb,
    components        JSONB NOT NULL DEFAULT '[]'::jsonb,
    
    -- 作成日時（DB管理用）
    created_at        TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at        TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);
CREATE OR REPLACE TRIGGER update_discord_webhook_messages_updated_at
    BEFORE UPDATE ON discord_webhook_messages
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();
