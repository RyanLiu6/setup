from pathlib import Path
from unittest.mock import MagicMock

import pytest
from invoke.context import Context

from tasks import (
    ZSHRC_TOOL_MARKER,
    _extract_zshrc_tool_content,
    _restore_zshrc_tool_content,
    cleanup,
)


@pytest.fixture
def fake_home(tmp_path: Path, monkeypatch: pytest.MonkeyPatch) -> Path:
    monkeypatch.setattr(Path, "home", lambda: tmp_path)
    return tmp_path


LOADER_TEMPLATE = """\
# ~/.zshrc loader
source /some/path/shell/.zshrc

# Tools install themselves below this line
"""

TOOL_CONTENT = """\
# Added by some-tool
source ~/.some_tool_profile

# another-tool completions
eval "$(another-tool completions zsh)"
"""

ZSHRC_WITH_TOOLS = LOADER_TEMPLATE + TOOL_CONTENT


class TestExtractZshrcToolContent:
    def test_extract_zshrc_tool_content(self, fake_home: Path) -> None:
        zshrc = fake_home / ".zshrc"
        zshrc.write_text(ZSHRC_WITH_TOOLS)

        result = _extract_zshrc_tool_content()
        assert result is not None
        assert result.startswith(ZSHRC_TOOL_MARKER)
        assert "some_tool_profile" in result
        assert "another-tool completions" in result

    def test_extract_zshrc_tool_content_no_marker(self, fake_home: Path) -> None:
        zshrc = fake_home / ".zshrc"
        zshrc.write_text("# just some zshrc\nexport FOO=bar\n")

        assert _extract_zshrc_tool_content() is None

    def test_extract_zshrc_tool_content_no_file(self, fake_home: Path) -> None:
        assert _extract_zshrc_tool_content() is None

    def test_extract_zshrc_tool_content_empty_after_marker(self, fake_home: Path) -> None:
        zshrc = fake_home / ".zshrc"
        zshrc.write_text(LOADER_TEMPLATE + "\n  \n")

        assert _extract_zshrc_tool_content() is None

    def test_extract_zshrc_tool_content_symlink(self, fake_home: Path) -> None:
        real_file = fake_home / ".zshrc.real"
        real_file.write_text(ZSHRC_WITH_TOOLS)
        zshrc = fake_home / ".zshrc"
        zshrc.symlink_to(real_file)

        assert _extract_zshrc_tool_content() is None


class TestRestoreZshrcToolContent:
    def test_restore_zshrc_tool_content(self, fake_home: Path) -> None:
        zshrc = fake_home / ".zshrc"
        zshrc.write_text(LOADER_TEMPLATE)

        preserved = ZSHRC_TOOL_MARKER + "\n" + TOOL_CONTENT
        _restore_zshrc_tool_content(preserved)

        result = zshrc.read_text()
        assert "some_tool_profile" in result
        assert "another-tool completions" in result
        assert result.startswith("# ~/.zshrc loader")
        assert result.count(ZSHRC_TOOL_MARKER) == 1

    def test_restore_zshrc_tool_content_no_marker(self, fake_home: Path) -> None:
        zshrc = fake_home / ".zshrc"
        zshrc.write_text("# no marker here\n")

        preserved = ZSHRC_TOOL_MARKER + "\n" + TOOL_CONTENT
        _restore_zshrc_tool_content(preserved)

        result = zshrc.read_text()
        assert result == "# no marker here\n"


class TestCleanup:
    @pytest.fixture
    def fake_home(self, tmp_path: Path, monkeypatch: pytest.MonkeyPatch) -> Path:
        monkeypatch.setattr(Path, "home", lambda: tmp_path)
        monkeypatch.setenv("HOME", str(tmp_path))
        return tmp_path

    def test_cleanup(self, fake_home: Path) -> None:
        backup_files: list[Path] = []
        backup_dirs: list[Path] = []

        for rel in [
            ".zprofile.backup",
            ".gitignore_global.backup",
            ".config/starship.toml.backup",
            ".config/direnv/direnvrc.backup",
        ]:
            p = fake_home / rel
            p.parent.mkdir(parents=True, exist_ok=True)
            p.write_text("backup")
            backup_files.append(p)

        ghostty_backup = fake_home / ".config" / "ghostty.backup"
        ghostty_backup.mkdir(parents=True)
        (ghostty_backup / "config").write_text("backup")
        backup_dirs.append(ghostty_backup)

        for ts in ["20240101_120000", "20240615_090000"]:
            p = fake_home / f".zshrc.backup.{ts}"
            p.write_text("backup")
            backup_files.append(p)

        claude_dir = fake_home / ".claude"
        claude_dir.mkdir(parents=True, exist_ok=True)
        for name in [
            "CLAUDE.md.backup.20240101_120000",
            "settings.json.backup.20240101_120000",
        ]:
            p = claude_dir / name
            p.write_text("backup")
            backup_files.append(p)

        skills_backup = claude_dir / "skills.backup.20240101_120000"
        skills_backup.mkdir()
        (skills_backup / "some-skill").mkdir()
        backup_dirs.append(skills_backup)

        gemini_dir = fake_home / ".gemini"
        gemini_dir.mkdir(parents=True, exist_ok=True)
        p = gemini_dir / "GEMINI.md.backup.20240101_120000"
        p.write_text("backup")
        backup_files.append(p)

        commands_backup = gemini_dir / "commands.backup.20240101_120000"
        commands_backup.mkdir()
        backup_dirs.append(commands_backup)

        preserved = []
        for rel in [".zprofile", ".zshrc"]:
            p = fake_home / rel
            p.write_text("real config")
            preserved.append(p)
        for name, parent in [("CLAUDE.md", claude_dir), ("GEMINI.md", gemini_dir)]:
            p = parent / name
            p.write_text("real config")
            preserved.append(p)

        all_backups = backup_files + backup_dirs
        for p in all_backups:
            assert p.exists()

        cleanup(MagicMock(spec=Context))

        for p in all_backups:
            assert not p.exists(), f"Cleanup missed: {p}"
        for p in preserved:
            assert p.exists(), f"Cleanup wrongly removed: {p}"

    def test_cleanup_no_backups(self, fake_home: Path) -> None:
        cleanup(MagicMock(spec=Context))
