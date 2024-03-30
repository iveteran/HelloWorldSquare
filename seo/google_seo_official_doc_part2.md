# Google SEO官方文档笔记(二)

### The Notes of Google SEO Official Document - Part 2

**Created by: [matrix.works](https://matrix.works/)**

[引用出处][1]: https://developers.google.com/search/docs?hl=zh-cn


## 抓取和索引编制

### Google 编入索引的文件类型
[查看列表](https://developers.google.com/search/docs/crawling-indexing/indexable-file-types?hl=zh-cn)

### Google 的网址结构最佳实践
- **建议**：在网址中使用简单、说明性字词
> `https://en.wikipedia.org/wiki/Aviation`
- **建议**：在网址中使用已本地化的字词（如果适用）
> `https://www.example.com/lebensmittel/pfefferminz`
- **建议**：酌情使用 UTF-8 编码。例如，以下示例对网址中的中文字符使用 UTF-8 编码
> `https://example.com/%E6%9D%82%E8%B4%A7/%E8%96%84%E8%8D%B7`
- **不建议**：在网址中使用非 ASCII 字符
> `https://www.example.com/杂货/薄荷`
- **不建议**：在网址中使用不易读的、冗长的 ID 编号
> `https://www.example.com/index.php?id_sezione=360&sid=3a5ebc944f41daa6f849f730f1`
- **建议**：采用特定国家/地区网域
> `https://example.de`
- **建议**：搭配 gTLD 采用特定国家/地区子目录
> `https://example.com/de/`
- **建议**：使用连字符 (-)
> `https://www.example.com/summer-clothing/filter?color-profile=dark-grey`
- **不建议**：使用下划线 (_)
> `https://www.example.com/summer_clothing/filter?color_profile=dark_grey`
- **不建议**：将网址中的字词连接在一起
> `https://www.example.com/greendress`

**与网址相关的常见问题**
导致网址过多可能有多种原因，其中包括：
- 累加过滤一组项目
- 动态生成文档
- 网址中的参数有问题
- 排序参数
- 网址中存在不相关的参数，例如引荐参数
- 日历问题
- 损坏的相对链接

**解决与网址相关的问题**
若要避免网址结构可能导致的问题，建议您采取以下措施：
- 创建简单的网址结构。建议您组织一下内容，使网址结构合乎逻辑并特别易于人类理解。
- 考虑使用 robots.txt 文件阻止 Googlebot 访问有问题的网址。一般情况下应考虑阻止动态网址，例如会生成搜索结果或无限空间（比如日历）的网址。在 robots.txt 文件中使用正则表达式可以轻松拦截大量网址。
- 尽可能避免在网址中使用会话 ID，而应考虑使用 Cookie。
- 如果网络服务器对网址中的大小写文本的处理方式相同，请将所有文本转换为同一大小写形式，以便 Google 能够更轻松地确定相应网址引用的是同一网页。
- 删去不必要的参数，尽可能缩短网址。
- 如果您的网站具有未设置期限的日历，请为指向动态创建的未来日历页的链接添加 nofollow 属性。
- 检查网站是否有损坏的相对链接。

### Google 的链接最佳实践
1. 确保链接可供抓取
- 推荐（Google 可以解析）
> `<a href="https://example.com">`
> `<a href="/products/category/shoes">`
- 不推荐（但 Google 可能仍会尝试解析）
> `<a routerLink="products/category">`
> `<span href="https://example.com">`
> `<a onclick="goto('https://example.com')">`
- 推荐（Google 可以解决）
> `<a href="https://example.com/stuff">`
> `<a href="/products">`
> `<a href="/products.php?id=123">`
- 不推荐（但 Google 可能仍会尝试解决此问题）
> `<a href="javascript:goTo('products')">`
> `<a href="javascript:window.location.href='/products'">`
2. 定位文字放置方式
> 定位文字（也称为链接文字）是链接的可见文字
- 良好：
> `<a href="https://example.com/ghost-peppers">鬼椒</a>`
- 欠佳（链接文字为空）：
> `<a href="https://example.com"></a>`
> `<a href="https://example.com/ghost-pepper-recipe" title="如何腌制鬼椒"></a>`
> `<a href="/add-to-cart.html"><img src="enchiladas-in-shopping-cart.jpg" alt="将辣椒肉馅玉米卷饼添加到购物车"/></a>`
3. 撰写优质定位文字
> 优质定位文字应描述清楚、措辞简洁，且与其所在网页和链接到的网页相关。它提供链接的背景信息，并为读者设定预期。 
> 定位文字越优质，用户就越容易浏览您的网站，Google 也就越能轻松地理解您所链接到的网页的内容。
4. 内部链接：交叉引荐您自己的内容
- 如果能加大对用于内部链接的定位文字的关注，则可帮助用户和 Google 更轻松地了解您的网站并找到您网站上的其他网页
- 对于您重视的每个网页，您都应在您网站上至少 1 个其他网页中提供相应的引荐链接
5. 外部链接：指向其他网站的链接
- 请仅在您不信任内容来源的情况下使用 nofollow，而且不要对您网站上的每个外部链接都使用它
- 如果您以某种方式收取了链接费用，请使用 sponsored 或 nofollow 确保这些链接合格
- 如果用户可以在您的网站上插入链接（例如您有论坛版块或问答网站），请也在这些链接中添加 ugc 或 nofollow

### 站点地图
> 站点地图是一种文件，您可在其中提供与您网站中的网页、视频或其他文件有关的信息，也可以说明这些内容之间的关系。
1. 您可以使用站点地图提供与特定类型的网页内容（包括视频、图片和新闻内容）有关的信息。例如：
- 站点地图视频条目可以指定视频的时长、评分以及适合哪些年龄段的受众。
- 站点地图图片条目中可包含网页中所含图片的位置。
- 站点地图新闻条目中可包含报道标题和发布日期。
2. 在以下情况下，您可能需要站点地图：
- 您的网站很大
- 网站为新网站且指向该网站的外部链接不多
- 您的网站包含大量富媒体内容（视频、图片）或显示在 Google 新闻中
3. 在以下情况下，您可能不需要站点地图
- 您的网站规模“较小”
- 您的网站已在内部全面建立链接
- 您想在搜索结果中显示的媒体文件（视频、图片）或新闻网页不多

#### 创建和提交站点地图
1. 站点地图最佳做法
- 站点地图大小限制：无论采用哪种格式，单个站点地图的文件大小一律不得超过 50MB（未压缩），并且其中包含的网址数量不得超过 50,000 个，否则必须将站点地图拆分成多个较小的站点地图
- 站点地图文件编码和位置：站点地图文件必须采用 UTF-8 编码
- 引用网址的属性：请在站点地图中使用完全限定的绝对网址
2. XML 站点地图
> XML 站点地图是用途最广的受支持站点地图格式
3. RSS、mRSS 和 Atom 1.0
> 如果您的 CMS 会生成 RSS 或 Atom Feed，您可以将该 Feed 的网址作为站点地图提交。 大多数 CMS 都会为您创建 Feed，但请注意，此类 Feed 仅提供近期网址的相关信息
4. 文本站点地图
5. 如何创建站点地图
- 让您的 CMS 为您生成站点地图。
- 如果要创建的站点地图包含的网址不到几十个，您可以手动创建站点地图。
- 如果要创建的站点地图包含的网址超过几十个，使用工具自动生成站点地图。
6. 将站点地图提交给 Google
- 使用站点地图报告在 Search Console 中提交站点地图。
- 使用 Search Console API 程序化地提交站点地图。
- 将下面这行内容插入到 robots.txt 文件中的任意位置，指定站点地图的路径。我们会在下次抓取 robots.txt 文件时找到该站点地图：
> `Sitemap: https://example.com/my_sitemap.xml`
- 如果您使用 Atom 或 RSS，则可以使用 WebSub 向搜索引擎（包括 Google）广播您的更改。
7. 如何跨网站提交多个网站的站点地图
如果您拥有多个网站，您可以创建一个或多个站点地图，其中包含您所有经过验证的网站对应的网址，然后将这些站点地图保存到同一位置，从而简化站点地图提交过程
8. 使用站点地图索引文件管理站点地图
如果您的站点地图超过了大小上限，则需要将较大的站点地图拆分成多个站点地图，让每个新站点地图都小于大小上限。拆分站点地图后，您可以使用站点地图索引文件这种方式同时提交多个站点地图。
9. 站点地图扩展项
- [图片站点地图](https://developers.google.com/search/docs/crawling-indexing/sitemaps/image-sitemaps?hl=zh-cn)
- [Google 新闻站点地图](https://developers.google.com/search/docs/crawling-indexing/sitemaps/news-sitemap?hl=zh-cn)
- [视频站点地图和替代方案](https://developers.google.com/search/docs/crawling-indexing/sitemaps/video-sitemaps?hl=zh-cn)
- [如何结合使用站点地图扩展](https://developers.google.com/search/docs/crawling-indexing/sitemaps/combine-sitemap-extensions?hl=zh-cn)


### 抓取工具管理

#### 请求 Google 重新抓取您的网址
如果您最近向网站添加了新网页或对网站中的现有网页进行了更改，则可以使用下列任一方法请求 Google 将该网页重新编入索引。
抓取用时可能会从几天到几周不等。请耐心等待，并通过索引状态报告或网址检查工具监控进度。
1. 使用网址检查工具（若网址数量不多）
2. 提交站点地图（一次提交多个网址

### 减慢 Googlebot 的抓取速度
1. Google 会通过先进的算法确定最佳的网站抓取速度
2. 减慢 Googlebot 的抓取速度将会产生广泛的影响，请谨慎考虑
3. 如果您急需让抓取速度在短时间（如几个小时或 1-2 天）内减慢，则应向抓取请求返回 500、503 或 429 HTTP 响应状态代码（而非 200

### 验证 Googlebot 和其他 Google 抓取工具
1. Google 抓取工具分为三类：
- Googlebot
> Google 搜索产品的主要抓取工具。始终遵循 robots.txt 规则。
> 反向 DNS 掩码: crawl-***-***-***-***.googlebot.com 或 geo-crawl-***-***-***-***.geo.googlebot.com
> [IP范围](https://developers.google.com/static/search/apis/ipranges/googlebot.json?hl=zh-cn)
- 特殊情况下的抓取工具
> 执行特定功能的抓取工具（例如 AdsBot），不一定遵循 robots.txt 规则。
> 反向 DNS 掩码: rate-limited-proxy-***-***-***-***.google.com
> [IP范围](https://developers.google.com/static/search/apis/ipranges/special-crawlers.json?hl=zh-cn)
- 用户触发的抓取器
> 最终用户触发抓取操作的工具和产品功能。例如，Google 网站验证工具会响应用户请求。由于是用户请求的抓取，因此这些抓取器会忽略 robots.txt 规则。
> 反向 DNS 掩码: ***-***-***-***.gae.googleusercontent.com	user-triggered-fetchers.json
> [IP范围](https://developers.google.com/static/search/apis/ipranges/user-triggered-fetchers.json?hl=zh-cn)

2. 验证 Google 抓取工具的方法有两种：
- 手动验证：如果是一次性查找，请使用命令行工具。对于大多数用例，此方法足以满足需求。
> 通过host, dig命令查询
- 自动验证：如果是大规模查找，请使用自动解决方案将抓取工具的 IP 地址与已发布的 Googlebot IP 地址列表进行比对。

### 面向大型网站所有者的抓取预算管理指南
这是一个高级指南，适用于：
内容更改较为频繁（每周一次）的大型网站（非重复网页数量超过 100 万个）
内容每日更改飞快的中大型网站（非重复网页数量超过 10000 个）
网站的全部网址中有很大一部分被 Search Console 归类为已发现 - 尚未编入索引
1. 抓取的一般理论
- 抓取容量上限
- 抓取需求
下面这几个因素在确定抓取需求方面起着重要作用：
Google 感知到的网址目录：如果没有您的引导，Googlebot 会尝试抓取在您网站上发现的所有或大多数网址。如果这些网址中有很多是重复的，或者您由于其他某种原因（网址已被移除、不重要等）不希望 Google 抓取这些网址，则它们会浪费大量 Google 抓取您网站的时间。这一因素是最能得到您的积极控制的。
热门程度：Googlebot 往往会更加频繁地抓取互联网上较为热门的网址，以便在我们的索引中及时更新这些网址的内容。
过时性：我们的系统希望尽可能频繁地重新抓取文档，以便将所有更改收入囊中。
2. 最佳实践
- 管理网址目录
    - 整合重复内容
    - 使用 robots.txt 禁止抓取网址
    - 针对永久移除的网页返回 404 或 410 状态代码
    - 消除 soft 404 错误
    - 及时更新站点地图
    - 避免使用很长的重定向链
- 提高网页的加载速度
- 监控网站抓取情况
- 监控网站的抓取和索引编制情况
    - 查看 Googlebot 是否在您的网站上遇到了可用性问题
    - 查看您网站中是否有应被抓取但未被抓取的部分
    - 查看更新内容的抓取速度是否足够快
- 提高您网站的抓取效率
    - 使用 HTTP 状态代码指定内容更改
    - 隐藏您不希望显示在搜索结果中的网址
    - 处理您的网站遭过度抓取的问题（紧急情况）

### HTTP 状态代码以及网络连接错误和 DNS 错误对 Google 搜索有何影响
> Search Console 会为 4xx–5xx 范围内的状态代码和失败的重定向 (3xx) 生成错误消息。如果服务器返回 2xx 状态代码，则响应中接收到的内容可能会被考虑编入索引
1. Googlebot 最常遇到的 HTTP 状态代码，并解释了 Google 如何处理各个状态代码
- 2xx (success)
> Google 会考虑将内容编入索引。如果内容表明有错误，例如空网页或错误消息，则 Search Console 会显示 soft 404 错误
- 3xx (redirection)
> Googlebot 会跟踪最多 10 次重定向。如果抓取工具在 10 次重定向内没有收到内容，则 Search Console 会在网站的“网页索引编制”报告中显示重定向错误。
> Googlebot 跟踪的重定向次数取决于用户代理；例如，Googlebot（智能手机版）的重定向次数值可能不同于 Googlebot Image。
> 对于 robots.txt，Googlebot 会按照 RFC 1945 的规定跟踪至少五次重定向，然后便会停止，并将其作为 robots.txt 文件的 404 错误处理。
> Googlebot 重定向网址中收到的任何内容都会被忽略，最终目标网址的内容会被考虑编入索引。
- 4xx (client errors)
> Google 的索引编制流水线不会考虑将返回 4xx 状态代码的网址编入索引，而已编入索引且返回 4xx 状态代码的网址会从索引中移除。
> Googlebot 从会返回 4xx 状态代码的网址收到任何内容都将被忽略。
- 5xx (server errors)
> 5xx 和 429 服务器错误会提示 Google 抓取工具暂时减慢抓取速度。已编入索引的网址仍会保留在索引中，但最终会被丢弃。
> 如果 robots.txt 文件返回服务器错误状态代码的时间超过 30 天，Google 会使用 robots.txt 的最后一个缓存副本。如果没有缓存副本，Google 会假定没有任何抓取限制。
> Googlebot 从会返回 5xx 状态代码的网址收到任何内容都将被忽略。
2. 网络连接错误和 DNS 错误
- 如果发生网络连接错误，抓取速度会立即开始减慢，因为网络连接错误表明服务器可能无法处理服务负载
3. 调试网络连接错误
- 查看防火墙设置和日志
- 查看网络流量
4. 调试 DNS 错误
- 检查防火墙规则
- 查看 DNS 记录
- 请检查您的所有域名服务器是否指向您网站的正确 IP 地址
- 如果您在过去 72 小时内更改了 DNS 配置
- 如果您运行的是自己的 DNS 服务器，请确保它运行状况良好，并且没有过载

### Google 抓取工具和抓取器（用户代理）
1. 常见抓取工具
- Googlebot（智能手机版）
> 用户代理令牌: Googlebot
> 完整的用户代理字符串: Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/W.X.Y.Z Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)
- Googlebot（桌面版）
> 用户代理令牌: Googlebot
> 完整的用户代理字符串: Mozilla/5.0 AppleWebKit/537.36 (KHTML, like Gecko; compatible; Googlebot/2.1; +http://www.google.com/bot.html) Chrome/W.X.Y.Z Safari/537.36
- Googlebot Image
> 用于抓取图片（适用于 Google 图片和依赖于图片的产品）
> 用户代理令牌: Googlebot-Image Googlebot
> 完整的用户代理字符串: Googlebot-Image/1.0
- Googlebot News
> 使用 Googlebot 抓取新闻报道，但会遵循其历史用户代理令牌 Googlebot-News。
> 用户代理令牌: Googlebot-News Googlebot
> 完整的用户代理字符串: Googlebot-News 用户代理使用各种 Googlebot 用户代理字符串。
- Googlebot Video
> 用于抓取视频，适用于 Google 视频和依赖于视频的产品。
> 用户代理令牌: Googlebot-Video Googlebot
> 完整的用户代理字符串: Googlebot-Video/1.0
- Google StoreBot
> 抓取某些类型的网页，包括但不限于商品详情页、购物车页和结账页。
> 用户代理令牌: Storebot-Google
> 完整的用户代理字符串	
> > 桌面版代理：
> > Mozilla/5.0 (X11; Linux x86_64; Storebot-Google/1.0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/W.X.Y.Z Safari/537.36
>
> > 移动版代理：
> > Mozilla/5.0 (Linux; Android 8.0; Pixel 2 Build/OPD3.170816.012; Storebot-Google/1.0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/W.X.Y.Z Mobile Safari/537.36
- Google-InspectionTool
> Google-InspectionTool 是 Search Console 中的搜索测试工具（如富媒体搜索结果测试和网址检查）所使用的抓取工具。除了用户代理和用户代理令牌之外，它还模仿 Googlebot。
> 用户代理令牌: Google-InspectionTool Googlebot
> 完整的用户代理字符串: 略
- GoogleOther
> GoogleOther 是可供各种产品团队用于从网站中抓取可公开访问的内容的通用抓取工具。例如，它可能会用于一次性抓取，供内部研究和开发。
> 用户代理令牌: GoogleOther
> 完整的用户代理字符串: GoogleOther
- Google-Extended
> Google-Extended 是一个独立的产品令牌，供网站发布商用于管理其网站是否帮助改进 Gemini 应用和 Vertex AI 生成式 API，包括为这些产品提供支持的模型的未来版本。
> Google-Extended 不会对网站列入 Google 搜索结果及其在搜索结果中的排名产生影响。
> 用户代理令牌: Google-Extended
> 完整的用户代理字符串: Google-Extended 没有单独的 HTTP 请求用户代理字符串。抓取操作是使用现有的 Google 用户代理字符串进行的；robots.txt 用户代理令牌用于控制权限。
2. 特殊情况下的抓取工具
- APIs-Google
> 供 Google API 传递推送通知消息。忽略 robots.txt 中的全局用户代理 (*)。
> 用户代理令牌: APIs-Google
- AdsBot Mobile Web Android
> 检查 Android 网页广告质量。忽略 robots.txt 中的全局用户代理 (*)。
> 用户代理令牌AdsBot-Google-Mobile
- AdsBot Mobile Web
> 检查iPhone 网页广告质量。忽略 robots.txt 中的全局用户代理 (*)。
> 用户代理令牌: AdsBot-Google-Mobile
- AdsBot
> 检查桌面版网页广告质量。忽略 robots.txt 中的全局用户代理 (*)。
> 用户代理令牌: AdsBot-Google
- AdSense
> AdSense 抓取工具通过访问您的网站确定网站内容，以便提供相关的广告。忽略 robots.txt 中的全局用户代理 (*)。
> 用户代理令牌: Mediapartners-Google
- Mobile AdSense
> Mobile AdSense 抓取工具通过访问您的网站确定网站内容，以便提供相关的广告。忽略 robots.txt 中的全局用户代理 (*)。
> 用户代理令牌: Mediapartners-Google
- Google-Safety
> Google-Safety 用户代理负责处理针对滥用行为的抓取，例如对 Google 产品和服务上公开发布的链接进行恶意软件发现。此用户代理会忽略 robots.txt 规则。
> 完整的用户代理字符串: Google-Safety
3. 用户触发的抓取器
- Feedfetcher
> Feedfetcher 用于为 Google 播客、Google 新闻和 PubSubHubbub 抓取 RSS 或 Atom Feed。
> 用户代理令牌: FeedFetcher-Google
- Google 发布商中心
> 抓取并处理发布商通过 Google 发布商中心明确提供的 Feed，以便在 Google 新闻着陆页中使用。
> 完整的用户代理字符串: GoogleProducer; (+http://goo.gl/7y4SX)
- Google Read Aloud
> 根据用户请求，Google Read Aloud 会使用文字转语音 (TTS) 技术来抓取并朗读网页内容。
> 完整的用户代理字符串
> 现用代理：略
- Google 网站验证工具
> Google 网站验证工具会在用户请求 Search Console 验证令牌时进行抓取。
> 完整的用户代理字符串: Mozilla/5.0 (compatible; Google-Site-Verification/1.0)
4. 关于用户代理中的 Chrome/W.X.Y.Z 的说明
表中的用户代理字符串中有时候会出现 Chrome/W.X.Y.Z 字符串，W.X.Y.Z 实际上是代表该用户代理使用的 Chrome 浏览器版本的占位符：例如，41.0.2272.96。随着时间的推移，此版本号会增大，以便与 Googlebot 使用的最新 Chromium 发布版本相匹配。
5. robots.txt 中的用户代理
如果 Google 在 robots.txt 文件中识别出多个用户代理，将会跟踪最具体的用户代理。如果您希望 Google 的所有抓取工具都能够抓取您的网页，根本不需要使用 robots.txt 文件。如果您希望禁止或允许 Google 的所有抓取工具访问您的某些内容，只需将 Googlebot 指定为用户代理即可
6. 控制抓取速度
每个 Google 抓取工具都会出于特定目的以不同的速度访问网站

### robots.txt

#### robots.txt 简介
robots.txt 文件规定了搜索引擎抓取工具可以访问您网站上的哪些网址
1. robots.txt 对不同文件类型的影响
- 网页
> 对于网页（包括 HTML、PDF，或其他 Google 能够读取的非媒体格式），您可在以下情况下使用 robots.txt 文件管理抓取流量：您认为来自 Google 抓取工具的请求会导致您的服务器超负荷；或者，您不想让 Google 抓取您网站上的不重要网页或相似网页。
- 媒体文件
> 您可以使用 robots.txt 文件管理抓取流量并阻止图片、视频和音频文件出现在 Google 搜索结果中。这不会阻止其他网页或用户链接到您的图片/视频/音频文件。
- 资源文件
> 如果您认为在加载网页时跳过诸如不重要的图片、脚本或样式文件之类的资源不会对网页造成太大影响，您可以使用 robots.txt 文件屏蔽此类资源。不过，如果缺少此类资源会导致 Google 抓取工具更难解读网页，请勿屏蔽此类资源，否则 Google 将无法有效分析有赖于此类资源的网页。
2. 了解 robots.txt 文件的限制
- 并非所有搜索引擎都支持 robots.txt 规则
- 不同的抓取工具会以不同的方式解析语法
- 不同的抓取工具会以不同的方式解析语法

#### 如何编写和提交 robots.txt 文件
[引用](https://developers.google.com/search/docs/crawling-indexing/robots/create-robots-txt?hl=zh-cn)

#### Google 如何解读 robots.txt 规范
[引用](https://developers.google.com/search/docs/crawling-indexing/robots/robots_txt?hl=zh-cn)


### 规范化

#### 什么是规范化
规范化是指选择一段内容的有代表性的规范网址的过程。因此，规范网址是指 Google 从一组重复网页中选出的最具代表性的网页的网址。此过程通常称为重复信息删除，有助于 Google 在搜索结果中仅显示重复内容的一个版本。
1. 网站包含重复内容的原因有很多：
- 区域变体：例如，面向美国和英国的一段内容可通过不同的网址访问，但实质上是同一语言的相同内容
- 设备变体：例如，一个网页既有移动版又有桌面版
- 协议变体：例如，网站的 HTTP 版本和 HTTPS 版本
- 网站函数：例如，类别网页的排序函数和过滤函数的结果
- 意外变体：例如，网站的演示版本意外仍可供抓取工具访问
2. Google 如何将网站编入索引并选择规范网址
- Google 将网页编入索引时，会确定每个网页的主要内容
- 有一些因素会影响规范化：网页是通过 HTTP 还是 HTTPS 提供、重定向、站点地图中是否出现了相应网址，以及 rel="canonical" link 注释
- 对于同一网页的不同语言版本，仅当这些网页的主要内容采用相同的语言时，才会被视为重复网页
- 在评估内容和质量时，Google 会使用规范网页作为主要来源

#### 如何使用 rel="canonical" 及其他方法指定规范网址
- 重定向：强信号，表明重定向的目标应成为规范网址。
- rel="canonical" link 注释：强信号，表明所指定的网址应成为规范网址。
- 站点地图包含：弱信号，有助于站点地图中包含的网址成为规范网址。
1. 指定规范网址的原因
- 指定您希望用户在搜索结果中看到的网址
- 整合类似网页或重复网页的信号
- 简化一段内容的跟踪指标
- 避免花费时间抓取重复网页
2. 最佳实践
- 请勿使用 robots.txt 文件进行规范化
请勿使用网址移除工具进行规范化，它会在搜索结果中隐藏网址的所有版本。
请勿使用不同的规范化方法为同一网页指定不同的规范网址（例如，请勿既在站点地图中为某个网页指定一个规范网址，又使用 rel="canonical" 为同一网页另行指定一个规范网址）。
我们不建议使用 noindex 阻止选择单个网站中的规范网页，因为这样会完全阻止该网页显示在 Google 搜索结果中。rel="canonical" link 注释是首选解决方案。
如果您使用的是 hreflang 元素，请务必指定一个采用同一语言的规范网页；如果没有这样的规范网页，请指定一个采用最佳替代语言的规范网页。
在网站中提供链接时，请链接到规范网址（而非重复网址）。 始终链接到您认定的规范网址有助于 Google 了解您偏好的网址。
3. 规范化方法
- rel="canonical" link 元素
> 在所有重复网页的代码中分别添加一个 <link> 元素，使其指向规范网页。
- rel="canonical" HTTP 标头
> 在网页响应中发送 rel="canonical" 标头。
- 站点地图
> 在站点地图中指定您的规范网页。
- 重定向
> 使用重定向告知 Googlebot 重定向网址是比给定网址更佳的版本。请仅在弃用重复网页时使用此方法。
- AMP 变体
> 如果您的某个网页变体是 AMP 网页，请按照 AMP 指南指明规范网页和 AMP 变体。
- 其他信号
> 除了明确提供的方法之外，Google 还使用一组规范化信号，这些信号通常基于网站设置：优先选择 HTTPS（而非 HTTP）以及优先选择 hreflang 集群中的网址。

#### 解决规范化问题
[检查工具](https://support.google.com/webmasters/answer/9012289?hl=zh-Hans#google-selected-canonical)
常见的规范化问题
- 没有本地化注释的语言版本
- 不正确的规范元素
- 服务器配置不正确
- 恶意攻击
- 转载内容
- 仿冒网站

### 关于移动网站和优先将移动版网站编入索引的最佳实践
1. 创建适合移动设备的网站
有三种配置可供选择:
> 自适应设计(优先选择)
> 动态提供内容
> 动态提供内容
2. 确保 Google 能够访问并呈现您的内容
> 在移动版网站和桌面版网站上使用相同的 robots meta 标记
> 不要依靠用户互动来延迟加载主要内容
> 允许 Google 抓取您的资源
3. 确保桌面版网站和移动版网站具有相同的内容
> 确保移动版网站所含内容与桌面版网站所含内容相同
> 在移动版网站上使用与桌面版网站相同的明确且有意义的标题
4. 检查您的结构化数据
> 确保移动版网站和桌面版网站包含相同的结构化数据
> 在结构化数据中使用正确的网址
> 如果您使用了数据标注工具，请在移动版网站上训练它
5. 在网站的两个版本上添加相同的元数据
> 确保在网站的两个版本上使用等效的 title 元素和元描述
6. 检查广告的展示位置
> 不要让广告对移动版网页的排名产生不良影响
7. 检查视觉内容
- 检查图片
    - 提供高质量的图片
    - 使用支持的图片格式
    - 不要使用每次网页加载时都会更改的图片网址
    - 确保移动版网站使用的图片替代文本与桌面版网站相同
    - 确保移动版网页的内容质量与桌面版网页一样出色
- 检查视频
    - 不要使用每次网页加载时都会更改的视频网址
    - 请使用支持的视频格式，并将视频放入支持的标记中
    - 在移动版网站和桌面版网站上使用相同的视频结构化数据
    - 将视频放在使用移动设备查看网页时易于找到的位置
8. 关于单独网址的其他最佳实践
- 确保桌面版网站和移动版网站上的报错网页状态是相同的
- 确保移动版网站不包含片段网址
- 确保提供不同内容的桌面版本分别具有对应的等效移动版本
- 在 Search Console 中验证网站的这两个版本，确保您能访问这两个版本中的数据和消息
- 检查单独网址中的 hreflang 链接
- 确保移动版网站有足够的容量来应对可能更快的抓取速度
- 验证 robots.txt 规则，确保它们在网站的这两个版本上都能达到预期效果
- 在移动版和桌面版之间使用正确的 rel=canonical 和 rel=alternate link 元素
9. 问题排查
- 缺少结构化数据
- 网页上的 noindex 标记
- 缺少图片
- 图片被屏蔽
- 图片质量不佳
- 缺少替代文本
- 缺少网页标题
- 缺少元描述
- 移动网址指向报错网页
- 移动网址包含锚标记片段
- 移动版网页被 robots.txt 屏蔽
- 重复定向到同一个移动版网页
- 桌面版网站重定向到移动版网站的首页
- 网页存在质量问题
- 视频问题
- 主机负载问题

### AMP (Accelerated Mobile Pages)
与 Google 搜索中的 AMP 网页相关的准则
- AMP 网页必须遵守 [AMP HTML 规范](https://www.ampproject.org/docs/reference/spec.html)。 如果您是新手，请了解如何[创建您的首个 AMP HTML 网页](https://www.ampproject.org/docs/get_started/create.html)。
- 就可浏览的内容和可完成的操作而言，您必须尽可能地让用户能在 AMP 网页上获得与在对应的规范网页上相同的体验。
- AMP 的 URL scheme 必须易于用户理解。
- AMP 网页必须有效，这样才能按预期向用户呈现，并使用与 AMP 相关的功能。包含无效 AMP 标记的网页将无法使用部分搜索功能。
- 如果您向网页中添加结构化数据，请务必遵守我们的结构化数据政策。

#### 了解 AMP 在搜索结果中的运作原理
- Google 搜索会将 AMP 网页编入索引，以提供快速可靠的网络体验。当有可用的 AMP 网页时，系统会将其显示在移动搜索结果中，作为富媒体搜索结果和轮播界面的一部分。
- 当用户选择查看 AMP 网页时，Google 搜索会从 Google AMP Cache 中检索相应网页，从而实现各种加载优化（例如预渲染），网页通常会即刻显示出来。在桌面设备上，AMP 网页目前不会通过 Google AMP Cache/AMP 查看工具提供。 规范的 AMP 网页在行为方面与标准搜索结果类似
- 在用户点击 AMP 内容后的显示方式
> Google AMP 查看工具：Google AMP 查看工具的顶部会显示内容所在的网域，以便用户了解内容发布者是谁。
> Signed Exchange：一种可让浏览器将文档视为属于您的源网域的技术。

#### 优化AMP内容
1. 创建基本的 AMP 网页
2. 使用 CMS 创建 AMP 网页
3. 针对富媒体搜索结果进行优化
4. 监控和改进网页
5. 通过 Codelab 练习

#### 验证AMP内容
1. 通过以下几种方式验证 AMP 内容是否可以在 Google 搜索结果中显示：
- 使用 AMP 测试工具确保您的 AMP 内容能够在 Google 搜索结果中显示。
- 对于适用的 AMP 内容类型，请使用富媒体搜索结果测试验证结构化数据能否正确解析。
- 使用 AMP 状态报告监控您网站上所有 AMP 网页的性能。
2. 修正常见的 AMP 错误
- 关联相关网页，使您的 AMP 网页可被轻松发现
- 遵循针对 AMP 网页的 Google 搜索指南
- 使您的 AMP 内容可供 Googlebot 访问
- 确保您的结构化数据遵循适用于您的网页和功能类型的结构化数据指南

#### 删除AMP内容
略


### JavaScript SEO

#### JavaScript SEO 基础知识
1. Google 对 JavaScript 网络应用的处理流程分为 3 大阶段：
- 抓取
- 呈现
- 索引编制
2. 工作原理
某些 JavaScript 网站可能会使用应用 Shell 模型；在该模型中，初始 HTML 不包含实际内容，并且 Google 需要执行 JavaScript，然后才能查看 JavaScript 生成的实际网页内容。
请注意，依然建议您采取服务器端渲染或预渲染，因为：(1) 它可让用户和抓取工具更快速地看到您的网站内容；(2) 并非所有漫游器都能运行 JavaScript。
3. 用独特的标题和摘要来描述网页
独特的描述性 title 元素和有用的元描述可帮助用户快速找到符合其目标的最佳结果；我们的指南中解释了怎样才算是良好的 title 元素和元描述。
4. 编写兼容的Javascript代码
5. 使用有意义的 HTTP 状态代码
- 避免单页应用中出现 soft 404 错误
    - 使用 JavaScript 重定向至服务器响应 404 HTTP 状态代码（例如 /not-found）的网址
    - 使用 JavaScript 向错误页面添加 `<meta name="robots" content="noindex">`
6. 使用 History API 而非片段
7. 正确注入 rel="canonical" 链接标记
**Warning**: 使用 JavaScript 注入 rel="canonical" 链接标记时，请确保这是网页上唯一的 rel="canonical" 链接标记。不正确的实现方式可能会创建多个 rel="canonical" 链接标记或更改现有的 rel="canonical" 链接标记。 存在冲突或有多个 rel="canonical" 链接标记可能会导致意外结果。
8. 谨慎使用 robots meta 标记
**Warning**: 如果 Google 遇到 noindex 标记，就会跳过渲染和 JavaScript 执行步骤。由于 Google 会在这种情况下跳过您的 JavaScript，也就没有机会从网页上移除标记。
使用 JavaScript 更改或移除 robots meta 标记可能不会起到预期效果。如果 robots meta 标记最初包含 noindex，Google 会跳过渲染和 JavaScript 执行步骤。如果您确实希望将网页编入索引，请勿在原始网页代码中使用 noindex 标记。
9. 使用长效缓存
10. 使用结构化数据
11. 遵循网络组件最佳做法
12. 修正图片和延迟加载的内容
13. 以无障碍为设计宗旨

#### 解决与 Google 搜索相关的 JavaScript 问题
> Googlebot 经过精心设计，是一名优秀的网上公民。它的主要任务是抓取网站，同时确保其抓取操作不会导致网站的用户体验下降。Googlebot 及其网页呈现服务 (WRS) 组件会不断分析和识别对基本网页内容没有贡献的资源，并且可能不会抓取此类资源。例如，对基本网页内容没有贡献的报告和错误请求，以及在提取基本网页内容时不使用或没必要使用的其他类似类型的请求。客户端分析可能无法完整或准确地体现您网站上的 Googlebot 和 WRS 活动。使用 Search Console 可以监控您网站上的 Googlebot 和 WRS 活动及反馈。
1. 如需测试 Google 抓取和呈现网址的效果，请使用 Search Console 中的富媒体搜索结果测试或网址检查工具。您可以查看已加载的资源、JavaScript 控制台输出和异常、呈现的 DOM 以及更多信息
2. 请务必防范 soft 404 错误
两种策略
- 重定向至服务器响应 404 状态代码的网址
- 添加 robots meta 标记或将其更改为 noindex
3. Googlebot 可能会拒绝用户权限请求
4. 请勿使用片段网址加载不同的内容
> 建议使用 History API 根据 SPA 中的网址加载不同的内容
5. 不要依赖数据持久性来提供内容
6. 使用内容指纹避免 Googlebot 缓存问题
7. 确保您的应用针对其所需的所有关键 API 使用功能检测，并在适用情况下提供后备行为或 polyfill
8. 确保您的内容适用于 HTTP 连接
> 它不支持其他类型的连接，例如 WebSockets 或 WebRTC 连接
9. 确保网络组件能按预期呈现。
> 使用富媒体搜索结果测试或网址检查工具检查呈现的 HTML 是否包含您期望的所有内容。
10. 修正此核对清单中的内容后，请再次使用 Search Console 中的富媒体搜索结果测试或网址检查工具测试您的网页

#### 修正延迟加载的内容
1. 当内容在视口中可见时对其进行加载
2. 支持分页加载以实现无限滚动
3. 测试
> 使用 Puppeteer 脚本在本地测试实现效果

#### 将动态呈现作为临时解决方法
动态呈现是一种临时解决方法，而非长期的解决方案，用于解决搜索引擎中 JavaScript 生成的内容的相关问题。 我们建议您使用服务器端呈现、静态呈现或 hydration 作为解决方案。
1. 了解动态呈现的运作方式
要采用动态呈现，您的网络服务器必须能够检测抓取工具（例如，通过检查用户代理）。来自抓取工具的请求将路由到呈现器，来自用户的请求将以正常方式进行处理。如果需要，动态呈现器会提供适合抓取工具的内容版本，例如，它可能会提供静态 HTML 版本。您可以选择为所有网页启用动态呈现器，也可以逐个网页启用动态呈现器。
![原理图](https://developers.google.com/static/search/docs/images/how-dynamic-rendering-works.png?hl=zh-cn)
2. 实现动态呈现
- 安装并配置动态渲染器（例如 Puppeteer、Rendertron 或 prerender.io），以便将内容转换为更便于抓取工具使用的静态 HTML。
- 选择您希望接收您的静态 HTML 的用户代理，并参考具体的配置详情，了解如何更新或添加用户代理
- 确定用户代理需要桌面版内容还是移动版内容
- 将服务器配置为向您选择的抓取工具提供静态 HTML
    - 将来自抓取工具的请求重定向到动态呈现器。
    - 在部署过程中进行预呈现，并使您的服务器向抓取工具提供静态 HTML 内容。
    - 将动态呈现机制内置到自定义服务器代码中。
    - 将来自预渲染服务的静态内容提供给抓取工具。
    - 为服务器使用中间件（例如，rendertron 中间件）。
3. 验证配置
- 使用网址检查工具测试移动版和桌面版内容，确保在渲染的网页上也可以看到这些内容（渲染的网页是 Google 所看到的网页样貌）。
- 如果您使用结构化数据，请使用富媒体搜索结果测试来测试结构化数据能否正确渲染。
4. 问题排查
- 内容不完整或看起来不同
- 响应时间较长
- 网络组件无法按预期呈现
- 缺少结构化数据
[解决方法](https://developers.google.com/search/docs/crawling-indexing/javascript/dynamic-rendering?hl=zh-cn#troubleshooting)

### 网页和内容元数据

#### 页面元数据
1. 使用有效的 HTML 指定网页元数据
2. 元标志
- Google 支持的 meta 标记和属性
> meta 标记是一种 HTML 标记，用于向搜索引擎和其他客户端提供有关网页的其他信息。客户端会处理 meta 标记，并忽略不受支持的元标记。meta 标记应添加到 HTML 网页的 head 部分
3. Google 支持以下 meta 标记：
- `<meta name="description" content="A description of the page">`
- `<meta name="robots" content="..., ..."> OR <meta name="googlebot" content="..., ...">`
- `<meta name="google" content="nositelinkssearchbox">`
- `<meta name="googlebot" content="notranslate">`
- `<meta name="google" content="nopagereadaloud">`
- `<meta name="google-site-verification" content="...">`
- `<meta http-equiv="Content-Type" content="...; charset=..."> OR <meta charset="...">`
- `<meta http-equiv="refresh" content="...;url=...">`
- `<meta name="viewport" content="...">`
- `<meta name="rating" content="adult"> OR <meta name="rating" content="RTA-5042-1996-1400-1577-RTA">`
4. HTML 标记属性
- 对于索引编制来说，Google 搜索支持的 HTML 属性数量有限。src 和 href 等属性用于发现图片和网址等资源。Google 还支持各种 rel 属性，可让网站所有者限定出站链接。
- 通过 div、span 和 section 标记的 data-nosnippet 属性，您可以从摘要中排除 HTML 网页的某些部分。
5. 需要注意的其他事项
- 无论网页采用的是哪种代码，Google 都能读取 HTML 和 XHTML 样式的 meta 标记。
- 为了确保机器能读懂，head 部分必须是有效的 HTML；如果是属性，则所有父标记都必须有对应的结束标记。
- 除了 google-site-verification 外，其他 meta 标记的大小写通常无关紧要。
- 如果其他 meta 标记对您的网站很重要，您可以使用它们，但 Google 会忽略它不支持的 meta 标记。
- 如果您考虑使用 JavaScript 注入或更改 meta 标记，请谨慎操作。我们建议您尽可能避免使用 JavaScript 注入或更改 meta 标记。如果确有必要这么做，请全面[测试您的实现](https://developers.google.com/search/docs/crawling-indexing/javascript/fix-search-javascript?hl=zh-cn)。
- 如需检查网页上的 meta 标记和属性，请使用[网址检查工具](https://support.google.com/webmasters/answer/9012289?hl=zh-cn)。

#### Robots meta 标记、data-nosnippet 和 X-Robots-Tag 规范

只有在抓取工具可以访问包含这些设置的网页时，系统才会读取和遵循这些设置。
`<meta name="robots" content="noindex">` 规则适用于搜索引擎抓取工具。如需屏蔽非搜索抓取工具（例如 AdsBot-Google），您可能需要添加针对具体抓取工具的规则（例如 `<meta name="AdsBot-Google" content="noindex">`）

1. 使用robots meta 标记
借助robots meta 标记，您可以使用精细的网页级设置，控制各个网页被编入索引并在 Google 搜索结果中显示给用户的方式
> 例：`<meta name="robots" content="noindex">`
Google 支持在robots meta 标记中使用以下两个用户代理令牌，其他值会被忽略：
- googlebot：适用于所有文本结果。
- googlebot-news：适用于新闻结果。
2. 使用 X-Robots-Tag HTTP 标头
- X-Robots-Tag 可用作指定网址的 HTTP 标头响应中的一个元素。任何可在robots meta 标记中使用的规则也可以指定为 X-Robots-Tag
`
HTTP/1.1 200 OK
Date: Tue, 25 May 2010 21:42:43 GMT
(…)
X-Robots-Tag: noindex
(…)
`
- 可以在 HTTP 响应中组合使用多个 X-Robots-Tag 标头，也可以指定一系列以英文逗号分隔的规则
`
HTTP/1.1 200 OK
Date: Tue, 25 May 2010 21:42:43 GMT
(…)
X-Robots-Tag: noarchive
X-Robots-Tag: unavailable_after: 25 Jun 2010 15:00:00 PST
(…)
`
- X-Robots-Tag 也可以在规则前面指定用户代理
`
HTTP/1.1 200 OK
Date: Tue, 25 May 2010 21:42:43 GMT
(…)
X-Robots-Tag: googlebot: nofollow
X-Robots-Tag: otherbot: noindex, nofollow
(…)
`
3. 有效的索引编制规则和内容显示规则
- all
- noindex
- nofollow
- none
- noarchive
- nositelinkssearchbox
- nosnippet
- indexifembedded
- max-snippet: [number]
- max-image-preview: [setting]
- max-video-preview: [number]
- notranslate
- noimageindex
- unavailable_after: [date/time]
[规则描述](https://developers.google.com/search/docs/crawling-indexing/robots-meta-tag?hl=zh-cn#directives)
4. 如何处理合并的索引编制规则和内容显示规则
您可以将多个以英文逗号分隔的robots meta 标记规则合并起来或使用多个 meta 标记，创建一条包含多个规则的命令。
例: `<meta name="robots" content="noindex, nofollow">`
5. 使用 data-nosnippet HTML 属性
您可以指定不要使用 HTML 网页的哪些文字部分生成摘要。您可以使用 span、div 和 section 元素中的 data-nosnippet HTML 属性，在 HTML 元素级别实现这一点
6. 使用结构化数据
如需管理在网页中使用结构化数据的方式，请修改结构化数据类型和值本身，添加或移除信息，以便只提供您想提供的数据
7. 实际添加 X-Robots-Tag 
您可以通过网站的网络服务器软件的配置文件将 X-Robots-Tag 添加到网站的 HTTP 响应中
在 HTTP 响应中使用 X-Robots-Tag 的好处是，您可以指定要应用于整个网站的抓取规则。系统支持正则表达式，因此带来了很高的灵活性。
例子：
- Apache
`
<Files ~ "\.pdf$">
  Header set X-Robots-Tag "noindex, nofollow"
</Files>
`
- Nginx
`
location ~* \.pdf$ {
  add_header X-Robots-Tag "noindex, nofollow";
}
`
8. 合并使用 robots.txt 规则与索引编制及内容显示规则
只有当网址被抓取时，robots meta 标记和 X-Robots-Tag HTTP 标头才会被抓取工具发现。

#### 使用 noindex 阻止搜索引擎编入索引
noindex 是一个包含 `<meta>` 标记或 HTTP 响应标头的规则集，用于防止支持 noindex 规则的搜索引擎（例如 Google）将内容编入索引

1. 实施 noindex
实施 noindex 的方法有两种：将其作为 `<meta>` 标记实施，或作为 HTTP 响应标头实施。
- `<meta>` 标记
`<meta name="googlebot" content="noindex">`
- HTTP 响应标头
响应标头可用于非 HTML 资源，例如 PDF、视频文件和图片文件
`
HTTP/1.1 200 OK
(...)
X-Robots-Tag: noindex
(...)
`
2. 调试 noindex 问题
- 可以使用网址检查工具请求 Google 重新抓取您的网页。
- 可以使用 Search Console 中的“网页索引编制”报告监控您网站上 Googlebot 从中发现 noindex 规则的网页。

#### 安全搜索功能和您的网站
1. 安全搜索功能旨在滤除下列影像类搜索结果：
任何类型的露骨色情内容，包括色情作品
裸露内容
逼真的情趣玩具
以性为目的的约会或陪侍服务
暴力或血腥内容
指向包含露骨内容的网页的链接
2. 确定安全搜索功能是否会滤除您的网站
如需确定您的网页是否会被识别为露骨内容，请搜索一个通常会使该网页显示在搜索结果中的字词，然后[开启安全搜索功能](https://support.google.com/websearch/answer/510?hl=zh-Hans)。
如需确定您的整个网站是否会被识别为露骨内容，请在安全搜索功能启用的情况下使用 [site: 搜索运算符](https://developers.google.com/search/docs/monitor-debug/search-operators/all-search-site?hl=zh-cn)。如果搜索结果中未显示您的网站，则表明在安全搜索功能启用的情况下 Google 会滤除您的网站。
3. 如何针对安全搜索功能优化您的网站
- 向含有露骨内容的网页添加元数据
将具有 adult 值的 rating 标记用作 meta 标记或 HTTP 响应标头
`<meta name="rating" content="adult">`
- 将包含露骨内容的网页归入单独位置
如果您的网站包含大量露骨内容和非露骨内容，除了添加元数据之外，建议您在网站中将包含露骨内容的网页与不含露骨内容的网页分为不同的组。
如果您没有分别将网页分组，那么即使有些网页可能不含有露骨内容，我们的系统也可能会确定您的整个网站貌似为露骨性质，并会在安全搜索功能启用的情况下滤除整个网站。
- 使 Google 能够提取您的视频内容文件
- 允许 Googlebot 在抓取内容时不触发年龄限制
4. 问题排查
如果您按照本文中的建议做出了更改，但仍发现网站被系统误标记为露骨内容，请考虑以下事项：
- 如果您近期做出了更改，我们的分类器可能需要更多时间进行处理。此过程最多可能需要 2-3 个月。
- 如果您将网页上的露骨图片进行模糊处理，那么若相应图片可采取模糊修复或指向不模糊的图片，系统仍可能会将其视为露骨内容。
- 请注意，无论您出于什么原因而在网页中包含裸露内容（即使是为了直观展示医疗流程），也无法否定该内容的露骨性质。
- 请注意，如果您的网站包含用户生成的露骨内容，或黑客使用隐藏真实内容的关键字或其他技术向您的网站注入了露骨内容，那么您的网站可能会被视为露骨性质。
- 请注意，包含露骨内容的网页不符合使用某些搜索功能的条件，例如丰富网页摘要、精选摘要或视频预览功能。详细了解搜索功能政策。
- 使用 Search Console 中的网址检查工具实际网址测试，确认 Googlebot 能够在抓取内容时不触发任何年龄限制。

#### rel属性
1. 向 Google 说明您的出站链接的用意
对于您网站上的某些链接，您可能需要向 Google 说明您的网站与链接页之间的关系。为此，请在 <a> 标记中使用下列 rel 属性值之一。
2. rel属性列表
Google 通常不会跟踪标有这些 rel 属性的链接。
- rel="sponsored"
> 请使用 sponsored 值标记广告链接或付费展示位置链接（通常称为“付费链接”）。
- rel="ugc"
> 建议您使用 ugc 值标记用户生成的内容（例如评论和论坛帖子）的链接。
- rel="nofollow"
> 如果其他值不适用，并且您希望 Google 不跟踪您网站上的出站链接，或不从您的网站上抓取链接页，请使用 nofollow 值。对于您网站中的链接，请使用 robots.txt disallow 规则。
- 多个值，您可以使用以空格或英文逗号分隔的列表，指定多个 rel 值。示例：
> `<p>I love <a rel="ugc nofollow" href="https://cheese.example.com/Appenzeller_cheese">Appenzeller</a> cheese.</p>`

如果您不想让 Google 提取指向您的站内网页的链接，请使用 robots.txt disallow 规则。
如果您不想让 Google 将某个网页编入索引，请允许抓取并使用 noindex robots 规则。

### 删除索引

#### 控制与 Google 分享的内容
1. 您可能会出于多种原因而希望阻止 Google 访问您的某些内容：
- 限制数据：您可能希望将自己网站上托管的数据仅呈现给已进入您网站的用户
- 避免向受众群体显示价值不大的内容
- 让 Google 专注于您的重要内容
2. 如何屏蔽内容
- 从您的网站中移除内容
- 通过密码保护文件
- noindex 规则
- 使用 robots.txt 禁止抓取内容
- 停用特定的 Google 产品和服务
- 选择停止显示在 Page Insights 的地点实体功能中
3. 从 Google 中移除现有内容
[从 Google 中移除托管在您网站上的网页](https://developers.google.com/search/docs/crawling-indexing/remove-information?hl=zh-cn)

#### 从 Google 搜索结果中移除您网站上托管的网页
1. 速移除网页
使用[“移除”工具](https://support.google.com/webmasters/answer/9689846?hl=zh-cn)，这样 1 天内即可从 Google 搜索结果中移除托管在您网站上的网页。
有效期大约为 6 个月
2. 永久移除内容 
- 移除或更新您网页上的内容。这是一种最为安全的方式，可防止您的信息显示在可能不遵循 noindex 标记的其他搜索引擎中，还可确保其他人无法访问您的网页。
- 通过密码保护您的网页。通过限制对网页的访问，可让合适的用户查看您的网页，同时阻止 Googlebot 和其他网页抓取工具访问该网页。
- 向网页中添加 noindex 标记。noindex 标记仅会阻止您的网页显示在 Google 搜索结果中。用户和其他不支持 noindex 的搜索引擎仍可访问您的网页。

#### 从 Google 搜索结果中移除您网站上托管的图片
1. 速移除图片
使用[“移除”工具](https://support.google.com/webmasters/answer/9689846?hl=zh-cn)，这样 1 天内即可从 Google 搜索结果中移除托管在您网站上的网页。
有效期大约为 6 个月
2. 永久移除内容 
- robots.txt 禁止规则
例：
`
User-agent: Googlebot-Image
Disallow: /images/dogs.jpg
Disallow: /images/animal-picture-*.jpg
Disallow: /*.gif$
`
- noindex X-Robots-Tag HTTP 标头
3. 让隐去的信息不显示在 Google 搜索中
略


### 网址迁移和变更

#### 重定向和 Google 搜索
1. 重定向网址是将现有网址解析为不同网址的做法，相当于告知访问者和 Google 搜索某个网页有新的地址
定向在以下情况下尤为有用：
- 您已将网站移至新网域，并且想尽可能顺畅地完成迁移。
- 用户可通过多个不同的网址访问您的网站。
- 您正在合并两个网站，并且想确保指向旧网址的链接重定向至正确网页。
- 您移除了某个网页，并希望将用户转到新网页。
2. 重定向类型概览
- 永久重定向：在搜索结果中显示新的重定向目标。
> Googlebot 会遵循重定向指令，并且索引编制流水线会将其用作指示重定向目标应是规范网址的强信号。
    - HTTP 301 (moved permanently)	
    - HTTP 308 (moved permanently)
    - meta refresh（0 秒）
    - JavaScript location
    - Crypto 重定向
- 临时重定向：在搜索结果中显示源网页。
> Googlebot 会遵循重定向指令，并且索引编制流水线会将其用作指示重定向目标应是规范网址的弱信号。
    - HTTP 302 (found)
    - HTTP 303 (see other)
    - HTTP 307 (temporary redirect)

3. 服务器端重定向
如需设置服务器端重定向，您需要访问服务器配置文件（例如 Apache 上的 .htaccess 文件），或使用服务器端脚本（例如 PHP 脚本）来设置重定向标头。
- PHP
> `
> header('HTTP/1.1 301 Moved Permanently');
> header('Location: https://www.example.com/newurl');
> exit();
> 
> header('HTTP/1.1 302 Found');
> header('Location: https://www.example.com/newurl');
> exit();
> `
- Apache
**使用mod_alias:**
> `
> \# Permanent redirect:
> Redirect permanent "/old" "https://example.com/new"
> 
> \# Temporary redirect:
> Redirect temp "/two-old" "https://example.com/two-new"
> `

**使用mod_rewrite**
> `
> RewriteEngine on
> \# redirect the service page to a new page with a permanent redirect
> RewriteRule   "^/service$"  "/about/service"  [R=301]
> 
> \# redirect the service page to a new page with a temporary redirect
> RewriteRule   "^/service$"  "/about/service"  [R]
>`
- Nginx
**return**
> `
> location = /service {
>   \# for a permanent redirect
>   return 301 $scheme://example.com/about/service
> 
>   \# for a temporary redirect
>   return 302 $scheme://example.com/about/service
> }
> `
**rewrite**
> `
> location = /service {
>   \# for a permanent redirect
>   rewrite service?name=$1 ^service/offline/([a-z]+)/?$ permanent;
> 
>   \# for a temporary redirect
>   rewrite service?name=$1 ^service/offline/([a-z]+)/?$ redirect;
> }
> `

4. meta refresh 及其 HTTP 等效项
- 即时 meta refresh 重定向：在浏览器加载网页时立即触发。Google 搜索会将即时 meta refresh 重定向解析为永久重定向。
- 延迟 meta refresh 重定向：仅在网站所有者设置的任意秒数之后触发。Google 搜索会将延迟 meta refresh 重定向解析为临时重定向。
**<head> 元素示例**
`
<!doctype html>
<html>
  <head>
  <meta http-equiv="refresh" content="0; url=https://example.com/newlocation">
  <title>Example title</title>
  </head>
  <!--...-->
</html>
`
**HTTP 标头项示例**
`
HTTP/1.1 200 OK
Refresh: 0; url=https://www.example.com/newlocation
...
`
**延迟重定向，请将 content 属性设置为重定向应延迟的秒数**
`
<!doctype html>
<html>
  <head>
  <meta http-equiv="refresh" content="5; url=https://example.com/newlocation">
  <title>Example title</title>
  <!--...-->
`

5. JavaScript location 重定向
仅在您无法实施服务器端重定向或 meta refresh 重定向时，才使用 JavaScript 重定向。虽然 Google 会尝试呈现 Googlebot 抓取到的每个网址，但可能会由于各种原因而呈现失败。这意味着，如果您设置了 JavaScript 重定向，但 Google 无法呈现相应内容，那么 Google 可能永远都无法看到该重定向。
例如：
`
<!doctype html>
<html>
  <head>
    <script>
      window.location.href = "https://www.example.com/newlocation";
    </script>
    <title>Example title</title>
    <!--...-->
`
6. 网址的备用版本
当您重定向网址时，Google 会跟踪重定向来源（旧网址）和重定向目标（新网址）。

#### 网址迁移
1. 更改托管基础架构
- 准备新的托管基础架构
    - 复制和测试新网站
    - 检查 Googlebot 能否访问新的托管基础架构
    - 降低 DNS 记录的 TTL 值
    - 检查 Search Console 验证状态
- 开始网站迁移
    - 移除所有会被抓取的临时数据块
    - 更新 DNS 设置
- 监控流量
    - 密切关注新旧服务器上的服务器日志
    - 使用不同的公共 DNS 检查工具
    - 监控抓取
- Googlebot 抓取速度注意事项
如果您更改托管基础架构，那么正常情况下，Googlebot 的抓取速度在新系统启用后即会出现暂时下降，但在接下来的几天内会稳步上升，并可能会升至比迁移之前还要高的速度。
- 关闭旧的托管基础架构
检查旧服务提供商的服务器日志。一旦旧服务提供商的访问流量为零，您便可关闭旧的托管基础架构。

2. 如何迁移网站
- 迁移网站最佳实践
    - 将迁移过程分解为若干个小步骤（如果适合您的网站）。
    - 一次只更改一项内容
    - 尽量选择在网络流量较低时进行迁移
    - 预计迁移期间网站排名会出现短暂波动
    - 不用担心链接权重
    - 充分利用 Search Console
    - 耐心等待
- 准备新网站
- 准备网址映射
- 开始网站迁移
- 监控流量
- 其他资源
- 排查网站迁移问题
[参考](https://developers.google.com/search/docs/crawling-indexing/site-move-with-url-changes?hl=zh-cn)
3. A/B 测试
[参考](https://developers.google.com/search/docs/crawling-indexing/website-testing?hl=zh-cn)
4. 暂停或停用网站
[参考](https://developers.google.com/search/docs/crawling-indexing/pause-online-business?hl=zh-cn)
