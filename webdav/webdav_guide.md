# WebDAV 相关概念

---

## 1. 什么是 WebDAV

**Web Distributed Authoring and Versioning**（RFC 4918）

HTTP 的扩展协议，把 Web 服务器变成一个**可读写的文件系统**，允许客户端通过 HTTP
对服务器上的资源进行创建、读取、更新、删除、移动、复制等操作。

```
HTTP         → 只读为主（GET/POST）
WebDAV       → 可读写（扩展了 10+ 个方法）
CalDAV/CardDAV → 在 WebDAV 上再加日历/联系人语义
```

---

## 2. 核心概念

### 资源（Resource）
WebDAV 管理两种资源：

| 类型 | 说明 | 类比 |
|------|------|------|
| **普通资源** | 单个文件，有内容 | 文件 |
| **集合（Collection）** | 包含其他资源的容器 | 目录/文件夹 |

### 属性（Property）
每个资源都有一组元数据属性，分两类：

| 类型 | 说明 | 例子 |
|------|------|------|
| **活属性（Live）** | 服务端自动维护 | `getcontentlength`、`getetag`、`getlastmodified` |
| **死属性（Dead）** | 客户端自由设置 | `displayname`、`calendar-color` |

### 命名空间
属性用 XML 命名空间区分来源：

```xml
DAV:                              <!-- WebDAV 核心属性 -->
urn:ietf:params:xml:ns:caldav    <!-- CalDAV 属性 -->
urn:ietf:params:xml:ns:carddav   <!-- CardDAV 属性 -->
http://apple.com/ns/ical/        <!-- Apple 扩展属性 -->
```

---

## 3. 扩展的 HTTP 方法

### PROPFIND — 读取属性
最常用的 WebDAV 方法，读取资源的元数据：

```bash
# Depth: 0 → 只返回当前资源
# Depth: 1 → 返回当前资源 + 直接子资源
# Depth: infinity → 递归（Radicale 不支持）

curl -X PROPFIND -H "Depth: 1" \
  -d '<?xml version="1.0"?>
  <d:propfind xmlns:d="DAV:">
  <d:prop>
  <d:displayname/>
  <d:resourcetype/>
  <d:getetag/>
  </d:prop>
  </d:propfind>' \
  https://cal.matrix.works/user@matrix.works/
```

三种请求变体：
```xml
<d:propfind>
<d:prop>...</d:prop>      <!-- 请求指定属性 -->
</d:propfind>

<d:propfind>
<d:allprop/>              <!-- 请求所有属性 -->
</d:propfind>

<d:propfind>
<d:propname/>             <!-- 只列属性名，不返回值 -->
</d:propfind>
```

### PROPPATCH — 修改属性
设置或删除资源的死属性：

```bash
curl -X PROPPATCH \
  -d '<?xml version="1.0"?>
  <d:propertyupdate xmlns:d="DAV:">
  <d:set>
  <d:prop>
  <d:displayname>我的工作日历</d:displayname>
  </d:prop>
  </d:set>
  </d:propertyupdate>' \
  https://cal.matrix.works/user@matrix.works/work/
```

### MKCOL — 创建集合
创建一个新目录（集合）：

```bash
curl -X MKCOL \
  https://cal.matrix.works/user@matrix.works/new-folder/
```

CalDAV 用 `MKCALENDAR` 代替（创建时可附带属性）。

### COPY — 复制资源
```bash
curl -X COPY \
  -H "Destination: https://cal.matrix.works/user@matrix.works/contacts/copy.vcf" \
  https://cal.matrix.works/user@matrix.works/contacts/abc.vcf
```

### MOVE — 移动/重命名
```bash
curl -X MOVE \
  -H "Destination: https://cal.matrix.works/user@matrix.works/contacts/new-name.vcf" \
  https://cal.matrix.works/user@matrix.works/contacts/old-name.vcf
```

### LOCK / UNLOCK — 锁定资源
防止并发写冲突（CalDAV/CardDAV 通常不需要，用 ETag 代替）：

```bash
curl -X LOCK \
  -d '<?xml version="1.0"?>
  <d:lockinfo xmlns:d="DAV:">
  <d:lockscope><d:exclusive/></d:lockscope>
  <d:locktype><d:write/></d:locktype>
  </d:lockinfo>' \
  https://example.com/file.txt
```

### REPORT — 查询（WebDAV 扩展）
CalDAV/CardDAV 最重要的查询方法，类似 SQL SELECT：

```
REPORT = 带条件的 PROPFIND
```

不同的 report-type 对应不同查询：
- `calendar-query` — 按条件过滤日历事件
- `calendar-multiget` — 批量获取指定事件
- `addressbook-query` — 按条件搜索联系人
- `addressbook-multiget` — 批量获取指定联系人
- `sync-collection` — 增量同步

---

## 4. 完整方法对比

