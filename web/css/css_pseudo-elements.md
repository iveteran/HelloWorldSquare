# CSS伪元素 

伪元素类似于添加或定位额外的元素而无需添加更多 HTML。

1. ::first-letter 第一个字符
可用的属性包括：
- color
- background 属性（例如 background-image）
- border 属性（例如 border-color）
- float
- font 属性（例如 font-size 和 font-weight）
- 文本属性（如 text-decoration 和 word-spacing）
```css
p::first-letter {
  color: goldenrod;
  font-weight: bold;
}
```

2. ::before和::after
仅当您定义了 content 属性时，::before 和 ::after 伪元素才会在元素内创建子元素。
content 可以是任何字符串（即使是空字符串）
创建 ::before 或 ::after 元素后，您可以随意为其设置样式，且没有任何限制。您只能将 ::before 或 ::after 元素插入接受子元素的元素

3. ::first-line
仅当已应用 ::first-line 的元素的 display 值为 block、inline-block、list-item、table-caption 或 table-cell 时，::first-line 伪元素才会允许您设置文本第一行的样式。
```css
p::first-line {
  color: goldenrod;
  font-weight: bold;
}
```

4. ::backdrop
如果您有以全屏模式呈现的元素（例如 <dialog> 或 <video>），可以使用 ::backdrop 伪元素设置背景幕（元素与页面其余部分之间的空间）的样式：
```css
video::backdrop {
  background-color: goldenrod;
}
```

5. ::marker
借助 ::marker 伪元素，您可以为列表项或 <summary> 元素的箭头设置项目符号或编号的样式。
::marker 仅支持一小部分 CSS 属性：
- color
- content
- white-space
- font 个房源
- animation 和 transition 属性

6. ::selection 伪元素可用于设置所选文本的外观。
```css
::selection {
  background: green;
  color: white;
}
p:nth-of-type(2)::selection {
  background: darkblue;
  color: yellow;
}
```

7. ::placeholder
您可以为表单元素添加辅助提示，例如具有 placeholder 属性的 <input>。您可以使用 ::placeholder 伪元素设置该文本的样式。
```css
input::placeholder {
  color: darkcyan;
}
```
::placeholder 仅支持部分 CSS 规则：
- color
- background
- font
- text

8. ::cue
可以设置 WebVTT 提示（即 <video> 元素的字幕）的样式。
您还可以将选择器传递到 ::cue 中，以便设置标题内的特定元素的样式。
```css
video::cue {
  color: yellow;
}
video::cue(b) {
  color: red;
}
video::cue(i) {
  color: lightpink;
}
```
