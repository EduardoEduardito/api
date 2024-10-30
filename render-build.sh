#!/bin/bash

# Instala o Chrome em uma pasta específica
mkdir -p /opt/render/project/.render/chrome
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
dpkg -x google-chrome-stable_current_amd64.deb /opt/render/project/.render/chrome
rm google-chrome-stable_current_amd64.deb

# Instala o ChromeDriver na mesma pasta
wget -O /opt/render/project/.render/chrome/chromedriver https://chromedriver.storage.googleapis.com/$(curl -sS chromedriver.storage.googleapis.com/LATEST_RELEASE)/chromedriver_linux64.zip
unzip /opt/render/project/.render/chrome/chromedriver_linux64.zip -d /opt/render/project/.render/chrome
chmod +x /opt/render/project/.render/chrome/chromedriver

# Instala as dependências do Python
pip install -r requirements.txt
