local msg = "Hello, " .. ARGV[1]
return msg

-- Usage:
--   redis-cli --eval your_script.lua KEYS[1] KEYS[2] ... KEYS[N] , ARGV[1] ARGV[2] ... ARGV[N]
--   redis-cli --eval hello.lua , world
