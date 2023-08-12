# Ref: https://www.cnblogs.com/botai/p/python_chatgpt_api.html
import requests
import os,json

# 设置 API 密钥和 API URL
apikey = "xxxx"  #
url = "https://api.openai.com/v1/chat/completions"

# 设置请求头
headers = {
        "Content-Type": "application/json",
        "Authorization": "Bearer " + apikey,
        }
        
# 设置请求体
prompt = "3+3=?"
field = {
    "model":"gpt-3.5-turbo",
    "messages":[
        # {"role": "system", "content": "You are a helpful assistant."},
        {"role": "user", "content": prompt},
        # {"role": "assistant", "content": "https://www.cnblogs.com/botai/"}
    ]
}

# 发送 HTTP POST 请求
response = requests.post(url, headers=headers, data=json.dumps(field))

#proxies = {
#        "http":"http://198.11.175.192:7302"
#        }
# response = requests.post(url, headers=headers, proxies=proxies, data=json.dumps(field)) #使用代理

# 解析响应结果
result = response.json()
print(result)
print(result["choices"][0]["message"]["content"].strip())
