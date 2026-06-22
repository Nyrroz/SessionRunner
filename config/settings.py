import os
from dotenv import load_dotenv

load_dotenv()

USERNAME = os.getenv("USERNAME")
PASSWORD = os.getenv("PASSWORD")

# headless=False utile en local pour debug visuel, True obligatoire sur VPS (pas d'écran)
HEADLESS = os.getenv("HEADLESS", "true").lower() == "true"