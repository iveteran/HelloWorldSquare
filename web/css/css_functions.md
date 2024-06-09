# CSS 函数

在 CSS 中，您只能使用所提供的函数，而不能自行编写函数，但在某些情况下，函数可以相互嵌套，从而赋予它们更大的灵活性。

## 功能选择器
例如 :is() 和 :not() 等函数
```css
.post :is(h1, h2, h3) {
    line-height: 1.2;
}
```

## 自定义属性和 var()
```css
:root {
    --base-color: #ff00ff;
}

.my-element {
    background: var(--base-color);
}
```
自定义属性是一种变量，可用于对 CSS 代码中的值进行标记化。自定义属性也会受级联的影响，这意味着可以在上下文中操作或重新定义自定义属性。自定义属性必须以两个短划线 (--) 为前缀，并且区分大小写。

var() 函数接受一个必需参数：您尝试作为值返回的自定义属性。在上面的代码段中，var() 函数将 --base-color 作为参数传递。如果定义了 --base-color，则 var() 将返回该值。
```css
.my-element {
    background: var(--base-color, hotpink);
}
```
您还可以将回退声明值传入 var() 函数。这意味着，如果找不到 --base-color，系统会改用所传递的声明，在本例中，该声明为 hotpink 颜色。

## 返回值的函数
attr() 和 url() 等函数遵循与 var() 类似的结构，您需要传递一个或多个参数，并在 CSS 声明的右侧使用它们。
```css
a::after {
  content: attr(href);
}
```
url() 函数采用字符串网址作为参数，用于加载图片、字体和内容。 如果未传入有效网址或找不到网址指向的资源，则 url() 函数不会返回任何内容。

## 颜色函数
可用的颜色函数包括 rgb()、rgba()、hsl()、hsla()、hwb()、lab() 和 lch()。所有这些对象的形式都类似，其中传入配置参数，然后返回颜色。

## 数学表达式
1. calc()
calc() 函数接受单个数学表达式作为其参数。此数学表达式可以组合多种类型，如长度、数字、角度和频率。单位也可以混用。
```css
.my-element {
    width: calc(100% - 2rem);
}
```
calc() 函数可以嵌套在另一个 calc() 函数中。您还可以将自定义属性作为表达式的一部分在 var() 函数中传递。
2. min()和max()
min() 函数会返回一个或多个已传递参数的最小计算值。max() 函数则相反：获取一个或多个传递的参数中的最大值。
```css
.my-element {
  width: min(20vw, 30rem);
  height: max(20vh, 20rem);
}
```
3. clamp()
clamp() 函数采用三个参数：最小大小、理想大小和最大大小。
```css
h1 {
  font-size: clamp(2rem, 1rem + 3vw, 3rem);
}
```
4. 形状
clip-path、offset-path 和 shape-outside CSS 属性使用形状直观地裁剪方框或提供形状，让内容四处移动。
有一些形状函数可用于这两种属性。circle()、ellipse() 和 inset() 等简单形状可使用配置参数来确定其大小。更复杂的形状（例如 polygon()）可使用逗号分隔的 X 轴和 Y 轴值对来创建自定义形状。
```css
.circle {
  clip-path: circle(50%);
}

.polygon {
  clip-path: polygon(0% 0%, 100% 0%, 100% 75%, 75% 75%, 75% 100%, 50% 75%, 0% 75%);
}
```
与 polygon() 一样，还有一个 path() 函数，该函数接受 SVG 填充规则作为参数。因此，可以使用 Illustrator 或 Inkscape 等图形工具绘制高度复杂的形状，然后将其复制到 CSS 中。

## 变形
您可以使用 rotate() 函数旋转元素，该函数会围绕元素的中心轴旋转元素。
您还可以改用 rotateX()、rotateY() 和 rotateZ() 函数，让元素在特定轴上旋转。您可以通过传递角度、转弯和弧度单位来确定旋转角度。
```css
.my-element {
  transform: rotateX(10deg) rotateY(10deg) rotateZ(10deg);
}
```
rotate3d()函数采用四个参数，第四个参数是旋转，与其他旋转函数一样，它接受角度、角度和转弯。

