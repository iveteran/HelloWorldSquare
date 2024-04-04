# Web 性能

refer: https://web.dev/learn/performance/welcome?hl=zh-cn

## 一般注意事项

1. 尽量减少重定向
2. 缓存 HTML 响应
缓存 HTML 的一种审慎方法是使用 ETag 或 Last-Modified 响应标头。ETag（也称为实体标记）标头是一个标识符，用于唯一标识所请求资源，通常使用资源内容的哈希值：
ETag: "33a64df551425fcc55e4d42a148795d9f25f89d4"
3. 测量服务器响应时间
如果用户在字段遇到 TTFB 缓慢的问题，您可以使用 Server-Timing 响应标头公开有关时间在服务器上的什么位置的信息：
> Server-Timing: auth;dur=55.5, db;dur=220
Server-Timing 标头的值可以包含多个指标，以及每个指标的时长。
然后，可以在现场使用 Navigation Timing API 从用户那里收集这些数据，并进行分析，以了解用户是否遇到延迟。
在前面的代码段中，响应标头包含两个显示时间：
- 对用户进行身份验证的时间 (auth)，用时 55.5 毫秒。
- 数据库访问时间 (db)，用时 220 毫秒。
4. 压缩
基于文本的响应（例如 HTML、JavaScript、CSS 和 SVG 图片）应进行压缩，以减小通过网络传输时的大小，从而加快其下载速度。
最常用的压缩算法是 gzip 和 Brotli。Brotli 比 gzip 提高了约 15% 到 20%。
- 尽可能使用 Brotli。如前所述，Brotli 比 gzip 提供了相当明显的改进，并且所有主流浏览器都支持 Brotli。
- 文件大小至关重要。非常小的资源（小于 1 KiB）压缩得不太好，有时甚至根本压缩不到。
- 了解动态压缩和静态压缩。动态压缩和静态压缩是确定何时应压缩资源的不同方法。
5. 内容分发网络 (CDN)
内容分发网络 (CDN) 是分布式服务器网络，服务器从源服务器缓存资源，反过来再从物理上更靠近用户的边缘服务器传送资源。在距离用户较近时，可以缩短往返时间 (RTT)，而 HTTP/2 或 HTTP/3、缓存和压缩等优化技术则可以让 CDN 更快地提供内容，而不是从源服务器提取内容。在某些情况下，使用 CDN 可以显著改善网站的 TTFB。

## 了解关键呈现路径

