#!/usr/bin/env python3
"""
parse_dav.py — DAV XML 解析工具，供 caldav-discover.sh 调用

子命令:
  principal  <xml>   从 PROPFIND 响应提取 current-user-principal href
  cal-home   <xml>   提取 calendar-home-set href
  card-home  <xml>   提取 addressbook-home-set href
  collections <xml>  提取所有 collection，输出 TSV: type\thref\tname\tcomps

xml 参数为 '-' 时从 stdin 读取，否则为文件路径。
"""
import sys
import xml.etree.ElementTree as ET

DAV     = 'DAV:'
CALDAV  = 'urn:ietf:params:xml:ns:caldav'
CARDDAV = 'urn:ietf:params:xml:ns:carddav'
CS      = 'http://calendarserver.org/ns/'

def read_xml(src):
    if src == '-':
        data = sys.stdin.read().strip()
    else:
        with open(src, encoding='utf-8') as f:
            data = f.read().strip()
    if not data:
        return None
    try:
        return ET.fromstring(data)
    except ET.ParseError as e:
        print(f'ERROR: XML parse failed: {e}', file=sys.stderr)
        return None

def get_200_prop(response):
    """返回 HTTP 200 propstat 下的 prop 元素"""
    for propstat in response.findall(f'{{{DAV}}}propstat'):
        status = propstat.find(f'{{{DAV}}}status')
        if status is not None and '200' in (status.text or ''):
            return propstat.find(f'{{{DAV}}}prop')
    return None

# ── 子命令实现 ─────────────────────────────────────────────

def cmd_principal(root):
    """提取 current-user-principal/href"""
    # 直接搜索整棵树
    el = root.find(f'.//{{{DAV}}}current-user-principal/{{{DAV}}}href')
    if el is not None and el.text:
        print(el.text.strip())
        return
    # 也尝试从各 response 的 prop 里找
    for response in root.findall(f'.//{{{DAV}}}response'):
        prop = get_200_prop(response)
        if prop is None:
            continue
        el = prop.find(f'{{{DAV}}}current-user-principal/{{{DAV}}}href')
        if el is not None and el.text:
            print(el.text.strip())
            return

def cmd_cal_home(root):
    """提取 calendar-home-set/href"""
    el = root.find(f'.//{{{CALDAV}}}calendar-home-set/{{{DAV}}}href')
    if el is not None and el.text:
        print(el.text.strip())

def cmd_card_home(root):
    """提取 addressbook-home-set/href"""
    el = root.find(f'.//{{{CARDDAV}}}addressbook-home-set/{{{DAV}}}href')
    if el is not None and el.text:
        print(el.text.strip())

def cmd_collections(root):
    """
    枚举 Depth:1 响应里的所有 collection
    输出 TSV: type\thref\tname\tcomps
    type = calendar | addressbook
    """
    for response in root.findall(f'{{{DAV}}}response'):
        href_el = response.find(f'{{{DAV}}}href')
        if href_el is None or not href_el.text:
            continue
        href = href_el.text.strip()

        prop = get_200_prop(response)
        if prop is None:
            continue

        # displayname
        name_el = prop.find(f'{{{DAV}}}displayname')
        name = (name_el.text or '').strip() if name_el is not None else ''

        # resourcetype
        is_cal = is_card = False
        rt_el = prop.find(f'{{{DAV}}}resourcetype')
        if rt_el is not None:
            is_cal  = rt_el.find(f'{{{CALDAV}}}calendar')     is not None
            is_card = rt_el.find(f'{{{CARDDAV}}}addressbook') is not None

        # supported-calendar-component-set → 有此节点说明是 calendar
        comp_set = prop.find(f'{{{CALDAV}}}supported-calendar-component-set')
        comps = []
        if comp_set is not None:
            comps = [
                c.get('name', '')
                for c in comp_set.findall(f'{{{CALDAV}}}comp')
                if c.get('name')
            ]
            if not is_card:
                is_cal = True

        # addressbook-description → 是通讯录
        if prop.find(f'{{{CARDDAV}}}addressbook-description') is not None:
            is_card = True
            is_cal  = False

        # 跳过顶层 home（无名称、无组件、类型未知）
        if not name and not comps and not is_cal and not is_card:
            continue

        # 兜底：按名称/路径关键字猜测
        if not is_cal and not is_card:
            hint = (name + href).lower()
            if any(k in hint for k in ['contact', 'address', 'vcard', '通讯', '联系']):
                is_card = True
            else:
                is_cal = True

        ctype = 'addressbook' if is_card else 'calendar'
        print(f'{ctype}\t{href}\t{name}\t{",".join(comps)}')

# ── 入口 ───────────────────────────────────────────────────

COMMANDS = {
    'principal':   cmd_principal,
    'cal-home':    cmd_cal_home,
    'card-home':   cmd_card_home,
    'collections': cmd_collections,
}

def usage():
    print(__doc__)
    sys.exit(1)

if __name__ == '__main__':
    if len(sys.argv) < 3:
        usage()
    cmd  = sys.argv[1]
    src  = sys.argv[2]
    if cmd not in COMMANDS:
        print(f'未知子命令: {cmd}', file=sys.stderr)
        usage()
    root = read_xml(src)
    if root is not None:
        COMMANDS[cmd](root)
