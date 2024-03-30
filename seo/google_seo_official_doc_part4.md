# Google SEO官方文档笔记(四)

### The Notes of Google SEO Official Document - Part 4

**Created by: [matrix.works](https://matrix.works/)**

[引用出处][1]: https://developers.google.com/search/docs?hl=zh-cn


## 监控与调试

### 调试 Google 搜索流量下降问题

1. 导致自然搜索流量下降的主要原因
- 技术问题
- 安全问题
- 违规行为和人工处置措施
- 算法变化
- 搜索热度下降
- 您最近迁移了自己的网站
2. 分析搜索流量下降规律
- 将分析报告日期范围更改为包含 16 个月
- 将流量下降时期与类似时期进行比较
- 单独分析各种搜索类型
- 监控您的网站在搜索结果中的平均排名
- 在受影响的网页中寻找规律
- 调查所在行业的总体趋势

### Search Console 使用入门

1. 面向 SEO 专家、数字营销人员和网站管理员的实用报告
- 了解我们是否对您的网站执行了 Google 搜索人工处置措施
- 暂时不让网页显示在 Google 搜索结果中
- 将网站迁移情况告知 Google
- 检查结构化数据实施方面的问题
2. 面向 Web 开发者的实用报告
- 面向 Web 开发者的实用报告
- 调试网页级搜索索引编制问题
- 查找并修复影响您网站的威胁
- 确保您的网站能向用户提供良好的网页体验

### 利用 Search Console 气泡图改进搜索引擎优化 (SEO) 效果

1. 解读图表
存在多个指标和维度时，气泡图是一种非常直观的可视化图表，因为它可以让您更有效地发现数据中的关系和模式。在此处显示的示例中，您可以在一个视图中查看相应查询和设备维度的点击率 (CTR)、平均排名以及点击次数。
2. 数据源
3. 过滤条件和数据控制

### Google 搜索运算符概览

- cache:
> cache:https://www.google.com/

- filetype: 查找特定文件类型（由 content-type HTTP 标头或文件扩展名定义）的搜索结果。例如，您可以搜索以 .rtf 结尾且内容中包含“galway”一词的 RTF 文件和网址：
> filetype:rtf galway

- imagesize: 查找包含特定尺寸的图片的网页。此搜索运算符仅适用于 Google 图片。例如：
> imagesize:1200x800

- site: 查找来自特定的网域、网址或网址前缀的搜索结果。例如：
> site:https://www.google.com/

src: 查找在 src 属性中引用了特定图片网址的网页。此搜索运算符仅适用于 Google 图片。例如：
> src:https://www.example.com/images/peanut-butter.png
