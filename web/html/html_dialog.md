# 对话框 

对话框可以是模态（只能与对话框中的内容互动）或非模态（仍然可以与对话框外部的内容互动）。
模态对话框会显示在其余页面内容之上。页面的其余部分是自然的，默认情况下会被半透明背景遮挡。

用于创建对话框的语义 HTML `<dialog>` 元素包含语义、键盘交互以及 HTMLDialogElement 接口的所有属性和方法。

HTMLDialogElement 有三个主要方法，以及从 HTMLElement 继承的所有方法。
- dialog.show() /* opens the dialog */
- dialog.showModal() /* opens the dialog as a modal */
- dialog.close() /* closes the dialog */

## 关闭对话框
您无需使用 HTMLDialogElement.close() 方法关闭对话框。您根本不需要 JavaScript。如需在不使用 JavaScript 的情况下关闭 `<dialog>`，请添加带有对话框方法的表单，方法是在 `<form>` 上设置 method="dialog" 或对按钮设置 formmethod="dialog"。

当用户通过 dialog 方法提交数据时，用户输入的数据的状态将保持不变。有提交事件时，表单会经过限制条件验证（除非设置了 novalidate）- 用户数据既不会被清除，也不会提交。不含 JavaScript 的关闭按钮可写为：
`
<dialog open>
  <form method="dialog">
    <button type="submit" autofocus>close</button>
  </form>
</dialog>
`
您可能已经注意到，在此示例中，为关闭 `<button>` 设置了 autofocus 属性。在 `<dialog>` 内设置了 autofocus 属性的元素在网页加载时不会获得焦点（除非页面在加载时对话框可见）。不过，当对话框打开时，它们将获得焦点。

默认情况下，当对话框打开时，对话框中的第一个可聚焦元素将获得焦点，除非对话框中的其他元素设置了 autofocus 属性。为关闭按钮设置 autofocus 属性可确保该按钮在对话框打开时获得焦点。
但是，在 `<dialog>` 中包含 autofocus 时，只是要仔细考虑。系统会跳过自动聚焦元素之前出现的序列中的所有元素。 我们将在专题课程中进一步讨论此属性。

HTMLDialogElement 接口包含一个 returnValue 属性。使用 method="dialog" 提交表单时，会将 returnValue 设置为用于提交表单的提交按钮的 name（如果有）。
如果我们编写了 `<button type="submit" name="toasty">close</button>`，returnValue 将为 toasty。

对话框打开时，系统会显示布尔值 open 属性，这意味着对话框处于活动状态，可以与之互动。当通过添加 open 属性（而不是通过 .show() 或 .showModal()）打开对话框时，对话框将无模态。HTMLDialogElement.open 属性会返回 true 或 false，具体取决于对话框是否可用于互动，而不是对话框是否为模态对话框。

虽然 JavaScript 是打开对话框的首选方法（包括在网页加载时添加 open 属性，然后使用 .close() 移除该属性），但有助于确保即使 JavaScript 不可用，对话框仍然可用。
