from openai import OpenAI
client = OpenAI()

response = client.responses.create(
    #model="gpt-5", # 卡顿，长时间无返回
    model="gpt-5-mini",
    #model="gpt-4.1",
    tools=[{"type": "web_search"}],
    input="请问今天有什么热门的新闻故事?"
)

print(response.output_text)
