# Playwright 对比 Selenium 的优势

1. Selenium 需要通过 WebDriver 操作浏览器；Playwright 通过开发者工具与浏览器交互，安装简洁，不需要安装各种 Driver。
2. Playwright 几乎支持所有语言，且不依赖于各种 Driver，通过调用内置浏览器所以启动速度更快。
3. Selenium 基于 HTTP 协议（单向通讯），Playwright 基于 Websocket（双向通讯）可自动获取浏览器实际情况。
4. Playwright 为自动等待，而在 Selenium 中经常需要写 sleep 去作为一个等待，保证程序正常运行:
- 等待元素出现（定位元素时，自动等待30s，等待时间可以自定义，单位毫秒）
- 等待事件发生

已知局限性
1. Playwright 不支持旧版 Microsoft Edge 或 IE11。支持新的 Microsoft Edge（在 Chromium 上），所以对浏览器版本有硬性要求的项目不适用。
2. 需要 SSL 证书进行访问的网站可能无法录制，该过程需要单独定位编写。
