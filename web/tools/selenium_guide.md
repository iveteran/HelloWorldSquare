# Selenium 全攻略

[Refer][1](https://zhuanlan.zhihu.com/p/462460461)
[Refer][2](https://www.selenium.dev/zh-cn/documentation/webdriver/)

## 安装

1. 安装selenium库
pip install selenium

3. 安装浏览器驱动ChromeDriver

- 手动安装
先查看本地Chrome浏览器版本，两种方式：
1) url: chrome://version
2) 菜单->帮助->关于Google Chrome

- 自动安装
自动安装需要用到第三方库webdriver_manager，先安装这个库，然后调用对应的方法即可。
`
from selenium import webdriver
from selenium.webdriver.common.keys import Keys
from webdriver_manager.chrome import ChromeDriverManager

browser = webdriver.Chrome(ChromeDriverManager().install())

browser.get('http://www.baidu.com')
search = browser.find_element_by_id('kw')
search.send_keys('python')
search.send_keys(Keys.ENTER)

browser.close()
`

## 基本用法

1. 初始化浏览器对象
`
from selenium import webdriver

\# 初始化浏览器为chrome浏览器
browser = webdriver.Chrome()

\# 指定绝对路径的方式
path = r'chromedriver-linux64/VERSION/chromedriver'
browser = webdriver.Chrome(path)

\# 关闭浏览器
browser.close()
`

2. 无界面的浏览器
`
from selenium import webdriver

\# 无界面的浏览器
option = webdriver.ChromeOptions()
option.add_argument("headless")
browser = webdriver.Chrome(options=option)

\# 访问百度首页
browser.get(r'https://www.baidu.com/')
\# 截图预览
browser.get_screenshot_as_file('截图.png')

\# 关闭浏览器
browser.close()
`

## 常用功能
1. 操作浏览器
- 设置浏览器大小：最大化、最小化、全屏
browser.maximize_window()
browser.minimize_window()
browser.fullscreen_window()
- 设置分辨率 500*500
browser.set_window_size(500,500)
- 分别获取窗口每个尺寸
width = browser.get_window_size().get("width")
height = browser.get_window_size().get("height")
- 得到窗口的位置
x = browser.get_window_position().get('x')
y = browser.get_window_position().get('y')
- 设置窗口位置
browser.set_window_position(0, 0)
- 刷新页面
browser.refresh()
- 前进后退
browser.forward()
browser.back()
- 屏幕截图
browser.save_screenshot('./image.png')
- 元素屏幕截图 
elem = browser.find_element(By.CSS_SELECTOR, 'h1')
elem.screenshot('./image.png')
- 打印页面
`
from selenium.webdriver.common.print_page_options import PrintOptions

print_options = PrintOptions()
print_options.page_ranges = ['1-2']

driver.get("printPage.html")

base64code = driver.print_page(print_options)
`
2. 获取页面基础属性
- 网页标题
> print(browser.title)
- 当前网址
> print(browser.current_url)
- 浏览器名称
> print(browser.name)
- 网页源码
> print(browser.page_source)

## 定位页面元素
1. id定位
browser.find_element_by_id('kw').send_keys('python')
2. name定位
browser.find_element_by_name('wd').send_keys('python')
3. class定位
browser.find_element_by_class_name('s_ipt').send_keys('python')
4. tag定位
browser.find_element_by_tag_name('input').send_keys('python')
5. link定位
browser.find_element_by_link_text('新闻').click()
6. partial定位
browser.find_element_by_partial_link_text('闻').click()
7. xpath定位
browser.find_element_by_xpath("//*[@id='kw']").send_keys('python')
8. css定位
browser.find_element_by_css_selector('#kw').send_keys('python')
9. find_element的By定位
browser.find_element(By.ID,'kw')
browser.find_element(By.NAME,'wd')
browser.find_element(By.CLASS_NAME,'s_ipt')
browser.find_element(By.TAG_NAME,'input')
browser.find_element(By.LINK_TEXT,'新闻')
browser.find_element(By.PARTIAL_LINK_TEXT,'闻')
browser.find_element(By.XPATH,'//*[@id="kw"]')
browser.find_element(By.CSS_SELECTOR,'#kw')
多个元素使用find_elements

## 获取页面元素属性

1. 获取logo的图片地址
logo = browser.find_element_by_class_name('index-logo-src')
print(logo.get_attribute('src'))
2. 获取文本
logo = browser.find_element_by_css_selector('#hotsearch-content-wrapper > li:nth-child(1) > a')
print(logo.text)
3. 获取其他属性
logo = browser.find_element_by_class_name('index-logo-src')
print(logo.id)
print(logo.location)
print(logo.tag_name)
print(logo.size)

