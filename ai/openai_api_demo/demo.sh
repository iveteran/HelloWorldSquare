curl https://api.openai.com/v1/responses \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $OPENAI_API_KEY" \
  -X POST \
  -d '{
    "model": "gpt-5.2",
    "input": "请讲解一下LLM的原理."
  }' | jq
