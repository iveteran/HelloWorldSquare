# sl=en: Source language
# tl=zh: Target language
# dt=t:  Translation
# dt=ld: Pronunciation for source language 
# dt=rm: Pronunciation for target language
# dt=bd: Dictionary entries
# dt=md: Definitions
# dt=ss: Synonyms
# dt=ex: Examples
curl -s "https://translate.googleapis.com/translate_a/single?client=gtx&sl=en&tl=zh&dt=t&dt=rm&dt=ld&q=hello" | jq

#curl -s "https://translate.googleapis.com/translate_a/single?client=gtx&sl=en&tl=zh&dt=t&dt=rm&dt=ld&dt=bd&dt=md&dt=ss&dt=ex&q=hello" | jq

#curl -s "http://translate.googleapis.com/translate_a/single?client=gtx&ie=UTF-8&oe=UTF-8&dt=bd&dt=ex&dt=ld&dt=md&dt=rw&dt=rm&dt=ss&dt=t&dt=at&dt=gt&dt=qca&sl=en&tl=zh-CN&hl=en&q=hello" | jq
