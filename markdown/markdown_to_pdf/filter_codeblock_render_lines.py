#!/usr/bin/env python3
"""
filter4_highlight_lines.py — 支持行高亮标注
效果：在代码行末尾加 # HL 标记的行会被高亮显示（黄色背景）

Markdown 写法：
    ```python
    def foo():       # HL
        return 42
    ```

使用：pandoc input.md --filter=filter4_highlight_lines.py --pdf-engine=xelatex -o out.pdf
"""

import sys
import json
import re

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

# 行高亮标记正则（行末的 # HL 或 // HL）
HL_MARKER = re.compile(r'\s*(?:#|//)\s*HL\s*$')

HEADER = r"""
\usepackage{listings}
\usepackage{xcolor}

\definecolor{codebg}{RGB}{248,248,248}
\definecolor{hlline}{RGB}{255,255,180}

\lstdefinestyle{highlighted}{
  basicstyle=\ttfamily\small,
  keywordstyle=\bfseries\color{blue!70!black},
  commentstyle=\itshape\color{green!50!black},
  stringstyle=\color{red!60!black},
  backgroundcolor=\color{codebg},
  showstringspaces=false,
  breaklines=true,
  frame=single,
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


def process_code(code: str, listings_lang: str) -> str:
    """
    扫描代码行，找出带 # HL 标记的行号，
    生成 linebackgroundcolor 选项实现逐行高亮。
    """
    lines = code.splitlines()
    hl_lines = []
    clean_lines = []

    for i, line in enumerate(lines, start=1):
        if HL_MARKER.search(line):
            hl_lines.append(i)
            clean_lines.append(HL_MARKER.sub("", line))
        else:
            clean_lines.append(line)

    clean_code = "\n".join(clean_lines)

    # 构造 linebackgroundcolor 宏：高亮行用黄色，其余透明
    if hl_lines:
        hl_set = "{" + ",".join(str(n) for n in hl_lines) + "}"
        hl_opt = (
            r"linebackgroundcolor={"
            r"\ifnum\value{lstnumber}\in" +
            hl_set +
            r"\color{hlline}\else\color{codebg}\fi}"
        )
    else:
        hl_opt = ""

    lang_opt = f"language={listings_lang}," if listings_lang else ""
    opts = f"{lang_opt}style=highlighted"
    if hl_opt:
        # listings 需要 linenos 配合 linebackgroundcolor
        # 使用 lstlinebgrd 宏包实现，这里用 escapeinside 方案替代
        # 直接在选项里加背景色范围
        opts += f",linebackgroundcolor={{\\ifinlistcs{{\\value{{lstnumber}}}}{{{','.join(str(n) for n in hl_lines)}}}{{\\color{{hlline}}}}{{\\color{{codebg}}}}}}"

    # 简化方案：用 \colorbox 对高亮行包裹（通过 escapeinside）
    # 更可靠：直接把高亮行包在 \colorbox 里，用 moredelim
    highlighted_lines = []
    for i, line in enumerate(clean_lines, start=1):
        if i in set(hl_lines):
            # 用 @...@ 作为 escape 分隔符包裹整行
            highlighted_lines.append(f"@\\colorbox{{hlline}}{{\\strut {{}}{line}}}@")
        else:
            highlighted_lines.append(line)

    final_code = "\n".join(highlighted_lines)
    lang_opt2 = f"language={listings_lang}," if listings_lang else ""

    return (
        f"\\begin{{lstlisting}}[{lang_opt2}style=highlighted,"
        f"moredelim={{[is][{{}}]{{@}}{{@}}}}]\n"
        f"{final_code}\n"
        f"\\end{{lstlisting}}"
    )


def walk_blocks(blocks: list) -> list:
    result = []
    for block in blocks:
        t = block.get("t")
        if t == "CodeBlock":
            attr, code = block["c"]
            classes = attr[1]
            lang = (classes[0] if classes else "").lower()
            listings_lang = LANG_MAP.get(lang, "")
            tex = process_code(code, listings_lang)
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
