# Ref: https://www.cnblogs.com/botai/p/python_chatgpt_api.html
import openai

prompt = "2+2=?"
# 设置 API 密钥
apikey = "xxxx"  #

# 调用 ChatGPT
response = openai.ChatCompletion.create(
            model="gpt-3.5-turbo",
            messages=[
                # {"role": "system", "content": "You are a helpful assistant."},
                {"role": "user", "content": prompt},
                # {"role": "assistant", "content": "https://www.cnblogs.com/botai/"},
            ],
            temperature=0.2,
        )

# 输出响应结果
# print(response)
answer = response.choices[0].message.content.strip()
print(answer)
