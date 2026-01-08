from api.tests.testing_db import test_db, test_client, entry_payload
from fastapi.testclient import TestClient
import pytest
import asyncio


from api.main import app

pytest_plugins = ('pytest_asyncio',)

client = TestClient(app)

def test_create_entry(test_db, entry_payload):

    create_response = client.post("/entries/", json=entry_payload)
    
    data = create_response.json()
    assert create_response.status_code == 200
    assert data["entry"]["intention"] == '3'
    assert data["entry"]["struggle"] == '2'
    assert data["entry"]["work"] == '1'
    assert data["entry"]["id"] is not None


def test_get_entry_by_id(test_db, entry_payload):

    entry_response = client.post("/entries/", json=entry_payload)

    assert entry_response.status_code == 200

    created_entry = entry_response.json()
    entry_id = created_entry["entry"]["id"]

    # Get the entry that was just created
    get_response = client.get(f"/entries/{entry_id}")
    
    assert get_response.status_code == 200
    assert get_response.json()["entry"]["id"] == entry_id
    assert get_response.json()["entry"]["work"] == "1"


def test_read_root():
    response = client.get("/")
    assert response.status_code == 200
    assert response.json() == {"message": "Server is running."}


def test_delete_entry_by_id(test_db, entry_payload):

    entry_post = client.post("/entries/", json=entry_payload)
    created_post = entry_post.json()
    created_post_id = created_post["entry"]["id"]

    # Delete entry
    entry_delete = client.delete(f"/entries/{created_post_id}")

    assert entry_delete.status_code == 200
    assert entry_delete.json() == {
        "message": f"Entry {created_post_id} deleted successfully."
    }


def test_get_all_entries(test_db, entry_payload):

    entry_post = client.post("/entries/", json=entry_payload)

    get_entries = client.get("/entries")

    data = get_entries.json()

    assert get_entries.status_code == 200
    assert data["count"] == 1

def test_delete_all_entries(test_db, entry_payload):

    entry_post = client.post("/entries/", json=entry_payload)

    entry_delete_all = client.delete("/entries")

    assert entry_delete_all.status_code == 200
    assert entry_delete_all.json() == {
        "detail": "All entries deleted"
    }


def test_update_entry(test_db, entry_payload):

    entry_post = client.post("/entries/", json=entry_payload)
    response = entry_post.json()
    entry_post_id = response["entry"]["id"]

    entry_update = {
        "work": "u",
        "struggle": "p",
        "intention": "e"
    }
    entry_patch = client.patch(f"/entries/{entry_post_id}", json=entry_update)

    data = entry_patch.json()
    print(data)
    assert entry_patch.status_code == 200
    assert data["id"] is not None
    assert data["work"] == "u"
    assert data["struggle"] == "p"
    assert data["intention"] == "e"