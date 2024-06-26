# CSS尺码单位

[Refer](https://web.dev/learn/css/sizing?hl=zh-cn)

## Numbers 表格
数字的含义取决于它们的具体情境。 例如，在定义 line-height 时，如果您在没有支持单位的情况下定义，则数字代表比率：
```css
p {
  font-size: 24px;
  line-height: 1.5;
}
```
数字也可以在以下位置使用：

设置过滤条件的值时：filter: sepia(0.5) 会向元素应用 50% 深褐色滤镜。
设置不透明度时：opacity: 0.5 会应用 50% 不透明度。
在颜色通道中：rgb(50, 50, 50)，可以使用值 0-255 设置颜色值。请参阅颜色课程。
转换元素：transform: scale(1.2) 会将元素大小按其初始大小的 120% 缩放。

## 百分比
在 CSS 中使用百分比时，您需要知道百分比的计算方式。 例如，width 的计算方式是占父元素可用宽度的百分比。

## 尺寸和长度
如果您将单位附加到数字，它就会成为维度。 例如，1rem 就是一个维度。在这种情况下，数字与数字对应的单位在规范中称为“维度令牌”。 长度是表示距离的维度，可以是绝对的，也可以是相对的。

1. 绝对长度
cm	    厘米	    1 厘米 = 96 像素/2.54
mm	    毫米	    1 毫米 = 1 厘米的 1/10
q	    1/4 毫米	1Q = 1 厘米的 1/40
in	    英寸	    1 英寸 = 2.54 厘米 = 96 像素
pc	    毕加语	    1 个 = 1/6/1 英寸
pt	    磅  	    1 分 = 1 英寸的 1/72
px	    像素	    1 px = 1 英寸的 1/96

2. 相对长度
em	    相对于字体大小，例如 1.5em 将比其父项计算出的基本字体大小大 50%。（过去都是大写字母“M”的高度）。
ex  	使用启发法来确定是在元素当前计算出的字体大小中使用 x 高度、字母“x”还是“.5em”。
cap	    元素当前计算出的字体大小中大写字母的高度。
ch	    元素字体（以“0”字形表示）较窄字形的平均字符跳转。
ic	    元素字体中全宽字形的平均字符跳转，以“水”（以“水”字形，CJK 水表意文字，U+6C34）字形表示。
rem 	根元素的字体大小（默认为 16 像素）。
lh	    元素的行高。
rlh	    根元素的行高。

3. 视口相对单位
vw	    视口宽度的 1%。用户可以使用此单元进行一些很酷的字体调整，例如根据页面宽度调整标题字体的大小，这样当用户调整大小时，字体也会随之调整大小。
vh	    视口高度的 1%。 例如，如果您有页脚工具栏，则可以使用此参数来排列界面中的项目。
vi	    根元素的内嵌轴占视口大小的 1%。 轴是指书写模式。在英语等水平书写模式下，内嵌轴是水平的。 在垂直书写模式（例如某些日语字体）中，内嵌轴从上到下运行。
vb	    根元素的屏蔽轴占视口大小的 1%。 对于块轴，则是语言的方向性。英语等 LTR 语言会有一个垂直块轴，因为英语读者会从上到下解析页面。 垂直写入模式具有水平块轴。
vmin	视口较小尺寸的 1%。
vmax	视口较大尺寸的 1%。

4. 其他单位
角度单位: deg
分辨率单位: dpi
