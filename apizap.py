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

# Configura o Selenium em modo headless
chrome_options = Options()
chrome_options.add_argument("--headless")
chrome_options.add_argument("--no-sandbox")
chrome_options.add_argument("--disable-dev-shm-usage")
chrome_options.binary_location = "/opt/render/project/.render/chrome/opt/google/chrome/chrome"  # Caminho para o binário do Chrome

# Define o caminho explícito para o ChromeDriver
chrome_service = Service("/opt/render/project/.render/chrome/chromedriver")

@app.post("/get_profile_picture")
async def get_profile_picture(phone: str):
    whatsapp_url = f"https://api.whatsapp.com/send?phone={phone}"
    
    driver = webdriver.Chrome(service=chrome_service, options=chrome_options)
    try:
        driver.get(whatsapp_url)
        driver.implicitly_wait(10)
        
        profile_picture_element = driver.find_element(By.CSS_SELECTOR, 'img._9vx6')
        img_url = profile_picture_element.get_attribute("src")
        
        response = requests.get(img_url)
        if response.status_code != 200:
            raise HTTPException(status_code=404, detail="Imagem de perfil não encontrada.")
        
        image = Image.open(BytesIO(response.content))
        buffer = BytesIO()
        image.save(buffer, format="JPEG")
        buffer.seek(0)
        
        return StreamingResponse(buffer, media_type="image/jpeg")
    
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
    finally:
        driver.quit()
