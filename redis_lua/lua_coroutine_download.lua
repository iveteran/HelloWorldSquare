require "socket"

function receive(connection)
    connection:timeout(0)   -- do not block
    local s,status=connection:receive(2^10)
    if status=="timeout" then
        coroutine.yield(connection)
    end 
    return s, status
end

function download(host, file)
    local c=assert(socket.connection(host, 80))
    local count = 0
    c:send("GET" .. file .. " HTTP/1.0\r\n\r\n")
    while true do
        local s, status=receive(c)
        count=count+string.len(s)
        if status=="closed" then break end
    end 
    c:close()
    print(file, count)
end

threads = {}
function get(host, file)
    local co=coroutine.create(function()
                download(host, file)
            end)

    table.insert(threads, co)
end

function dispatcher()
    while true do
        local n=#threads
        if n==0 then break end 
        local connections={}
        for i=1,n do
            local status,res=coroutine.resume(threads[i])
            if not res then         -- finish
                table.remove(threads, i)
                break
            else    -- timeout
                table.insert(connections, res)
            end
        end

        if #connections == n then
            socket.select(connections)
        end
    end
end

host="http://news.baidu.com/"
get(host, "/sports")
get(host, "/internet")
get(host, "/tech")
dispatcher()
