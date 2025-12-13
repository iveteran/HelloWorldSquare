from openai import OpenAI
client = OpenAI()

response = client.responses.create(
    model="gpt-5-nano",
    input="请讲解一下什么是LLM."
)

print(response.output_text)
