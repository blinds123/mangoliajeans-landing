#!/usr/bin/env python3
"""
Test Suite for Ralph Loop Verification Engine
Run with: python3 -m pytest tests/test_verify_step.py -v
Or: python3 tests/test_verify_step.py
"""

import sys
import os
import json
import tempfile
import shutil
from pathlib import Path

# Add parent directory to path for imports
sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..', '.agent', 'skills', 'ralph-loop', 'scripts'))

from verify_step import (
    load_json,
    file_exists_and_valid,
    has_key_check,
    no_placeholder_check,
    generic_language_check,
    previous_step_passed_check,
    contains_text_check,
    clear_cache,  # Import cache clearing function
)

class TestContext:
    """Context manager for test files."""
    def __init__(self):
        self.temp_dir = tempfile.mkdtemp()
        self.original_cwd = os.getcwd()
        
    def __enter__(self):
        os.chdir(self.temp_dir)
        return self
        
    def __exit__(self, *args):
        os.chdir(self.original_cwd)
        shutil.rmtree(self.temp_dir)
        clear_cache()  # Clear file cache between tests
        
    def create_file(self, name, content):
        with open(name, 'w') as f:
            f.write(content)
        return os.path.join(self.temp_dir, name)


def test_load_json_valid():
    """Test loading valid JSON."""
    with TestContext() as ctx:
        ctx.create_file('test.json', '{"key": "value"}')
        result = load_json('test.json')
        assert result == {"key": "value"}
        print("✅ test_load_json_valid PASSED")

def test_load_json_invalid():
    """Test loading invalid JSON returns None."""
    with TestContext() as ctx:
        ctx.create_file('bad.json', '{invalid json}')
        result = load_json('bad.json')
        assert result is None
        print("✅ test_load_json_invalid PASSED")

def test_load_json_missing():
    """Test loading missing file returns None."""
    with TestContext() as ctx:
        result = load_json('missing.json')
        assert result is None
        print("✅ test_load_json_missing PASSED")

def test_file_exists_and_valid_pass():
    """Test file exists check passes for valid file."""
    with TestContext() as ctx:
        ctx.create_file('large.txt', 'x' * 2000)  # 2KB
        passed, msg = file_exists_and_valid('large.txt', 1)
        assert passed
        print("✅ test_file_exists_and_valid_pass PASSED")

def test_file_exists_and_valid_too_small():
    """Test file exists check fails for small file."""
    with TestContext() as ctx:
        ctx.create_file('small.txt', 'x')  # ~1 byte
        passed, msg = file_exists_and_valid('small.txt', 1)
        assert not passed
        assert "too small" in msg
        print("✅ test_file_exists_and_valid_too_small PASSED")

def test_has_key_check_pass():
    """Test has_key passes when key exists."""
    with TestContext() as ctx:
        ctx.create_file('test.json', '{"expected_key": "value"}')
        passed, msg = has_key_check('test.json', 'expected_key')
        assert passed
        print("✅ test_has_key_check_pass PASSED")

def test_has_key_check_fail():
    """Test has_key fails when key missing."""
    with TestContext() as ctx:
        ctx.create_file('test.json', '{"other_key": "value"}')
        passed, msg = has_key_check('test.json', 'missing_key')
        assert not passed
        assert "MISSING" in msg
        print("✅ test_has_key_check_fail PASSED")

def test_no_placeholder_check_pass():
    """Test no placeholder check passes for clean file."""
    with TestContext() as ctx:
        ctx.create_file('clean.html', '<h1>Real Content</h1>')
        passed, msg = no_placeholder_check('clean.html')
        assert passed
        print("✅ test_no_placeholder_check_pass PASSED")

def test_no_placeholder_check_fail():
    """Test no placeholder check fails when placeholders exist."""
    with TestContext() as ctx:
        ctx.create_file('dirty.html', '<h1>{{PLACEHOLDER}}</h1>')
        passed, msg = no_placeholder_check('dirty.html')
        assert not passed
        assert "PLACEHOLDERS FOUND" in msg
        print("✅ test_no_placeholder_check_fail PASSED")

