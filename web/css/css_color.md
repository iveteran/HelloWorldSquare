# CSS颜色

[Refer](https://web.dev/learn/css/color?hl=zh-cn)

## 数字颜色
1. 十六进制颜色
```css
h1 {
  color: #b71540;
  /* color: #b7154080; with 50% aphla */
}
```

2. RGB（红、绿、蓝）
```css
h1 {
  color: rgb(183, 21, 64);
}
```
如需在 RGB 中设置黑色，请将其设置为 rgb(0 0 0)，即零红色、零绿色和零蓝色。黑色也可以定义为 rgb(0%, 0%, 0%)。
白色是完全相反的字母：rgb(255, 255, 255) 或 rgb(100%, 100%, 100%)。

有两种方式之一在 rgb() 中设置 Alpha 版:
- 在红色、绿色和蓝色参数后面添加一个 /。
- 使用 rgba() 函数。
alpha 值可以指定为百分比或介于 0 到 1 之间的小数。例如，如需在现代浏览器中设置 50% alpha 黑色，请写入：rgb(0 0 0 / 50%) 或 rgb(0 0 0 / 0.5)。
如需获得更广泛的支持，请使用 rgba() 函数，写入 rgba(0, 0, 0, 50%) 或 rgba(0, 0, 0, 0.5)。

NOTE: 我们从 rgb() 和 hsl() 表示法中移除了英文逗号，因为较新的颜色函数（例如 lab() 和 lch()）使用空格（而非英文逗号）作为分隔符。

3. HSL（色调、饱和度、亮度）
```css
h1 {
  color: hsl(344, 79%, 40%);
}
```
HSL 代表色相、饱和度和亮度。 色调用于描述色轮上的值，范围为 0 度到 360 度，从红色开始（表示 0 和 360 度）。 色调 180（即 50%）位于蓝色范围内。这是我们所见颜色的来源。
Alpha 是在 hsl() 中定义的，方式与 rgb() 相同，即在色相、饱和度和亮度参数后面添加 /，或者使用 hsla() 函数。

4. 颜色关键字
[CSS 中有 148 种已命名的颜色](https://web.dev/learn/css/color?hl=zh-cn#color_keywords)

5. 在 CSS 规则中的什么位置使用颜色
- 文本样式: color、text-shadow 和 text-decoration-color
- 背景: background、background-color 和 linear-gradient
- 边框和轮廓: border-color 和 outline-color, box-shadow 属性也接受 color 作为值之一。
