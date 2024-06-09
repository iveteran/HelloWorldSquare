# CSS布局

[Refer](https://web.dev/learn/css/layout?hl=zh-cn)

## 内嵌元素(inline)
内嵌元素的行为类似于句子中的字词。它们在内嵌方向上并排显示。
`<span>` 和 `<strong>` 等元素通常用于为所含元素（如 `<p> `[段落]）中的文本段设置样式，它们默认采用内嵌样式。它们还会保留周围的空白。
您无法为内嵌元素设置明确的宽度和高度。周围的元素会忽略任何块级的外边距和内边距。
```css
.my-element {
  display: inline;
}
```

## 块元素(block)
块元素不会并排放置。 他们会自行另起一行。
除非被其他 CSS 代码更改，否则块元素将展开为内嵌尺寸，因此在水平书写模式下会跨越整个宽度。将采用 block 元素所有侧边的外边距。
```css
.my-element {
  display: block;
}
```

## 弹性盒子(flex)
flex 会使该框成为块级框，并将其子项转换为弹性项。这会启用用于控制对齐、排序和流动的灵活属性。
```css
.my-element {
  display: flex;
}
```
- Flexbox 是一维布局的布局机制。沿单轴布局（水平或垂直）。 默认情况下，Flexbox 将在内嵌方向上彼此相邻地对齐元素的子元素，并在块方向上拉伸这些子元素，使它们的高度相同。
- 各项内容将保持在同一轴上，且在空间用尽时不会换行。 相反，它们会尝试各自挤入同一行。 可以使用 align-items、justify-content 和 flex-wrap 属性更改此行为。
- flex 属性是 flex-grow、flex-shrink 和 flex-basis 的简写形式。如下两个示例相同：
```css
.my-element div {
  flex: 1 0 auto;
}
.my-element div {
  flex-grow: 1;
  flex-shrink: 0;
  flex-basis: auto;
}
```

## 网格(grid)
1. 网格在很多方面与 Flexbox 类似，但其设计是为了控制多轴布局，而不是单轴布局（垂直或水平空间）。
```css
.my-element {
  display: grid;
}
```
2. 您可以构建传统的 12 列网格，每个项之间有间隔，并具有 3 个 CSS 属性：
```css
.my-element {
  display: grid;
  grid-template-columns: repeat(12, 1fr);
  gap: 1rem;
}
```
3. 网格可让您在两个维度上精确控制项的位置。我们可以定义此网格中的第一项占据 2 行 3 列：
```css
.my-element :first-child {
  grid-row: 1/3;
  grid-column: 1/4;
}
```
grid-row 和 grid-column 属性指示网格中的第一个元素从第一列跨越到第四列的起始位置，然后从第一行跨越到第三行。

## 流式布局

1. 内嵌块(inline-block)
还记得周围元素如何不遵循内嵌元素的块外边距和内边距吗？借助 inline-block，您可以做到这一点。
```css
p span {
    display: inline-block;
}
```
使用 inline-block 会得到一个具备块级元素一些特性的框，但该框仍然内嵌在文本中。
```css
p span {
    margin-top: 0.5rem;
}
```

2. 浮动(float)
如果某张图片包含在一段文本中，那么这段文字会不会很方便，就像您在报纸中看到的那样？您可以使用浮动执行此操作。
```css
img {
    float: left;
    margin-right: 1em;
}
```
float 属性指示元素“浮动”到指定的方向。此示例中的图像被指示向左浮动，然后同级元素可以“环绕”它。您可以指示某个元素悬浮 left、right 或 inherit。

3. 多列布局
```html
<h1>All countries</h1>
<ul class="countries">
  <li>Argentina</li>
  <li>Aland Islands</li>
  <li>Albania</li>
  <li>Algeria</li>
  <li>American Samoa</li>
  <li>Andorra</li>
  …
</ul>
```
```css
.countries {
    column-count: 2;
    column-gap: 1em;
}
```
或
```css
.countries {
    width: 100%;
    column-width: 260px;
    column-gap: 1em;
}
```

4. 定位(Positioning)
position 属性可更改元素在文档正常流程中的行为方式，以及元素与其他元素的关系。可用选项包括 relative、absolute、fixed 和 sticky，默认值为 static。
```css
.my-element {
  position: relative;
  top: 10px;
}
```
如果将 position 设置为 absolute，则会将该元素脱离当前文档流程。这意味着有两个方面：
您可以将此元素放到任何位置，只需在其最近的相对父项中使用 top、right、bottom 和 left 即可。
绝对元素周围的所有内容都会重排，以填充该元素所剩的剩余空间。
position 值为 fixed 的元素的行为与 absolute 类似，其父级是根 `<html>` 元素。固定位置元素会根据您设置的 top、right、bottom 和 left 值保持在左上角锚定。

您可以使用 sticky 实现 fixed 的锚定固定方面以及 relative 的可预测性更强的文档流遵循方面。使用此值时，当视口滚动经过该元素时，它会固定在您设置的 top、right、bottom 和 left 值上。
