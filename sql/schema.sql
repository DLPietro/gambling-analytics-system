-- BONUS ABUSE DETECTION SCHEMA

-- 1. Players table
CREATE TABLE IF NOT EXISTS players (
    player_id BIGINT PRIMARY KEY,
    registration_date DATE,
    country VARCHAR(10),
    email VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. Bonuses table
CREATE TABLE IF NOT EXISTS bonuses (
    bonus_id BIGSERIAL PRIMARY KEY,
    player_id BIGINT REFERENCES players(player_id),
    bonus_type VARCHAR(50),
    bonus_amount DECIMAL(10, 2),
    bonus_date DATE,
    wagering_requirement INT,
    status VARCHAR(20),
    is_abuse BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 3. Transactions table
CREATE TABLE IF NOT EXISTS transactions (
    transaction_id BIGSERIAL PRIMARY KEY,
    player_id BIGINT REFERENCES players(player_id),
    bonus_id BIGINT REFERENCES bonuses(bonus_id),
    transaction_type VARCHAR(20),
    amount DECIMAL(10, 2),
    transaction_date TIMESTAMP,
    game_type VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 4. Abuse indicators (ML features)
CREATE TABLE IF NOT EXISTS abuse_indicators (
    indicator_id BIGSERIAL PRIMARY KEY,
    player_id BIGINT REFERENCES players(player_id),
    bonus_id BIGINT REFERENCES bonuses(bonus_id),
    bonus_velocity FLOAT,
    conversion_speed_hours INT,
    win_rate_with_bonus FLOAT,
    rtp_anomaly FLOAT,
    rapid_withdrawal BOOLEAN,
    account_age_days INT,
    abuse_score FLOAT,
    predicted_abuse BOOLEAN,
    prediction_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Performance indices
CREATE INDEX idx_player_date ON transactions(player_id, transaction_date);
CREATE INDEX idx_bonus_player ON bonuses(player_id);
CREATE INDEX idx_abuse_score ON abuse_indicators(abuse_score DESC);
