# CardDAV 相关概念

---

## 1. 协议栈

```
CardDAV (RFC 6352)
  └── WebDAV (RFC 4918)
        └── HTTP/1.1
```

与 CalDAV 完全平行，只是数据格式从 iCalendar 换成了 vCard。

---

## 2. HTTP 方法

与 CalDAV 相同，继承自 WebDAV：

| 方法 | 用途 |
|------|------|
| `GET` | 下载单个 .vcf |
| `PUT` | 创建/更新联系人 |
| `DELETE` | 删除联系人 |
| `PROPFIND` | 列出通讯录/获取属性 |
| `REPORT` | 按条件查询联系人 |
| `MKCOL` | 创建通讯录集合 |

---

## 3. 重要属性

| 属性 | 说明 |
|------|------|
| `DAV:resourcetype` | 包含 `addressbook` 标识 |
| `DAV:displayname` | 通讯录显示名称 |
| `DAV:getetag` | 版本标识，同步用 |
| `carddav:addressbook-home-set` | 通讯录主目录路径 |
| `carddav:supported-address-data` | 支持的 vCard 版本 |
| `carddav:max-resource-size` | 单个联系人最大字节数 |

---

## 4. 核心资源模型

```
Principal（用户主体）
└── Home Set（通讯录主目录）
      └── Address Book Collection（通讯录集合，即一个通讯录）
          └── Address Object（联系人对象，即一个 .vcf 文件）
```

### Principal
- 代表一个用户
- 有 `addressbook-home-set` 属性，指向通讯录主目录
- 例：`/test001@matrix.works/`

### Address Book Collection
- 相当于一个"通讯录本"
- WebDAV 集合，带有 `addressbook` resourcetype
- 例：`/test001@matrix.works/contacts/`

### Address Object Resource
- 单个 `.vcf` 文件，包含一个 VCARD
- 用 UUID 命名
- 例：`/test001@matrix.works/contacts/abc-123.vcf`

---

## 5. vCard 数据格式（RFC 6350）

CardDAV 传输的内容是 vCard 格式：

```
BEGIN:VCARD
VERSION:3.0
UID:abc-123@matrix.works
FN:张三                        ← 显示名（全名）
N:张;三;;;                     ← 姓名结构（姓;名;中间名;称谓;后缀）
EMAIL;TYPE=work:zhangsan@example.com
TEL;TYPE=cell:+86-138-0000-0000
ADR;TYPE=work:;;北京市朝阳区;;;中国
ORG:示例公司;技术部
TITLE:工程师
NOTE:备注内容
PHOTO;ENCODING=b;TYPE=JPEG:<base64数据>
REV:20260608T000000Z          ← 最后修改时间
END:VCARD
```

**常用字段：**

| 字段 | 说明 |
|------|------|
| `UID` | 唯一标识，永久不变 |
| `FN` | 显示名（必填） |
| `N` | 姓名结构（姓;名;中间名;称谓;后缀） |
| `EMAIL` | 邮箱，可多个 |
| `TEL` | 电话，可多个 |
| `ADR` | 地址 |
| `ORG` | 组织;部门 |
| `TITLE` | 职位 |
| `PHOTO` | 头像（Base64） |
| `BDAY` | 生日 |
| `REV` | 最后修改时间 |
| `CATEGORIES` | 分组标签 |

---

## 6. vCard 版本差异

| 版本 | RFC | 说明 |
|------|-----|------|
| **2.1** | 旧 | 部分老设备使用，功能有限 |
| **3.0** | RFC 2426 | 最广泛兼容，iOS/Android 默认 |
| **4.0** | RFC 6350 | 最新，支持更多字段，兼容性稍差 |

Radicale 默认支持 3.0 和 4.0。

---

## 7. 查询方式

### addressbook-query（按条件搜索）

```xml
<card:addressbook-query xmlns:d="DAV:" xmlns:card="urn:ietf:params:xml:ns:carddav">
<d:prop>
<d:getetag/>
<card:address-data/>
</d:prop>
<card:filter test="anyof">
<card:prop-filter name="FN">
<card:text-match collation="i;unicode-casemap" match-type="contains">
张三
</card:text-match>
</card:prop-filter>
<card:prop-filter name="EMAIL">
<card:text-match match-type="contains">zhang</card:text-match>
</card:prop-filter>
</card:filter>
</card:addressbook-query>
```

### addressbook-multiget（批量获取指定联系人）

```xml
<card:addressbook-multiget xmlns:d="DAV:" xmlns:card="urn:ietf:params:xml:ns:carddav">
<d:prop>
<d:getetag/>
<card:address-data/>
</d:prop>
<d:href>/test001@matrix.works/contacts/abc-123.vcf</d:href>
<d:href>/test001@matrix.works/contacts/def-456.vcf</d:href>
</card:addressbook-multiget>
```

---

## 8. 发现流程

```
客户端
  │
  ├─① GET https://cal.matrix.works/.well-known/carddav
  │       ↓
  │   301 重定向 → /
  │
  ├─② PROPFIND / (current-user-principal)
  │       ↓
  │   /test001@matrix.works/
  │
  ├─③ PROPFIND /test001@matrix.works/ (addressbook-home-set)
  │       ↓
  │   /test001@matrix.works/
  │
  └─④ PROPFIND /test001@matrix.works/ Depth:1
          ↓
      列出所有通讯录集合（contacts/、def-addressbook/ 等）
```

---

## 9. curl 操作速查

```bash
# 列出通讯录集合
curl -u user@matrix.works:pass \
  -X PROPFIND -H "Depth: 1" \
  https://cal.matrix.works/user@matrix.works/

# 获取所有联系人
curl -u user@matrix.works:pass \
  -X REPORT -H "Depth: 1" \
  -H "Content-Type: application/xml" \
  -d '<card:addressbook-query xmlns:d="DAV:" xmlns:card="urn:ietf:params:xml:ns:carddav">
    <d:prop><d:getetag/><card:address-data/></d:prop>
    <card:filter/>
    </card:addressbook-query>' \
  https://cal.matrix.works/user@matrix.works/contacts/

# 新增联系人
curl -u user@matrix.works:pass \
  -X PUT \
  -H "Content-Type: text/vcard; charset=utf-8" \
  -d 'BEGIN:VCARD
VERSION:3.0
UID:abc-123@matrix.works
FN:张三
EMAIL:zhangsan@example.com
TEL:138-0000-0000
END:VCARD' \
  https://cal.matrix.works/user@matrix.works/contacts/abc-123.vcf

# 删除联系人
curl -u user@matrix.works:pass \
  -X DELETE \
  https://cal.matrix.works/user@matrix.works/contacts/abc-123.vcf
```

---

## 10. CalDAV vs CardDAV 对比

| | CalDAV | CardDAV |
|--|--------|---------|
| RFC | 4791 | 6352 |
| 数据格式 | iCalendar / .ics | vCard / .vcf |
| 核心对象 | VEVENT、VTODO | VCARD |
| 集合类型 | calendar | addressbook |
| 主目录属性 | `calendar-home-set` | `addressbook-home-set` |
| 查询方法 | `calendar-query` | `addressbook-query` |
| 发现入口 | `/.well-known/caldav` | `/.well-known/carddav` |
| 时间过滤 | ✅ 支持 | ❌ 无（联系人无时间维度） |
| 全文搜索 | ❌ 有限 | ✅ text-match |

两者共用同一套 WebDAV 基础设施，Radicale 同时提供两种服务。
