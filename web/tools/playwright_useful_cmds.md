1. 截屏
npx playwright screenshot --help

- Wait 3 seconds before capturing a screenshot after page loads ('load' event fires)
npx playwright screenshot \
    --device="iPhone 11" \
    --color-scheme=dark \
    --wait-for-timeout=3000 \
    twitter.com twitter-iphone.png


- Capture a full page screenshot
npx playwright screenshot --full-page en.wikipedia.org wiki-full.png

2. 生成PDF#
生成PDF的功能仅支持 Headless Chromium.
npx playwright pdf https://en.wikipedia.org/wiki/PDF wiki.pdf

3. 安装系统依赖#
Ubuntu 18.04 和 Ubuntu 20.04 系统支持自动安装依赖组件.。This is useful for CI environments.
npx playwright install-deps

4. 打开页面（Pages
使用 open 命令，您可以使用Playwright绑定的浏览器浏览网页。Playwright提供了跨平台WebKit构建，可用于跨Windows、Linux和macOS复制Safari渲染。

- Open page in Chromium
npx playwright open example.com

- Open page in WebKit
npx playwright wk example.com

5. 模拟设备#
open 命令可以模拟 playwright.devices 列表中的移动和平板电脑设备。
- Emulate iPhone 11.
npx playwright open --device="iPhone 11" wikipedia.org

6. 模拟配色方案和视口大小#
- Emulate screen size and color scheme.
npx playwright open --viewport-size=800,600 --color-scheme=dark twitter.com

7. 模拟地理位置、语言和时区#
- Emulate timezone, language & location
npx playwright open --timezone="Europe/Rome" --geolocation="41.890221,12.492348" --lang="it-IT" maps.google.com

8. 保留已验证状态#
执行 codegen 并指定 --save-storage 参数来保存 cookies 和 localStorage。 这对于单独记录身份验证步骤并在以后负复用它非常有用。

npx playwright codegen --save-storage=auth.json
- Perform authentication and exit.  auth.json will contain the storage state.
使用 --load-storage 参数来加载先前的存储。通过这种方式，所有的 cookies 和 localStorage 将被恢复，使大多数web应用程序进入认证状态。

npx playwright open --load-storage=auth.json my.web.app
npx playwright codegen --load-storage=auth.json my.web.app

9. 生成代码
npx playwright codegen wikipedia.org
