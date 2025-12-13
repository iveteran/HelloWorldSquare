from google import genai

client = genai.Client()

response = client.models.generate_content(
    model="gemini-3-pro-preview",
    contents="请解析一下AI agent的原理",
)

print(response.text)
