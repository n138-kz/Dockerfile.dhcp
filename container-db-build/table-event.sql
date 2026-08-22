-- FUNCTION
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';
-- TABLE
DROP VIEW IF EXISTS discord_webhook_view;
DROP TABLE IF EXISTS discord_webhook;
CREATE TABLE IF NOT EXISTS discord_webhook (
    id SERIAL PRIMARY KEY,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);
-- TRIGGER
CREATE OR REPLACE TRIGGER update_discord_webhook_updated_at
    BEFORE UPDATE ON discord_webhook
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();
-- VIEW
CREATE OR REPLACE VIEW discord_webhook_view AS
    SELECT
        id,
        created_at,
        updated_at
    FROM
        discord_webhook
