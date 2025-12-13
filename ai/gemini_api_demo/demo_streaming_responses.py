from google import genai

client = genai.Client()

response = client.models.generate_content_stream(
    model="gemini-2.5-flash",
    contents=["Explain how LLM works"]
)
for chunk in response:
    print(chunk.text, end="")

