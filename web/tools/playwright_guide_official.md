## 安装
$ npm i -D playwright

你还需要安装浏览器 - 手动或添加一个可以自动为你完成此操作的包。
- Download the Chromium, Firefox and WebKit browser
$ npx playwright install chromium firefox webkit

- Alternatively, add packages that will download a browser upon npm install
$ npm i -D @playwright/browser-chromium @playwright/browser-firefox @playwright/browser-webkit

## 基础用法
`
import { chromium, devices } from 'playwright';
import assert from 'node:assert';

(async () => {
  // Setup
  const browser = await chromium.launch();
  const context = await browser.newContext(devices['iPhone 11']);
  const page = await context.newPage();

  // The actual interesting bit
  await context.route('**.jpg', route => route.abort());
  await page.goto('https://example.com/');

  assert(await page.title() === 'Example Domain'); // 👎 not a Web First assertion

  // Teardown
  await context.close();
  await browser.close();
})();
`

## 定位器
定位器 是 Playwright 自动等待和重试能力的核心部分。简而言之，定位器代表了一种随时在页面上查找元素的方法。

推荐的内置定位器：
- page.getByRole() 通过显式和隐式可访问性属性进行定位。
- page.getByText() 按文本内容定位。
- page.getByLabel() 通过关联标签的文本定位表单控件。
- page.getByPlaceholder() 通过占位符定位输入。
- page.getByAltText() 通过文本替代来定位元素（通常是图片）。
- page.getByTitle() 通过标题属性来定位元素。
- page.getByTestId() 根据 data-testid 属性定位元素（可以配置其他属性）。
`
await page.getByLabel('User Name').fill('John');
await page.getByLabel('Password').fill('secret-password');
await page.getByRole('button', { name: 'Sign in' }).click();
await expect(page.getByText('Welcome, John!')).toBeVisible();
`

## 行动
1. 文本输入
使用 locator.fill() 是填写表单字段的最简单方法。它聚焦元素并使用输入的文本触发 input 事件。它适用于 `<input>、<textarea> 和 [contenteditable]` 元素。
2. 复选框和单选按钮
使用 locator.setChecked() 是选中和取消选中复选框或单选按钮的最简单方法。此方法可用于 `input[type=checkbox]、input[type=radio] 和 [role=checkbox]` 元素。
`
// Check the checkbox
await page.getByLabel('I agree to the terms above').check();

// Assert the checked state
expect(page.getByLabel('Subscribe to newsletter')).toBeChecked();

// Select the radio button
await page.getByLabel('XL').check();
`
3. 选择选项
使用 locator.selectOption() 选择 `<select>` 元素中的一个或多个选项。你可以指定选项 value 或 label 进行选择。可以选择多个选项。
`
// Single selection matching the value or label
await page.getByLabel('Choose a color').selectOption('blue');

// Single selection matching the label
await page.getByLabel('Choose a color').selectOption({ label: 'Blue' });

// Multiple selected items
await page.getByLabel('Choose multiple colors').selectOption(['red', 'green', 'blue']);
`
4. 鼠标点击
`
// Generic click
await page.getByRole('button').click();

// Double click
await page.getByText('Item').dblclick();

// Right click
await page.getByText('Item').click({ button: 'right' });

// Shift + click
await page.getByText('Item').click({ modifiers: ['Shift'] });

// Hover over element
await page.getByText('Item').hover();

// Click the top left corner
await page.getByText('Item').click({ position: { x: 0, y: 0 } });
`
5. 输入字符
大多数时候，你应该使用 locator.fill() 输入文本。请参阅上面的 文本输入 部分。仅当页面上有特殊键盘处理时才需要键入字符。
`
// Press keys one by one
await page.locator('#area').pressSequentially('Hello World!');
`
6. 按键和快捷键
`
// Hit Enter
await page.getByText('Submit').press('Enter');

// Dispatch Control+Right
await page.getByRole('textbox').press('Control+ArrowRight');

// Press $ sign on keyboard
await page.getByRole('textbox').press('$');
`
7. 上传文件
你可以使用 locator.setInputFiles() 方法选择要上传的输入文件。它期望第一个参数指向类型为 "file" 的 输入元素。可以在数组中传递多个文件。如果某些文件路径是相对的，则它们将相对于当前工作目录进行解析。空数组会清除选定的文件。
`
// Select one file
await page.getByLabel('Upload file').setInputFiles(path.join(__dirname, 'myfile.pdf'));

// Select multiple files
await page.getByLabel('Upload files').setInputFiles([
  path.join(__dirname, 'file1.txt'),
  path.join(__dirname, 'file2.txt'),
]);

// Remove all the selected files
await page.getByLabel('Upload file').setInputFiles([]);

// Upload buffer from memory
await page.getByLabel('Upload file').setInputFiles({
  name: 'file.txt',
  mimeType: 'text/plain',
  buffer: Buffer.from('this is test')
});
`
8. 焦点元素
对于处理焦点事件的动态页面，你可以使用 locator.focus() 将给定元素聚焦。
await page.getByLabel('Password').focus();
9. 拖放
你可以使用 locator.dragTo() 执行拖放操作。该方法将：
- 将鼠标悬停在要拖动的元素上。
- 按鼠标左键。
- 将鼠标移动到将接收掉落的元素。
- 释放鼠标左键。
await page.locator('#item-to-be-dragged').dragTo(page.locator('#item-to-drop-at'));
10. 手动拖动
如果你想精确控制拖动操作，请使用更底层的方法，例如 locator.hover()、mouse.down()、mouse.move() 和 mouse.up()。
await page.locator('#item-to-be-dragged').hover();
await page.mouse.down();
await page.locator('#item-to-drop-at').hover();
await page.mouse.up();

## 用户验证
无论你选择哪种身份验证策略，你都可能将经过身份验证的浏览器状态存储在文件系统上。
我们建议创建 playwright/.auth 目录并将其添加到你的 .gitignore 中。你的身份验证例程将生成经过身份验证的浏览器状态并将其保存到此 playwright/.auth 目录中的文件中。稍后，测试将重用此状态并开始已通过身份验证的操作。

## 截图
1. 基本用法
await page.screenshot({ path: 'screenshot.png' });
2. 整页截图
await page.screenshot({ path: 'screenshot.png', fullPage: true });
3. 捕获到缓冲区
const buffer = await page.screenshot();
console.log(buffer.toString('base64'));
4. 元素截图
await page.locator('.header').screenshot({ path: 'screenshot.png' });

## 录视频
1. 视频大小默认为缩小到适合 800x800 的视口大小
`
const context = await browser.newContext({
  recordVideo: {
    dir: 'videos/',
    size: { width: 640, height: 480 },
  }
});
`
2. 访问与该页面关联的视频文件
`
const path = await page.video().path();
`

## 录制脚本
可用于记录用户交互并生成 JavaScript 代码。
$ npx playwright codegen wikipedia.org
