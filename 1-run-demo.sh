#!/bin/bash

main() {
  install_homebrew
  install_wget
  install_python
  install_pipx
  install_pkgmgr
  install_agentguard
  export PYTHONPATH="./agent-guard"
  $PKGMGR run python3 filevars.py
}

install_homebrew() {
  if [[ "$(uname)" != "Darwin" ]]; then
    return
  elif [[ "$(which brew)" != "" ]]; then
    echo "Homebrew is already installed: $(brew -v)"
    return
  fi
  echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  if [[ "$(which brew)" == "" ]]; then
    echo; echo
    echo "Homebrew installation failed. Your Mac may not be configured for development."
    echo "Contact your IT administrator for assistance."
    echo; echo
    exit 1
  fi
}

install_wget() {
  if [[ "$(which wget)" != "" ]]; then
    echo "wget is already installed: $(wget --version | head -1)"
    return
  fi
  echo "Installing wget..."
  case $(uname) in
    Darwin)
      brew install wget
      ;;
    Linux)
      sudo apt update
      sudo apt install -y wget
      ;;
    *)
      echo "Unsupported OS $(uname)"
      exit -1
  esac
}

install_python() {
  if [[ "$(which python3)" != "" ]]; then
    echo "Python is already installed: $(python3 -V)"
    return
  fi
  echo "Installing Python..."
  case $(uname) in
    Darwin)
      brew install python@3.11
      ;;
    Linux)
      sudo apt update
      sudo add-apt-repository ppa:deadsnakes/ppa -y
      sudo apt update
      sudo apt install -y python3.11
      sudo apt install -y python3-pip
      ;;
    *)
      echo "Unsupported OS $(uname)"
      exit -1
  esac
}

install_pipx() {
  if [[ "$(which pipx)" != "" ]]; then
    echo "pipx is already installed: pipx $(pipx --version)"
    return
  fi
  echo "Installing pipx..."
  case $(uname) in
    Darwin)
      brew install python3-pip
      brew install pipx
      ;;
    Linux)
      sudo apt install -y python3-pip
      sudo apt install -y pipx
      ;;
    *)
      echo "Unsupported OS $(uname)"
      exit -1
  esac
}

install_pkgmgr() {
  if [[ "$(which uv)" ]]; then
    uv sync
    PKGMGR=uv
  elif [[ "$(which poetry)" ]]; then
    poetry update
    PKGMGR=poetry
  else
    echo "No package manager found - installing uv..."
    pipx install uv
    pipx ensurepath
    uv sync
    PKMGR=uv
  fi
}

install_agentguard() {
  if [ ! -d "./agent-guard" ]; then
    git clone git@github.com:cyberark/agent-guard.git
  fi
  if [ ! -d "./agent-guard" ]; then
    echo "Agent Guard repo not cloned. Check git configuration."
    exit -1
  fi
}

main $@
