from api.tests.testing_db import test_db
from fastapi.testclient import TestClient
import pytest
import asyncio

from api.main import app

pytest_plugins = ('pytest_asyncio',)

client = TestClient(app)

def test_post_entry(test_db):
    entry = {
        "work": "1",
        "struggle": "2",
        "intention": "3"
    }
    create_response = client.post("/entries/", json=entry)
    
    assert create_response.status_code == 200
    # assert create_response.json() == {
    #     "detail": "Entry created successfully",
    #     "entry": entry
    # }


def test_get_entry_by_id(test_db):
    entry_data = {
        "work": "test",
        "struggle": "test1",
        "intention": "test2"
    }

    entry_response = client.post("/entries/", json=entry_data)

    assert entry_response.status_code == 200

    created_entry = entry_response.json()
    entry_id = created_entry["entry"]["id"]

    # Get the entry that was just created
    get_response = client.get(f"/entries/{entry_id}")
    
    assert get_response.status_code == 200
    assert get_response.json()["entry"]["id"] == entry_id
    assert get_response.json()["entry"]["work"] == "test"