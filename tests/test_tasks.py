from pathlib import Path

import pytest

from tasks import (
    ZSHRC_TOOL_MARKER,
    _extract_zshrc_tool_content,
    _restore_zshrc_tool_content,
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
# Added by Instacart
source ~/.instacart_shell_profile

# bento completions
eval "$(bento completions zsh)"
"""

ZSHRC_WITH_TOOLS = LOADER_TEMPLATE + TOOL_CONTENT


class TestExtractZshrcToolContent:
    def test_extract_zshrc_tool_content(self, fake_home: Path) -> None:
        zshrc = fake_home / ".zshrc"
        zshrc.write_text(ZSHRC_WITH_TOOLS)

        result = _extract_zshrc_tool_content()
        assert result is not None
        assert result.startswith(ZSHRC_TOOL_MARKER)
        assert "instacart_shell_profile" in result
        assert "bento completions" in result

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
        assert "instacart_shell_profile" in result
        assert "bento completions" in result
        assert result.startswith("# ~/.zshrc loader")
        assert result.count(ZSHRC_TOOL_MARKER) == 1

    def test_restore_zshrc_tool_content_no_marker(self, fake_home: Path) -> None:
        zshrc = fake_home / ".zshrc"
        zshrc.write_text("# no marker here\n")

        preserved = ZSHRC_TOOL_MARKER + "\n" + TOOL_CONTENT
        _restore_zshrc_tool_content(preserved)

        result = zshrc.read_text()
        assert result == "# no marker here\n"
