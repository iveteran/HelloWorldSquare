file = io.open("lua_io_test.lua", "a")

-- 设置默认输出文件为 lua_io_test.lua
io.output(file)

-- 在文件最后一行添加 Lua 注释
io.write("--  lua_io_test.lua 文件末尾注释\n")

-- 关闭打开的文件
io.close(file)
--  lua_io_test.lua 文件末尾注释
--  lua_io_test.lua 文件末尾注释
