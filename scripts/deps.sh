#!/usr/bin/env bash


if [ -f /etc/os-release ]; then
  . /etc/os-release
  if [[ "$ID" == "ubuntu" || "$ID" == "debian" ]]; then
    echo "System is $PRETTY_NAME"
    sudo apt install ffmpeg libxcb-xinerama0
  else
    echo "System is not Ubuntu or Debian"
  fi
else
  echo "Cannot determine OS"
fi

python -m pip install --upgrade pip

install_cpu_dependencies() {
  pip install --extra-index-url https://download.pytorch.org/whl/cpu --requirement requirements.txt
}

install_cuda_dependencies() {
  pip install --requirement requirements.txt
  pip install git+https://github.com/Dao-AILab/flash-attention.git
}

# Check if nvidia-smi is available
if command -v nvidia-smi &> /dev/null; then
  # Check if nvidia-smi runs successfully
  if nvidia-smi &> /dev/null; then
    # CUDA is available
    install_cuda_dependencies
  else
    # nvidia-smi is present, but not functioning properly
    install_cpu_dependencies
  fi
else
  # CUDA is not available (nvidia-smi not found)
  install_cpu_dependencies
fi