## 页面交互操作

1. 输入文本
input = browser.find_element_by_class_name('s_ipt')
input.send_keys('python')
2. 点击
click = browser.find_element_by_link_text('新闻')
click.click()
3. 清除文本
input = browser.find_element_by_class_name('s_ipt')
input.clear()
4. 回车确认
input = browser.find_element_by_class_name('s_ipt')
input.send_keys('python')
input.submit()
5. 单选
先定位需要单选的某个元素，然后点击(click)一下即可
6. 多选
依次定位需要选择的元素，点击(click)即可。
7. 下拉框
`
from selenium.webdriver.support.select import Select

'''1、三种选择某一选项项的方法'''
select_by_index()           # 通过索引定位；注意：>index索引是从“0”开始。
select_by_value()           # 通过value值定位，va>lue标签的属性值。
select_by_visible_text()    # 通过文本值定位，即显>示在下拉框的值。

'''2、三种返回options信息的方法'''
voptions                    # 返回select元素所有>的options
all_selected_options        # 返回select元素中所>有已选中的选项
first_selected_options      # 返回select元素中选>中的第一个选项


'''3、四种取消选中项的方法'''
deselect_all                # 取消全部的已选择项
deselect_by_index           # 取消已选中的索引项
deselect_by_value           # 取消已选中的value值
deselect_by_visible_text    # 取消已选中的文本值
`

## 多窗口切换

1. Frame切换
- 切换到子页面
switch_to.frame()
- 回到父页面
switch_to.parent_frame()

2. 选项卡/窗口切换
current_window_handle：获取当前窗口的句柄。
window_handles：返回当前浏览器的所有窗口的句柄。
switch_to_window()：用于切换到对应的窗口。
- 创建新窗口(或)新标签页并且切换
driver.switch_to.new_window('tab')
driver.switch_to.new_window('window')
- 关闭标签页或窗口
driver.close()
- 切回到之前的标签页或窗口
driver.switch_to.window(original_window)

