#!/usr/bin/env bash
# dav-discover.sh — 根据邮件地址发现 CalDAV/CardDAV 路径
# 依赖: curl, dig, python3；同目录需有 parse_dav.py

set -euo pipefail

EMAIL="${1:-}"
PASS="${2:-}"

usage() {
  echo "用法: $0 <email> <password>"
  echo "示例: $0 my@matrix.works mypassword"
  exit 1
}
[[ -z "$EMAIL" || -z "$PASS" ]] && usage

DOMAIN="${EMAIL##*@}"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PARSE_PY="${SCRIPT_DIR}/parse_dav.py"

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
CYAN='\033[0;36m'; DIM='\033[2m'; NC='\033[0m'

info()    { echo -e "${CYAN}▸${NC} $*"; }
ok()      { echo -e "${GREEN}✓${NC} $*"; }
warn()    { echo -e "${YELLOW}⚠${NC} $*"; }
fail()    { echo -e "${RED}✗${NC} $*"; }
section() { echo -e "\n${DIM}── $* ──${NC}"; }

for cmd in curl dig python3; do
  command -v "$cmd" &>/dev/null || { fail "缺少依赖: $cmd"; exit 1; }
done
[[ -f "$PARSE_PY" ]] || { fail "找不到 parse_dav.py，应与脚本同目录"; exit 1; }

# ── 调用 parse_dav.py 的封装 ───────────────────────────────
# 用法: dav_parse <subcommand> <xml_string>
dav_parse() {
  local subcmd="$1"
  local xml="$2"
  local tmpf
  tmpf=$(mktemp)
  echo "$xml" > "$tmpf"
  python3 "$PARSE_PY" "$subcmd" "$tmpf"
  rm -f "$tmpf"
}

# ── 通用 PROPFIND ──────────────────────────────────────────
propfind() {
  local url="$1" depth="$2" body="$3"
  curl -sS --max-time 15 -L \
    -u "${EMAIL}:${PASS}" \
    -X PROPFIND \
    -H "Depth: $depth" \
    -H "Content-Type: application/xml" \
    --data-raw "$body" \
    "$url" 2>/dev/null || true
}

PRINCIPAL_BODY='<?xml version="1.0"?>
<d:propfind xmlns:d="DAV:">
<d:prop><d:current-user-principal/></d:prop>
</d:propfind>'

HOME_BODY='<?xml version="1.0"?>
<d:propfind xmlns:d="DAV:"
  xmlns:cal="urn:ietf:params:xml:ns:caldav"
  xmlns:card="urn:ietf:params:xml:ns:carddav">
<d:prop>
<cal:calendar-home-set/>
<card:addressbook-home-set/>
</d:prop>
</d:propfind>'

LIST_BODY='<?xml version="1.0" encoding="utf-8"?>
<d:propfind xmlns:d="DAV:"
  xmlns:cal="urn:ietf:params:xml:ns:caldav"
  xmlns:card="urn:ietf:params:xml:ns:carddav"
  xmlns:cs="http://calendarserver.org/ns/">
<d:prop>
<d:displayname/>
<d:resourcetype/>
<cal:supported-calendar-component-set/>
<cs:getctag/>
</d:prop>
</d:propfind>'

# ── Step 1: DNS SRV ────────────────────────────────────────
section "Step 1: DNS SRV"

DAV_HOST="" DAV_PORT="443" SCHEME="https" DAV_PATH="/.well-known/caldav"

for svc in "_caldavs._tcp" "_caldav._tcp"; do
  info "查询 SRV: $svc.$DOMAIN"
  result=$(dig +short SRV "$svc.$DOMAIN" 2>/dev/null | head -1 || true)
  if [[ -n "$result" ]]; then
    ok "SRV: $result"
    DAV_PORT=$(echo "$result" | awk '{print $3}')
    DAV_HOST=$(echo "$result" | awk '{print $4}' | sed 's/\.$//')
    txt=$(dig +short TXT "$svc.$DOMAIN" 2>/dev/null \
          | grep -o 'path=[^ "]*' | cut -d= -f2 || true)
    [[ -n "$txt" ]] && DAV_PATH="$txt" && info "TXT path: $DAV_PATH"
    [[ "$svc" == *"caldavs"* ]] && SCHEME="https" || SCHEME="http"
    break
  fi
