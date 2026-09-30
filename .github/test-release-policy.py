#!/usr/bin/env python3
"""Execute the shared workflow's actual tag gate against merged/unmerged tags."""
from pathlib import Path
import os
import re
import subprocess
import tempfile
import textwrap

workflow = Path('.github/workflows/app-release.yml').read_text()
match = re.search(r'      - name: Require a tag merged into main\n        run: \|\n(.*?)(?=      - name:)', workflow, re.S)
assert match, 'shared release ancestry gate missing'
gate = textwrap.dedent(match.group(1))
with tempfile.TemporaryDirectory() as directory:
    env = dict(os.environ, GIT_AUTHOR_NAME='Fixture', GIT_AUTHOR_EMAIL='fixture@example.invalid',
               GIT_COMMITTER_NAME='Fixture', GIT_COMMITTER_EMAIL='fixture@example.invalid', TAG='v1.0.0')
    def git(*args):
        return subprocess.run(['git'] + list(args), cwd=directory, env=env, check=True, capture_output=True)
    git('init', '-b', 'main')
    git('commit', '--allow-empty', '-m', 'base')
    git('update-ref', 'refs/remotes/origin/main', 'HEAD')
    git('checkout', '-b', 'feature')
    git('commit', '--allow-empty', '-m', 'unmerged')
    git('tag', 'v1.0.0')
    def check(expected):
        result = subprocess.run(['sh', '-c', gate], cwd=directory, env=env, capture_output=True)
        assert (result.returncode == 0) == expected, result.stderr
    check(False)
    git('update-ref', 'refs/remotes/origin/main', 'HEAD')
    check(True)
print('release policy: unmerged version rejected, merged version accepted')
