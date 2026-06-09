# CalDAV 相关概念

---

## 1. 协议栈

```
CalDAV (RFC 4791)
  └── WebDAV (RFC 4918)
          └── HTTP/1.1
```

| 协议 | 作用 |
|------|------|
| **HTTP** | 传输层，GET/PUT/DELETE 等基础方法 |
| **WebDAV** | 扩展 HTTP，增加 PROPFIND/MKCOL/REPORT 等方法，管理"资源集合" |
| **CalDAV** | 在 WebDAV 基础上定义日历数据的存储与查询规范 |

---

## 2. 核心资源模型

```
Principal（用户主体）
└── Home Set（日历主目录）
    └── Calendar Collection（日历集合，即一个日历）
            └── Calendar Object（日历对象，即一个事件/任务）
```

### Principal
- 代表一个用户（或资源，如会议室）
- 有一个 `calendar-home-set` 属性，指向其日历主目录
- 例：`/test001@matrix.works/`

### Calendar Collection
- 相当于一个"日历本"
- 是 WebDAV 集合（目录），带有 `calendar` resourcetype
- 例：`/test001@matrix.works/work/`

### Calendar Object Resource
- 单个 `.ics` 文件，包含一个 VCALENDAR
- 用 UUID 命名，全局唯一
- 例：`/test001@matrix.works/work/abc-123.ics`

---

## 3. iCalendar 数据格式（RFC 5545）

CalDAV 传输的内容是 iCalendar 格式：

```
VCALENDAR          ← 容器（一个 .ics 文件）
├── VEVENT         ← 日历事件
├── VTODO          ← 待办任务
├── VJOURNAL       ← 日志
├── VFREEBUSY      ← 忙闲信息
└── VTIMEZONE      ← 时区定义
```

**VEVENT 关键字段：**

```
UID          唯一标识（全局，永久不变）
SUMMARY      标题
DTSTART      开始时间
DTEND        结束时间
DTSTAMP      对象创建/修改时间戳
RRULE        重复规则（如每周一）
ATTENDEE     参与者
ORGANIZER    组织者
STATUS       状态（CONFIRMED/TENTATIVE/CANCELLED）
VALARM       提醒
```

---

## 4. HTTP 方法扩展

| 方法 | 来自 | 用途 |
|------|------|------|
| `GET` | HTTP | 下载单个 .ics 文件 |
| `PUT` | HTTP | 创建/更新事件 |
| `DELETE` | HTTP | 删除事件 |
| `PROPFIND` | WebDAV | 读取资源属性（列目录、获取 ETag） |
| `PROPPATCH` | WebDAV | 修改资源属性（改日历名称） |
| `MKCOL` | WebDAV | 创建集合（新建日历） |
| `REPORT` | WebDAV | 查询（按条件筛选事件） |
| `MKCALENDAR` | CalDAV | 创建日历集合（专用） |

---

## 5. 重要属性（Properties）

通过 `PROPFIND` 读写：

| 属性 | 说明 |
|------|------|
| `DAV:resourcetype` | 资源类型（collection、calendar） |
| `DAV:displayname` | 显示名称 |
| `DAV:getetag` | 版本标识，用于同步判断是否变更 |
| `DAV:current-user-principal` | 当前用户路径 |
| `caldav:calendar-home-set` | 日历主目录路径 |
| `caldav:supported-calendar-component-set` | 支持的组件类型（VEVENT/VTODO） |
| `caldav:calendar-color` | 日历颜色（扩展属性） |

---

## 6. 同步机制

客户端同步有两种方式：

### ETag 比对（基础）
```
客户端 PROPFIND → 获取所有 .ics 的 ETag
对比本地缓存的 ETag → 发现变化的文件
GET 变化的文件 → 更新本地数据
```

### sync-token / WebDAV-Sync（RFC 6578，高效）
```
客户端保存上次的 sync-token
REPORT sync-collection + sync-token → 服务端只返回"变化的资源"
无需全量对比，带宽消耗小
```

---

## 7. 发现流程（Service Discovery）

客户端配置时自动发现日历路径：

```
1. GET /.well-known/caldav
  → 301 重定向到 /
2. PROPFIND / (current-user-principal)
  → /test001@matrix.works/
3. PROPFIND /test001@matrix.works/ (calendar-home-set)
  → /test001@matrix.works/
4. PROPFIND /test001@matrix.works/ Depth:1
  → 列出所有日历集合
```

iOS / Android DAVx⁵ 都通过这个流程自动发现，所以只需填写服务器地址即可。

---

## 8. 与 CardDAV 的关系

| | CalDAV | CardDAV |
|--|--------|---------|
| RFC | 4791 | 6352 |
| 数据格式 | iCalendar (.ics) | vCard (.vcf) |
| 存储对象 | VEVENT / VTODO | VCARD |
| 发现入口 | `/.well-known/caldav` | `/.well-known/carddav` |
| 共同基础 | WebDAV | WebDAV |

两者通常由同一服务（如 Radicale）同时提供。
