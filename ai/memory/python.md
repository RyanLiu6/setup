# Python Rules

## Functions & Documentation
### Docstrings
- **Never** use simple one-line docstrings like `"""Generate compose file."""`
- Public-facing functions must have full docstrings with:
  - Description
  - Args (with types and descriptions)
  - Returns (with type and description)
  - Raises (if applicable)
- Private/internal helper functions may omit docstrings if the function name is self-explanatory
- Example:
  ```python
  # Bad - too simple, provides no value
  def generate_compose_file(services: list[str]) -> str:
      """Generate compose file."""
      ...

  # Good - full documentation for public API
  def generate_compose_file(services: list[str], output_dir: Path | None = None) -> str:
      """Generate a Docker Compose file from service definitions.

      Args:
          services: List of service names to include in the compose file.
          output_dir: Directory to write the file to. If None, returns content only.

      Returns:
          The generated compose file content as a string.

      Raises:
          ValueError: If services list is empty.
          FileNotFoundError: If output_dir does not exist.
      """
      ...
  ```

### Function Design
- Function names should clearly convey responsibility
- Functions should be logical in size - neither too granular nor too monolithic
- Single responsibility principle: one function, one job
- In-code comments are allowed but only when necessary to explain *why*, not *what*

### Type Hints
- Use primitive types whenever possible (`list`, `dict`, `set`, `tuple`)
- Prefer `Optional[str]` over `str | None`
- Only import from `typing` when no primitive alternative exists (e.g., `Optional`, `Callable`, `TypeVar`)
- All functions must have fully typed arguments and return types
- **Never use `Any`** except for complex nested dictionary responses where full typing becomes unreadable
  - Acceptable: `dict[str, dict]` or `dict[str, Any]` instead of `dict[str, dict[str, int | str | list[float]]]`
  - When using `Any`, document the expected structure in the docstring
- Example:
  ```python
  # Bad - unnecessary typing imports
  from typing import List, Dict
  def process(items: List[str]) -> Dict[str, int]: ...

  # Good - use primitives
  def process(items: list[str]) -> dict[str, int]: ...

  # Bad - union syntax for optional
  def fetch(url: str, timeout: int | None = None) -> str: ...

  # Good - Optional from typing
  from typing import Optional
  def fetch(url: str, timeout: Optional[int] = None) -> str: ...

  # Acceptable - Any for complex nested dicts, with docstring explaining structure
  from typing import Any
  def get_api_response(endpoint: str) -> dict[str, Any]:
      """Fetch data from API endpoint.

      Args:
          endpoint: The API endpoint path.

      Returns:
          Response dict with structure: {"data": {"id": int, "items": list[str]}, "meta": {...}}
      """
      ...
  ```

## Python Testing
### Test Naming Convention
- Tests are named `test_<function_name>_<suffix>`
- The first test should have no `_<suffix>` to indicate a base test case (i.e., does this function work given some expected input)
- Tests that follow the first one should always have a suffix to describe that specific case
- Tests should never have comments to describe what it does, the name should suffice.
- Example:
  ```python
  def test_detect_conf_drift(mocker):
      # Base case - function works as expected

  def test_detect_conf_drift_with_differences(mocker):
      # Specific case - function handles differences

  def test_detect_conf_drift_returns_none(setup_scenario):
      # Edge case - function returns None
  ```

### Test Assertions
- Use `assert` statements for value comparisons
- Use assertion functions like `assert_has_calls` only when asserting mock calls
- Example:
  ```python
  # Good - simple assertions
  assert report is not None
  assert report["missing_in_current"] == []

  # Good - for mock call verification
  mock_func.assert_has_calls([call(arg1), call(arg2)])
  ```

### Test Parametrization
- Parametrize test-cases whenever possible
- If multiple tests are testing very similar cases, reduce them to one with parametrize
- Example:
  ```python
  @pytest.mark.parametrize(
      "setup_scenario",
      ["no_target_service", "no_deploys"],
  )
  def test_detect_conf_drift_returns_none(setup_scenario):
      # Single test handles multiple similar edge cases
  ```

### Test Structure
- Keep tests focused and concise
- Remove unnecessary comments like "# Setup" or "# Test" - the code should be self-explanatory
- Use descriptive docstrings for complex test cases
- Group related assertions together