## 扩缩
您可以使用 transform 和 scale() 函数更改元素的缩放比例。该函数接受一个或两个数字作为值，用于确定正类别或负比例。 如果您只定义一个数字参数，X 轴和 Y 轴都将按相同的缩放比例进行缩放，因此定义两者是 X 和 Y 的简写形式。与 rotate() 类似，有 scaleX()、scaleY() 和 scaleZ() 函数可用于在特定轴上缩放元素。
```css
.my-element {
  transform: scaleX(1.2) scaleY(1.2);
}
```

## 翻译
translate() 函数会在元素保持其在文档流中的位置时移动元素。它们接受长度和百分比值作为参数。 如果定义了一个参数，translate() 函数会沿 X 轴平移元素；如果定义了两个参数，则函数会沿 X 轴和 Y 轴平移元素。
```css
.my-element {
  transform: translatex(40px) translatey(25px);
}
```

## 偏差
您可以使用接受角度作为参数的 skew() 函数使元素倾斜。skew() 函数的工作方式与 translate() 非常相似。如果您只定义一个参数，则只会影响 X 轴；如果您同时定义了这两个参数，则会影响 X 轴和 Y 轴。您还可以使用 skewX 和 skewY 分别影响每个轴。
```css
.my-element {
  transform: skew(10deg);
}
```

## 渐变
1. 线性渐变
- linear-gradient() 函数逐步生成两种或更多颜色的图片。它需要多个参数，但在最简单的配置中，您可以传递一些颜色（就像这样），它会自动均匀拆分这些颜色，同时进行混合。
```css
.my-element {
    background: linear-gradient(black, white);
}
```
- 还可以传递代表角度的角度或关键字。如果您选择使用关键字，请在 to 关键字后指定方向。 这意味着，如果您需要一种从左（黑）到右（白）的黑白渐变，则应将角度指定为 to right 作为第一个参数。
```css
.my-element {
    background: linear-gradient(to right, black, white);
}
```
- 可以在 linear-gradient() 中添加任意数量的颜色和颜色停止点，并且可以用逗号分隔各个渐变，从而在彼此之上叠加渐变。
```css
.my-element {
	background: linear-gradient(45deg, darkred 20%, crimson, darkorange 60%, gold, bisque);
}
```
2. 径向渐变
如需创建以圆形辐射的渐变，radial-gradient() 函数可以提供帮助。
它与 linear-gradient() 类似，但您可以选择指定位置和结束形状，而不是指定角度。如果您只指定颜色，radial-gradient() 会自动将位置设为 center，并根据框的大小选择圆形或椭圆形。
```css
.my-element {
    background: radial-gradient(white, black);
}
```
3. 圆锥渐变
圆锥渐变在框中有一个中心点，从顶部开始（默认情况下），沿着 360 度圆环。
```css
.my-element {
    background: conic-gradient(white, black);
}
```
conic-gradient() 函数接受位置和角度参数。
默认情况下，角度为 0 度，从顶部（中心）开始。如果您将角度设置为 45deg，则该角度为右上角。angle 参数接受任何类型的角度值，例如线性渐变和径向渐变。
默认情况下，该位置位于中心位置。与径向和线性渐变一样，定位可以基于关键字，也可以用数值定义。
和其他渐变类型一样，您可以根据需要添加任意数量的颜色停止点。使用圆锥渐变功能时，就很适合使用 CSS 渲染饼图。
```css
.my-element {
	background: conic-gradient(
     gold 20deg, lightcoral 20deg 190deg, mediumturquoise 190deg 220deg, plum 220deg 320deg, steelblue 320deg);
  border-radius: 50%;
  border: 10px solid;
}
```
4. 重复和混合
repeating-linear-gradient()、repeating-radial-gradient() 和 repeating-conic-gradient()。它们与非重复函数类似，并采用相同的参数。 不同之处在于，如果可以重复定义的渐变以填充框，则渐变效果将发生变化。

## 动画
可以使用 CSS 动画制作此类动画，从而使用关键帧设置动画序列。 动画可以是简单的单状态动画，也可以是复杂的基于时间的序列。

1. 什么是关键帧？
在动画软件、CSS 和大多数可让您为内容添加动画效果的工具中，关键帧是用来为时间轴上时间戳分配动画状态的机制。
我们使用“脉搏器”作为上下文。整个动画会运行 1 秒，并在 2 种状态下运行。