done

if [[ -z "$DAV_HOST" ]]; then
  warn "未找到 SRV，回退到: $DOMAIN"
  DAV_HOST="$DOMAIN"
fi

BASE_URL="${SCHEME}://${DAV_HOST}"
[[ "$DAV_PORT" != "443" && "$DAV_PORT" != "80" ]] && BASE_URL="${BASE_URL}:${DAV_PORT}"
info "服务器: $BASE_URL"

# ── Step 2: 确定 principal ────────────────────────────────
section "Step 2: well-known → current-user-principal"

PRINCIPAL=""

# 尝试从 well-known 和根路径解析 principal
for try_url in "${BASE_URL}${DAV_PATH}" "${BASE_URL}/"; do
  info "请求: $try_url"
  RESP=$(propfind "$try_url" 0 "$PRINCIPAL_BODY")
  PRINCIPAL=$(dav_parse principal "$RESP" || true)
  if [[ -n "$PRINCIPAL" ]]; then
    ok "从响应获取 principal: $PRINCIPAL"
    break
  fi
done

# Radicale 特性：well-known 需要认证且重定向到用户路径
# 直接用邮件地址构造 principal 路径作为兜底（Radicale 标准行为）
if [[ -z "$PRINCIPAL" ]]; then
  # URL 编码 @ 为 %40
  ENCODED_EMAIL=$(python3 -c "import urllib.parse,sys; print(urllib.parse.quote(sys.argv[1], safe=''))" "$EMAIL")
  CANDIDATE="/${ENCODED_EMAIL}/"
  info "尝试构造路径: ${BASE_URL}${CANDIDATE}"
  status=$(curl -sS -o /dev/null -w "%{http_code}" \
           -u "${EMAIL}:${PASS}" -X PROPFIND -H "Depth: 0" \
           "${BASE_URL}${CANDIDATE}" 2>/dev/null || true)
  if [[ "$status" == "207" ]]; then
    PRINCIPAL="$CANDIDATE"
    ok "构造路径有效 (207): $PRINCIPAL"
  fi
fi

# 最后尝试不编码的路径
if [[ -z "$PRINCIPAL" ]]; then
  CANDIDATE="/${EMAIL}/"
  status=$(curl -sS -o /dev/null -w "%{http_code}" \
           -u "${EMAIL}:${PASS}" -X PROPFIND -H "Depth: 0" \
           "${BASE_URL}${CANDIDATE}" 2>/dev/null || true)
  if [[ "$status" == "207" ]]; then
    PRINCIPAL="$CANDIDATE"
    ok "原始路径有效 (207): $PRINCIPAL"
  fi
fi

[[ -z "$PRINCIPAL" ]] && { fail "无法确定 principal 路径"; exit 1; }

[[ "$PRINCIPAL" == http* ]] \
  && PRINCIPAL_URL="$PRINCIPAL" \
  || PRINCIPAL_URL="${BASE_URL}${PRINCIPAL}"
ok "Principal: $PRINCIPAL_URL"

# ── Step 3: home-set ───────────────────────────────────────
section "Step 3: calendar-home-set / addressbook-home-set"

HOME_RESP=$(propfind "$PRINCIPAL_URL" 0 "$HOME_BODY")

CAL_HOME=$(dav_parse  cal-home  "$HOME_RESP" || true)
CARD_HOME=$(dav_parse card-home "$HOME_RESP" || true)

# Radicale 默认 home-set 与 principal 相同
[[ -z "$CAL_HOME"  ]] && CAL_HOME="$PRINCIPAL"
[[ -z "$CARD_HOME" ]] && CARD_HOME="$PRINCIPAL"