1. 渐进式渲染
在使用前安装的原生应用不同，浏览器不能依赖于具有呈现网页所需的所有资源的网站。
2. 关键渲染路径
呈现路径涉及以下步骤：
- 通过 HTML 构建文档对象模型 (DOM)。
- 通过 CSS 构建 CSS 对象模型 (CSSOM)。
- 应用任何会更改 DOM 或 CSSOM 的 JavaScript。
- 通过 DOM 和 CSSOM 构建渲染树。
- 在页面上执行样式和布局操作，看看哪些元素适合显示。
- 在内存中绘制元素的像素。
- 如果有任何像素重叠，则合成像素。
- 以物理方式将所有生成的像素绘制到屏幕上。
![render flow](https://web.dev/static/learn/performance/understanding-the-critical-path/image/fig-1-v2.svg?hl=zh-cn)
3. 浏览器需要等待一些关键资源下载完毕，然后才能完成初始渲染。这些资源包括：
HTML 的一部分。
`<head>` 元素中阻塞渲染的 CSS。
`<head>` 元素中的阻塞渲染的 JavaScript。
4. 在首次渲染时，浏览器通常不会等待：
- 所有 HTML。
- 字体。
- Images.
- `<head>` 元素外（例如，位于 HTML 末尾的 `<script>` 元素）之外的非阻塞渲染的 JavaScript。
- `<head>` 元素外或media 属性值不适用于当前视口的 CSS，不会阻止内容渲染。
5. `<head>` 元素是处理关键渲染路径的关键。优化 `<head>` 元素的内容是提升网页性能的一个关键方面。
不过，并非 `<head>` 元素中引用的所有资源都是首次呈现网页所必需的，因此浏览器只会等待那些资源。
为了确定哪些资源处于关键渲染路径中，您需要了解阻塞渲染和解析器的 CSS 和 JavaScript。
6. 阻塞渲染的资源
有些资源被认为非常关键，以至于浏览器会暂停网页呈现，直到它处理完毕。CSS 默认属于此类别。
当浏览器看到 CSS（无论是 `<style>` 元素中的内嵌 CSS，还是由 `<link rel=stylesheet href="...">` 元素指定的外部引用的资源）时，浏览器在完成对该 CSS 的下载和处理之前，将避免呈现更多内容。
资源阻塞渲染并不一定意味着它会阻止浏览器执行任何其他操作。浏览器会尽可能地提高效率，因此，当浏览器发现需要下载某项 CSS 资源时，它会请求该 CSS 资源并暂停渲染，但仍会继续处理其余 HTML 并寻找其他工作。
7. 阻塞解析器的资源
阻塞解析器的资源是指那些阻止浏览器通过继续解析 HTML 来寻找要执行的其他工作的资源。默认情况下，JavaScript 会阻塞解析器（除非明确标记为异步或延迟），因为 JavaScript 可能会在执行时更改 DOM 或 CSSOM。因此，在了解所请求 JavaScript 对网页 HTML 造成的全部影响之前，浏览器就不可能继续处理其他资源。因此，同步 JavaScript 会阻止解析器。
8. 识别阻塞资源
许多性能审核工具都会识别阻塞渲染和解析器的资源。
[WebPageTest](https://www.webpagetest.org/) 会使用资源网址左侧橙色圆圈标记阻止呈现的资源
Lighthouse 还会以更巧妙的方式突出显示阻塞渲染的资源，并且仅会在该资源实际延迟页面渲染时突出显示。
9. 关键内容渲染路径
长期以来，关键渲染路径一直关注的是初次渲染。然而，出现了更多以用户为中心的 Web 性能指标，这让用户质疑关键渲染路径的端点应该是首次渲染，还是之后内容更丰富的渲染之一。

另一种方法是将注意力集中在内容渲染路径（或其他人可能称之为关键路径）的 Largest Contentful Paint (LCP)（甚至是 First Contentful Paint (FCP)）之前。在这种情况下，您可能需要包含不一定会阻塞的资源（这一直是关键渲染路径的典型定义），但这些资源对于渲染内容渲染是必需的。

无论您对“关键”内容有何确切定义，了解阻碍任何初始渲染的因素和关键内容非常重要。首次渲染用于衡量首次可能有机会为用户渲染任何内容。理想情况下，这应该有意义，而不是像背景颜色一样，但即使它没有内容，呈现给用户仍然是有价值的，这也是衡量关键渲染路径（如传统上所定义）的一个参数。同时，衡量何时向用户呈现主要内容也有价值。

- 确定内容呈现路径
许多工具都可以识别 LCP 元素及其呈现时间。除了 LCP 元素之外，Lighthouse 还可以帮助您确定 LCP 阶段以及每个阶段所花费的时间，以帮助您了解最集中的优化工作

## 优化资源加载

1. 渲染阻塞
CSS 是一种阻塞渲染的资源，因为它会阻止浏览器渲染任何内容，直至您构建了 CSS 对象模型 (CSSOM)。浏览器会阻止呈现，以防止出现非样式内容闪烁 (FOUC)，这从用户体验的角度来看是不希望发生的。
2. 解析器屏蔽
阻止解析器的资源会中断 HTML 解析器，例如没有 async 或 defer 属性的 `<script>` 元素。当解析器遇到 `<script>` 元素时，浏览器需要先评估并执行脚本，然后才能继续解析 HTML 的其余部分。这是设计使然，因为在 DOM 构建过程中，脚本可能会修改或访问 DOM。
`
<!-- This is a parser-blocking script: -->
<script src="/script.js"></script>
`
使用外部 JavaScript 文件（不带 async 或 defer）时，从发现文件开始，到下载、解析和执行该文件，解析器才会被阻止。使用内嵌 JavaScript 时，解析器也会以类似方式被屏蔽，直到解析并执行内嵌脚本。
3. 预加载扫描器
预加载扫描程序是一种浏览器优化，采用辅助 HTML 解析器的形式，可扫描原始 HTML 响应，以找出并推测性地提取资源，然后主 HTML 解析器才会发现这些资源。
预加载扫描器无法发现以下资源加载模式：
- 由 CSS 使用 background-image 属性加载的图片。这些图片引用位于 CSS 中，预加载扫描器无法发现这些引用。
- 动态加载的脚本，采用 `<script>` 元素标记（使用 JavaScript 注入 DOM）或使用动态 import() 加载的模块。
- 使用 JavaScript 在客户端上呈现的 HTML。此类标记包含在 JavaScript 资源的字符串中，预加载扫描器无法发现此类标记。
- CSS @import 声明
4. CSS
- 缩减大小
缩减 CSS 文件大小可缩减 CSS 资源的文件大小，从而缩短下载速度。
这主要是通过从 CSS 源文件中移除内容（例如空格和其他不可见字符）并将结果输出到新优化的文件来实现的
- 移除未使用的 CSS
在呈现任何内容之前，浏览器需要先下载并解析所有样式表。完成解析所需的时间还包括当前网页上未使用的样式
如需发现当前网页未使用的 CSS，请使用 Chrome 开发者工具中的[覆盖率工具](https://developer.chrome.com/docs/devtools/css/reference/?hl=zh-cn#coverage)。
- 避免使用 CSS @import 声明
虽然这看起来似乎很方便，但您应避免在 CSS 中使用 @import 声明：
`
/* Don't do this: */
@import url('style.css');

<!-- Do this instead: -->
<link rel="stylesheet" href="style.css">
`
- 内嵌关键 CSS
下载 CSS 文件所需的时间可能会增加网页的 FCP。在文档 `<head>` 中内嵌关键样式可以消除对 CSS 资源的网络请求，并且如果操作正确，可以在用户的浏览器缓存尚未准备好时缩短初始加载时间。
其余 CSS 可以异步加载，也可以附加到 `<body>` 元素的末尾。
`
<head>
  <title>Page Title</title>
  <!-- Inline CSS -->
  <style>h1,h2{color:#000}h1{font-size:2em}h2{font-size:1.5em}</style>
</head>
<body>
  <!-- Other page markup... -->
  <link rel="stylesheet" href="non-critical.css">
</body>
`
但其缺点是，内嵌大量 CSS 会导致初始 HTML 响应的字节增多。
由于 HTML 资源通常无法缓存很长时间（甚至根本无法缓存），因此对于可能在外部样式表中使用同一 CSS 的后续网页，系统不会缓存内联的 CSS。请测试和衡量网页的性能，以确保权衡取舍是值得的。

5. JavaScript
- 阻止呈现的 JavaScript
加载不带 defer 或 async 属性的 `<script>` 元素时，浏览器会阻止解析和呈现，直到脚本下载、解析并执行完毕。同样，内联脚本也会阻止解析器，直到解析和执行脚本。
async 与 defer
async 和 defer 允许加载外部脚本，而不会阻止 HTML 解析器，而具有 type="module" 的脚本（包括内嵌脚本）会自动延迟。不过，async 和 defer 之间存在一些差异，请务必理解。
使用 async 加载的脚本会在下载后立即解析和执行，而使用 defer 加载的脚本会在 HTML 文档解析完成时执行 - 这与浏览器的 DOMContentLoaded 事件同时发生。
此外，async 脚本可能会不按顺序执行，而 defer 脚本则会按照它们在标记中出现的顺序执行。
- 客户端渲染
通常，您应避免使用 JavaScript 来呈现任何关键内容或网页的 LCP 元素。这称为客户端渲染，是一种在单页应用 (SPA) 中广泛使用的技术。
- 缩减大小
与 CSS 类似，缩减 JavaScript 大小可缩减脚本资源的文件大小。 这可以加快下载速度，使浏览器能够更快地继续解析和编译 JavaScript 的过程。
此外，缩减 JavaScript 的大小比缩减其他资源（如 CSS）更进一步。缩减 JavaScript 的大小时，不仅会去除空格、制表符和注释等内容，而且源 JavaScript 中的符号也会被缩短。此过程有时称为“伪造”。

## 通过资源提示协助浏览器

资源提示可以告知浏览器如何加载资源并确定资源优先级，从而帮助开发者进一步缩短网页加载时间。

1. preconnect
preconnect 提示用于与另一个来源（您要从其中提取关键资源）建立连接。例如，您可能在 CDN 或其他跨源上托管图片或资源：
`
<link rel="preconnect" href="https://example.com">
`
使用 preconnect 即表示您预计浏览器计划在不久的将来连接到特定的跨源服务器，并且浏览器应尽快打开该连接，最好是在等待 HTML 解析器或预加载扫描程序执行此操作之前打开。
如果网页上有大量跨源资源，请对当前网页最至关重要的资源使用 preconnect。
crossorigin 属性用于指示是否必须使用跨域资源共享 (CORS) 提取资源。使用 preconnect 提示时，如果从来源下载的资源使用 CORS（例如字体文件），则需要将 crossorigin 属性添加到 preconnect 提示中。
`
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
`

2. dns-prefetch
虽然尽早打开与跨源服务器的连接可以显著缩短初始网页加载时间，但同时与多个跨源服务器建立连接可能不合理或不可行。如果您担心可能过度使用了 preconnect，可以使用 dns-prefetch 提示来使用开销大大降低的资源提示。

根据其名称，dns-prefetch 不会与跨源服务器建立连接，而只是提前为其执行 DNS 查找。在将域名解析为其底层 IP 地址时，会发生 DNS 查询。虽然在设备和网络层级设置 DNS 缓存层有助于使此过程从总体上加快，但仍然需要一些时间。
`
<link rel="dns-prefetch" href="https://fonts.googleapis.com">
<link rel="dns-prefetch" href="https://fonts.gstatic.com">
`

3. preload
preload 指令用于提前请求呈现网页所需的资源：
`
<link rel="preload" href="/lcp-image.jpg" as="image">
`
preload 指令应仅限于后期发现的关键资源。最常见的用例包括字体文件、通过 @import 声明提取的 CSS 文件，或可能是 Largest Contentful Paint (LCP) 候选对象的 CSS background-image 资源。在这种情况下，预加载扫描器不会发现这些文件，因为相应资源是在外部资源中引用的。
与 preconnect 类似，如果您要预加载 CORS 资源（例如字体），则 preload 指令也需要 crossorigin 属性。如果您未添加 crossorigin 属性（或者为非 CORS 请求添加该属性），则浏览器会下载两次资源，浪费带宽，本来可以本该花在其他资源上。
`
<link rel="preload" href="/font.woff2" as="font" crossorigin>
`

4. prefetch
prefetch 指令用于针对可能会用于未来导航的资源发起低优先级请求：
`
<link rel="prefetch" href="/next-page.css" as="style">
`
prefetch 主要是推测性的，因为您将发起对资源的提取，以便将来的导航不一定会发生。
有时，prefetch 可以派上用场 - 例如，如果您在网站上确定了一个大多数用户需要完成的操作流程，那么为这些未来网页使用渲染关键资源的 prefetch 就有助于缩短用户的加载时间。

5. 提取优先级 API
您可以通过其 fetchpriority 属性使用 Fetch Priority API 来提高资源的优先级。您可以将该属性与 `<link>、<img> 和 <script>` 元素一起使用。
`
<div class="gallery">
  <div class="poster">
    <img src="img/poster-1.jpg" fetchpriority="high">
  </div>
  <div class="thumbnails">
    <img src="img/thumbnail-2.jpg" fetchpriority="low">
    <img src="img/thumbnail-3.jpg" fetchpriority="low">
    <img src="img/thumbnail-4.jpg" fetchpriority="low">
  </div>
</div>
`
默认情况下，系统会以较低的优先级提取图片。完成布局后，如果发现图片位于初始视口内，优先级将提升为高。在前面的 HTML 代码段中，fetchpriority 会立即告知浏览器以高优先级下载较大的 LCP 图片，而以较低的优先级下载不太重要的缩略图。

现代浏览器分两个阶段加载资源。第一阶段预留给关键资源，并在所有阻塞脚本下载和执行后结束。在此阶段，低优先级资源的下载可能会延迟。通过使用 fetchpriority="high"，您可以提高资源的优先级，使浏览器能够在第一阶段下载资源。

## 图片效果

1. 映像大小
使用图片资源时，您可以执行的第一项优化是以正确的尺寸显示图片。

2. srcset
`<img>` 元素支持 srcset 属性，该属性可让您指定浏览器可能会使用的可能图片来源的列表。指定的每个图片来源都必须包含图片网址，以及宽度或像素密度描述符。
`
<img
  alt="An image"
  width="500"
  height="500"
  src="/image-500.jpg"
  srcset="/image-500.jpg 1x, /image-1000.jpg 2x, /image-1500.jpg 3x"
>
`
3. sizes
借助 sizes 属性，您可以指定一组来源尺寸，其中每个来源尺寸都由媒体条件和值组成。sizes 属性用于描述图片的预期显示尺寸（以 CSS 像素为单位）。
与 srcset 宽度描述符结合使用时，浏览器可以选择哪种图片来源最适合用户的设备。
`
<img
  alt="An image"
  width="500"
  height="500"
  src="/image-500.jpg"
  srcset="/image-500.jpg 500w, /image-1000.jpg 1000w, /image-1500.jpg 1500w"
  sizes="(min-width: 768px) 500px, 100vw"
>
`

4. 文件格式
浏览器支持多种不同的图片文件格式。与 PNG 或 JPEG 相比，新型图片格式（例如 WebP 和 AVIF）可提供更好的压缩效果，从而缩小图片文件大小，从而缩短下载时间。
- WebP 是一种受到广泛支持的格式，适用于所有新型浏览器。
WebP 的压缩效果通常比 JPEG、PNG 或 GIF 更好，既能提供有损压缩，也提供无损压缩。即使在使用有损压缩时，WebP 也支持 Alpha 通道透明度，而 JPEG 编解码器没有此功能。
- AVIF 是一种较新的图片格式，虽然没有 WebP 那么广泛支持，但它的跨浏览器支持相当得心应。
AVIF 同时支持有损压缩和无损压缩，并且在某些情况下，与 JPEG 相比，测试的节省幅度超过了 50%。AVIF 还提供广色域 (WCG) 和高动态范围 (HDR) 功能。

5. 压缩
涉及图像时，有两种压缩类型：
- 有损压缩
- 无损压缩
有损压缩的工作原理是通过量化降低图片准确性，并且可能会使用色度子采样舍弃其他颜色信息。
无损压缩可以通过在不丢失数据的情况下压缩图片来减小文件大小。无损压缩根据与相邻像素之间的差异来描述像素。
您可以使用 [Squoosh](https://squoosh.app/)、[ImageOptim](https://imageoptim.com/) 或图片优化服务压缩图片。

6. `<picture>` 元素
`<picture>` 元素可让您更灵活地指定多个候选图片：
`
<picture>
  <source type="image/avif" srcset="image.avif">
  <source type="image/webp" srcset="image.webp">
  <img
    alt="An image"
    width="500"
    height="500"
    src="/image.jpg"
  >
</picture>
`
使用此方法时，浏览器会选择指定匹配的第一个 `<source>` 元素。如果它可以以该格式渲染图像，则会使用该图像。否则，浏览器会移至下一个指定的 `<source>` 元素。直至回退到更兼容的旧图片格式。
`<source>` 元素还支持 media、srcset 和 sizes 属性。与前面的 `<img>` 示例类似，这些变量会向浏览器指示要在不同视口上选择哪个图片。
`
<picture>
  <source
    media="(min-resolution: 1.5x)"
    srcset="/image-1000.jpg 1000w, /image-1500.jpg 1500w"
    sizes="(min-width: 768px) 500px, 100vw"
  >
  <img
    alt="An image"
    width="500"
    height="500"
    src="/image-500.jpg"
  >
</picture>
`

7. 如何管理复杂性
根据 Accept 请求标头提供图片
Accept HTTP 请求标头会告知服务器，用户的浏览器可以理解哪些类型的内容。服务器可以使用此信息来提供最佳图片格式，而无需向 HTML 响应添加额外的字节。

8. 延迟加载
您可以使用 loading 属性告知浏览器在图片显示在视口中时延迟加载图片。lazy 的属性值会告知浏览器：图片在进入（或靠近）视口时才会下载。这样可以节省带宽，让浏览器可以优先使用渲染视口中已有的关键内容所需的资源。

9. decoding
decoding 属性会告知浏览器应如何解码图片。值 async 会告知浏览器，图片可以异步解码，有可能缩短呈现其他内容的时间。值 sync 会告知浏览器，此图片应与其他内容同时呈现。auto 的默认值允许浏览器决定什么最适合用户。

## 视频表现

1. 视频源文件
多种形式
使用视频文件时，如果浏览器不支持所有现代格式，那么指定多种格式可以作为后备选项。
`
<video>
  <source src="video.webm" type="video/webm">
  <source src="video.mp4" type="video/mp4">
</video>
`
2. poster 属性
视频的海报图片是使用 `<video>` 元素上的 poster 属性添加的，该属性会在开始播放前向用户提示视频内容可能是什么：
`
<video poster="poster.jpg">
  <source src="video.webm" type="video/webm">
  <source src="video.mp4" type="video/mp4">
</video>
`
3. 自动播放
如果您的网站要求自动播放视频，您可以直接在 `<video>` 元素上使用 autoplay 属性：
`
<!-- This will automatically play a video, but
     it will loop continuously and be muted: -->
<video autoplay muted loop playsinline>
  <source src="video.webm" type="video/webm">
  <source src="video.mp4" type="video/mp4">
</video>
`
4. 用户启动的播放
通常，一旦 HTML 解析器发现 <video> 元素，浏览器就会开始下载视频文件。如果您有 <video> 元素在用户发起播放时播放，那么您可能需要等到用户与其互动之后，才开始下载视频。
您可以使用 <video> 元素的 preload 属性来影响为视频资源下载的内容：
- 设置 preload="none" 可告知浏览器不应预加载任何视频内容。
- 设置 preload="metadata" 仅提取视频元数据，例如视频时长，可能还有一些其他粗略信息。
如果您要加载用户需要开始播放的视频，则最好设置 preload="none"。
5. 嵌入
考虑到高效优化和提供视频内容非常复杂，有必要将此问题分流给 YouTube 或 Vimeo 等专用视频服务。这些服务会为您优化视频的传送过程，但嵌入来自第三方服务的视频可能会对性能产生自身的影响，因为嵌入的视频播放器通常会提供大量额外的资源，例如 JavaScript。

## 优化网页字体

网络字体会影响网页在加载时和呈现时的性能。 较大的字体文件可能需要一段时间才能下载完毕，并且会对 First Contentful Paint (FCP) 产生负面影响，而不正确的 font-display 值则可能会导致不必要的布局偏移，进而导致网页的Cumulative Layout Shift (CLS)。

1. 发现字体
页面的网络字体是使用 @font-face 声明在样式表中定义的：
`
@font-face {
  font-family: "Open Sans";
  src: url("/fonts/OpenSans-Regular-webfont.woff2") format("woff2");
}
`
上述代码段定义了一个名为 "Open Sans" 的 font-family，并告知浏览器在哪里可以找到相应的网页字体资源。为了节省带宽，浏览器在确定当前页面的布局需要网页字体之前，不会下载该字体。
`
h1 {
  font-family: "Open Sans";
}
`
在上述 CSS 代码段中，浏览器会在解析网页的 HTML 中的 `<h1>` 元素时下载 "Open Sans" 字体文件。
2. prelaod
您可以使用 preload 指令发起对网页字体资源的提前请求。preload 指令可让网页字体在网页加载初期被检测到，浏览器会立即开始下载这些字体，无需等待样式表完成下载和解析。preload 指令不会等到网页上需要相应字体时再执行。
`
<!-- The `crossorigin` attribute is required for fonts—even
     self-hosted ones, as fonts are considered CORS resources. -->
<link rel="preload" as="font" href="/fonts/OpenSans-Regular-webfont.woff2" crossorigin>
`
3. 内嵌 @font-face 声明
您可以使用 `<style>` 元素在 HTML 的 `<head>` 中内嵌会阻止渲染的 CSS（包括 @font-face 声明），以便使字体在网页加载的早期阶段被检测到。在这种情况下，
浏览器会在网页加载初期发现网页字体，因为它不需要等待外部样式表下载。
内嵌 @font-face 声明优于使用 preload 提示，因为浏览器只会下载呈现当前网页所需的字体。这样可以消除下载未使用的字体的风险。

4. 下载
- 自行托管网页字体
网络字体可通过第三方服务（如 Google Fonts）提供，也可以在源站上自行托管。使用第三方服务时，您的网页需要先打开与提供商网域的连接，然后才能开始下载所需的网页字体。这可能会延迟网页字体的发现和后续下载。

使用 preconnect 资源提示可以减少此开销。通过使用 preconnect，您可以告知浏览器比浏览器通常更快打开跨源连接：
`
<link rel="preconnect" href="https://fonts.googleapis.com">  
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
`
- 仅使用 WOFF2 和 WOFF2
WOFF2 获得了广泛的浏览器支持和最佳压缩效果，比 WOFF 高出 30%。文件缩小可加快下载速度。WOFF2 格式通常是现代浏览器实现完全兼容性所需的唯一格式。

5. 字体渲染
浏览器发现并下载某种网页字体后，就可以进行渲染了。默认情况下，在下载使用网页字体的任何文本之前，浏览器都会阻止其渲染。您可以使用 font-display CSS 属性调整浏览器的文本渲染行为，并配置在网页字体完全加载之前应显示（或不显示）哪些文本。

- block
font-display 的默认值为 block。使用 block 时，浏览器会阻止呈现使用指定网页字体的任何文本。

- swap
swap 是使用最广泛的 font-display 值。swap 不会阻止渲染，并且会在交换成指定的网页字体之前立即以后备方式显示文本。这样，您就可以立即显示内容，而无需等待网络字体下载完成。
不过，swap 的缺点是，如果 CSS 中指定的后备网页字体和网页字体在行高、字距和其他字体指标方面存在很大差异，则会导致布局偏移。如果您不小心使用 preload 提示尽快加载网页字体资源，或者不考虑其他 font-display 值，这可能会影响网站的 CLS。

- fallback
font-display 的 fallback 值在 block 和 swap 之间折衷。与 swap 不同，浏览器会阻止字体渲染，但只能在很短的时间内交换回退文本。不过，与 block 不同的是，阻塞期极短。
使用 fallback 值可以在运行速度较快的网络上取得良好效果。
在此类网络上，如果网页字体可以快速下载，则网页字体是网页首次渲染时立即使用的字体。不过，如果网速较慢，系统会在屏蔽期过后先显示后备文本，然后在网页字体到达时替换掉后备文本。

- optional
optional 是最严格的 font-display 值，仅在 100 毫秒内下载时才会使用网页字体资源。
如果某种网页字体的加载用时超过该时长，便不会在网页上使用，因此浏览器会使用后备字体进行当前导航，同时在后台下载该网页字体并将其存放在浏览器缓存中。
因此，后续网页导航可以立即使用网页字体，因为网页字体已下载。font-display: optional 可以避免 swap 时发生的布局偏移，但如果网页字体在初始网页导航时过晚出现，某些用户就看不到网页字体了。

## 代码拆分 JavaScript 

加载大型 JavaScript 资源会显著影响网页速度。将 JavaScript 拆分为较小的区块并仅下载网页在启动期间正常运行所必需的内容，可以极大地提高网页的加载响应能力，进而提高网页的互动到下一次绘制 (INP)。

关于代码拆分的实用说明
1. 如果可以，请使用捆绑器
2. 避免意外停用流式编译
- 转换您的生产代码，避免使用 JavaScript 模块。
- 如果您要将 JavaScript 模块部署到生产环境中，请使用 .mjs 扩展。

Webpack
webpack 附带一个名为 SplitChunksPlugin 的插件，您可以通过该插件配置打包器拆分 JavaScript 文件的方式。webpack 可识别动态 import() 和静态 import 语句。您可以通过在其配置中指定 chunks 选项来修改 SplitChunksPlugin 的行为：
- chunks: async 是默认值，表示动态 import() 调用。
- chunks: initial 是指静态 import 调用。
- chunks: all 涵盖动态 import() 和静态导入，可让您在 async 和 initial 导入之间共享分块。

## 延迟加载图片和 `<iframe>` 元素

1. 使用 loading 属性延迟加载图片
可以将 loading 属性添加到 `<img>` 元素中，以告知浏览器应如何加载这些元素：
- "eager" 用于告知浏览器应立即加载图片，即使图片位于初始视口之外。这也是 loading 属性的默认值。
- "lazy" 会延迟图片加载，直到图片与可见视口之间的距离保持在设定的范围内。此距离因浏览器而异，但通常设置得足够大，以便在用户滚动到图片时加载图片。
2. 不要延迟加载初始视口中的图片
您只能为位于初始视口之外的 `<img>` 元素添加 loading="lazy" 属性。不过，在呈现网页之前知道元素在视口中的确切位置可能并非易事。必须考虑不同的视口大小、宽高比和设备。

3. `<iframe>` 元素的 loading 属性
所有主流浏览器也都支持 `<iframe>` 元素上的 loading 属性。loading 属性的值及其行为与使用 loading 属性的 `<img>` 元素相同：
- "eager" 为默认值。它会告知浏览器立即加载 `<iframe>` 元素的 HTML 及其子资源。
- "lazy" 会延迟加载 `<iframe>` 元素的 HTML 及其子资源，直到该元素与视口之间的距离在预定义的距离以内。

## 预提取、预渲染和 Service Worker 预缓存

您可以使用 `<link rel="prefetch">` 资源提示提前提取资源（包括图片、样式表或 JavaScript 资源）。prefetch 提示用于告知浏览器在不久的将来可能需要某个资源。

1. 预提取网页，加快日后的导航速度
您还可以通过在指向某个 HTML 文档时指定 as="document" 属性来预提取网页及其所有子资源：
`
<link rel="prefetch" href="/page" as="document">
`
当浏览器处于空闲状态时，可能会为 /page 发起低优先级请求。

2. 预渲染页面
除了预提取资源之外，还可以提示浏览器在用户导航到某个网页之前预呈现该网页。这种做法几乎可以即时加载网页，因为系统会在后台提取和处理网页及其资源。当用户导航到相应页面后，系统会将该页面置于前台。
Speculation Rules API 支持预渲染：
`
<script type="speculationrules">
{
  "prerender": [
    {
      "source": "list",
      "urls": ["/page-a", "page-b"]
    }
  ]
}
</script>
`
3. Service Worker 预缓存
您还可以使用 Service Worker 推测性地预提取资源。Service Worker 预缓存可以使用 Cache API 提取和保存资源，这样浏览器无需访问网络即可使用 Cache API 处理请求。Service Worker 预缓存使用一种非常有效的 Service Worker 缓存策略，称为“仅缓存”策略。这种模式非常有效，因为将资源放入 Service Worker 缓存后，可在收到请求时几乎即时提取这些资源。
Workbox 使用预缓存清单来确定应预缓存的资源。预缓存清单是一个文件和版本控制信息列表，可作为要预缓存的资源的“可信来源”。
`
[{
    url: 'script.ffaa4455.js',
    revision: null
}, {
    url: '/index.html',
    revision: '518747aa'
}]
`
