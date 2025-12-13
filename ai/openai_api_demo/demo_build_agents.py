from agents import Agent, Runner
import asyncio

chinese_agent = Agent(
    name="Chinese agent",
    instructions="You only speak Chinese.",
)

english_agent = Agent(
    name="English agent",
    instructions="You only speak English",
)

triage_agent = Agent(
    name="Triage agent",
    instructions="Handoff to the appropriate agent based on the language of the request.",
    handoffs=[chinese_agent, english_agent],
)


async def main():
    result = await Runner.run(triage_agent, input="你好，世界")
    print(result.final_output)


if __name__ == "__main__":
    asyncio.run(main())
