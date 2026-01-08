import asyncpg
import pytest
import asyncio
from fastapi.testclient import TestClient
from uuid import uuid4
from datetime import datetime, timezone
import json

from api.main import app

@pytest.fixture(scope='function')
async def test_db():
    # Create test db connection
    conn = await asyncpg.connect(
        host='postgres',
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

@pytest.fixture
def test_client():
    with TestClient(app) as test_client:
        yield test_client


# Generate a journal entry
@pytest.fixture
def entry_payload():

    return {
        "work": "1",
        "struggle": "2",
        "intention": "3",
    }