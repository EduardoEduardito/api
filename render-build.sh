#!/bin/bash

# Cria o diretório para Chrome
mkdir -p /opt/render/project/.render/chrome

# Baixa o Google Chrome para Linux
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -O chrome.deb
dpkg -x chrome.deb /opt/render/project/.render/chrome
rm chrome.deb

# Baixa o ChromeDriver correto para Linux
CHROMEDRIVER_VERSION=$(curl -sS chromedriver.storage.googleapis.com/LATEST_RELEASE)
wget https://chromedriver.storage.googleapis.com/${CHROMEDRIVER_VERSION}/chromedriver_linux64.zip -O chromedriver.zip
unzip chromedriver.zip -d /opt/render/project/.render/chrome/
rm chromedriver.zip
chmod +x /opt/render/project/.render/chrome/chromedriver

# Instala as dependências do Python
pip install -r requirements.txt
