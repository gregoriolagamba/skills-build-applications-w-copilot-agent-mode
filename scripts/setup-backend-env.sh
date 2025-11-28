#!/usr/bin/env bash
set -euo pipefail

# Helper script for Linux / WSL to create a virtual environment and install requirements
# Run from repo root: ./scripts/setup-backend-env.sh

REPO_ROOT=$(pwd)
BACKEND_DIR="$REPO_ROOT/octofit-tracker/backend"
VENV_DIR="$BACKEND_DIR/venv"
REQ_FILE="$BACKEND_DIR/requirements.txt"

echo "Repo root: $REPO_ROOT"
echo "Backend dir: $BACKEND_DIR"
echo "Venv dir: $VENV_DIR"
echo "Requirements: $REQ_FILE"

# Ensure python3 available
if ! command -v python3 &>/dev/null; then
  echo "python3 not found. Install Python 3.8+ (for Ubuntu: sudo apt install python3 python3-venv python3-pip)" >&2
  exit 1
fi

# Create venv if missing
if [ ! -d "$VENV_DIR" ]; then
  echo "Creating virtual environment..."
  python3 -m venv "$VENV_DIR"
else
  echo "Virtual environment already exists at $VENV_DIR"
fi

VENV_PY="$VENV_DIR/bin/python"
if [ ! -x "$VENV_PY" ]; then
  echo "Venv python not found at $VENV_PY" >&2
  exit 1
fi

echo "Upgrading pip in venv..."
"$VENV_PY" -m pip install --upgrade pip

if [ ! -f "$REQ_FILE" ]; then
  echo "requirements.txt not found at $REQ_FILE" >&2
  exit 1
fi

echo "Installing requirements (may take a while; using --prefer-binary where possible)..."
"$VENV_PY" -m pip install --prefer-binary --disable-pip-version-check -r "$REQ_FILE"

echo "Done. Activate the venv with: source $VENV_DIR/bin/activate"