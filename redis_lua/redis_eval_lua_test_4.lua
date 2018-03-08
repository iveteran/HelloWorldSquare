local current
current = redis.call("incr", KEYS[1])
if tonumber(current) == 1 then
    redis.call("expire", KEYS[1], ARGV[1])
end
return current

-- usage:
--   1. Load this Lua script to Redis sever, will got SHA of script:
--   bash$ redis-cli script load "$(cat ./lua_scripts/incr_expire.lua)"
--           "c66336b7791deec6d5cd204640eb9a4c56387844" 
--
--   2. Run script with Redis command evalsha:
--   bash$ redis-cli evalsha c66336b7791deec6d5cd204640eb9a4c56387844 1 YOUR_KEY EXPIRE_SECONDS
--      OR redis> evalsha c66336b7791deec6d5cd204640eb9a4c56387844 1 YOUR_KEY EXPIRE_SECONDS
