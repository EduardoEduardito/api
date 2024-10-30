#!/bin/bash

# Exibe uma mensagem de início do processo de configuração
echo "Iniciando a instalação do Chrome e do ChromeDriver..."

# Cria o diretório para Chrome e ChromeDriver
mkdir -p /opt/render/project/.render/chrome

# Baixa o Google Chrome para Linux e instala no diretório personalizado
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -O chrome.deb
dpkg -x chrome.deb /opt/render/project/.render/chrome
rm chrome.deb

# Define a variável de versão do Chrome instalada para garantir compatibilidade com o ChromeDriver
CHROME_VERSION=$( /opt/render/project/.render/chrome/opt/google/chrome/chrome --version | grep -oP "\d+\.\d+\.\d+")

# Baixa o ChromeDriver correto compatível com a versão do Chrome instalada
CHROMEDRIVER_VERSION=$(curl -sS "https://googlechromelabs.github.io/chrome-for-testing/known-good-versions-with-downloads.json" | grep -oP "${CHROME_VERSION}.\d+" | head -1)
wget https://edgedl.me.gvt1.com/edgedl/chrome/chrome-for-testing/${CHROMEDRIVER_VERSION}/linux64/chromedriver-linux64.zip -O chromedriver.zip
unzip chromedriver.zip -d /opt/render/project/.render/chrome/
rm chromedriver.zip
chmod +x /opt/render/project/.render/chrome/chromedriver

# Instala as dependências do Python
pip install -r requirements.txt

echo "Configuração concluída com sucesso!"
