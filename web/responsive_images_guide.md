# 自适应图片

[Refer](https://web.dev/articles/responsive-images?hl=zh-cn)

## 摘要
1. 为图片使用相对尺寸，以防止图片意外溢出容器。
2. 如果您想根据设备特性（也称为艺术指导）指定不同的图片，请使用 picture 元素。
3. 在 img 元素中使用 srcset 和 x 描述符，以提示浏览器从不同密度中选择最合适的图片。
4. 如果您的网页只有一两张图片，并且这些图片未在网站上的其他位置使用，请考虑使用内嵌图片以减少文件请求。

## 使用相对尺寸的图片
`
img, embed, object, video {
    max-width: 100%;
}
`

## 针对高 DPI 设备使用 srcset 增强 img
srcset 属性增强了 img 元素的行为，可让您轻松针对不同设备特性提供多个图片文件，srcset 允许浏览器根据设备特性选择最佳图片。
`
<img src="photo.png" srcset="photo@2x.png 2x" ...>
`

## 自适应图片中的艺术指导picture
picture 元素定义了一个声明性解决方案，用于根据设备尺寸、设备分辨率、屏幕方向等不同特征提供图片的多个版本。
`
<picture>
  <source media="(min-width: 800px)" srcset="head.jpg, head-2x.jpg 2x">
  <source media="(min-width: 450px)" srcset="head-small.jpg, head-small-2x.jpg 2x">
  <img src="head-fb.jpg" srcset="head-fb-2x.jpg 2x" alt="a head carved out of wood">
</picture>
`

## 相对大小的图片
如果不知道图片的最终尺寸，则很难为图片来源指定密度描述符。
您可以通过添加宽度描述符以及图片元素的大小来指定所提供图片的大小，而不是提供固定的图片大小和密度，这样浏览器就可以自动计算有效像素密度并选择要下载的最佳图片。
`
<img src="lighthouse-200.jpg" sizes="50vw"
     srcset="lighthouse-100.jpg 100w, lighthouse-200.jpg 200w,
             lighthouse-400.jpg 400w, lighthouse-800.jpg 800w,
             lighthouse-1000.jpg 1000w, lighthouse-1400.jpg 1400w,
             lighthouse-1800.jpg 1800w" alt="a lighthouse">
`

## 考虑自适应图片中的断点
在许多情况下，图片大小可能会根据网站的布局断点发生变化。例如，在小屏幕上，您可能希望图片占据视口的整个宽度，而在大屏幕上，则应只占很小的比例。
`
<img src="400.png"
     sizes="(min-width: 600px) 25vw, (min-width: 500px) 50vw, 100vw"
     srcset="100.png 100w, 200.png 200w, 400.png 400w,
             800.png 800w, 1600.png 1600w, 2000.png 2000w" alt="an example image">
`

## 其他图像技术
1. 压缩图片
2. JavaScript 图片替换
创建和存储图片有两种完全不同的方法，这会影响以响应方式部署图片的方式。
- 光栅图片（如照片和其他图片）表示为由各个颜色点组成的网格。光栅图像可能来自相机或扫描仪，或者通过 HTML 画布元素创建。PNG、JPEG 和 WebP 等格式用于存储光栅图片。
- 矢量图片（例如徽标和艺术线条）被定义为一组曲线、线条、形状、填充色和渐变色。矢量图像可通过 Adobe Illustrator 或 Inkscape 等程序创建，或使用 SVG 等矢量格式在代码中手写。
3. 数据 URI
数据 URI 提供了一种内嵌文件（例如图片）的方法，只需使用如下格式将 img 元素的 src 设置为 Base64 编码的字符串即可：
`<img src="data:image/svg+xml;base64,[data]">`
4. 在 CSS 中内嵌
Data URI 和 SVG 还可以内联到 CSS 中，移动设备和桌面设备均支持此功能。下面是两个外观完全相同的图片，在 CSS 中实现为背景图片；一个是 Data URI，另一个是 SVG：

## CSS 中的图片
摘要
- 使用最适合显示屏的特性的图像，还应考虑屏幕尺寸、设备分辨率和页面布局。
- 结合使用媒体查询和 min-resolution 和 -webkit-min-device-pixel-ratio，针对高 DPI 显示屏更改 CSS 中的 background-image 属性。
- 除了标记中的 1x 图片之外，使用 srcset 提供高分辨率图片。
- 在使用 JavaScript 图片替换技术或向分辨率较低的设备提供高度压缩的高分辨率图片时，请考虑性能成本。

1. 使用媒体查询有条件地加载图片或提供艺术指导
`
.example {
  height: 400px;
  background-image: url(small.png);
  background-repeat: no-repeat;
  background-size: contain;
  background-position-x: center;
}

@media (min-width: 500px) {
  body {
    background-image: url(body.png);
  }
  .example {
    background-image: url(large.png);
  }
}
`
2. 使用 image-set 提供高分辨率图片
CSS 中的 image-set() 函数增强了 background 属性的行为，可让您轻松针对不同设备特性提供多个图片文件。
`
background-image: image-set(
    url(icon1x.jpg) 1x,
    url(icon2x.jpg) 2x
);
`
3. 使用媒体查询提供高分辨率图片或艺术指导
`
.sample {
  width: 128px;
  height: 128px;
  background-image: url(icon1x.png);
}

@media (min-resolution: 2dppx), /* Standard syntax */
(-webkit-min-device-pixel-ratio: 2)  /* Safari & Android Browser */
{
  .sample {
    background-size: contain;
    background-image: url(icon2x.png);
  }
}
`

## 为图标使用 SVG
1. 使用 Unicode 替换简单图标
许多字体支持大量 Unicode 字形，可用于代替图片。与图片不同，Unicode 字体可以缩放，无论在屏幕上的显示大小如何，显示效果都很好。
`
You're a super &#9733;
`
2. 将复杂图标替换为 SVG
对于更复杂的图标要求，SVG 图标通常要轻量、易用，并且可以通过 CSS 设置样式。
3. 谨慎使用图标字体

## 优化图片以提升性能
1. 选择合适的图片格式
在选择适当的格式时，请先参考以下准则：
- 对于摄影图片，请使用 JPG。
- 对矢量艺术和纯色图形（例如徽标和艺术线条）使用 SVG。如果矢量插画不可用，请尝试使用 WebP 或 PNG。
- 使用 PNG 而非 GIF，因为前者可以提供更多颜色并提供更好的压缩比。
- 如需更长的动画，请考虑使用 `<video>`，它可以提供更好的图片质量，并允许用户控制播放。
2. 缩减文件大小
对于 JPG，请尝试使用 jpegtran 或 jpegoptim（仅适用于 Linux；使用 --strip-all 选项运行）。对于 PNG，请尝试 OptiPNG 或 PNGOUT
3. 使用图片精灵
CSS 精灵是一种技术，可将许多图片组合成一张“精灵表”图片。然后，您可以通过指定元素的背景图片（精灵表）以及指定用于显示正确部分的偏移量，来使用各张图片。
4. 考虑延迟加载
在非首屏包含多张图片的长页面中，延迟加载可以显著加快加载速度，它可以根据需要加载图片，或者在主要内容加载和呈现完毕后加载这些图片。

5. 延迟加载
loading 属性
Chrome 会以不同的优先级加载图片，具体取决于这些图片相对于设备视口的位置。视口下方的图片会以较低的优先级加载，但仍会在网页加载时抓取。
您可以使用 loading 属性完全推迟加载通过滚动到达的屏幕外图片：
`<img src="image.png" loading="lazy" alt="…" width="200" height="200">`
以下是 loading 属性支持的值：
lazy：延迟加载资源，直到资源与视口达到计算出的距离为止。
eager：浏览器的默认加载行为，等同于不添加该属性，并表示无论图片位于网页上的何处，系统都会加载图片。虽然这是默认设置，但如果您的工具在没有明确值时自动添加 loading="lazy"，或者如果 linter 提示未明确设置，则显式设置会很有用。

## 完全避免使用图片
将文本放在标记内，而不是嵌入到图片中
使用 CSS 替换图片
