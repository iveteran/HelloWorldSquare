Refers: https://web.dev/learn/html/attributes?hl=zh-cn 
        https://developer.mozilla.org/zh-CN/docs/Web/HTML/Global_attributes#list_of_global_attributes

1. id
全局属性 id 用于定义元素的唯一标识符。它有多种用途，包括： - 链接的片段标识符的目标。 - 识别用于编写脚本的元素。 - 将表单元素与其标签相关联。 - 为辅助技术提供标签或说明。 - 在 CSS 中以（高特异性或作为属性选择器）定位样式。

2. class
class 属性提供了一种使用 CSS（和 JavaScript）定位元素的额外方法，但在 HTML 中它没有其他用途（尽管框架和组件库可能会使用它们）。类属性接受以空格分隔的元素类（区分大小写）的列表，作为其值。

3. style
借助 style 属性，您可以应用内嵌样式，即应用于设置了该属性的单个元素的样式。 style 属性以 CSS 属性值对作为其值，并且值的语法与 CSS 样式块的内容相同：属性后跟英文冒号，就像在 CSS 中一样，并且英文分号作为每个声明的结尾，在值之后。

4. tabindex
您可以向任何元素添加 tabindex 属性，以使该元素能够获得焦点。tabindex 值用于指定是否将其添加到 Tab 键顺序中，以及（可选）添加到非默认 Tab 键顺序中。

5. role
role 属性是 ARIA 规范（而非 WHATWG HMTL 规范）的一部分。role 属性可用于提供内容的语义含义，以便屏幕阅读器将对象的预期用户互动告知网站用户。

6. contenteditable
将 contenteditable 属性设置为 true 的元素可修改、可聚焦，并可添加到 Tab 键顺序中，就如同设置了 tabindex="0"。Contenteditable 是支持值 true 和 false 的枚举属性，如果属性不存在或具有无效值，则默认值为 inherit。

7. 自定义特性
我们现在仅涉及 HTML 全局属性的表面。还有更多属性仅适用于一个或一组有限的元素。即使有数百个已定义的属性，您也可能需要一个规范中没有的属性。HTML 助您一臂之力。
您可以通过添加 data- 前缀来创建任何所需的自定义属性。您可以为属性命名，名称以 data- 开头，后跟一组不以 xml 开头且不包含英文冒号 (:) 的小写字符。
