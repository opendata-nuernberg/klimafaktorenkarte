import os
import shutil

from invoke import task

SHELL = os.getenv("SHELL", "/bin/bash")


@task()
def pip_prepare_venvs(c, remove_venvs=False):
    if remove_venvs:
        c.run("rm -r *_venv", pty=True)
    c.run("python -m venv osm_fetch_venv")
    c.run("osm_fetch_venv/bin/pip install -r osm_fetch/requirements.txt")


@task()
def pip_freeze(c):
    c.run("osm_fetch_venv/bin/pip freeze > osm_fetch/requirements.txt")


def run_in_venv(c, venv_name, cmd, pty=False):
    c.run(f"{SHELL} -c 'source {venv_name}_venv/bin/activate; {cmd}'", pty=pty)


@task()
def venv_scraper_activate(c):
    run_in_venv(c, "osm_fetch", SHELL, pty=True)


@task()
def scraper_run(c):
    run_in_venv(c, "osm_fetch", "python osm_fetch/main.py", pty=True)
