import re
from pathlib import Path

import pytest

from scripts.setup import convert_md_to_toml, find_skill_files, parse_frontmatter


def _collect_skill_files(ai_root: Path) -> list[tuple[str, Path]]:
    skills = find_skill_files(ai_root / "skills")
    work_skills = ai_root / "work" / "skills"
    if work_skills.exists():
        skills.extend(find_skill_files(work_skills))
    return skills


def _get_skill_ids(ai_root: Path) -> list[str]:
    return [name for name, _ in _collect_skill_files(ai_root)]


@pytest.mark.parametrize(
    "skill_name",
    _get_skill_ids(Path(__file__).resolve().parent.parent / "ai"),
)
def test_skill_has_valid_frontmatter(skill_name: str, ai_root: Path) -> None:
    skills = dict(_collect_skill_files(ai_root))
    skill_path = skills[skill_name]
    content = skill_path.read_text()

    assert content.startswith("---"), f"{skill_path}: missing YAML frontmatter delimiter"

    frontmatter, body = parse_frontmatter(content)

    assert "description" in frontmatter, f"{skill_path}: missing 'description' in frontmatter"
    assert len(frontmatter["description"]) > 0, f"{skill_path}: empty description"
    assert len(body.strip()) > 0, f"{skill_path}: empty skill body"


@pytest.mark.parametrize(
    "skill_name",
    _get_skill_ids(Path(__file__).resolve().parent.parent / "ai"),
)
def test_skill_name_matches_directory(skill_name: str, ai_root: Path) -> None:
    skills = dict(_collect_skill_files(ai_root))
    skill_path = skills[skill_name]
    content = skill_path.read_text()
    frontmatter, _ = parse_frontmatter(content)

    if "name" in frontmatter:
        assert frontmatter["name"] == skill_name, (
            f"{skill_path}: frontmatter name '{frontmatter['name']}' "
            f"does not match directory name '{skill_name}'"
        )


@pytest.mark.parametrize(
    "skill_name",
    _get_skill_ids(Path(__file__).resolve().parent.parent / "ai"),
)
def test_skill_at_references_resolve(skill_name: str, ai_root: Path) -> None:
    skills = dict(_collect_skill_files(ai_root))
    skill_path = skills[skill_name]
    content = skill_path.read_text()

    at_refs = re.findall(r"^@(.+)$", content, re.MULTILINE)
    for ref in at_refs:
        ref_path = (skill_path.parent / ref).resolve()
        assert ref_path.exists(), (
            f"{skill_path}: @-reference '{ref}' resolves to {ref_path} which does not exist"
        )


@pytest.mark.parametrize(
    "skill_name",
    _get_skill_ids(Path(__file__).resolve().parent.parent / "ai"),
)
def test_skill_converts_to_toml(skill_name: str, ai_root: Path) -> None:
    skills = dict(_collect_skill_files(ai_root))
    skill_path = skills[skill_name]

    toml_output = convert_md_to_toml(skill_path)

    assert 'description = "' in toml_output, f"{skill_path}: TOML missing description"
    assert 'prompt = """' in toml_output, f"{skill_path}: TOML missing prompt block"
    assert toml_output.rstrip().endswith('"""'), f"{skill_path}: TOML prompt block not closed"


def test_no_duplicate_skill_names(ai_root: Path) -> None:
    skills = _collect_skill_files(ai_root)
    names = [name for name, _ in skills]
    duplicates = [name for name in names if names.count(name) > 1]
    assert not duplicates, f"Duplicate skill names: {set(duplicates)}"
