#!/usr/bin/env python3
"""
filter2_titled.py — 带标题栏的 listings（显示语言名）
效果：代码块顶部有灰色标题栏，显示语言名称（如 "bash"）
使用：pandoc input.md --filter=filter2_titled.py --pdf-engine=xelatex -o out.pdf
"""

import sys
import json

LANG_MAP = {
    "bash": "bash", "sh": "bash", "shell": "bash",
    "python": "Python", "py": "Python",
    "c": "C", "cpp": "C++", "c++": "C++",
    "java": "Java", "javascript": "Java", "js": "Java",
    "ruby": "Ruby", "perl": "Perl", "sql": "SQL",
    "xml": "XML", "html": "HTML",
    "tex": "TeX", "latex": "TeX",
    "r": "R", "make": "make", "php": "PHP",
}

HEADER = r"""
\usepackage{listings}
\usepackage{xcolor}

% 标题栏颜色
\definecolor{codebg}{RGB}{245,245,245}
\definecolor{titlebg}{RGB}{70,130,180}
\definecolor{titlefg}{RGB}{255,255,255}

\lstdefinestyle{titled}{
  basicstyle=\ttfamily\small,
  keywordstyle=\bfseries\color{blue!70!black},
  commentstyle=\itshape\color{green!50!black},
  stringstyle=\color{red!60!black},
  showstringspaces=false,
  breaklines=true,
  backgroundcolor=\color{codebg},
  frame=tb,
  framerule=0pt,
  numbers=left,
  numberstyle=\tiny\color{gray},
  numbersep=8pt,
  xleftmargin=12pt,
}
"""


def make_raw_latex(tex: str) -> dict:
    return {"t": "RawBlock", "c": ["latex", tex]}


def make_header_meta(meta: dict) -> dict:
    entry = {"t": "MetaInlines", "c": [{"t": "RawInline", "c": ["latex", HEADER]}]}
    hi = meta.get("header-includes")
    if hi is None:
        meta["header-includes"] = {"t": "MetaList", "c": [entry]}
    elif hi["t"] == "MetaList":
        hi["c"].append(entry)
    else:
        meta["header-includes"] = {"t": "MetaList", "c": [hi, entry]}
    return meta


def walk_blocks(blocks: list) -> list:
    result = []
    for block in blocks:
        t = block.get("t")
        if t == "CodeBlock":
            attr, code = block["c"]
            classes = attr[1]
            lang = classes[0] if classes else ""
            listings_lang = LANG_MAP.get(lang.lower(), "")
            display_name = lang if lang else "code"

            # 标题栏：用 \colorbox 模拟
            title_bar = (
                r"\noindent\colorbox{titlebg}{"
                r"\makebox[\linewidth][l]{"
                r"\textcolor{titlefg}{\ttfamily\small\bfseries\ " +
                display_name +
                r"}}}"
            )

            lang_opt = f"language={listings_lang}," if listings_lang else ""
            listing = (
                f"\\begin{{lstlisting}}[{lang_opt}style=titled]\n"
                f"{code}\n"
                f"\\end{{lstlisting}}"
            )

            tex = title_bar + "\n" + listing
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
