
from PIL import Image
import os

img = Image.open("assets/images/logo.jpg").convert("RGBA")

os.makedirs("web/icons", exist_ok=True)

img.resize((32, 32),   Image.LANCZOS).save("web/favicon.png")
img.resize((192, 192), Image.LANCZOS).save("web/icons/Icon-192.png")
img.resize((512, 512), Image.LANCZOS).save("web/icons/Icon-512.png")
img.resize((192, 192), Image.LANCZOS).save("web/icons/Icon-maskable-192.png")
img.resize((512, 512), Image.LANCZOS).save("web/icons/Icon-maskable-512.png")

print("✅ Done!")
