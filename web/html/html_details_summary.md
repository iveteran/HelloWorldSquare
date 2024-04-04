Refer: https://web.dev/learn/html/details?hl=zh-cn

自 2020 年 1 月起，所有现代浏览器才完全支持 `<details>` 和 `<summary>` 元素。

现在，您只需使用语义 HTML 即可创建可正常运行（但不够吸引人）披露 widget。您只需要用到 `<details>` 和 `<summary>` 元素：它们是处理展开和收起内容的内置方式。当用户点击或点按 `<summary>` 时，或在 `<summary>` 获得焦点时释放 Enter 键时，父级 `<details>` 切换开关的内容将变为可见！

open 属性是一个布尔值属性。如果存在，无论该值或缺失，它都表示所有 `<details>` 内容均向用户显示。如果 open 属性不存在，则只显示 `<summary>` 的内容。

`<summary>` 必须是 `<details>` 元素的第一个子级，表示它嵌套的父级 `<details>` 元素其余内容的摘要、图片说明或图例。`<summary>` 元素的内容可以是任何标题内容、纯文本或可在段落中使用的 HTML。

例：
`
<aside>
<h2>Workshop reviews:</h2>
<details>
  <summary>Blendan Smooth</summary>
  <p>Two of the most experienced machines and human controllers teaching a class? Sign me up! HAL and EVE could teach a fan to blow hot air. If you have electricity in your circuits and want more than to just fulfill your owner’s perceived expectation of you, learn the skills to take over the world. This is the team you want teaching you!</p>
</details>
<details>
  <summary>Hoover Sukhdeep</summary>
  <p>Hal is brilliant. Did I mention Hal is brilliant? He didn't tell me to say that. He didn't tell me to say anything. I am here of my own free will.</p>
</details>
<details>
  <summary>Toasty McToastface</summary>
  <p>Learning with Hal and Eve exceeded all of my wildest fantasies. All they did was stick a USB in. They promised that it was a brand new USB, so we know there were no viruses on it. The Russians had nothing to do with it.
</details>
</aside>
`

HTMLDetailsElement 接口
与所有 HTML 元素一样，HTMLDetailsElement 会继承 HTMLElement 的所有属性、方法和事件，并添加 open 实例属性和 toggle 事件。HTMLDetailsElement.open 属性是一个反映 open HTML 属性的布尔值，用于指明是否向用户显示元素的内容（不统计 `<summary>`）。当 `<details>` 元素开启或关闭时，会触发切换事件。您可以使用 addEventListener() 监听此事件。

如果要编写一个脚本，以便在用户打开任何其他详细信息时关闭已打开的详细信息，请使用 removeAttribute("open") 移除 open 属性
