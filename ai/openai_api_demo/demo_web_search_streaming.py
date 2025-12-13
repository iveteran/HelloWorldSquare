from openai import OpenAI
client = OpenAI()

with client.responses.stream(
    model="gpt-4.1",
    tools=[{"type": "web_search"}],
    input="请问今天有什么热门的新闻故事?"
) as stream:
    for event in stream:
        print(event)
