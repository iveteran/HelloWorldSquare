# CSS 继承

[Refer](https://web.dev/learn/css/inheritance?hl=zh-cn)

## 默认继承的属性的完整列表:
azimuth(方位角)
border-collapse
border-spacing
caption-side(图片说明)
color(颜色)
cursor
direction
empty-cells(空单元格)
font-family(字体系列)
font-size
font-style
font-variant
font-weight
font(字体)
letter-spacing(字母间距)
line-height
list-style-image
list-style-position
list-style-type
list-style
orphans(孤儿)
quotes(引号)
text-align
text-indent
text-transform
visiblility(可见性)
white-space
widows(丧偶)
word-spacing

## 继承流程

根元素 (<html>) 不会继承任何内容，因为它是文档中的第一个元素。在该 HTML 元素上添加一些 CSS，该元素便会开始沿文档向下级联。
继承只会向下流动，而不会向上流向父元素。

1. inherit 关键字
您可以使用 inherit 关键字使任何属性继承其父项的计算值。使用此关键字的实用方法是创建例外情况。
```css
.my-component strong {
  font-weight: inherit;
}
```

2. initial 关键字
继承可能会导致元素出现问题，并且 initial 为您提供了强大的重置选项。
您之前已经了解到，CSS 中的每个属性都有一个默认值。initial 关键字会将属性设置回初始默认值。
```css
aside strong {
  font-weight: initial;
}
```

3. unset 关键字
无论是否默认继承了某个属性，unset 属性的行为都会有所不同。如果属性在默认情况下是继承的，则 unset 关键字将与 inherit 相同。
如果默认情况下不继承该属性，则 unset 关键字等于 initial。

如果您将 aside p 规则更改为 all: unset，将来对 p 应用哪些全局样式无关紧要，这些样式将始终处于未设置状态。
aside p {
    margin: unset;
    color: unset;
    all: unset;
}
