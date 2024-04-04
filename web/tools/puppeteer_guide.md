# Puppeteer中文文档

[Refer](https://puppeteer.bootcss.com/)

## 简介
Puppeteer 是一个 Node 库，它提供了一个高级 API 来通过 DevTools 协议控制 Chromium 或 Chrome。Puppeteer 默认以 headless 模式运行，但是可以通过修改配置文件运行“有头”模式。

你可以在浏览器中手动执行的绝大多数操作都可以使用 Puppeteer 来完成！ 下面是一些示例：
生成页面 PDF。
抓取 SPA（单页应用）并生成预渲染内容（即“SSR”（服务器端渲染））。
自动提交表单，进行 UI 测试，键盘输入等。
创建一个时时更新的自动化测试环境。 使用最新的 JavaScript 和浏览器功能直接在最新版本的Chrome中执行测试。
捕获网站的 timeline trace，用来帮助分析性能问题。
测试浏览器扩展。

## 基本使用
`
const puppeteer = require('puppeteer');

(async () => {
  const browser = await puppeteer.launch();
  const page = await browser.newPage();
  await page.goto('https://news.ycombinator.com', {waitUntil: 'networkidle2'});
  await page.pdf({path: 'hn.pdf', format: 'A4'});

  await browser.close();
})();
`

## 页面中执行脚本
`
const puppeteer = require('puppeteer');

(async () => {
  const browser = await puppeteer.launch();
  const page = await browser.newPage();
  await page.goto('https://example.com');

  // Get the "viewport" of the page, as reported by the page.
  const dimensions = await page.evaluate(() => {
    return {
      width: document.documentElement.clientWidth,
      height: document.documentElement.clientHeight,
      deviceScaleFactor: window.devicePixelRatio
    };
  });

  console.log('Dimensions:', dimensions);

  await browser.close();
})();
`

## 默认模式
1. 使用无头模式
`
const browser = await puppeteer.launch({headless: false}); // default is true
`
2. 运行绑定的 Chromium 版本
`
const browser = await puppeteer.launch({executablePath: '/path/to/Chrome'});
`
