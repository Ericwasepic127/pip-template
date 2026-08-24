#!/bin/bash
# Made by @Ericwasepic127

TEST=""

while [ $# -gt 0 ]; do
    case "$1" in
        --token)
            PYPI_TOKEN="$2"
            shift 2
            ;;
        --pip)
            PYTHONPIP="$2"
            shift 2
            ;;
        --python)
            PYTHON="$2"
            shift 2
            ;;
        --test)
            TEST=true
            shift
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
done

if [ -z "$PYTHON" ]; then
    read -p "Enter python command to use: " PYTHON
fi

if [ -z "$PYPI_TOKEN" ]; then
    read -s -p "Enter twine token: " PYPI_TOKEN
fi

if [ -n "$PYTHON" ]; then
    PYTHONLOC=$(which $PYTHON)
else
    PYTHONLOC=$(which python3 || which python)
fi

if [ -z "$PYTHONLOC" ]; then
    echo "Cannot find python. Exiting ..."
    exit 1
fi

if [ -z "$PYTHONPIP" ]; then
    PYTHONPIP="$PYTHONLOC -m pip"
fi

if ! "$PYTHONPIP" --version >/dev/null 2>&1; then
    echo "Pip doesn't found, exiting ..."
    exit 1
fi

$PYTHONPIP install --upgrade pip
$PYTHONPIP install --upgrade setuptools twine build

if ! $PYTHONLOC -m build; then
    if [ -z "$TEST" ]; then
        $PYTHONLOC -m twine upload --repository testpypi --username __token__ --password "$PYPI_TOKEN" dist/*
    else
        $PYTHONLOC -m twine upload --username __token__ --password "$PYPI_TOKEN" dist/*
    fi
fi
