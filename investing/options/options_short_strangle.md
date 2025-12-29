# 卖出宽跨式组合 - Short Strangle

[Refer](https://www.futunn.com/learn/detail-selling-a-wide-span-combination-75944-230209045?chain_id=5nigzlLNeOJa2-.1kl2dpl&global_content=%7B%22promote_id%22%3A13766%2C%22sub_promote_id%22%3A14%2C%22f%22%3A%22nn%2Flearn%2Fdetail-bullish-options-spread-in-a-bull-market-75944-230360076%22%7D)

## 使用场景

预期短期内市场的不确定性变小，也不会有引发大涨或大跌的因素。
如果你判断市场波动会趋于平缓，可采取卖出宽跨式组合（Short Strangle），通过卖出价外（OTM）期权增加期权到期时处于价外的概率，赚取期权金收益。

## 策略简介

1. 策略构成
「卖出Put」+「卖出Call」
Call和Put的标的资产、到期日、合约数量完全相同，但是Put的行权价小于Call的行权价。通常情况下两张期权均处价外（OTM），即Put行权价＜股票价格＜Call行权价。

2. 盈亏分析
盈利来源：同时卖出Call和Put赚取期权金收益。后续股价若在一定区间范围内温和波动，只要涨跌带来的损失不超过获得的期权金，策略就能获利。

3. 策略特点
预期：中性。如果你认为短期内股价不会剧烈变化，可以构建Short Strangle策略。
盈利有限：当Put行权价＜股价＜Call行权价时，两张期权均处于价外，获得全部期权金。最大盈利=总期权金。
亏损无限：无论股价上涨还是下跌，只要股价偏离行权价你都需要承担被行权的支出。上涨或下跌的幅度越大，亏损就越多。
波动率：该策略属于做空波动率策略，如果到期日标的资产价格较大，可能会承担无限的理论亏损，所以更适合在IV较高且预期IV变低的时候构建。
