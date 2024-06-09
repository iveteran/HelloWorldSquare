# CSS 伪类

## 互动状态

1. :hover
如果用户有鼠标或触控板等指控设备，并且他们将其放在某个元素上，您可以使用 :hover 连接到该状态以应用样式。

2. :active
如果在释放点击之前用户正与某个元素互动（例如点击）时，就会触发此状态。

3. :focus、:focus-within 和 :focus-visible
如果某个元素可以获得焦点（例如 <button>），您可以使用 :focus 伪类来响应该状态。
如果元素的子元素获得焦点，您还可以使用 :focus-within 做出回应。
借助 :focus-visible，您可以在元素通过键盘获得焦点时显示焦点样式

4. :target
:target 伪类用于选择 id 与网址片段匹配的元素。

5. :link
可应用于 href 值尚未被访问的任何 <a> 元素。

6. :visited
设置用户访问的链接的样式。
如果您定义了 :visited 样式，它可被特异性至少相同的链接伪类替换。 因此，建议您使用 LVHA 规则按特定顺序为包含伪类的链接设置样式：:link、:visited、:hover、:active。


## 表单状态

1. :disabled和:enabled
如果浏览器停用了某个表单元素（例如 <button>），您可以使用 :disabled 伪类连接到该状态。:enabled 伪类适用于相反状态，尽管表单元素默认情况下也是 :enabled，因此您可能无法找到此伪类。

2. :checked和:indeterminate
当辅助表单元素（如复选框或单选按钮）处于选中状态时，可以使用 :checked 伪类。
但当复选框既未勾选也未取消选中时，它就会处于中间状态。这称为 :indeterminate 状态。

3. :placeholder-shown
如果表单字段具有 placeholder 属性但没有值，则 :placeholder-shown 伪类可用于将样式附加到该状态。一旦字段中有内容，无论其是否具有 placeholder，此状态将不再适用。

## 验证状态

您可以使用 :valid、:invalid 和 :in-range 等伪类响应 HTML 表单验证。
:valid 和 :invalid 伪类对于以下上下文非常有用：电子邮件字段需要匹配 pattern 才能成为有效字段。此有效值状态可以显示给用户，帮助他们了解可以安全地移动到下一个字段。
如果输入具有 min 和 max（例如数字输入），并且其值在这些边界内，则可以使用 :in-range 伪类。

## 按索引、顺序和出现次数选择元素

1. :first-child和:last-child
如果要查找第一项或最后一项，可以使用 :first-child 和 :last-child。这些伪类将返回一组同级元素中的第一个或最后一个元素。

2. :only-child
使用 :only-child 伪类选择没有同级的元素。

3. :first-of-type和:last-of-type
:first-of-type 表示一组兄弟元素中其类型的第一个元素。
:last-of-type 表示了在（它父元素的）子元素列表中，最后一个给定类型的元素。

4. :nth-child和:nth-of-type
:nth-child 和 :nth-of-type 伪类允许您指定位于特定索引的元素。CSS 选择器中的索引编制从 1 开始。
您还可以使用 An+B 微语法创建更复杂的选择器，这些选择器会以固定间隔查找项。
```css
li:nth-child(3n+3) {
    background: yellow;
}
```

5. :only-of-type
在一组同级元素中找到某一类型的唯一元素。如果您想选择仅包含一个项的列表，或者要查找某个段落中唯一的粗体元素，这会非常有用。

6. :empty
如果某个元素没有子元素，则系统会对子元素应用 :empty 伪类。

## 查找和排除多个元素

1. :is()
如果您要在 .post 元素中查找所有 h2、li 和 img 子元素，则可能需要编写如下所示的选择器列表：
```css
.post h2,
.post li,
.post img {
    …
}
```
您可以使用 :is() 伪类编写更紧凑的版本：
```ccs
.post :is(h2, li, img) {
    …
}
```

2. :not()
您还可以使用 :not() 伪类排除项。例如，您可以用它来设置没有 class 属性的所有链接的样式。
```css
a:not([class]) {
    color: blue;
}
```