def test_generic_language_check_pass():
    """Test generic language check passes for unique copy."""
    with TestContext() as ctx:
        ctx.create_file('unique.json', '{"copy": "The forbidden grail finally landed"}')
        passed, msg = generic_language_check('unique.json')
        assert passed
        print("✅ test_generic_language_check_pass PASSED")

def test_generic_language_check_fail():
    """Test generic language check fails for lazy copy."""
    with TestContext() as ctx:
        ctx.create_file('lazy.json', '{"copy": "premium quality best in class product"}')
        passed, msg = generic_language_check('lazy.json')
        assert not passed
        assert "GENERIC LANGUAGE" in msg
        print("✅ test_generic_language_check_fail PASSED")

def test_dag_dependencies_parallel():
    """Test DAG allows parallel cluster execution."""
    with TestContext() as ctx:
        # Create progress with only 1-initialize complete
        progress = {
            "steps_completed": [{"step": "1-initialize"}]
        }
        ctx.create_file('progress.json', json.dumps(progress))
        
        # Both Scout and Profiler should pass (parallel start)
        passed1, msg1 = previous_step_passed_check("2A-scout")
        passed2, msg2 = previous_step_passed_check("2C-profiler")
        passed3, msg3 = previous_step_passed_check("2E-mechanic")
        
        assert passed1, f"Scout should pass: {msg1}"
        assert passed2, f"Profiler should pass: {msg2}"
        assert passed3, f"Mechanic should pass: {msg3}"
        print("✅ test_dag_dependencies_parallel PASSED")

def test_dag_dependencies_strategist_requires_all():
    """Test Strategist requires all 5 research steps."""
    with TestContext() as ctx:
        # Create progress with only some steps complete
        progress = {
            "steps_completed": [
                {"step": "1-initialize"},
                {"step": "2A-scout"},
                {"step": "2B-spy"},
                # Missing: 2D-avatar, 2E-mechanic
            ]
        }
        ctx.create_file('progress.json', json.dumps(progress))
        
        # Strategist should fail
        passed, msg = previous_step_passed_check("2F-strategist")
        assert not passed
        assert "NOT complete" in msg
        print("✅ test_dag_dependencies_strategist_requires_all PASSED")

def test_contains_text_check_pass():
    """Test contains_text passes when text exists."""
    with TestContext() as ctx:
        ctx.create_file('report.md', '# Report\n\nHALLUCINATION_CHECK: PASSED\n')
        passed, msg = contains_text_check('report.md', 'HALLUCINATION_CHECK: PASSED')
        assert passed
        print("✅ test_contains_text_check_pass PASSED")

def test_contains_text_check_fail():
    """Test contains_text fails when text missing."""
    with TestContext() as ctx:
        ctx.create_file('report.md', '# Report\n\nHALLUCINATION_CHECK: FAILED\n')
        passed, msg = contains_text_check('report.md', 'HALLUCINATION_CHECK: PASSED')
        assert not passed
        print("✅ test_contains_text_check_fail PASSED")


def run_all_tests():
    """Run all tests manually."""
    print("=" * 60)
    print("🧪 RALPH LOOP TEST SUITE")
    print("=" * 60)
    
    tests = [
        test_load_json_valid,
        test_load_json_invalid,
        test_load_json_missing,
        test_file_exists_and_valid_pass,
        test_file_exists_and_valid_too_small,
        test_has_key_check_pass,
        test_has_key_check_fail,
        test_no_placeholder_check_pass,
        test_no_placeholder_check_fail,
        test_generic_language_check_pass,
        test_generic_language_check_fail,
        test_dag_dependencies_parallel,
        test_dag_dependencies_strategist_requires_all,
        test_contains_text_check_pass,
        test_contains_text_check_fail,
    ]
    
    passed = 0
    failed = 0
    
    for test in tests:
        try:
            test()
            passed += 1
        except AssertionError as e:
            print(f"❌ {test.__name__} FAILED: {e}")
            failed += 1
        except Exception as e:
            print(f"❌ {test.__name__} ERROR: {e}")
            failed += 1
    
    print("=" * 60)
    print(f"✅ Passed: {passed}")
    print(f"❌ Failed: {failed}")
    print(f"📊 Total: {passed + failed}")
    print("=" * 60)
    
    return failed == 0


if __name__ == "__main__":
    success = run_all_tests()
    sys.exit(0 if success else 1)