## 模拟鼠标操作
1. 导入模块
`
from selenium.webdriver.common.action_chains import ActionChains
`
2. 左键
- 单击
`
clickable = driver.find_element(By.ID, "clickable")
ActionChains(driver).click(clickable).perform()
`
- 点击并按住
`
clickable = driver.find_element(By.ID, "clickable")
ActionChains(driver).click_and_hold(clickable).perform()
`
3. 右键
context_click()
`
target = browser.find_element_by_link_text('新闻')
ActionChains(browser).context_click(target).perform()
`
4. 双击
double_click()
`
target = browser.find_element_by_css_selector('#bottom_layer > div > p:nth-child(8) > span')
ActionChains(browser).double_click(target).perform()
`
5. 移动光标到元素上
move_to_element(move)
`
move = browser.find_element_by_css_selector("#form > span.bg.s_ipt_wr.new-pmd.quickdelete-wrap > span.soutu-btn")
ActionChains(browser).move_to_element(move).perform()
`
6. 通过偏移量移动动光标
- 从元素中心点（原点）偏移 
`
mouse_tracker = driver.find_element(By.ID, "mouse-tracker")
ActionChains(driver).move_to_element_with_offset(mouse_tracker, 8, 0).perform()
`
- 从视窗左上角（原点）偏移
`
action = ActionBuilder(driver)
action.pointer_action.move_to_location(8, 0)
action.perform()
`
- 从当前光标位置（原点）偏移
`
ActionChains(driver).move_by_offset(13, 15).perform()
`
7. 拖拽
drag_and_drop(source,target)
`
source = browser.find_element_by_css_selector("#draggable_source")
target = browser.find_element_by_css_selector("#droppable_target")
actions = ActionChains(browser)
actions.drag_and_drop(source, target)
actions.perform()
`
- 通过偏移量拖放元素
`
draggable = driver.find_element(By.ID, "draggable")
start = draggable.location
finish = driver.find_element(By.ID, "droppable").location
ActionChains(driver).drag_and_drop_by_offset(draggable, finish['x'] - start['x'], finish['y'] - start['y']).perform()
`
8. 鼠标滚轮
- Scroll to element
`
target = driver.find_element(By.TAG_NAME, "iframe")
ActionChains(browser).scroll_to_element(target).perform()
`
- Scroll by given amount
`
footer = driver.find_element(By.TAG_NAME, "footer")
delta_y = footer.rect['y']
ActionChains(driver).scroll_by_amount(0, delta_y).perform()
`
- Scroll from an element by a given amount
`
target = driver.find_element(By.TAG_NAME, "iframe")
scroll_origin = ScrollOrigin.from_element(target)
ActionChains(driver).scroll_from_origin(scroll_origin, 0, 200).perform()
`
- Scroll from an element with an offset 
`
footer = driver.find_element(By.TAG_NAME, "footer")
scroll_origin = ScrollOrigin.from_element(footer, 0, -50)
ActionChains(driver).scroll_from_origin(scroll_origin, 0, 200).perform()
`
- Scroll from a offset of origin (element) by given amount
`
scroll_origin = ScrollOrigin.from_viewport(10, 10)
ActionChains(driver).scroll_from_origin(scroll_origin, 0, 200).perform()
`
9. 模拟键盘操作
`
from selenium.webdriver.common.keys import Keys

send_keys(Keys.BACK_SPACE)：删除键(BackSpace)
send_keys(Keys.SPACE)：空格键(Space)
send_keys(Keys.TAB)：制表键(TAB)
send_keys(Keys.ESCAPE)：回退键(ESCAPE)
send_keys(Keys.ENTER)：回车键(ENTER)
send_keys(Keys.CONTRL,'a')：全选(Ctrl+A)
send_keys(Keys.CONTRL,'c')：复制(Ctrl+C)
send_keys(Keys.CONTRL,'x')：剪切(Ctrl+X)
send_keys(Keys.CONTRL,'v')：粘贴(Ctrl+V)
send_keys(Keys.F1)：键盘F1
.....
send_keys(Keys.F12)：键盘F12
`
- 按下/释放按键
`
ActionChains(driver)\
    .key_down(Keys.SHIFT)\
    .send_keys("a")\
    .key_up(Keys.SHIFT)\
    .send_keys("b")\
    .perform()
`
- 指定元素输入 
`
text_input = driver.find_element(By.ID, "textInput")
ActionChains(driver)\
    .send_keys_to_element(text_input, "abc")\
    .perform()
`
10. 延时等待
- 强制等待
`
time.sleep(10)
`
- 隐式等待
`
browser.implicitly_wait(10)
`
- 显式等待
`
wait = WebDriverWait(browser, 10)
input = wait.until(EC.presence_of_element_located((By.ID, 'kw')))
`
- 其他等待条件
`
from selenium.webdriver.support import expected_conditions as EC

\# 判断标题是否和预期的一致
title_is
\# 判断标题中是否包含预期的字符串
title_contains

\# 判断指定元素是否加载出来
presence_of_element_located
\# 判断所有元素是否加载完成
presence_of_all_elements_located

\# 判断某个元素是否可见. 可见代表元素非隐藏，并且元素的宽和高都不等于0，传入参数是元组类型的locator
visibility_of_element_located
\# 判断元素是否可见，传入参数是定位后的元素WebElement
visibility_of
\# 判断某个元素是否不可见，或是否不存在于DOM树
invisibility_of_element_located

\# 判断元素的 text 是否包含预期字符串
text_to_be_present_in_element
\# 判断元素的 value 是否包含预期字符串
text_to_be_present_in_element_value

\# 判断frame是否可切入，可传入locator元组或者直接传入定位方式：id、name、index或WebElement
frame_to_be_available_and_switch_to_it

\# 判断是否有alert出现
alert_is_present

\# 判断元素是否可点击
element_to_be_clickable

\# 判断元素是否被选中,一般用在下拉列表，传入WebElement对象
element_to_be_selected
\# 判断元素是否被选中
element_located_to_be_selected
\# 判断元素的选中状态是否和预期一致，传入参数：定位后的元素，相等返回True，否则返回False
element_selection_state_to_be
\# 判断元素的选中状态是否和预期一致，传入参数：元素的定位，相等返回True，否则返回False
element_located_selection_state_to_be

\# 判断一个元素是否仍在DOM中，传入WebElement对象，可以判断页面是否刷新了
staleness_of
`

## 运行JavaScript

browser.execute_script('window.open()')
browser.execute_script('window.scrollTo(0, document.body.scrollHeight)')
browser.execute_script('alert("To Bottom")')

## Cookie

`
\# 获取cookie
print(f'Cookies的值：{browser.get_cookies()}')
\# 添加cookie
browser.add_cookie({'name':'才哥', 'value':'帅哥'})
print(f'添加后Cookies的值：{browser.get_cookies()}')
\# 删除cookie
browser.delete_all_cookies()
print(f'删除后Cookies的值：{browser.get_cookies()}')
`
