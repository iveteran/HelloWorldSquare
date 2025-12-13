from PIL import Image
from google import genai

client = genai.Client()

image = Image.open("/home/yuu/Pictures/IMG_1614.jpeg")
response = client.models.generate_content(
    model="gemini-2.5-flash",
    contents=[image, "告诉我这是什么动物"]
)
print(response.text)

