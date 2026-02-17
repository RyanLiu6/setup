import os
from pathlib import Path

import pytest

from tasks import COMPONENTS

SYMLINK_SOURCES = [
    ("shell", "shell/.zprofile", "file"),
    ("shell", "shell/.zshrc", "file"),
    ("shell", "shell/.zshrc.loader", "file"),
    ("direnv", "direnv/direnvrc", "file"),
    ("git", "git/.gitignore_global", "file"),
    ("git", "git/.gitconfig.shared", "file"),
    ("terminal", "terminal/ghostty", "dir"),
    ("terminal", "terminal/starship.toml", "file"),
    ("rectangle", "rectangle/com.knollsoft.Rectangle.plist", "file"),
]


@pytest.mark.parametrize("component", COMPONENTS)
def test_setup_script_exists(component: str, repo_root: Path) -> None:
    script = repo_root / component / "setup"
    assert script.is_file(), f"{component}/setup does not exist"


@pytest.mark.parametrize("component", COMPONENTS)
def test_setup_script_executable(component: str, repo_root: Path) -> None:
    script = repo_root / component / "setup"
    assert os.access(script, os.X_OK), f"{component}/setup is not executable"


@pytest.mark.parametrize("component", COMPONENTS)
def test_setup_script_sources_platform_sh(component: str, repo_root: Path) -> None:
    script = repo_root / component / "setup"
    content = script.read_text()
    assert 'source "$REPO_DIR/lib/platform.sh"' in content, (
        f"{component}/setup does not source lib/platform.sh"
    )


@pytest.mark.parametrize(
    "component, rel_path, expected_type",
    SYMLINK_SOURCES,
    ids=[f"{c}:{p}" for c, p, _ in SYMLINK_SOURCES],
)
def test_symlink_sources_exist(
    component: str, rel_path: str, expected_type: str, repo_root: Path
) -> None:
    path = repo_root / rel_path
    assert path.exists(), f"{rel_path} does not exist"
    if expected_type == "file":
        assert path.is_file(), f"{rel_path} should be a file"
    else:
        assert path.is_dir(), f"{rel_path} should be a directory"


def test_platform_sh_exists(repo_root: Path) -> None:
    assert (repo_root / "lib" / "platform.sh").is_file()
