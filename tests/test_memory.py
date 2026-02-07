import re
from pathlib import Path

import pytest


def _get_memory_files(memory_dir: Path) -> list[str]:
    return [f.name for f in sorted(memory_dir.glob("*.md"))]


@pytest.mark.parametrize(
    "filename",
    _get_memory_files(Path(__file__).resolve().parent.parent / "ai" / "memory"),
)
def test_memory_file_not_empty(filename: str, memory_dir: Path) -> None:
    content = (memory_dir / filename).read_text()
    assert len(content.strip()) > 0


@pytest.mark.parametrize(
    "filename",
    _get_memory_files(Path(__file__).resolve().parent.parent / "ai" / "memory"),
)
def test_memory_file_has_heading(filename: str, memory_dir: Path) -> None:
    content = (memory_dir / filename).read_text()
    assert re.search(r"^#\s+", content, re.MULTILINE), (
        f"memory/{filename}: missing top-level heading"
    )


def test_tool_configs_reference_all_memory_files(memory_dir: Path, modules_dir: Path) -> None:
    memory_files = sorted(memory_dir.glob("*.md"))

    for tool_dir in sorted(modules_dir.iterdir()):
        if not tool_dir.is_dir():
            continue

        config_files = list(tool_dir.glob("*.md"))
        if not config_files:
            continue

        config_content = config_files[0].read_text()
        at_refs = re.findall(r"^@(.+)$", config_content, re.MULTILINE)
        referenced_paths = {(config_files[0].parent / ref).resolve() for ref in at_refs}

        for mem_file in memory_files:
            assert mem_file.resolve() in referenced_paths, (
                f"modules/{tool_dir.name}/{config_files[0].name}: "
                f"does not reference memory/{mem_file.name}"
            )


def test_tool_config_at_references_resolve(modules_dir: Path) -> None:
    for tool_dir in sorted(modules_dir.iterdir()):
        if not tool_dir.is_dir():
            continue

        for config_file in tool_dir.glob("*.md"):
            content = config_file.read_text()
            at_refs = re.findall(r"^@(.+)$", content, re.MULTILINE)
            for ref in at_refs:
                ref_path = (config_file.parent / ref).resolve()
                assert ref_path.exists(), (
                    f"modules/{tool_dir.name}/{config_file.name}: "
                    f"@-reference '{ref}' resolves to {ref_path} which does not exist"
                )
