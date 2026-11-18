"""Regression tests for profile rejection and packaging validation."""

import contextlib
import io
import re
import shutil
import subprocess
import sys
import tempfile
import unittest
from pathlib import Path
from unittest.mock import patch

from tools import check_profiles

ROOT = Path(__file__).resolve().parents[1]


class ProfileValidationTests(unittest.TestCase):
    def setUp(self):
        self.directory = tempfile.TemporaryDirectory()
        self.addCleanup(self.directory.cleanup)
        self.root = Path(self.directory.name)
        (self.root / 'shaders/lib').mkdir(parents=True)
        shutil.copyfile(ROOT / 'shaders/lib/settings.glsl',
                        self.root / 'shaders/lib/settings.glsl')
        self.properties = self.root / 'shaders/shaders.properties'
        self.text = re.sub(r'\\\r?\n[ \t]*', ' ',
                           (ROOT / 'shaders/shaders.properties').read_text())

    def validate(self, text):
        self.properties.write_text(text)
        with patch.object(check_profiles, 'ROOT', self.root):
            with contextlib.redirect_stdout(io.StringIO()):
                check_profiles.check()

    def change_option(self, profile, key, value):
        def replace(match):
            options = match[2].split()
            options = [token for token in options if not token.startswith(key + '=')]
            if value is not None:
                options.append(key + '=' + value)
            return match[1] + ' '.join(options)
        return re.sub(r'^(profile\.' + profile + r'=)(.*)$',
                      replace, self.text, flags=re.MULTILINE)

    def test_valid_profiles(self):
        self.validate(self.text)

    def test_rejects_unknown_profile_name(self):
        with self.assertRaisesRegex(ValueError, 'Unexpected profile names'):
            self.validate(self.text.replace('profile.FAST=', 'profile.UNKNOWN='))

    def test_rejects_missing_menu_control(self):
        with self.assertRaisesRegex(ValueError, 'missing menu controls'):
            self.validate(self.change_option('FAST', 'SHADOWS', None))

    def test_rejects_illegal_value(self):
        with self.assertRaisesRegex(ValueError, 'invalid setting'):
            self.validate(self.change_option('FAST', 'SHADOWS', '999'))

    def test_rejects_changed_tier_contract(self):
        with self.assertRaisesRegex(ValueError, 'FAST must set SHADOWS=1'):
            self.validate(self.change_option('FAST', 'SHADOWS', '0'))

    def test_rejects_fxaa_enabled(self):
        with self.assertRaisesRegex(ValueError, 'Every profile must disable FXAA'):
            self.validate(self.change_option('CRISP', 'FXAA', '1'))

    def test_requires_shadow_program_directive(self):
        with self.assertRaisesRegex(ValueError, 'Missing shadow program'):
            self.validate(self.text.replace('program.shadow.enabled=false', ''))

    def test_single_control_change_must_select_custom(self):
        fast = re.search(r'^profile\.FAST=(.*)$', self.text, re.MULTILINE)[1]
        near_fast = re.sub(r'\bSHADOWS=1\b', 'SHADOWS=0', fast)
        text = re.sub(r'^profile\.CRISP=.*$', lambda match: 'profile.CRISP=' + near_fast,
                      self.text, flags=re.MULTILINE)
        with self.assertRaisesRegex(ValueError, 'must select Custom'):
            self.validate(text)

    def test_packaging_rejects_invalid_profiles_even_with_optimization(self):
        # Run the real packaging entry point against an isolated source copy.
        shutil.copytree(ROOT / 'shaders', self.root / 'shaders', dirs_exist_ok=True)
        shutil.copytree(ROOT / 'tools', self.root / 'tools',
                        ignore=shutil.ignore_patterns('__pycache__'))
        self.properties.write_text(self.change_option('FAST', 'SHADOWS', '999'))
        for flags in ([], ['-O']):
            with self.subTest(flags=flags):
                output = self.root / 'dist'
                result = subprocess.run(
                    [sys.executable, *flags, str(self.root / 'tools/build.py'),
                     '--without-cubic', '--output-dir', str(output)],
                    capture_output=True, text=True, check=False, timeout=30,
                )
                self.assertNotEqual(result.returncode, 0)
                self.assertIn('invalid setting SHADOWS=999', result.stderr)
                self.assertFalse(output.exists())


if __name__ == '__main__':
    unittest.main()