to_url() { [[ "$1" == http* ]] && echo "$1" || echo "${BASE_URL}$1"; }
CAL_HOME_URL=$(to_url "$CAL_HOME")
CARD_HOME_URL=$(to_url "$CARD_HOME")

ok "Calendar home:    $CAL_HOME_URL"
ok "Addressbook home: $CARD_HOME_URL"

# ── Step 4: 枚举 collections ───────────────────────────────
section "Step 4: 枚举 collections"

TMPFILE=$(mktemp)
trap 'rm -f "$TMPFILE"' EXIT

print_entry() {
  local href="$1" name="$2" comps="$3"
  local full_url
  [[ "$href" == http* ]] && full_url="$href" || full_url="${BASE_URL}${href}"
  printf "    路径: %s\n" "$full_url"
  [[ -n "$name"  ]] && printf "    名称: %s\n" "$name"
  [[ -n "$comps" ]] && printf "    组件: %s\n" "$comps"
  echo
}

echo -e "\n${CYAN}📅 日历 (CalDAV)${NC}"
LIST_RESP=$(propfind "$CAL_HOME_URL" 1 "$LIST_BODY")
CAL_URLS=(); CAL_NAMES=()

dav_parse collections "$LIST_RESP" | grep '^calendar' > "$TMPFILE" || true
while IFS=$(printf '\t') read -r ctype href name comps; do
  [[ -z "$href" ]] && continue
  print_entry "$href" "$name" "$comps"
  [[ "$href" == http* ]] && CAL_URLS+=("$href") || CAL_URLS+=("${BASE_URL}${href}")
  CAL_NAMES+=("${name:-$href}")
done < "$TMPFILE"
[[ ${#CAL_URLS[@]} -eq 0 ]] && echo "  (未找到日历 collection)"

echo -e "${CYAN}👤 通讯录 (CardDAV)${NC}"
[[ "$CARD_HOME_URL" == "$CAL_HOME_URL" ]] \
  && CARD_LIST_RESP="$LIST_RESP" \
  || CARD_LIST_RESP=$(propfind "$CARD_HOME_URL" 1 "$LIST_BODY")

CARD_URLS=(); CARD_NAMES=()
dav_parse collections "$CARD_LIST_RESP" | grep '^addressbook' > "$TMPFILE" || true
while IFS=$(printf '\t') read -r ctype href name comps; do
  [[ -z "$href" ]] && continue
  print_entry "$href" "$name" "$comps"
  [[ "$href" == http* ]] && CARD_URLS+=("$href") || CARD_URLS+=("${BASE_URL}${href}")
  CARD_NAMES+=("${name:-$href}")
done < "$TMPFILE"
[[ ${#CARD_URLS[@]} -eq 0 ]] && echo "  (未找到通讯录 collection)"

# ── 汇总 ───────────────────────────────────────────────────
section "汇总"
printf "  %-16s %s\n" "邮箱:"        "$EMAIL"
printf "  %-16s %s\n" "DAV 服务器:" "$BASE_URL"
printf "  %-16s %s\n" "Principal:"  "$PRINCIPAL_URL"
echo
echo -e "  ${CYAN}日历:${NC}"
if [[ ${#CAL_URLS[@]} -gt 0 ]]; then
  for i in "${!CAL_URLS[@]}"; do
    printf "    [%d] %s\n        名称: %s\n" \
      "$((i+1))" "${CAL_URLS[$i]}" "${CAL_NAMES[$i]}"
  done
else
  echo "    (无)"
fi
echo
echo -e "  ${CYAN}通讯录:${NC}"
if [[ ${#CARD_URLS[@]} -gt 0 ]]; then
  for i in "${!CARD_URLS[@]}"; do
    printf "    [%d] %s\n        名称: %s\n" \
      "$((i+1))" "${CARD_URLS[$i]}" "${CARD_NAMES[$i]}"
  done
else
  echo "    (无)"
fi
echo
