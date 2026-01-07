import asyncpg
import pytest
import asyncio

@pytest.fixture
async def test_db():
    # Create test db connection
    conn = await asyncpg.connect(
        host='127.0.0.1',
        database='test_db',
        user='test',
        password='test'
    )

    await conn.execute('''
        CREATE TABLE IF NOT EXISTS entries (
            id VARCHAR PRIMARY KEY,
            data JSONB NOT NULL,
            created_at TIMESTAMP WITH TIME ZONE NOT NULL,
            updated_at TIMESTAMP WITH TIME ZONE NOT NULL
            );
    ''')

    yield conn

    await conn.execute("DROP TABLE IF EXISTS entries;")
    await conn.close()