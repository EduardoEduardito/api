#!/bin/bash

# Cria uma pasta temporária para o Google Chrome dentro do ambiente do Render
mkdir -p /opt/render/project/.render/chrome

# Baixa e instala o Google Chrome
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
dpkg -x google-chrome-stable_current_amd64.deb /opt/render/project/.render/chrome
rm google-chrome-stable_current_amd64.deb

# Instala pacotes do Python (por exemplo, FastAPI e Selenium)
pip install -r requirements.txt