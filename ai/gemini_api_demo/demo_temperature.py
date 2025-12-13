from google import genai
from google.genai import types

client = genai.Client()

response = client.models.generate_content(
    model="gemini-2.5-flash",
    contents=["请讲解一下大语言模型的工作原理"],
    config=types.GenerateContentConfig(
        temperature=0.1
    )
)
print(response.text)

