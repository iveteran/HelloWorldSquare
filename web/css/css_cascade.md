# CSS属性设置冲突时的处理规则

[Refer](https://web.dev/learn/css/the-cascade?hl=zh-cn)

编写 CSS 时或整个 Web 平台时，请务必注意，CSS 显示的所有内容都是一个框。无论是使用 border-radius 看上去像圆形的框，还是仅仅是一些文本，要记住的关键点在于，它都是框。

## CSS 表示级联样式表
级联是一种算法，用于解决多个 CSS 规则应用于 HTML 元素时发生的冲突。
1. 了解级联算法有助于您了解浏览器如何解决此类冲突。级联算法分为 4 个不同的阶段。
- 显示位置和显示顺序：CSS 规则的显示顺序
- 特异性：一种算法，用于确定哪个 CSS 选择器具有最强的匹配项
- 来源：CSS 的出现顺序及来源，是浏览器样式、浏览器扩展程序中的 CSS，还是您自己编写的 CSS
- 重要性：某些 CSS 规则的权重高于其他规则，尤其是 !important 规则类型

### 位置和显示顺序
1. 系统还会按照 CSS 规则的顺序应用位置
```css
.my-element {
  background: green;
  background: purple;  /* browser will use this value */
}
```
2. 声明了 CSS 的内嵌 style 属性将替换所有其他 CSS，无论其位置如何，除非在声明中定义了 !important。
3. 若要为不支持特定值的浏览器创建回退，一种简单的方法就是能够为同一属性指定两个值。
```css
.my-element {
  font-size: 1.5rem;
  font-size: clamp(1.5rem, 1rem + 3vw, 2rem);  /* 如果浏览器不支持clamp函数会使用上一行的值 */
}
```
### 特异性
特异性是一种使用加权或评分系统来确定最具体 CSS 选择器的算法。通过使规则更加具体，即使与选择器匹配的其他一些 CSS 稍后出现在 CSS 中，您也可以应用该规则。
- 与只定位元素相比，CSS 将类定位到元素会使该规则更具体，因此被视为更重要的应用
- id 会使 CSS 更加具体，因此应用于 ID 的样式将替换通过其他多种方式应用的样式。

### 来源
这些来源的特异性顺序（从最不具体到最具体）如下：
- 用户代理基本样式。这些是默认情况下您的浏览器应用于 HTML 元素的样式。
- 本地用户样式。这些设置可能来自操作系统级别，例如基本字体大小或首选移动优化。它们还可以来自浏览器扩展程序，例如允许用户为网页编写自定义 CSS 的浏览器扩展程序。
- 自行编写的 CSS。您编写的 CSS。
- 作者：!important。您添加到自己编写的声明中的任何 !important。
- 本地用户样式 !important。来自操作系统级或浏览器扩展级 CSS 的任何 !important。
- 用户代理 !important。在浏览器提供的默认 CSS 中定义的任何 !important。

### 重要性
重要性顺序如下所示（从最不重要到最高）：
- 一般规则类型，如 font-size、background 或 color
- animation 个规则类型
- !important 规则类型（遵循与源站相同的顺序）
- transition 个规则类型
