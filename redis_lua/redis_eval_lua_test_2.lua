local link_id = redis.call("INCR", KEYS[1])
redis.call("HSET", KEYS[2], link_id, ARGV[1])
return link_id

-- usage:
--   method 1):
--     redis-cli --eval redis_eval_lua_test_2.lua links:counter links:urls , http://malcolmgladwellbookgenerator.com/
--
--   method 2):
--     Like comments of redis_eval_lua_test.lua
