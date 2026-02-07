from pathlib import Path

import pytest


@pytest.fixture
def repo_root() -> Path:
    return Path(__file__).resolve().parent.parent


@pytest.fixture
def ai_root(repo_root: Path) -> Path:
    return repo_root / "ai"


@pytest.fixture
def skills_dir(ai_root: Path) -> Path:
    return ai_root / "skills"


@pytest.fixture
def memory_dir(ai_root: Path) -> Path:
    return ai_root / "memory"


@pytest.fixture
def modules_dir(ai_root: Path) -> Path:
    return ai_root / "modules"
