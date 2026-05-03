#!/usr/bin/env python3
"""
graph-easy.py — Pandoc JSON filter (Python)
等价于 graph-easy.lua，处理两种 graph-easy 代码块写法：

情况1：直接的 fenced block（info string 方式）
    ~~~graph-easy --as=boxart
    [ A ] - to -> [ B ]
    ~~~

情况2：普通代码块内嵌套 ~~~graph-easy 块
    ```
    ~~~graph-easy --as=boxart
    [ A ] - to -> [ B ]
    ~~~
    ```

用法：
    pandoc input.md --filter=graph-easy.py -o output.pdf
"""

import sys
import json
import re
import tempfile
import os
import subprocess


def run_graph_easy(args: str, body: str) -> str:
    """调用 graph-easy 命令，返回渲染结果字符串。"""
    with tempfile.NamedTemporaryFile(mode="w", suffix=".txt", delete=False) as fin:
        fin.write(body)
        tmp_in = fin.name

    tmp_out = tempfile.mktemp(suffix=".txt")

    try:
        cmd = f"graph-easy {args} --input={tmp_in} --output={tmp_out}"
        subprocess.run(cmd, shell=True, stderr=subprocess.DEVNULL)

        if os.path.exists(tmp_out):
            with open(tmp_out, "r") as f:
                return f.read()
        else:
            return "[graph-easy error: no output]"
    except Exception as e:
        return f"[graph-easy error: {e}]"
    finally:
        os.remove(tmp_in)
        if os.path.exists(tmp_out):
            os.remove(tmp_out)


def make_code_block(text: str) -> dict:
    """构造 Pandoc AST CodeBlock 节点。"""
    return {
        "t": "CodeBlock",
        "c": [["", [], []], text]
    }


def process_nested(text: str) -> list | None:
    """
    扫描普通 CodeBlock 的文本，查找嵌套的 ~~~graph-easy 块。
    有匹配时返回替换后的 Block 列表，无匹配返回 None。
    """
    pattern = re.compile(
        r'~~~graph-easy([^\n]*)\n(.*?)\n~~~',
        re.DOTALL
    )

    blocks = []
    pos = 0
    changed = False

    for m in pattern.finditer(text):
        # graph-easy 块之前的普通文本
        before = text[pos:m.start()].strip()
        if before:
            blocks.append(make_code_block(before))

        args = m.group(1).strip()
        body = m.group(2)

        print(f"[graph-easy.py] args={args!r} body={body!r}", file=sys.stderr)

        result = run_graph_easy(args, body)
        blocks.append(make_code_block(result))

        changed = True
        pos = m.end()

    if not changed:
        return None

    # 末尾剩余文本
    remaining = text[pos:].strip()
    if remaining:
        blocks.append(make_code_block(remaining))

    return blocks


def walk_blocks(blocks: list) -> list:
    """
    遍历 Block 列表，递归处理容器节点，转换 CodeBlock。

    Pandoc AST Block 类型结构：
      CodeBlock   c: [Attr, str]
      BulletList  c: [[Block]]              每个元素是一个 item（Block 列表）
      OrderedList c: [ListAttr, [[Block]]]  同上
      BlockQuote  c: [Block]
      Div         c: [Attr, [Block]]
    """
    result = []

    for block in blocks:
        t = block.get("t")

        # ── CodeBlock ──────────────────────────────────────────
        if t == "CodeBlock":
            attr, text = block["c"]
            classes = attr[1] if len(attr) > 1 else []

            # 情况1：info string 直接以 graph-easy 开头
            if classes and classes[0] == "graph-easy":
                args = " ".join(classes[1:])
                print(f"[graph-easy.py] args={args!r} body={text!r}", file=sys.stderr)
                rendered = run_graph_easy(args, text)
                result.append(make_code_block(rendered))
                continue

            # 情况2：普通 CodeBlock 内嵌套 ~~~graph-easy
            nested = process_nested(text)
            if nested is not None:
                result.extend(nested)
                continue

            # 无匹配，原样保留
            result.append(block)

        # ── BulletList  c: [[Block]] ───────────────────────────
        # block["c"] 是列表的列表，每个子列表是一个列表项的 Block 列表
        elif t == "BulletList":
            block["c"] = [walk_blocks(item) for item in block["c"]]
            result.append(block)

        # ── OrderedList  c: [ListAttr, [[Block]]] ─────────────
        elif t == "OrderedList":
            list_attr, items = block["c"]
            block["c"] = [list_attr, [walk_blocks(item) for item in items]]
            result.append(block)

        # ── BlockQuote  c: [Block] ─────────────────────────────
        elif t == "BlockQuote":
            block["c"] = walk_blocks(block["c"])
            result.append(block)

        # ── Div  c: [Attr, [Block]] ────────────────────────────
        elif t == "Div":
            attr, inner = block["c"]
            block["c"] = [attr, walk_blocks(inner)]
            result.append(block)

        else:
            result.append(block)

    return result


def main():
    doc = json.load(sys.stdin)

    # Pandoc AST 顶层结构：{"pandoc-api-version":..., "meta":..., "blocks":[...]}
    doc["blocks"] = walk_blocks(doc["blocks"])

    json.dump(doc, sys.stdout)


if __name__ == "__main__":
    main()
