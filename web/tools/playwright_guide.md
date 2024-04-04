# Playwright: 比 Puppeteer 更好用的浏览器自动化工具

[Refer](https://zhuanlan.zhihu.com/p/347213089)

## 安装
pip install playwright==1.8.0a1  # 很奇怪，必须指定版本，不指定会安装到一个古老的版本
python -m playwright install  # 安装浏览器

## 基本使用
`
from playwright.sync_api import sync_playwright as playwright

with playwright() as pw:
    webkit = pw.webkit.launch(headless=False)
    context = webkit.new_context()  # 需要创建一个 context
    page = context.new_page()  # 创建一个新的页面
    page.goto("https://www.apple.com")
    print(page.content())
    webkit.close()
`

## 新概念：Context
和 Puppeteer 不同的是，Playwright 新增了 context 的概念，每个 context 就像是一个独立的匿名模式会话，非常轻量，但是又完全隔离。比如说，可以在两个 context 中登录两个不同的账号，也可以在两个 context 中使用不同的代理。

1. 通过 context 还可以设置 viewport, user_agent 等。
`
context = browser.new_context(
  user_agent='My user agent'
)
context = browser.new_context(
  viewport={ 'width': 1280, 'height': 1024 }
)
context = browser.new_context(
    http_credentials={"username": "bill", "password": "pa55w0rd"}
)

\# new_context 其他几个比较有用的选项：
ignore_https_errors=False
proxy={"server": "http://example.com:3128", "bypass": ".example.com", "username": "", "password": ""}
extra_http_headers={"X-Header": ""}
`

2. context 中有一个很有用的函数context.add_init_script, 可以让我们设定在调用 context.new_page 的时候在页面中执行的脚本。
`
\# hook 新建页面中的 Math.random 函数，总是返回 42
context.add_init_script(script="Math.random = () => 42;")
\# 或者写在一个文件里
context.add_init_script(path="preload.js")
`

# 页面基本操作
1. 按照官网文档，调用 page.goto(url) 后页面加载过程：
- 设定 url
- 通过网络加载解析页面
- 触发 page.on("domcontentloaded") 事件
- 执行页面的 js 脚本，加载静态资源
- 触发 page.on("laod") 事件
- 页面执行动态加载的脚本
- 当 500ms 都没有新的网络请求的时候，触发 networkidle 事件
2. page.goto等待参数
page.goto(url, referer="", timeout=30, wait_until="domcontentloaded|load|networkidle")
- domcontentloaded: 如果关心加载的 CSS 图片等信息
- networkidle: 如果页面是 ajax 加载
- 等待元素处于可操作的稳定状态:
    - page.wait_for_event("event", event_predict, timeout)
    - page.wait_for_function(js_function)
    - page.wait_for_load_state(state="domcontentloaded|load|networkidle", timeout)
    - page.wait_for_selector(selector, timeout)
    - page.wait_for_timeout(timeout)  # 不推荐使用

3. 对页面的操作方法主要有：
`
\# selector 指的是 CSS 等表达式
page.click(selector)
page.fill(selector, value)  # 在 input 中填充值
`
4. 获取页面中的数据的主要方法有：
`
page.url  # url
page.title()  # title
page.content()  # 获取页面全文
page.inner_text(selector)  # element.inner_text()
page.inner_html(selector)
page.text_content(selector)
page.get_attribute(selector, attr)

\# eval_on_selector 用于获取 DOM 中的值
page.eval_on_selector(selector, js_expression)
\# 比如：
search_value = page.eval_on_selector("#search", "el => el.value")

\# evaluate 用于获取页面中 JS 中的数据，比如说可以读取 window 中的值
result = page.evaluate("([x, y]) => Promise.resolve(x * y)", [7, 8])
print(result) # prints "56"
`
5. 选择器表达式
`
\# 通过文本选择元素，这是 Playwright 自定义的一种表达式
page.click("text=login")

\# 直接通过 id 选择
page.click("id=login")

\# 通过 CSS 选择元素
page.click("#search")
\# 除了常用的 CSS 表达式外，Playwright 还支持了几个新的伪类
\# :has 表示包含某个元素的元素
page.click("article:has(div.prome)")
\# :is 用来对自身做断言
page.click("button:is(:text('sign in'), :text('log in'))")
\# :text 表示包含某个文本的元素
page.click("button:text('Sign in')")  # 包含
page.click("button:text-is('Sign is')")  # 严格匹配
page.click("button:text-matches('\w+')")  # 正则
\# 还可以根据方位匹配
page.click("button:right-of(#search)")  # 右边
page.click("button:left-of(#search)")  # 左边
page.click("button:above(#search)")  # 上边
page.click("button:below(#search)")  # 下边
page.click("button:near(#search)")  # 50px 之内的元素

\# 通过 XPath 选择
page.click("//button[@id='search'])")
\# 所有 // 或者 .. 开头的表达式都会默认为 XPath 表达式
`

## 复用 Cookies 等认证信息
可以直接导出 Cookies 和 LocalStorage, 然后在新的 Context 中使用。
`
\# 保存状态
import json
storage = context.storage_state()
with open("state.json", "w") as f:
    f.write(json.dumps(storage))

\# 加载状态
with open("state.json") as f:
    storage_state = json.loads(f.read())
context = browser.new_context(storage_state=storage_state)
`

## 监听事件
通过 page.on(event, fn) 可以来注册对应事件的处理函数：
`
def log_request(intercepted_request):
    print("a request was made:", intercepted_request.url)
page.on("request", log_request)
\# sometime later...
page.remove_listener("request", log_request)
`

## 拦截更改网络请求
可以通过 page.on("request") 和 page.on("response") 来监听请求和响应事件。
`
from playwright.sync_api import sync_playwright as playwright

def run(pw):
    browser = pw.webkit.launch()
    page = browser.new_page()
    # Subscribe to "request" and "response" events.
    page.on("request", lambda request: print(">>", request.method, request.url))
    page.on("response", lambda response: print("<<", response.status, response.url))
    page.goto("https://example.com")
    browser.close()

with playwright() as pw:
    run(pw)
`

## 灵活设置代理
Playwright 可以通过 Context 设置代理，这样就非常轻量，不用为了切换代理而重启浏览器。
`
context = browser.new_context(
    proxy={"server": "http://example.com:3128", "bypass": ".example.com", "username": "", "password": ""}
)
`

## 杀手级功能：录制操作直接生成代码
python -m playwright codegen http://example.com/


## 移动端浏览器模拟
`
iphone_11 = p.devices['iPhone 11 Pro']
browser = p.webkit.launch(headless=False)
context = browser.newContext(
    **iphone_11,
    locale='en-US',
    geolocation={ 'longitude': 12.492507, 'latitude': 41.889938 },
    permissions=['geolocation']
)
`
