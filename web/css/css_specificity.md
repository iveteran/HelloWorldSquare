# 特异性

[Refer](https://web.dev/learn/css/specificity?hl=zh-cn)

## 特异性评分
每条选择器规则都会获得一个评分。 您可以将特异性视为一个总分，每个选择器类型都会获得相应分数。得分最高的选择器胜出。

鉴于真实项目中的特异性，平衡行为是确保您希望应用的 CSS 规则确实能够应用，同时通常会降低得分以避免复杂性。 得分只应尽可能高，而不是追求尽可能高的得分。 将来，可能需要应用一些真正更重要的 CSS。如果你寻求最高分，这项工作就会很难。

## 选择器类型评分
1. 通用选择器 (*) 没有特异性，得 0 分。
2. 元素（类型）或伪元素选择器有 1 个特异性点。
3. 类、伪类或属性选择器有 10 个特异性点。
4. ID 选择器就有 100 个特异性。
5. CSS 直接应用于 HTML 元素的 style 属性，会得到特异性得分 1,000 分。
6. CSS 值末尾的 !important 的特异性得分为 10,000 分。

## 上下文的特异性
每个与某元素匹配的选择器的特异性累加在一起。
```html
<a class="my-class another-class" href="#">A link</a>
```
1. 此链接上包含两个类。添加以下 CSS，并获得 1 个特异性点：
```css
a {
  color: red;
}
```
2. 引用此规则中的某个类，它现在有 11 个特异性点：
```css
a.my-class {
  color: green;
}
```
3. 将另一个类添加到选择器中，它现在有 21 个特异性点：
```css
a.my-class.another-class {
  color: rebeccapurple;
}
```
4. 将 href 属性添加到选择器，该选择器现在有 31 个特异性：
```css
a.my-class.another-class[href] {
  color: goldenrod;
}
```
5. 最后，向所有这些类添加一个 :hover 伪类，选择器最终会有 41 个特异性点：
```css
a.my-class.another-class[href]:hover {
  color: lightgrey;
}
```
