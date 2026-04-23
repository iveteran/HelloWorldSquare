#!/usr/bin/env python3
"""
filter1_basic.py — 最基础的 listings 封装
效果：将代码块转为 \begin{lstlisting}[language=X] ... \end{lstlisting}
使用：pandoc input.md --filter=filter1_basic.py --pdf-engine=xelatex -o out.pdf
"""

import sys
import json

# Pandoc info string → listings language 映射
LANG_MAP = {
    "bash": "bash",
    "sh": "bash",
    "shell": "bash",
    "python": "Python",
    "py": "Python",
    "c": "C",
    "cpp": "C++",
    "c++": "C++",
    "java": "Java",
    "javascript": "Java",  # listings 无 JS，用 Java 近似
    "js": "Java",
    "ruby": "Ruby",
    "perl": "Perl",
    "sql": "SQL",
    "xml": "XML",
    "html": "HTML",
    "tex": "TeX",
    "latex": "TeX",
    "r": "R",
    "make": "make",
    "php": "PHP",
}

# 注入到 LaTeX header 的 listings 基础配置
HEADER = r"""
\usepackage{listings}
\usepackage{xcolor}
\lstset{
  basicstyle=\ttfamily\small,
  keywordstyle=\bfseries\color{blue!70!black},
  commentstyle=\itshape\color{green!50!black},
  stringstyle=\color{red!60!black},
  showstringspaces=false,
  breaklines=true,
  frame=single,
}
"""


def make_raw_latex(tex: str) -> dict:
    return {"t": "RawBlock", "c": ["latex", tex]}


def make_header_meta(current_meta: dict) -> dict:
    """将 HEADER 追加到文档 header-includes 元数据。"""
    entry = {
        "t": "MetaInlines",
        "c": [{"t": "RawInline", "c": ["latex", HEADER]}]
    }
    hi = current_meta.get("header-includes")
    if hi is None:
        current_meta["header-includes"] = {"t": "MetaList", "c": [entry]}
    elif hi["t"] == "MetaList":
        hi["c"].append(entry)
    else:
        current_meta["header-includes"] = {"t": "MetaList", "c": [hi, entry]}
    return current_meta


def walk_blocks(blocks: list) -> list:
    result = []
    for block in blocks:
        t = block.get("t")
        if t == "CodeBlock":
            attr, code = block["c"]
            classes = attr[1]
            lang = classes[0] if classes else ""
            listings_lang = LANG_MAP.get(lang.lower(), "")

            lang_opt = f"language={listings_lang}" if listings_lang else ""
            tex = f"\\begin{{lstlisting}}[{lang_opt}]\n{code}\n\\end{{lstlisting}}"
            result.append(make_raw_latex(tex))
        elif t == "BulletList":
            block["c"] = [walk_blocks(item) for item in block["c"]]
            result.append(block)
        elif t == "OrderedList":
            la, items = block["c"]
            block["c"] = [la, [walk_blocks(item) for item in items]]
            result.append(block)
        elif t == "BlockQuote":
            block["c"] = walk_blocks(block["c"])
            result.append(block)
        elif t == "Div":
            attr, inner = block["c"]
            block["c"] = [attr, walk_blocks(inner)]
            result.append(block)
        else:
            result.append(block)
    return result


def main():
    doc = json.load(sys.stdin)
    doc["meta"] = make_header_meta(doc.get("meta", {}))
    doc["blocks"] = walk_blocks(doc["blocks"])
    json.dump(doc, sys.stdout)


if __name__ == "__main__":
    main()
