Google AMP页面实施手册

[Refer](https://amp.dev/zh_cn/documentation/guides-and-tutorials/websites/start/converting/)

1. 文件名
<FILE>.amp.html
注：您无需将 AMP 文件命名为 .amp.html。事实上，AMP 文件可以使用您想要的任何扩展名。

2. 添加 AMP 库，请将下面这行内容添加到 `<head>` 标记底部：
`
<script async src="https://cdn.ampproject.org/v0.js"></script>
`

3. 指定 AMP 属性
`<html ⚡ lang="en"></html>`
或
`<html amp lang="en"></html>`

4. 指定视口
`
<meta name="viewport" content="width=device-width" />
`

5. 替换外部样式表
`
<link href="base.css" rel="stylesheet" />
`
改为
`
<style amp-custom>
  /* The content from base.css */
</style>
`

6. 排除第三方 JavaScript
一般来说，只有符合以下两项主要要求的脚本才允许在 AMP 中使用：
- 所有 JavaScript 都必须是异步的（即，在脚本代码中添加 async 属性）。
- JavaScript 用于 AMP 库以及网页中的任何 AMP 组件。

7. 添加 AMP CSS 样板
略

8. 将 `<img>` 替换为 `<amp-img>`
`
<amp-img
  src="mountains.jpg"
  layout="responsive"
  width="266"
  height="150"
></amp-img>
`

9. 添加字符集
`
<meta charset="utf-8" />
`

10. 关联 AMP 内容
article.amp.html:
`<link rel="canonical" href="/article.html" />`
article.html:
`<link rel="amphtml" href="/article.amp.html" />`

![](https://amp.dev/static/img/docs/tutorials/tut-convert-html-link-between.png)

11. 添加结构化数据
`
<script type="application/ld+json">
  {
    "@context": "http://schema.org",
    "@type": "NewsArticle",
    "mainEntityOfPage": {
      "@type": "WebPage",
      "@id": "https://example.com/my-article.html"
    },
    "headline": "My First AMP Article",
    "image": {
      "@type": "ImageObject",
      "url": "https://example.com/article_thumbnail1.jpg",
      "height": 800,
      "width": 800
    },
    "datePublished": "2015-02-05T08:00:00+08:00",
    "dateModified": "2015-02-05T09:20:00+08:00",
    "author": {
      "@type": "Person",
      "name": "John Doe"
    },
    "publisher": {
      "@type": "Organization",
      "name": "⚡ AMP Times",
      "logo": {
        "@type": "ImageObject",
        "url": "https://example.com/amptimes_logo.jpg",
        "width": 600,
        "height": 60
      }
    },
    "description": "My first experience in an AMPlified world"
  }
</script>
`

12. 验证：
浏览器开发者控制台
AMP 验证工具绑定了 AMP JS 库，因此可直接在任何 AMP 网页上使用。要验证 AMP 网页，请执行以下操作：
以下片段标识符添加到您的网址中：
`
#development=1
`
在浏览器中打开 AMP 网页。
将“#development=[1,actions,amp,amp4ads,amp4email]”附加到网址后面，例如 http://localhost:8000/released.amp.html#development=1 是用于验证 AMP 格式的旧方式。网址 http://localhost:8000/released.amp.html#development=amp4email 将针对 AMP 电子邮件规范验证文档。
打开 Chrome DevTools 控制台并检查有无验证错误。

13. AMP 扩展组件
- 内置：此类组件是指 AMP JavaScript 基础库中包括的组件（在 `<head>` 标记中指定），例如 amp-img 和 amp-pixel。这些组件可直接用于 AMP 文档中。
- 扩展：此类组件是指相对于基础库而言的扩展功能，必须作为自定义元素明确包括在文档中。自定义元素需要添加到 `<head>` 部分中的具体脚本（例如 `<script async custom-element="amp-video" ...`）。

1) 广告
`
<script
  async
  custom-element="amp-ad"
  src="https://cdn.ampproject.org/v0/amp-ad-0.1.js"
></script>
...
<amp-ad
  width="300"
  height="250"
  type="doubleclick"
  data-slot="/35096353/amptesting/image/static"
>
</amp-ad>
`

2) 嵌入 YouTube 视频
`
<script async custom-element="amp-youtube" src="https://cdn.ampproject.org/v0/amp-youtube-1.0.js"></script>
...
<amp-youtube
  data-videoid="npum8JsITQE"
  layout="responsive"
  width="480"
  height="270"
>
  <div fallback>
    <p>The video could not be loaded.</p>
  </div>
</amp-youtube>
`

3) 显示推文Twitter
`
<script
  async
  custom-element="amp-twitter"
  src="https://cdn.ampproject.org/v0/amp-twitter-0.1.js"
></script>
...
<amp-twitter
  width="486"
  height="657"
  layout="responsive"
  data-tweetid="638793490521001985"
>
</amp-twitter>
`

4) 突出显示报道中的精彩语段
`
<script
  async
  custom-element="amp-fit-text"
  src="https://cdn.ampproject.org/v0/amp-fit-text-0.1.js"
></script>
...
<amp-fit-text width="400" height="75" layout="responsive" max-font-size="42">
  Big, bold article quote goes here.
</amp-fit-text>
`

5) 简单的图片轮播界面
`
<script
  async
  custom-element="amp-carousel"
  src="https://cdn.ampproject.org/v0/amp-carousel-0.1.js"
></script>
...
<amp-carousel layout="fixed-height" height="168" type="carousel">
  <amp-img src="mountains-1.jpg" width="300" height="168"></amp-img>
  <amp-img src="mountains-2.jpg" width="300" height="168"></amp-img>
  <amp-img src="mountains-3.jpg" width="300" height="168"></amp-img>
</amp-carousel>
`
您可以通过各种方式配置 amp-carousel 组件。在此示例中，我们将界面改为一次仅显示 1 张图片，并将轮换展示内容的布局设为自适应。
为此，我们需要先将 amp-carousel 的 type 从 carousel 更改为 slides，将 layout 更改为 responsive，并将 width 设置为 300（请确保已定义 height 和 width）。然后，将 "layout=responsive" 属性添加到 amp-carousel 的各个 amp-img 子级中。

14. 通过分析跟踪互动
为了能够在 AMP 中复制此功能，我们必须先在文档的 `<head>` 中添加 amp-analytics 组件库：
`
<script
  async
  custom-element="amp-analytics"
  src="https://cdn.ampproject.org/v0/amp-analytics-0.1.js"
></script>
`
然后，将 amp-analytics 组件添加到文档的 body 末尾处：
`
<amp-analytics type="googleanalytics">
  <script type="application/json">
    {
      "vars": {
        "account": "UA-YYYY-Y"
      },
      "triggers": {
        "default pageview": {
          "on": "visible",
          "request": "pageview",
          "vars": {
            "title": "Name of the Article"
          }
        }
      }
    }
  </script>
</amp-analytics>
`
