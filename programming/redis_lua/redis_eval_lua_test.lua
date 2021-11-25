-- test lua script of redis
--
local msg_list_key = 'user_mailbox:' .. KEYS[1] .. ':*'
--redis.log(redis.LOG_WARNING, 'msg_list_key:', msg_list_key)

local msg_keys = redis.call('keys', msg_list_key)

local msg_list = {}
for idx, msg_key in ipairs(msg_keys)
do
    local msg = redis.call('get', msg_key)
    table.insert(msg_list, msg)
    --redis.log(redis.LOG_WARNING, 'msg_key:', msg_key, 'msg:', msg)
end

return msg_list


-- 
-- usage:
--   1. Load this Lua script to Redis sever, will got SHA of script:
--   bash$ redis-cli script load "$(cat ./redis_eval_lua_test.lua)"
--           "e62f32a26a9dd63173e8ea70f09b3b03b81dd2af" 
--
--   2. Run script with Redis command evalsha:
--   bash$ redis-cli evalsha e62f32a26a9dd63173e8ea70f09b3b03b81dd2af 1 2
--      OR redis> evalsha e62f32a26a9dd63173e8ea70f09b3b03b81dd2af 1 2
