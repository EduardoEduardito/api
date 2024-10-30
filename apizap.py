from fastapi import FastAPI, HTTPException
from selenium import webdriver
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.common.by import By
from selenium.webdriver.chrome.options import Options
from io import BytesIO
import requests
from PIL import Image
from fastapi.responses import StreamingResponse

app = FastAPI()

# Configura o Selenium em modo headless (sem abrir o navegador visualmente)
chrome_options = Options()
chrome_options.add_argument("--headless")
chrome_options.add_argument("--no-sandbox")
chrome_options.add_argument("--disable-dev-shm-usage")
chrome_options.binary_location = "/opt/render/project/.render/chrome/chrome-linux64/chrome"  # Caminho para o Chrome
chrome_service = Service(executable_path="/opt/render/project/.render/chrome/chromedriver-linux64/chromedriver")  # Caminho para o ChromeDriver

@app.post("/get_profile_picture")
async def get_profile_picture(phone: str):
    # Monta a URL de WhatsApp API com o número de telefone fornecido
    whatsapp_url = f"https://api.whatsapp.com/send?phone={phone}"
    
    # Inicializa o driver do Selenium
    driver = webdriver.Chrome(service=chrome_service, options=chrome_options)
    try:
        # Carrega a página da URL do WhatsApp
        driver.get(whatsapp_url)
        
        # Espera o carregamento completo da imagem de perfil (tempo de espera ajustável)
        driver.implicitly_wait(10)
        
        # Localiza a imagem de perfil pelo seletor CSS
        profile_picture_element = driver.find_element(By.CSS_SELECTOR, 'img._9vx6')
        img_url = profile_picture_element.get_attribute("src")
        
        # Faz o download da imagem de perfil
        response = requests.get(img_url)
        if response.status_code != 200:
            raise HTTPException(status_code=404, detail="Imagem de perfil não encontrada.")
        
        # Converte a imagem para um buffer de BytesIO para o envio
        image = Image.open(BytesIO(response.content))
        buffer = BytesIO()
        image.save(buffer, format="JPEG")
        buffer.seek(0)
        
        # Retorna a imagem como resposta
        return StreamingResponse(buffer, media_type="image/jpeg")
    
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
    finally:
        driver.quit()
