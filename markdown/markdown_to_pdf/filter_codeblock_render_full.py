#!/usr/bin/env python3
"""
filter5_full.py — 全功能 filter：标题栏 + 语言检测 + 行号 + 主题配色
效果：
  - 标题栏显示语言名，配色按语言类型分组
  - bash/shell：深色终端主题（黑底绿字）
  - python/ruby/perl：蓝色主题
  - c/c++/java：橙色主题
  - 其他：灰色默认主题
  - 无语言声明：简洁灰色块

使用：pandoc input.md --filter=filter5_full.py --pdf-engine=xelatex -o out.pdf
"""

import sys
import json

# ── 语言配置 ──────────────────────────────────────────────────────────────────

LANG_MAP = {
    "bash": ("bash",    "shell"),
    "sh":   ("bash",    "shell"),
    "shell":("bash",    "shell"),
    "python":("Python", "scripting"),
    "py":   ("Python",  "scripting"),
    "ruby": ("Ruby",    "scripting"),
    "perl": ("Perl",    "scripting"),
    "c":    ("C",       "systems"),
    "cpp":  ("C++",     "systems"),
    "c++":  ("C++",     "systems"),
    "java": ("Java",    "systems"),
    "sql":  ("SQL",     "data"),
    "xml":  ("XML",     "data"),
    "html": ("HTML",    "data"),
    "tex":  ("TeX",     "other"),
    "latex":("TeX",     "other"),
    "r":    ("R",       "scripting"),
    "make": ("make",    "other"),
    "php":  ("PHP",     "scripting"),
    "javascript": ("Java", "scripting"),
    "js":   ("Java",    "scripting"),
}

# 每个分组对应的标题栏颜色（RGB）
GROUP_COLORS = {
    "shell":     ("28,28,28",   "0,200,0"),      # 深色底，绿字
    "scripting": ("25,55,105",  "255,255,255"),   # 深蓝底，白字
    "systems":   ("140,60,20",  "255,255,255"),   # 深橙底，白字
    "data":      ("40,100,80",  "255,255,255"),   # 深绿底，白字
    "other":     ("80,80,80",   "255,255,255"),   # 灰底，白字
    "none":      ("100,100,100","255,255,255"),   # 无语言
}

# 每个分组对应的代码区背景色
BG_COLORS = {
    "shell":     "20,20,20",
    "scripting": "240,245,255",
    "systems":   "255,245,235",
    "data":      "240,255,248",
    "other":     "248,248,248",
    "none":      "248,248,248",
}

# 每个分组的关键字颜色
KW_COLORS = {
    "shell":     "0,220,0",
    "scripting": "30,100,200",
    "systems":   "180,80,20",
    "data":      "20,130,90",
    "other":     "80,80,160",
    "none":      "80,80,160",
}

# 每个分组的注释颜色
CM_COLORS = {
    "shell":     "100,180,100",
    "scripting": "100,140,100",
    "systems":   "150,100,60",
    "data":      "80,150,110",
    "other":     "120,120,120",
    "none":      "120,120,120",
}

# 每个分组的字符串颜色
STR_COLORS = {
    "shell":     "255,180,80",
    "scripting": "180,40,40",
    "systems":   "200,80,20",
    "data":      "40,160,120",
    "other":     "160,40,80",
    "none":      "160,40,80",
}

# 每个分组的基础字体颜色
FG_COLORS = {
    "shell":     "0,220,0",
    "scripting": "30,30,30",
    "systems":   "30,30,30",
    "data":      "30,30,30",
    "other":     "30,30,30",
    "none":      "30,30,30",
}


def build_header() -> str:
    """动态生成包含所有分组颜色定义的 LaTeX header。"""
    lines = [r"\usepackage{listings}", r"\usepackage{xcolor}", ""]

    for group, (bg_title, fg_title) in GROUP_COLORS.items():
        lines.append(f"\\definecolor{{titlebg{group}}}{{RGB}}{{{bg_title}}}")
        lines.append(f"\\definecolor{{titlefg{group}}}{{RGB}}{{{fg_title}}}")

    for group, rgb in BG_COLORS.items():
        lines.append(f"\\definecolor{{codebg{group}}}{{RGB}}{{{rgb}}}")
    for group, rgb in KW_COLORS.items():
        lines.append(f"\\definecolor{{kwcolor{group}}}{{RGB}}{{{rgb}}}")
    for group, rgb in CM_COLORS.items():
        lines.append(f"\\definecolor{{cmcolor{group}}}{{RGB}}{{{rgb}}}")
    for group, rgb in STR_COLORS.items():
        lines.append(f"\\definecolor{{strcolor{group}}}{{RGB}}{{{rgb}}}")
    for group, rgb in FG_COLORS.items():
        lines.append(f"\\definecolor{{fgcolor{group}}}{{RGB}}{{{rgb}}}")

    # 为每个分组定义 listings style
    for group in GROUP_COLORS:
        lines.append(f"""
\\lstdefinestyle{{style{group}}}{{
  basicstyle=\\ttfamily\\small\\color{{fgcolor{group}}},
  keywordstyle=\\bfseries\\color{{kwcolor{group}}},
  commentstyle=\\itshape\\color{{cmcolor{group}}},
  stringstyle=\\color{{strcolor{group}}},
  backgroundcolor=\\color{{codebg{group}}},
  showstringspaces=false,
  breaklines=true,
  frame=single,
  framerule=0.5pt,
  rulecolor=\\color{{titlebg{group}}},
  numbers=left,
  numberstyle=\\tiny\\color{{gray}},
  numbersep=8pt,
  xleftmargin=14pt,
  xrightmargin=4pt,
}}""")

    return "\n".join(lines)


HEADER = build_header()


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


def build_listing(code: str, lang_raw: str) -> str:
    """根据语言生成对应主题的 lstlisting LaTeX 代码。"""
    lang_lower = lang_raw.lower()

    if lang_lower in LANG_MAP:
        listings_lang, group = LANG_MAP[lang_lower]
        display_name = lang_raw
    else:
        listings_lang = ""
        group = "none"
        display_name = lang_raw if lang_raw else "code"

    tb_bg = f"titlebg{group}"
    tb_fg = f"titlefg{group}"

    # 标题栏
    title_bar = (
        f"\\noindent\\colorbox{{{tb_bg}}}{{"
        f"\\makebox[\\linewidth][l]{{"
        f"\\textcolor{{{tb_fg}}}{{\\ttfamily\\small\\bfseries\\ {display_name}"
        f"}}}}}}"
    )

    lang_opt = f"language={listings_lang}," if listings_lang else ""
    listing = (
        f"\\begin{{lstlisting}}[{lang_opt}style=style{group}]\n"
        f"{code}\n"
        f"\\end{{lstlisting}}"
    )

    return title_bar + "\n" + listing


def walk_blocks(blocks: list) -> list:
    result = []
    for block in blocks:
        t = block.get("t")
        if t == "CodeBlock":
            attr, code = block["c"]
            classes = attr[1]
            lang = classes[0] if classes else ""
            tex = build_listing(code, lang)
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
