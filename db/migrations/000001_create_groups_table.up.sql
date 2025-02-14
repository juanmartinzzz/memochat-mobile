CREATE TABLE groups (
    id VARCHAR(255) PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT NOT NULL,
    creator_id VARCHAR(255) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE
);

-- Add indexes for common query patterns
CREATE INDEX idx_groups_created_at ON groups(created_at);
CREATE INDEX idx_groups_creator_id ON groups(creator_id);

-- Add a group_id column to the chat_messages table
ALTER TABLE chat_messages ADD COLUMN group_id VARCHAR(255);

-- Add a foreign key constraint to the chat_messages table
ALTER TABLE chat_messages ADD CONSTRAINT fk_chat_messages_group_id FOREIGN KEY (group_id) REFERENCES groups(id);