2. @keyframes
以下是具有两种状态的基本规则。
```css
@keyframes my-animation {
    from {
        transform: translateY(20px);
    }
    to {
        transform: translateY(0px);
    }
}
```
要注意的第一部分是自定义 ID（自定义标识符），从更通俗易懂的角度来说，就是关键帧规则的名称。 此规则的标识符为 my-animation。
自定义标识符的作用类似于函数名称。正如您在函数模块中学到的那样，您可以在 CSS 代码中的其他位置引用关键帧规则。

3. animation 属性
- animation-duration 属性用于定义 @keyframes 时间轴的时长。它应该是时间值。 默认设置为 0 秒，表示动画仍会运行，但播放速度过快，您无法看到。时间值不能为负数。
```css
.my-element {
    animation-duration: 10s;
}
```

- animation-timing-function
为在动画中重现自然动作，您可以使用计时函数来计算动画在每个点的速度。计算值通常是曲线的，使得动画在 animation-duration 过程中以可变速度运行，
如果计算的值超过了 @keyframes 中定义的值，则让元素看起来像是弹跳。
CSS 中有几个关键字可用作预设，它们用作 animation-timing-function 的值：linear、ease、ease-in、ease-out、ease-in-out。
```css
.my-element {
    animation-timing-function: ease-in-out;
}
```

- steps 加/减速函数
有时，您可能希望更精细地控制动画，而不是沿着曲线移动，而是想按间隔移动。借助 steps() 加/减速函数，您可以将时间轴拆分为定义的相等间隔。
```css
.my-element {
    animation-timing-function: steps(10, end);
}
```
第一个参数是步数。 如果将步数定义为 10，并且有 10 个关键帧，那么每个关键帧将按照确切的时长依次播放，并且状态之间没有过渡。如果各步骤的关键帧不足，系统会根据第二个参数添加关键帧之间的步骤。
第二个参数是方向。 如果设置为 end（默认值），则相关步骤会在时间轴的末尾完成。如果设置为 start，则动画的第一步会在开始时立即完成，这意味着它比 end 早一个步骤结束。

- animation-iteration-count
```css
.my-element {
    animation-iteration-count: 10;
}
```
animation-iteration-count 属性会定义 @keyframes 时间轴的运行次数。默认情况下，值为 1，表示当动画到达时间轴的终点时，它会在结束处停止。 该数字不能为负数。

- animation-direction
```css
.my-element {
    animation-direction: reverse;
}
```
您可以使用 animation-direction 设置时间轴在关键帧上的运行方向：
normal：默认值，是转发的。
reverse：在您的时间轴上反向运行。
alternate：对于每次动画迭代，时间轴都会按顺序向前或向后运行。
alternate-reverse：alternate 的反转值。

- animation-delay
```css
.my-element {
    animation-delay: 5s;
}
```
animation-delay 属性会定义启动动画前的等待时间。 与 animation-duration 属性一样，此属性接受时间值。

- animation-play-state
```css
.my-element:hover {
    animation-play-state: paused;
}
```
借助 animation-play-state 属性，您可以播放和暂停动画。默认值为 running；如果将其设置为 paused，则会暂停动画。

- animation-fill-mode
animation-fill-mode 属性会定义 @keyframes 时间轴中的哪些值在动画开始前或结束之后会保留。默认值为 none，表示当动画完整播放时，时间轴中的值会被舍弃。 其他选项包括：
forwards：系统会根据动画方向持续保留最后一个关键帧。
backwards：第一个关键帧将根据动画方向持续显示。
both：遵循 forwards 和 backwards 的规则

4. animation 简写形式
您可以使用 animation 简写形式定义它们，而无需单独定义所有属性，这样您就可以按以下顺序定义动画属性：
animation-name
animation-duration
animation-timing-function
animation-delay
animation-iteration-count
animation-direction
animation-fill-mode
animation-play-state
```css
.my-element {
    animation: my-animation 10s ease-in-out 1s infinite forwards forwards running;
}
```

## 过滤条件
可以实时应用所需效果并对所需内容进行模糊处理。模糊处理和不透明度是可用的滤镜中的两种
例如您需要构建一个元素，该元素在图片顶部有一个略不透明的磨砂玻璃效果。

