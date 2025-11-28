# Build Applications with GitHub Copilot Agent Mode

[![CI: setup-backend](https://github.com/gregoriolagamba/skills-build-applications-w-copilot-agent-mode/actions/workflows/setup-backend.yml/badge.svg?branch=build-octofit-app)](https://github.com/gregoriolagamba/skills-build-applications-w-copilot-agent-mode/actions/workflows/setup-backend.yml)

<img src="https://octodex.github.com/images/Professortocat_v2.png" align="right" height="200px" />

Hey gregoriolagamba!

Mona here. I'm done preparing your exercise. Hope you enjoy! 💚

Remember, it's self-paced so feel free to take a break! ☕️

[![](https://img.shields.io/badge/Go%20to%20Exercise-%E2%86%92-1f883d?style=for-the-badge&logo=github&labelColor=197935)](https://github.com/gregoriolagamba/skills-build-applications-w-copilot-agent-mode/issues/1)

---

&copy; 2025 GitHub &bull; [Code of Conduct](https://www.contributor-covenant.org/version/2/1/code_of_conduct/code_of_conduct.md) &bull; [MIT License](https://gh.io/mit)

## Backend setup (OctoFit Tracker)

This repo includes a small Django backend skeleton under `octofit-tracker/backend` and helper scripts to create and populate a Python virtual environment with the project's requirements.

### Windows (PowerShell)

1. From the repository root run the PowerShell helper script (recommended):

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\setup-backend-env.ps1
```

2. Or run commands manually:

```powershell
# create venv
py -3 -m venv .\octofit-tracker\backend\venv

# upgrade pip and install
.\octofit-tracker\backend\venv\Scripts\python.exe -m pip install --upgrade pip
.\octofit-tracker\backend\venv\Scripts\python.exe -m pip install --prefer-binary -r .\octofit-tracker\backend\requirements.txt

# verify
.\octofit-tracker\backend\venv\Scripts\python.exe -m pip freeze
```

### WSL / Ubuntu (bash)

If you're using WSL or an Ubuntu environment use the provided shell helper script:

```bash
./scripts/setup-backend-env.sh
```

This script will create a `venv` inside `octofit-tracker/backend/venv` and install the packages from `requirements.txt` using `--prefer-binary` to reduce source builds.

Notes for Ubuntu users: make sure `python3`, `python3-venv` and `python3-pip` are installed (for example: `sudo apt update && sudo apt install -y python3 python3-venv python3-pip build-essential` if you expect packages requiring compilation).

### CI — GitHub Actions

A workflow has been added to help CI exercise the same setup on GitHub Actions. It runs on `ubuntu-latest` and:

- checks out the repository
- sets up Python 3.11
- caches pip downloads
- creates and uses `octofit-tracker/backend/venv`
- installs packages from `octofit-tracker/backend/requirements.txt` (with `--prefer-binary`)

The workflow is available at `.github/workflows/setup-backend.yml` and is triggered for pushes and PRs to the `build-octofit-app` branch.

If this machine/runner can't build a package from source, consider enabling additional build tools on the runner or using the `--prefer-binary` option as shown above.

