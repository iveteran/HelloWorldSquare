-- graph-easy.lua
-- 处理普通 CodeBlock 内嵌套的 ~~~graph-easy 语法
-- 例如：
--   ```
--   ~~~graph-easy --as=boxart
--   [ A ] - to -> [ B ]
--   ~~~
--   ```

local function run_graph_easy(args, input)
  local tmpIn  = os.tmpname()
  local tmpOut = os.tmpname()

  local f = io.open(tmpIn, "w")
  f:write(input)
  f:close()

  local cmd = string.format(
    "graph-easy %s --input=%s --output=%s 2>/dev/null",
    args, tmpIn, tmpOut
  )
  os.execute(cmd)

  local out = io.open(tmpOut)
  local result = out and out:read("*a") or "[graph-easy error]"
  if out then out:close() end

  os.remove(tmpIn)
  os.remove(tmpOut)

  return result
end

-- 情况1：直接的 graph-easy fenced block（info string 方式）
--   ~~~graph-easy --as=boxart
--   [ A ] - to -> [ B ]
--   ~~~
function CodeBlock(block)
  local first_class = block.classes[1] or ""

  -- 情况1：info string 直接是 graph-easy
  if first_class:match("^graph%-easy") then
    local args = ""
    for i = 2, #block.classes do
      args = args .. " " .. block.classes[i]
    end
    local result = run_graph_easy(args, block.text)
    return pandoc.CodeBlock(result)
  end

  -- 情况2：普通 CodeBlock 内容里包含 ~~~graph-easy 块
  -- 匹配：~~~graph-easy [可选参数]\n...内容...\n~~~
  local text = block.text
  local changed = false
  local blocks = {}

  local pos = 1
  while pos <= #text do
    -- 查找 ~~~graph-easy 开始行
    local s, e, args, body_start =
      text:find("~~~graph%-easy([^\n]*)\n()", pos)

    if not s then
      -- 没有更多 graph-easy 块，剩余文本原样保留
      local remaining = text:sub(pos)
      if #remaining > 0 then
        table.insert(blocks, pandoc.CodeBlock(remaining))
      end
      break
    end

    -- 保留 graph-easy 块之前的普通文本
    if s > pos then
      local before = text:sub(pos, s - 1)
      -- 去掉首尾空行
      before = before:match("^%s*(.-)%s*$")
      if #before > 0 then
        table.insert(blocks, pandoc.CodeBlock(before))
      end
    end

    -- 查找对应的结束 ~~~
    local end_s, end_e = text:find("\n~~~", body_start)
    if not end_s then
      -- 没找到结束标记，当普通文本处理
      table.insert(blocks, pandoc.CodeBlock(text:sub(s)))
      break
    end

    local graph_body = text:sub(body_start, end_s - 1)
    local graph_args = args:match("^%s*(.-)%s*$")  -- trim

    io.stderr:write(string.format(
      "[graph-easy.lua] args=%q body=%q\n", graph_args, graph_body))

    local result = run_graph_easy(graph_args, graph_body)
    table.insert(blocks, pandoc.CodeBlock(result))

    changed = true
    pos = end_e + 1
  end

  if not changed then
    return nil  -- 没有 graph-easy 块，原样返回
  end

  -- 如果只有一个块直接返回，否则返回多个块
  if #blocks == 1 then
    return blocks[1]
  else
    return blocks
  end
end
