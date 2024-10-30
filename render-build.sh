#!/bin/bash

# Cria o diretório para instalar o Chrome e o ChromeDriver
mkdir -p /opt/render/project/.render/chrome

# Baixa a versão específica do Google Chrome
wget https://storage.googleapis.com/chrome-for-testing-public/130.0.6723.69/linux64/chrome-linux64.zip -O chrome.zip
unzip chrome.zip -d /opt/render/project/.render/chrome
rm chrome.zip

# Define o caminho para o executável do Chrome
chmod +x /opt/render/project/.render/chrome/chrome-linux64/chrome
ln -s /opt/render/project/.render/chrome/chrome-linux64/chrome /opt/render/project/.render/chrome/chrome

# Baixa a versão específica do ChromeDriver
wget https://storage.googleapis.com/chrome-for-testing-public/130.0.6723.69/linux64/chromedriver-linux64.zip -O chromedriver.zip
unzip chromedriver.zip -d /opt/render/project/.render/chrome/
rm chromedriver.zip

# Define permissões para o ChromeDriver
chmod +x /opt/render/project/.render/chrome/chromedriver-linux64/chromedriver
ln -s /opt/render/project/.render/chrome/chromedriver-linux64/chromedriver /opt/render/project/.render/chrome/chromedriver

# Instala as dependências do Python
pip install -r requirements.txt
