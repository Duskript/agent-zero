import pytest
from harness.loader import load_harness
from harness.exceptions import HarnessCircularExtendsError, HarnessNotFoundError


@pytest.mark.skip(reason="requires harness YAML files in HARNESS_DIR — written in Phase 1")
def test_base_harness_loads():
    h = load_harness("zeus-base.yaml")
    assert h["name"] == "Zeus"
    assert h["driver"] == "llm"
    assert "identity" in h
    print("PASS: base harness loads")


@pytest.mark.skip(reason="requires harness YAML files in HARNESS_DIR — written in Phase 1")
def test_studio_harness_extends():
    h = load_harness("apollo-lyric-writing.yaml")
    assert h["name"] == "Apollo"
    assert h["studio"] == "Lyric Writing"
    # routing from child appears before routing from base
    assert len(h.get("routing", [])) > 0
    # hard stops from base and child are both present
    hard_stops = h["guardrails"]["hard_stops"]
    assert len(hard_stops) > 0
    print("PASS: studio harness extends base correctly")


@pytest.mark.skip(reason="requires harness YAML files in HARNESS_DIR — written in Phase 1")
def test_hard_stops_are_additive():
    base = load_harness("apollo-base.yaml")
    studio = load_harness("apollo-lyric-writing.yaml")
    base_count = len(base["guardrails"]["hard_stops"])
    studio_count = len(studio["guardrails"]["hard_stops"])
    assert studio_count >= base_count
    print("PASS: hard stops are additive across extends")


@pytest.mark.skip(reason="requires harness YAML files in HARNESS_DIR — written in Phase 1")
def test_missing_harness_raises():
    try:
        load_harness("does-not-exist.yaml")
        print("FAIL: should have raised HarnessNotFoundError")
    except HarnessNotFoundError:
        print("PASS: missing harness raises HarnessNotFoundError")


@pytest.mark.skip(reason="requires harness YAML files in HARNESS_DIR — written in Phase 1")
def test_script_driver_no_model():
    h = load_harness("hestia-base.yaml")
    assert h["driver"] == "script"
    assert "model" not in h
    print("PASS: script driver has no model field")


if __name__ == "__main__":
    test_base_harness_loads()
    test_studio_harness_extends()
    test_hard_stops_are_additive()
    test_missing_harness_raises()
    test_script_driver_no_model()