| 方法 | 来源 | 说明 |
|------|------|------|
| `GET` | HTTP | 下载资源内容 |
| `PUT` | HTTP | 上传/更新资源 |
| `DELETE` | HTTP | 删除资源 |
| `HEAD` | HTTP | 只获取响应头 |
| `OPTIONS` | HTTP | 查询服务端支持的方法 |
| `PROPFIND` | WebDAV | 读取属性 |
| `PROPPATCH` | WebDAV | 修改属性 |
| `MKCOL` | WebDAV | 创建集合 |
| `COPY` | WebDAV | 复制资源 |
| `MOVE` | WebDAV | 移动/重命名 |
| `LOCK` | WebDAV | 锁定资源 |
| `UNLOCK` | WebDAV | 解锁资源 |
| `REPORT` | WebDAV 扩展 | 条件查询 |
| `MKCALENDAR` | CalDAV | 创建日历集合 |

---

## 5. ETag 与并发控制

WebDAV 用 ETag 代替锁来处理并发，更轻量：

```
服务端返回：
  ETag: "abc123"

  客户端更新时带上：
  If-Match: "abc123"       → 只有 ETag 匹配才允许写入
  If-None-Match: *         → 只有资源不存在才允许创建
  ```

  流程：
  ```
  ① GET /file.ics          → ETag: "v1"
  ② 本地修改
  ③ PUT /file.ics
    If-Match: "v1"        → 服务端检查
      ├── ETag 仍为 v1 → 200 OK，更新成功，返回新 ETag: "v2"
          └── ETag 已变    → 412 Precondition Failed，有冲突
```

---

## 6. 多状态响应（207 Multi-Status）

PROPFIND/REPORT 返回多个资源时，HTTP 状态码用 **207**，内容是 XML：

```xml
HTTP/1.1 207 Multi-Status

<d:multistatus xmlns:d="DAV:">
<d:response>
<d:href>/user/contacts/abc.vcf</d:href>
<d:propstat>
<d:prop>
<d:displayname>张三</d:displayname>
<d:getetag>"v1"</d:getetag>
</d:prop>
<d:status>HTTP/1.1 200 OK</d:status>
</d:propstat>
</d:response>

<d:response>
<d:href>/user/contacts/def.vcf</d:href>
<d:propstat>
<d:prop>
<d:displayname/>   <!-- 该属性不存在 -->
</d:prop>
<d:status>HTTP/1.1 404 Not
Found</d:status>
</d:propstat>
</d:response>
</d:multistatus>
```

每个资源单独报告状态，一次请求可包含成功和失败混合结果。

---

## 7. OPTIONS — 探测服务能力

```bash
curl -v -X OPTIONS https://cal.matrix.works/

# 响应头包含：
Allow: GET, HEAD, OPTIONS, PROPFIND, PUT, DELETE, MKCOL, MKCALENDAR, REPORT, PROPPATCH
DAV: 1, 2, 3, calendar-access, addressbook
```

`DAV:` 响应头表示支持级别：
| 值 | 含义 |
|----|------|
| `1` | 基础 WebDAV |
| `2` | 支持 LOCK |
| `3` | 支持条件更新 |
| `calendar-access` | 支持 CalDAV |
| `addressbook` | 支持 CardDAV |

---

## 8. 同步机制（WebDAV-Sync，RFC 6578）

比 ETag 全量比对更高效：

```
① 首次同步
PROPFIND → 获取所有资源 ETag
服务端返回 sync-token: "token-001"
客户端保存 token

② 后续同步
REPORT sync-collection + sync-token: "token-001"
服务端只返回 token-001 之后的变化：
- 新增的资源
- 修改的资源（新 ETag）
- 删除的资源（<d:status>404</d:status>）
服务端返回新 sync-token: "token-002"
```

---

## 9. 与普通文件服务的区别

| | 普通 HTTP 文件服务 | WebDAV |
|--|------------------|--------|
| 读文件 | ✅ GET | ✅ GET |
| 写文件 | ❌ | ✅ PUT |
| 删文件 | ❌ | ✅ DELETE |
| 列目录 | 返回 HTML | ✅ PROPFIND（结构化 XML） |
| 元数据 | ❌ | ✅ 任意属性 |
| 并发控制 | ❌ | ✅ ETag / LOCK |
| 条件查询 | ❌ | ✅ REPORT |
| 增量同步 | ❌ | ✅ sync-token |

---

## 10. 在本项目中的位置

```
Radicale 服务
  ├── 实现了 WebDAV 核心（PROPFIND、PUT、DELETE、MKCOL...）
  ├── 实现了 CalDAV（MKCALENDAR、calendar-query...）
  └── 实现了 CardDAV（addressbook-query...）

Apache2
  └── mod_proxy → 把 HTTPS 请求转发给 Radicale
                    （包括所有 WebDAV 方法）
```

WebDAV 是整个 CalDAV/CardDAV 体系的地基，理解了它，CalDAV 和 CardDAV
只是在上面叠加了"日历语义"和"联系人语义"。