1. blur
这会应用高斯模糊，并且您可以传递的唯一参数是 radius，它表示应用的模糊程度。需要是一个长度单位，例如 10px。不接受百分比。
```css
.my-element {
    filter: blur(0.2em);
}
```
2. brightness
如需调高或调低元素的亮度，请使用亮度函数。亮度值以百分比表示，未更改的图片表示为值 100%。
值为 0% 会使图片完全变为黑色，因此，介于 0% 和 100% 之间的值会降低图片的亮度。使用大于 100% 的值来提高亮度。
```css
.my-element {
    filter: brightness(80%);
}
```
3. contrast
设置一个介于 0% 和 100% 之间的值，可分别降低或提高对比度。
```css
.my-element {
    filter: contrast(160%);
}
```
4. grayscale
您可以通过使用 1 作为 grayscale() 的值来应用完全灰度效果，或者使用 0 以获得完全饱和的元素。
您也可以使用百分比或小数值来仅应用部分灰度效果。 如果您未传递任何参数，元素将变为完全灰度模式。如果您传递的值大于 100%，则上限值为 100%。
```css
.my-element {
    filter: grayscale(80%);
}
```
5. invert
和 grayscale 一样，您可以将 1 或 0 传递给 invert() 函数以将其开启或关闭。开启后，元素的颜色会完全颠倒显示。您还可以使用百分比或小数值仅应用部分颜色反转。 如果您没有向 invert() 函数传递任何参数，则元素将被完全反转。
```css
.my-element {
    filter: invert(1);
}
```
6. opacity
opacity() 过滤器的工作方式与 opacity 属性类似，您可以通过传递数字或百分比来提高或降低不透明度。如果未传递任何参数，元素将完全可见。
```css
.my-element {
    filter: opacity(0.3);
}
```
7. saturate
饱和度过滤条件与 brightness 过滤条件非常相似，并接受相同的参数：数字或百分比。 saturate 会增加或降低色彩饱和度，而不是调高或调低亮度效果。
```css
.my-element {
    filter: saturate(155%);
}
```
8. sepia
您可以使用此滤镜添加深褐色调效果，其作用类似于 grayscale()。深褐色调是一种摄影技术，可将黑色色调转换为棕色调，让色调升温。
您可以将数字或百分比作为 sepia() 的参数传递，以增大或减小效果。不传递任何参数即可添加完整的棕褐色效果（等同于 sepia(100%)）。
```css
.my-element {
    filter: sepia(70%);
}
```
9. hue-rotate
您在颜色课程中了解了 hsl 中的色调如何引用色轮的旋转，并且此滤镜的工作原理类似。
如果您传递角度（例如角度或转弯），则会改变元素所有颜色的色调，改变其引用的色轮部分。 如果您不传递任何参数，则系统不会执行任何操作。
```css
.my-element {
    filter: hue-rotate(120deg);
}
```
10. drop-shadow
您可以像在设计工具（如 Photoshop）中一样，使用 drop-shadow 来应用弯曲的阴影。该阴影应用于 Alpha 蒙版，对于向刘海屏图片添加阴影非常有用。
drop-shadow 过滤器接受一个阴影参数，该参数包含以空格分隔的 offset-x、offset-y、blur 和 color 值。它与 box-shadow 几乎完全相同，但不支持 inset 关键字和分散值。
```css
.my-element {
    filter: drop-shadow(5px 5px 10px orange);
}
```
11. url
借助 url 滤镜，您可以应用来自关联的 SVG 元素或文件的 SVG 滤镜。您可以在此处详细了解[ SVG 滤镜](https://developer.mozilla.org/docs/Web/SVG/Element/filter)
```css
.my-element {
  /*  Defined in SVG  */
  filter: url(#pink-filter);
}
```
12. 背景幕滤镜(backdrop-filter)
backdrop-filter 属性接受所有与 filter 相同的过滤条件函数值。backdrop-filter 和 filter 之间的区别在于，backdrop-filter 属性仅将滤镜应用于背景，而 filter 属性会将其应用于整个元素。
```css
.my-element h1 {
  background: hsl(0 100% 100% / 55%);
  backdrop-filter: blur(10px);
}
```
