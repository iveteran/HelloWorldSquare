# Template, slot and shadow DOM

Refers: https://web.dev/learn/html/template?hl=zh-cn
        https://web.dev/articles/shadowdom-v1?hl=zh-cn
        https://juejin.cn/post/6844903694891220999

## Web 组件
Web 组件标准由三部分组成：HTML 模板、自定义元素和 Shadow DOM。结合使用这些元素，开发者能够构建可无缝集成到现有应用中的自定义、独立（封装）可重用元素，就像我们已经介绍的所有其他 HTML 元素一样。


## `<template>` 元素
`<template>` 元素用于声明要通过 JavaScript 克隆并插入到 DOM 中的 HTML 片段。默认情况下，元素的内容不会呈现。而是使用 JavaScript 对其进行实例化。


## `<slot>` 元素
我们提供了一个槽，其中包含自定义的“每次出现”图例。HTML 会在 `<template>` 内提供一个 `<slot>` 元素作为占位符，如果提供名称，则会创建一个“命名槽”。命名槽可用于自定义 Web 组件中的内容。通过 `<slot>` 元素，我们可以控制应将自定义元素的子项插入其影子树的什么位置。
如果元素具有 slot 属性且其值与命名槽的名称匹配，则 name 属性用于将槽分配给其他元素。如果自定义元素没有与广告位匹配，则会呈现 `<slot>` 的内容。

## 自定义元素
需要使用 JavaScript 才能定义自定义元素。定义后，`<star-rating>` 元素的内容将被替换为影子根，影子根包含我们与其关联的模板的所有内容。系统会将模板中的 `<slot>` 元素替换为 `<star-rating>`（其 slot 属性值与 `<slot>` 的名称值（如果有）匹配）中相应元素的内容。否则，系统会显示模板广告位的内容。

未与槽位关联的自定义元素（第三个 `<star-rating>` 中的 `<p>Is this text visible?</p>`）中的内容不会包含在影子根中，因此不会显示。

我们通过扩展 HTMLElement 来定义名为 star-rating 的自定义元素：
`
customElements.define('star-rating',
  class extends HTMLElement {
    constructor() {
      super(); // Always call super first in constructor
      const starRating = document.getElementById('star-rating-template').content;
      const shadowRoot = this.attachShadow({
        mode: 'open'
      });
      shadowRoot.appendChild(starRating.cloneNode(true));
    }
  });
`

## Shadow DOM
Shadow DOM 将 CSS 样式的作用域限定为每个影子树，将其与文档的其余部分隔离开来。这意味着外部 CSS 不适用于您的组件，并且组件样式对文档的其余部分没有影响，除非我们特意将它们设置为。
`
const shadowRoot = this.attachShadow({mode: 'open'});
shadowRoot.appendChild(starRating.cloneNode(true));
`

1. Shadow DOM 是一种用于构建基于组件的应用的工具。因此，它可为 Web 开发中的常见问题提供解决方案：
- 隔离 DOM：组件的 DOM 是独立的（例如，document.querySelector() 不会返回组件的 shadow DOM 中的节点）。
- 作用域 CSS：在 shadow DOM 内定义的 CSS 的作用域为相应 CSS。样式规则不会泄露，页面样式也不会渗入。
- 组合：为组件设计一个基于标记的声明式 API。
- 简化 CSS - 限定范围的 DOM 意味着您可以使用简单的 CSS 选择器和更通用的 ID/类名称，而不必担心命名冲突。
- 效率 - 将应用视为多个 DOM 块，而不是一个大的（全局）页面。

2. 组件定义的样式
shadow DOM 最有用的功能是作用域 CSS：
- 外部页面中的 CSS 选择器不适用于组件内部。
- 内部定义的样式不会渗出。它们的作用域限定为宿主元素。
