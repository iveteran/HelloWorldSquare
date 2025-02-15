# web3小白入门之旅

[奔跑的橡皮擦](http://juejin.cn/user/3966693683236664/posts)

2024-08-25

## 前言

随着web3世界如火如荼的发展，任何一个对于加密世界感兴趣的程序员来说，学习和掌握web3的开发技能显的十分有必要。然而web3开发从何开始呢，对于刚接触这个领域的小萌新来说，往往是两眼一黑不知从头开始啊。实不相瞒我刚开始也是这种状态，但是困难是纸老虎，你强它就弱，经过一番摸索，我发现实际没那么困难，希望以此文记录下学习之路经，同时给想了解这行业的小猿们起到抛砖引玉之功效！

下面我将这分为原理篇、技术栈篇，和实战篇等三个部分来讲，我不敢说我说的都是对的，只是将自学过程中一点理解，供大家参考，咱们可以一起探讨，共同进步

## 原理

说到区块链原理，我觉得比特币和以太坊这两个加密世界的先驱不得不提，一个开启了区块链的大门，一个使得区块链图灵完备，大规模商业化变为可能，其中众多概念：例如究竟什么是分布式账簿？挖矿的过程是什么样，pow和pos挖矿机制的区别？区块链的分叉方式分为硬分叉和软分叉的区别又是在哪？比特币减半又是怎么一回事呢？既然有了比特币为啥需要以太坊这种evm类型的区块链？智能合约又是干嘛的？不用急，接下来一一来探索。

### 比特币

![](https://p6-xtjj-sign.byteimg.com/tos-cn-i-73owjymdk6/38cd610972a44b50b83fa5baf55c1dc7~tplv-73owjymdk6-jj-mark-v1:0:0:0:0:5o6Y6YeR5oqA5pyv56S-5Yy6IEAg5aWU6LeR55qE5qmh55qu5pOm:q75.awebp?rk3s=f64ab15b&x-expires=1737358476&x-signature=bUom9VrWDXuSy0vtCf5SNHrVZYQ%3D)
作为加密领域的鼻祖，在2009年1月3日18:15:05 UTC，第一个创世区块被创建，比特币正式诞生了。它具有公开透明和不可篡改的特性，每一笔交易记录都可以在链上查到数据，同时交易记录不可篡改。比起中心化账本来说，其可靠性和优越性不言而喻。那它是怎么做到这一切的呢？下面将提到几个重要的概念，区块，区块链的形成过程，前面讲到的挖矿等概念也会在这讲到。

#### 区块

区块（Block）是区块链技术的核心组成部分，它是一个包含数据和元数据的数据结构。在比特币、以太坊等区块链网络中，区块用于记录交易信息和其他相关数据。区块通过密码学的方式链接在一起，形成一个不可篡改的分布式账本，称为区块链。

1. 区块的结构
每个区块通常由以下几部分组成：
![](https://p6-xtjj-sign.byteimg.com/tos-cn-i-73owjymdk6/ebf620b896974511a798c0011bed7c91~tplv-73owjymdk6-jj-mark-v1:0:0:0:0:5o6Y6YeR5oqA5pyv56S-5Yy6IEAg5aWU6LeR55qE5qmh55qu5pOm:q75.awebp?rk3s=f64ab15b&x-expires=1737358476&x-signature=Ilh6hauuTIvkMph9%2FluKkkWSsco%3D)

- 区块头（Block Header）: 包含区块的元数据，如版本号、上一个区块的哈希值、Merkle根哈希、时间戳、难度目标和随机数（nonce）等。这部分是区块链的关键，确保每个区块与前一个区块正确链接。
  - 版本号（Version）: 表示区块的结构版本。
  - 前一个区块的哈希值（Previous Block Hash）: 指向前一个区块的哈希值，形成链式结构。
  - Merkle根哈希（Merkle Root Hash）: 当前区块中所有交易的哈希值的哈希树根节点，确保交易数据的完整性和一致性。
  - 时间戳（Timestamp）: 记录区块被创建的时间。
  - 难度目标（Difficulty Target）: 用于调整挖矿的难度，以控制新区块的生成速度。
  - 随机数（Nonce）: 挖矿过程中用来满足特定难度要求的值。（在以太坊网络中，Nonce用来表示一个账户已经发起的交易数量）
  - coinBase: 是区块创建的时候用于分配区块奖励的一个特殊的记录
  - 区块体（Block Body）: 包含实际的数据，如交易记录或其他信息。在比特币中，区块体主要是交易列表。
  - 交易列表（Transaction List）: 该区块内记录的所有交易数据，包括发送方、接收方、金额、交易费等。

#### 挖矿的过程

- 挖矿的本质其实就是在生成新的区块之前，矿工通过不断的调整随机数nonce，并对整个区块头进行哈希计算，直到找到一个符合难度要求的哈希值。
这里面有两个重要概念：
  - 哈希函数: 比特币使用的是 SHA-256 哈希函数，这个函数将区块头的内容映射为一个固定长度的哈希值。
  - 难度目标: 难度目标通常要求哈希值的前几位为零，具体要求根据网络难度调整。这使得找到一个符合条件的哈希值非常耗费计算资源。

计算简易版过程大概如下

```hljs scss
/**
header包含：
前一个区块的哈希值（Previous Block Hash）
默克尔根哈希值（Merkle Root Hash）
时间戳（Timestamp）
难度目标（Difficulty Target）
Nonce（矿工不断调整的值）
*/
hash = SHA-256(SHA-256(block header))

```

然后通过比较计算出来的hash要求小于Difficulty Target，只要小于Difficulty Target，说明nounce值是有效的，随即会产生新的区块。

- 其中Difficulty Target 的表示：
十六进制表示: 比特币的 Difficulty Target 通常以256位（64个十六进制字符）的大整数表 示。例如：
0x00000000ffffffffffffffffffffffffffffffffffffffffffffffffffffffff
难度增加: 随着比特币网络的算力增加，难度目标会调整为更小的数字。例如：
0x0000000000000ffffffffffffffffffffffffffffffffffffffffffffffffffff
试着思考一下，是不是Difficulty Target值越小，相对而言有效的nounce就会越少，稀缺度更高了，相应的计算次数需要增加
![](https://p6-xtjj-sign.byteimg.com/tos-cn-i-73owjymdk6/00df4f862fce419fa8d9677c81f533b3~tplv-73owjymdk6-jj-mark-v1:0:0:0:0:5o6Y6YeR5oqA5pyv56S-5Yy6IEAg5aWU6LeR55qE5qmh55qu5pOm:q75.awebp?rk3s=f64ab15b&x-expires=1737358476&x-signature=8%2FoYjUmGkMhgpu%2BkolTLX5WFTxE%3D)

**挖矿的具体步骤如下：（权益证明）**
（1）收集交易
交易池：
矿工从比特币网络中的内存池（mempool）中收集待处理的交易。内存池存储了尚未被确认的交易。
选择交易：
矿工会根据交易的手续费和其他因素选择交易。通常会优先选择手续费较高的交易，以提高矿工的收益。

（2）构建区块
区块头部：
矿工创建一个新区块，包括区块头部和区块体。区块体包含所有待处理的交易，而区块头部包含了元数据，比如前一个区块的哈希值、时间戳、难度目标等。
默克尔树：
矿工会将区块体中的交易数据组织成默克尔树（Merkle Tree），计算默克尔根哈希值，并将其包含在区块头部中。

（3）计算哈希值
目标哈希值：
矿工需要找到一个有效的区块哈希值，使其小于网络的难度目标。这需要不断尝试不同的输入值（即“随机数”或“nonce”）来计算区块头部的哈希值。
哈希函数：
比特币使用 SHA-256 哈希函数来计算区块头部的哈希值。矿工尝试不同的 nonce 值，直到找到一个符合难度目标的哈希值。

（4）验证和广播
验证：
一旦矿工找到一个有效的哈希值，新的区块就会被生成并验证。其他节点会检查区块的合法性，包括交易是否有效、哈希值是否符合难度目标等。
广播：
验证通过后，矿工将新区块广播到比特币网络中的所有节点。这些节点会将新区块添加到自己的区块链副本中，并继续挖掘下一个区块。

#### 区块链是怎么形成的

其实前面挖矿过程已经就讲到了，随着新区块的产生，会携带上一个区块的hash，在新的区块中使用上一个区块的hash产生新的区块hash，随着新区块的加入，区块链逐渐延长，形成一个按时间顺序排列的链条。这就是所谓的区块链。随着区块高度的增加，想修改其中的某一个交易意味着要修改链上上所有的hash，这几乎是不可能的，这就是区块链不可篡改的原因。

其中有个特殊情况，就是有时会出现两个矿工几乎同时挖出不同的区块，导致区块链发生分叉，此时，网络中的节点会遵循“最长链原则”，即最长的链（包含最多的工作量证明）被视为有效链，其他较短的链被舍弃。（每一个节点产生都是工作量证明的产物，更为安全和可靠，所有选择最长链是合理的）。

#### 区块链分叉

区块链分叉分为硬分叉和软分叉

- 硬分叉：
  - 硬分叉（Hard Fork）是区块链网络中的一种重大协议更新，导致新链与旧链不再兼容。新的区块或交易格式、共识算法的改变、区块大小的调整等，都是可能引发硬分叉的更改。硬分叉会引入兼容的规则更改，使得节点必须升级到新版本才能继续参与网络。通常硬分叉会导致新的社区诞生。
  - 硬分叉的例子
    - 2017 年，比特币社区围绕区块大小限制的问题产生了激烈的争议。支持更大区块的人发起了硬分叉，创建了比特币现金（BCH），它将区块大小从 1MB 增加到 8MB。
    - 2016 年，以太坊网络因 The DAO 智能合约被黑客利用而丢失大量资金。以太坊社区决定通过硬分叉来逆转这次攻击，恢复资金。也就是现在的以太经典（ETC）
- 软分叉:
  - 软分叉（Soft Fork）是区块链网络中的一种协议更新方式，它引入的更改与旧版节点兼容，使得未升级的节点仍然可以继续参与网络。与硬分叉不同，软分叉不会导致区块链的分裂，而是通过限制性规则的更新来实现网络共识的改进或功能的增强。
  - 软分叉的例子：
    - 比特币的隔离见证（Segregated Witness, SegWit）： SegWit 是比特币历史上一次重要的软分叉更新。它通过改变交易数据的存储方式来提高比特币网络的效率和扩展性，并修复了一些潜在的安全漏洞
      参考 [mirror.xyz/0xc508Ba2Ba…](https://link.juejin.cn?target=https%3A%2F%2Fmirror.xyz%2F0xc508Ba2Ba28acD69225796cd49EF50e32FE5282D%2Feeg2NpMI3WioGhVX4Q_XU_IjqXN39F9R9JcFl-LTPfc "https://mirror.xyz/0xc508Ba2Ba28acD69225796cd49EF50e32FE5282D/eeg2NpMI3WioGhVX4Q_XU_IjqXN39F9R9JcFl-LTPfc")

#### 比特币减半

比特币网络每 210,000 个区块之后，区块奖励会减半。这大约每隔四年发生一次。减半意味着产量减少，所以每次减半之后会伴随着比特币价格的巨幅上涨，也就是我们所谓的牛市。

### 以太坊

前面就是比特币最为核心的部分区块和工作量证明，既然有了比特币网络，为啥还需要以太坊这样的网络呢？下面一一介绍。

#### 以太坊诞生原因

- 比特币的局限性：比特币最初是作为一种去中心化的数字货币或“数字黄金”设计的，主要用于点对点支付和价值存储。虽然比特币在这些方面取得了成功，但它的设计相对简单，功能较为单一。
- 比特币支持一种有限的脚本语言，用于执行简单的交易逻辑，比如多重签名、时间锁定等。然而，这种脚本语言不具备图灵完备性，无法用于构建复杂的智能合约和去中心化应用（DApps）。
- 更快的速度和图灵完备性，使得区块链应用大范围商业化成为可能，如今特别是金融业应用十分广泛了

#### 以太坊的挖矿机制

以太坊早期的挖矿机制是跟比特币类似的“Ethash”工作量证明。大家感兴趣的可以自行去查阅。由于工作量证明被认为是一种低效且浪费电力的行为，所以从2022年9月16日伴随着以太坊完成以太坊合并，它从工作量证明彻底转成了pos权益证明，节点验证成为了新的工作证明方式。下面着重讲一下pos。

#### pos（权益证明）的挖矿过程

1. 质押（Staking）
质押的作用：

保证机制：质押的32 ETH作为保证金，确保验证者不会进行恶意行为。如果验证者试图破坏网络的安全性，他们可能会失去一部分或全部质押的ETH。
质押过程：

参与质押：要成为验证者，用户需要在以太坊主网上质押32 ETH到一个特定的智能合约中。这可以通过官方的质押CLI工具或通过第三方质押服务来完成。
质押验证者密钥：验证者在质押时生成两个密钥对，一个用于验证区块的“验证密钥”，另一个用于提款的“提款密钥”。验证密钥用于签名区块，而提款密钥仅在撤回质押时使用。

2. 区块提议（Block Proposal）
提议者的选择：

随机性和加权：以太坊网络通过随机算法选择验证者来提议区块。随机性是通过以太坊2.0中的“RANDAO”机制实现的。选择过程是随机的，但质押的ETH越多，被选中的概率越高。
区块提议的过程：

交易选择：被选中的验证者从待处理交易池（Mempool）中选择交易，打包成一个区块。选择的交易通常是那些愿意支付较高Gas费的交易。
区块创建：验证者创建一个包含这些交易的区块，并添加必要的元数据，如前一个区块的哈希值、验证者签名等。

3. 验证与共识（Attestation and Consensus）
委员会（Committee）的选择：

随机分配：每个区块周期（Epoch）中，验证者会被随机分配到不同的委员会。委员会负责验证特定的区块，确保其有效性。
多委员会并行运行：在一个区块周期中，多个委员会可以并行运行，以加快验证过程。
验证过程：

验证区块的有效性：委员会的成员会验证区块的每一项内容，包括交易的有效性、区块结构、提议者的签名等。如果区块中的交易不符合规则或区块不符合格式要求，委员会成员可以投反对票。
共识达成：

投票（Attestation）：验证者通过签名表达他们对区块的同意或拒绝，这个签名称为“Attestation”。如果区块得到了足够多的Attestation（超过2/3），则被认为已达成共识，可以被添加到区块链中。

4. 奖励与惩罚（Rewards and Penalties）
奖励机制：

区块奖励：提议区块的验证者会得到区块奖励，这个奖励是由网络生成的新ETH以及区块中包含的交易费用构成的。
验证奖励：参与验证并投票的验证者也会根据他们的活动得到奖励。奖励的数量取决于他们是否在规定时间内提交了正确的Attestation。
惩罚机制：

削减（Slashing）：如果验证者进行恶意行为，如签名两个不同的区块链分支（双重签名）或提交无效的Attestation，他们的质押ETH可能会被削减。削减不仅减少验证者的质押，还会将他们从网络中移除。
罚金（Penalties）：如果验证者不活跃或未能在规定时间内提交Attestation，他们会受到罚金。罚金的大小取决于验证者的非活动时间长短。

5. 周期（Epochs）
周期的作用：

区块的组装：以太坊的时间被划分为周期（Epoch），每个周期包含32个区块。每个周期结束时，网络会对验证者的活动进行总结。
状态更新：周期结束后，所有的奖励和惩罚都会被结算并更新到验证者的账户中。
周期内的机制：

检查点（Checkpoints）：在每个周期的开始和结束时，都会创建一个“检查点区块”，这些检查点用于后续的链重组和状态恢复。
重组机制：如果出现区块链分叉，网络会选择包含更多Attestation的链作为主链，并根据这些检查点来决定哪条链是有效的。

6. 撤回质押（Unstaking）
撤回质押的过程：

发起请求：验证者可以随时发起撤回质押请求。一旦请求被提交，验证者会进入退出队列，等待网络确认。
等待期：撤回请求通常会有一个等待期，这个等待期的长短取决于网络的拥堵情况和质押的总数量。
提款：等待期结束后，验证者可以通过提款密钥将质押的ETH以及累积的奖励提取到指定的地址。
退出后重新参与：

重新质押：如果验证者希望重新参与质押，他们需要再次质押32 ETH，并生成新的验证密钥和提款密钥。
前面讲到的共识算法，其实在不同的evm链上，有不同的实现方式，这就是为什么有那么多公链号称是以太坊杀手呢，他们都是在巨人的肩膀上，改进算法，进而加快交易速度和降低费用等等，其实本质大同小异。

**其中验证者是如何工作：**

1. 周期和槽位（Epochs and Slots）
周期（Epoch）：在以太坊PoS中，时间被划分为周期（Epoch），每个周期包含32个槽位（Slot），即32个区块。每个槽位对应一个时间段，通常为12秒。
槽位（Slot）：每个槽位中会有一个区块提议者和多个委员会成员。不同的槽位可以拥有不同的委员会。
2. 验证者队列（Validator Queue）
验证者注册：当一个验证者质押了32 ETH后，他们会被添加到一个全局的验证者队列中。这个队列包含了所有活跃的验证者，每个验证者都有一个唯一的验证者索引（Validator Index）。
验证者的顺序：验证者在队列中的顺序不是固定的，而是根据一个随机种子（seed）定期重新排列。
3. 随机种子（Random Seed）
种子的生成：在每个周期开始时，以太坊网络会生成一个新的随机种子。这个种子是通过RANDAO（Random Number Beacon）和其他加密算法组合生成的，确保了足够的随机性。
RANDAO机制：RANDAO是一种去中心化的随机数生成方法。它通过多个验证者提交的随机数来生成一个全局的随机数。验证者提交的这些随机数会被混合在一起，从而产生一个难以预测的最终种子。
4. 委员会生成（Committee Formation）
委员会的大小：每个槽位的委员会通常由128个验证者组成，但这个数量可以根据网络条件进行调整。
验证者分配：使用随机种子，以太坊协议会将验证者随机分配到不同的槽位和委员会中。这个分配是通过算法将验证者索引（Validator Index）映射到特定槽位和委员会。
均匀分布：该算法确保每个验证者在不同的周期中都有机会被分配到不同的委员会，同时避免某些验证者总是被分配到同一委员会。
5. 委员会的职责
提议者选择：对于每个槽位，从该槽位对应的委员会中随机选择一个验证者作为区块提议者。提议者负责创建并提交区块。
验证与共识：委员会的其他成员负责验证区块，并通过签名（Attestation）表示他们对区块的同意或拒绝。只有当超过2/3的委员会成员同意该区块时，区块才会被添加到区块链中。
6. 委员会的独立性
并行运行：在一个周期内，多个委员会是并行运行的。每个槽位的委员会都是独立的，负责不同区块的验证。这种并行结构提高了网络的吞吐量和安全性。
抗攻击性：由于验证者和委员会的随机分配，攻击者很难预测特定槽位的委员会成员。这种随机性使得以太坊PoS系统更具抗攻击性，特别是抵御“长程攻击”和“贿赂攻击”。
7. 周期的变化
每周期重新分配：在每个新的周期开始时，随机种子会被更新，所有验证者的分配会重新计算。这意味着验证者在一个周期中的角色不会影响他们在下一个周期中的角色，这进一步增加了系统的随机性和安全性。

#### 智能合约

智能合约（Smart Contract）是一种在区块链上执行的自我执行程序，它能够在满足特定条件时自动执行预先定义的操作。智能合约的核心特点是它们在去中心化的环境中运行，不依赖于任何第三方，且执行结果是不可更改的。其在金金融、游戏、供应链、社交、dao等方面有着广泛应用。

#### 以太坊账户体系

以太坊除了工作量证明机制上和比特币很不一样，它的账户体系也是很不一样的，它将账户分为个人账户和合约账户。合约账户顾名思义就是合约代码部署之后会产生一个账户，归合约部署者拥有所以权，不过如果合约写的不过完善，可能会存在代币取不出来的情况，这个在后面实战部分会讲。

现今web3世界之所以如此丰富多彩，跟智能合约的出现有着重大的关系。（虽说比特币现在也有铭文这种方式可以实现编程，但是跟智能合约几乎没法比）讲了这么多，以太坊的智能合约到底是怎么一回事呢，接下来即将开启技术栈篇，来领略dapp开发的风采。

## 技术栈篇

前面讲到了，现阶段大部分evm公链基本上本质跟以太坊是大同小异的，主要体现在验证算法不一样。所以我们搞懂了以太坊开发，其他的问题就不大。那么加下来我开始以太坊web3开发之路。

### 开发语言 [solidty](https://link.juejin.cn?target=https%3A%2F%2Fdocs.soliditylang.org%2Fen%2Fv0.8.26%2F "https://docs.soliditylang.org/en/v0.8.26/")

以太坊智能的官方开发语言就是Solidty，它是一门现代语言，和我们前端同学使用的js其实很像。接下来简短的介绍一下这门语言。

- 一个简单的solidty结构分为版本声明和合约声明，如下：

```hljs arduino
// 版本声明
pragma solidity ^0.8.0;
// 合约声明
contract SimpleStorage {
    // 合约代码
}

```

- solidty变量分为状态变量、局部变量和全局变量。
  - 状态变量（State Variables）状态变量是存储在区块链上的永久数据，属于合约的状态。当你定义一个状态变量时，它会被存储在以太坊区块链上，具有持久性。由于永久存储会消费gas的，所有尽可能的少使用状态变量

```hljs csharp
  contract Example {
    uint public count; // 状态变量
    address owner;
}

```

- 局部变量（Local Variables）局部变量是在函数内部声明的变量，它们只在函数执行期间存在，并且不会存储在区块链上。
特点：局部变量比状态变量更加高效，因为它们不需要存储在区块链上。
- 全局变量是 Solidity 提供的内建变量，包含了区块链和交易的相关信息，常见如下。
msg.sender：调用合约的账户地址（消息发送者）。
msg.value：调用时发送的以太币数量（单位为 wei）。
block.timestamp：当前区块的时间戳（单位为秒）。
block.number：当前区块的编号。
tx.gasprice：交易的 gas 价格。

```hljs csharp
function doSomething() public {
    uint localVariable = 10; // 局部变量
}

```

- solidty 的函数定义

```hljs scss
function functionName([parameterList]) [visibility] [modifiers] [returns (returnType)] {
    // 函数体
}

```

分别是函数名（functionName），
参数（parameterList），
可见性修饰符（visibility）：

- public：任何人都可以调用该函数，内部和外部都可以访问。
- private：只有合约内部可以调用，外部不能访问。
- internal：仅当前合约和继承的合约可以调用。
- external：只能通过外部调用（如从其他合约或账户）访问，
修饰符（modifiers）：
- view：指示该函数不会修改状态变量。
- pure：指示该函数既不会读取也不会修改状态变量。
- payable：允许该函数接收以太币。
和返回类型（returns）：如果函数有返回值，必须使用 returns 关键字指定返回类型。
例如：

```hljs csharp
contract SimpleWallet {
    function deposit() public payable {
        // 这个函数允许接收以太币
    }

    function getBalance() public view returns (uint) {
        return address(this).balance;
    }

     function add(uint a, uint b) public pure returns (uint) {
        return a + b;
    }

    function subtract(uint a, uint b) public pure returns (uint) {
        return a - b;
    }
}

```

- 数据存储位置（Storage, Memory, CallData）


  - storage：用于持久化存储在区块链上的数据。状态变量默认使用 storage。

```hljs csharp
  string public data = "Hello";
  function updateData(string memory newData) public {
      data = newData; // data 使用的是 storage
  }

```

  - memory： 用于临时数据的存储，仅在函数调用期间有效。局部变量和函数参数通常使用 memory。

```hljs php
  function processData(string memory input) public pure returns (string memory) {
      string memory tempData = input;
      return tempData;
  }

```

  - calldata：专门用于函数的外部调用参数，数据不可变且更节省 gas。calldata 只能用于函数的输入参数。

```hljs php
function externalFunction(string calldata input) external {
    // input 是不可变的，只能读取
}

```

- 构造函数:构造函数是一个特殊的函数，在合约部署时执行一次。用于初始化合约的状态 。


```hljs ini
contract SimpleStorage {
    uint public storedData;

    constructor(uint initialValue) {
        storedData = initialValue;
    }
}

```

- 事件与日志
  - 事件：事件可以用于记录区块链上的操作日志，外部应用程序可以监听这些事件来获取合约的执行信息。(dapp和智能合约通讯的关键)

```hljs csharp
event DataStored(uint indexed data);

function set(uint x) public {
    storedData = x;
    emit DataStored(x);
}

```

- 错误处理与断言
Solidity 提供了 require、assert 和 revert 用于错误处理。
  - require：用于条件检查，失败时抛出异常并回退状态。
  - assert：用于检查不应该为假的条件，通常用于严重错误。（没有错误提示）
  - revert：直接抛出异常并回退状态。（与require不一样需要自己设置条件）

```hljs scss
function withdraw(uint amount) public {
    require(amount <= address(this).balance, "Insufficient balance");
    payable(msg.sender).transfer(amount);
}

```

- 继承与接口
继承： Solidity 支持单继承和多继承，子合约可以继承父合约的属性和方法。例如

```hljs csharp
contract Parent {
    function parentFunction() public pure returns (string memory) {
        return "This is a parent function";
    }
}

contract Child is Parent {
    function childFunction() public pure returns (string memory) {
        return "This is a child function";
    }
}

```

接口：接口用于定义合约需要实现的函数。接口中的函数没有实现，仅有声明。

```hljs php
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IToken {
    function transfer(address to, uint amount) external returns (bool);
    function balanceOf(address account) external view returns (uint);
}

```

接口实现：需要使用 is 关键词

```hljs scss
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./IToken.sol"; // 导入接口

contract MyToken is IToken {
    mapping(address => uint) private balances;

    constructor() {
        balances[msg.sender] = 1000; // 初始余额
    }

    function transfer(address to, uint amount) external override returns (bool) {
        require(balances[msg.sender] >= amount, "Insufficient balance");
        balances[msg.sender] -= amount;
        balances[to] += amount;
        return true;
    }

    function balanceOf(address account) external view override returns (uint) {
        return balances[account];
    }
}

```

- 装饰器： 主要体现在函数修饰符（Function Modifiers）的使用上。函数修饰符用于修改或增强函数的行为，类似于其他编程语言中的装饰器（decorators）。
基本结构例如下面：

```hljs javascript
modifier modifierName(parameters) {
    // 代码逻辑
    _;
    // 可选：更多代码逻辑
}

```

其中\_;这个符号代指逻辑代码插入的地方。例如：

```hljs typescript
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract AccessControl {
    address public owner;

    constructor() {
        owner = msg.sender; // 设置合约所有者
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Not the owner");
        _;
    }

    function secureFunction() public onlyOwner {
        // 只有所有者才能调用这个函数
    }
}

```

这就是solidty的基本用法了，具体更为高阶的内容，请移步官网查看。

### 以太坊合约协议

1. ERC 标准
ERC（Ethereum Request for Comments） 标准是以太坊社区提出的技术标准，用于定义智能合约的接口规范。以下是一些常见的 ERC 标准：

ERC-20：最常用的代币标准，定义了代币的基本功能，如转账、授权等。大多数以太坊代币遵循 ERC-20 标准。
ERC-721：定义了非同质化代币（NFT）的标准，用于创建唯一的、不可替代的代币，如数字艺术品或收藏品。
ERC-1155：一种多功能代币标准，支持创建同质化代币和非同质化代币。这使得在一个合约中可以同时管理多种代币类型。

2. EIP 标准
EIP（Ethereum Improvement Proposal） 是以太坊改进提案，用于定义和提议新的功能或标准。以下是一些相关的 EIP 标准：

EIP-20：同 ERC-20 标准，定义了代币的基本接口。
EIP-721：同 ERC-721 标准，定义了非同质化代币的接口。
EIP-155：介绍了链ID，以便在多个以太坊链上避免重放攻击。
EIP-2930：引入了访问列表，用于提高以太坊网络的效率和降低交易成本。
EIP-1559：改进了以太坊交易费市场，提出了交易费用的基础费和小费的概念，并引入了燃烧机制以改善网络费用问题。

协议太多了，在这就不赘述了 [请参考：https://docs.openzeppelin.com/contracts/5.x/erc20](https://link.juejin.cn?target=https%3A%2F%2Fdocs.openzeppelin.com%2Fcontracts%2F5.x%2Ferc20 "https://docs.openzeppelin.com/contracts/5.x/erc20")

### Ethers库的介绍

前面讲到都是智能合约开发部分，作为一个完备的dapp,智能合约有了，它是如何跟前端进行通讯的呢？这里不得不提常见的web3.js 和ethers.js库了。由于ethers.js库是在web3.js基础上更为精炼的一个库，这里以它为例。

- 连接到以太坊网络

```hljs ini
const { ethers } = require("ethers");

// 使用 Infura 连接到以太坊主网（Infura是一个节点服务商）
const provider = new ethers.InfuraProvider("homestead", "YOUR_INFURA_PROJECT_ID");

// 使用本地节点
// const provider = new ethers.providers.JsonRpcProvider("http://localhost:8545");

```

- 管理账号

```hljs arduino
// 创建新账户
const wallet = ethers.Wallet.createRandom();
console.log("地址:", wallet.address);
console.log("私钥:", wallet.privateKey);

// 从助记词导入账户
const mnemonic = "your mnemonic phrase here";
const walletFromMnemonic = ethers.Wallet.fromMnemonic(mnemonic);
console.log("地址:", walletFromMnemonic.address);

// 从私钥导入账户
const walletFromPrivateKey = new ethers.Wallet("YOUR_PRIVATE_KEY");
console.log("地址:", walletFromPrivateKey.address);

```

- 签名和发送交易

```hljs javascript
async function sendTransaction() {
    const provider = new ethers.InfuraProvider("homestead", "YOUR_INFURA_PROJECT_ID");
    const wallet = new ethers.Wallet("YOUR_PRIVATE_KEY", provider);

    const tx = {
        to: "0xADDRESS",
        value: ethers.utils.parseEther("0.1"),
        gasLimit: 21000,
        gasPrice: ethers.utils.parseUnits("50", "gwei")
    };

    const transactionResponse = await wallet.sendTransaction(tx);
    console.log("交易哈希:", transactionResponse.hash);

    // 等待交易确认
    const receipt = await transactionResponse.wait();
    console.log("交易回执:", receipt);
}

```

- 查询链上数据

```hljs javascript
async function getBalance(address) {
    const provider = new ethers.InfuraProvider("homestead", "YOUR_INFURA_PROJECT_ID");
    const balance = await provider.getBalance(address);
    console.log("余额:", ethers.utils.formatEther(balance));
}

async function getBlockNumber() {
    const provider = new ethers.InfuraProvider("homestead", "YOUR_INFURA_PROJECT_ID");
    const blockNumber = await provider.getBlockNumber();
    console.log("最新区块号:", blockNumber);
}

```

- 跟智能合约进行链上交互：这里用到了abi和bytecode，我在后面实战篇会讲到怎么拿这个值。

```hljs ini
const abi = [ /* ABI JSON */ ];
const bytecode = "0x..."; // 合约字节码（实际机器代码）编译器转换后得到的二进制形式

async function deployContract() {
    const provider = new ethers.InfuraProvider("homestead", "YOUR_INFURA_PROJECT_ID");
    const wallet = new ethers.Wallet("YOUR_PRIVATE_KEY", provider);

    const factory = new ethers.ContractFactory(abi, bytecode, wallet);
    const contract = await factory.deploy(/* constructor args */);
    console.log("合约地址:", contract.address);

    // 等待合约部署确认
    await contract.deployTransaction.wait();
    console.log("合约已部署");
}

async function callContract() {
    const provider = new ethers.InfuraProvider("homestead", "YOUR_INFURA_PROJECT_ID");
    const contractAddress = "0x..."; // 合约地址
    const contract = new ethers.Contract(contractAddress, abi, provider);

    // 调用合约函数
    const result = await contract.someFunction(/* args */);
    console.log("合约返回值:", result);
}

```

- 链上事件监听

```hljs javascript
const contract = new ethers.Contract(contractAddress, abi, provider);

contract.on("EventName", (param1, param2, event) => {
    console.log("事件参数:", param1, param2);
});

```

dapp开发两个核心其实就是智能合约的开发和前端dapp的开发，这里进行了简短的介绍。真正的实际开发过程中可能会用到openzeppelin这些合约的安全库，harhat和truffles以太坊开发框架，以及钱包交互库rainbow这些开发库等等，同时在开发过程中以太坊官方提供的Remix开发工具十分好用。还有节点服务商的选择，合约部署等怎么做都是接下来实战篇会介绍到的。

## 实战篇

既然讲了这么多，我们也探索一下一个完整的dapp是如何开发的。下面我以DOG\_KING为例，发行一套meme代币。

### 代币合约设计

```hljs typescript
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// 导入 OpenZeppelin 的 ERC-20 实现
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract DogKing is ERC20, Ownable(msg.sender) {
    uint256 public constant TOTAL_SUPPLY = 21000000 * 10**18; // 总供应量 2100 万个代币（假设有 18 个小数位）
    uint256 public constant MINT_COST = 0.00001 ether; // 每个代币的挖掘成本为 0.00001 ETH

    constructor() ERC20("DogKing", "DK"){
        _mint(address(this), TOTAL_SUPPLY); // 将所有代币铸造到合约自身地址
    }

    // 增发代币
    function addMint(uint256 amount) public onlyOwner {
        _mint(address(this), amount * 10**decimals());
    }

    function buyTokens() public payable {
        uint256 tokensToMint = (msg.value / MINT_COST) * 10**decimals();
        require(tokensToMint > 0, "Insufficient ETH to mint tokens");
        require(balanceOf(address(this)) >= tokensToMint, "Not enough tokens left");

        _transfer(address(this), msg.sender, tokensToMint);
    }

    function depositTokens(uint256 amount, address adrss) public onlyOwner {
        _transfer(msg.sender, adrss, amount * 10**decimals());
    }

    function withdrawETH() public onlyOwner {
        payable(owner()).transfer(address(this).balance);
    }
}

```

上面的代币，总量设置为2100万个，设置购买函数，增发函数、免费分配函数。

如何将合约部署在链上验证呢？接下来使用hardhat来部署合约。

### 合约部署

- 使用hardhat 创建一个项目

```hljs bash
mkdir project
cd project

```

安装依赖

```hljs csharp
yarn init

```

```hljs sql
yarn add --dev hardhat
yarn add @openzeppelin/contracts

```

```hljs csharp
npx hardhat init

```

生成hardhat.config.js文件

```hljs kotlin
yarn add --dev @nomicfoundation/hardhat-toolbox @nomicfoundation/hardhat-ignition @nomicfoundation/hardhat-ignition-ethers @nomicfoundation/hardhat-network-helpers @nomicfoundation/hardhat-chai-matchers @nomicfoundation/hardhat-ethers @nomicfoundation/hardhat-verify chai@4 ethers hardhat-gas-reporter solidity-coverage @typechain/hardhat typechain @typechain/ethers-v6

```

- 在project创建contract文件夹，此处用于存放合约代码,将上面的DogeKing合约放此处

```hljs arduino
npx hardhat compile // 编译合约

```

- 在hardhat.config.js设置网络配置，此处我用到了alchemy 节点服务商的服务，请自行去注册

```hljs javascript
require("@nomicfoundation/hardhat-toolbox");
require("@nomicfoundation/hardhat-ethers");

// Go to https://www.alchemyapi.io, sign up, create
// a new App in its dashboard, and replace "KEY" with its key
const ALCHEMY_API_KEY = "xxx"; // 注册的ALCHEMY_API_KEY

// Replace this private key with your Goerli account private key
// To export your private key from Metamask, open Metamask and
// go to Account Details > Export Private Key
// Beware: NEVER put real Ether into testing accounts
const GOERLI_PRIVATE_KEY = "xxx"; // 私钥

module.exports = {
  solidity: "0.8.20",
  networks: {
    sepolia: { // 此处为sepolia网络，可以自行切换
      url: `https://eth-sepolia.g.alchemy.com/v2/${ALCHEMY_API_KEY}`,
      accounts: [GOERLI_PRIVATE_KEY]
    }
  }
};

```

- 部署合约代码

```hljs arduino
 npx hardhat run scripts/deploy.js --network sepolia

```

我之前做测试部署过，可以参看 [sepolia.etherscan.io/search?q=0x…](https://link.juejin.cn?target=https%3A%2F%2Fsepolia.etherscan.io%2Fsearch%3Fq%3D0x68FDFa2aa8E831f9f9ade3f12a78623ec8B3c785 "https://sepolia.etherscan.io/search?q=0x68FDFa2aa8E831f9f9ade3f12a78623ec8B3c785")

那么接下来就是dapp调用合约部分，咱们接着看。

### 前端调用合约

#### 准备工作

在调用钱包之前，咱们需要准备一个web3钱包，常见的以metamask钱包，ok钱包等。并需要提前充值一些ETH供测试使用。我此处使用的的sepolia网络，可取水龙头网站领取一些sepolia-eth供测试使用，如下图所示
![](https://p6-xtjj-sign.byteimg.com/tos-cn-i-73owjymdk6/63bf3a9001d746e4b112d63d99eb6538~tplv-73owjymdk6-jj-mark-v1:0:0:0:0:5o6Y6YeR5oqA5pyv56S-5Yy6IEAg5aWU6LeR55qE5qmh55qu5pOm:q75.awebp?rk3s=f64ab15b&x-expires=1737358476&x-signature=FGIL0POPYEDen5Lf3PBAxXETUdE%3D)

#### 连接钱包

在连接dapp进行交易之前，需要钱包进行授权（当然也可以拿私钥的方式进行交互，不过那种一般都是后端跑脚本这么干）。具体如下。

首先需要获取一个provider，用于连接钱包。

```hljs javascript
const connectWallet = async () => {
    if (typeof window.ethereum !== 'undefined') {
      try {
        // 创建 Ethers.js Provider 并连接到 MetaMask
        const provider = new ethers.BrowserProvider(window.ethereum);

        setProvider(provider);

        // 请求用户连接 MetaMask
        await provider.send("eth_requestAccounts", []);
        const signer = await provider.getSigner();
        setSigner(signer);

        const { address }  = signer;
        setAccount(address);

        // // 创建合约实例
        const contract = new ethers.Contract(contractAddress, contractABI, signer);
        setContract(contract);

        console.log('Contract connected');
      } catch (error) {
        console.error('User rejected the request:', error);
      }
    } else {
      alert('MetaMask is not installed. Please install MetaMask to use this DApp.');
    }
  };

```

**请注意 const contract = new ethers.Contract(contractAddress, contractABI, signer);** 如果只需要读取合约的数据，不涉及交易等功能，第三个参数使用provider即可，如何涉及到交易的话，请使用得到授权的signer。

#### 合约交易

此处，我以buyTokens方法为例，购买代币。实现如下：

```hljs javascript
  const mint = useCallback(async () =>{
    // const writeContract = new ethers.Contract(contractAddress, contractABI, signer);
    console.log('writeContract', contract.buyTokens);
    if (contract) {
      try {
          const tx = await contract.buyTokens({ value: ethers.parseEther(`${0.00001 * mintNum}`) });
          await tx.wait(); // 等待交易被打包
          console.log("Tokens purchased successfully!");
      } catch (error) {
          console.error('Error buying tokens:', error);
      }
  }
  }, [signer, mintNum])

```

这里我没进行gaslimit和gasprice等参数的设置，只是简单的演示如何跟合约方法进行交互。涉及到代币交易的方法，这时候会弹出授权窗口，确认支付。如下
![](https://p6-xtjj-sign.byteimg.com/tos-cn-i-73owjymdk6/5cf2e07816eb4f52b8d8353742de3619~tplv-73owjymdk6-jj-mark-v1:0:0:0:0:5o6Y6YeR5oqA5pyv56S-5Yy6IEAg5aWU6LeR55qE5qmh55qu5pOm:q75.awebp?rk3s=f64ab15b&x-expires=1737358476&x-signature=RfLP8QK4z530Z9rUDsG9DziF%2B%2BA%3D)

#### 监听交易完成

如何监听交易完成呢，这里前面讲到的事件（Event）就用到了，我在合约代码那里

```hljs scss
    function buyTokens() public payable {
        uint256 tokensToMint = (msg.value / MINT_COST) * 10**decimals();
        require(tokensToMint > 0, "Insufficient ETH to mint tokens");
        require(balanceOf(address(this)) >= tokensToMint, "Not enough tokens left");

        _transfer(address(this), msg.sender, tokensToMint);
        emit mintFinished('buyTokens');
    }

```

交易完成之后用到了mintFinished事件。我只需监听这个事件即可。

前端监听事件代码如下：

```hljs scss
useEffect(() => {
  if (contract) {
      const filter = contract.filters.mintFinished();
      contract.on(filter, (message) => {
          console.log('Event received:', message);
          getTokenBalance();
      });

      // 清理事件监听器
      return () => {
          contract.removeAllListeners(filter);
      };
  }
}, [contract]);

```

完成代码如下：

```hljs javascript
import './App.css';
import React, { useState, useEffect, useCallback } from 'react';
import { ethers } from 'ethers';
function App() {
  const [account, setAccount] = useState(null);
  const [contract, setContract] = useState(null);
  // const [writeContract, setWriteContract]= useState(null);
  const [provider, setProvider] = useState(null);
  const [signer, setSigner] = useState(null);
  const [ mintNum, setMintNum ] = useState(0);
  const [balance, setBalance] = useState(null);
  const contractAddress = "0xa2AFA59bC68758F6293915c1B1787299cdB6e7BA"; // 替换为你的合约地址
  const contractABI =[
    {
      "inputs": [],
      "stateMutability": "nonpayable",
      "type": "constructor"
    },
    {
      "inputs": [
        {
          "internalType": "address",
          "name": "spender",
          "type": "address"
        },
        {
          "internalType": "uint256",
          "name": "allowance",
          "type": "uint256"
        },
        {
          "internalType": "uint256",
          "name": "needed",
          "type": "uint256"
        }
      ],
      "name": "ERC20InsufficientAllowance",
      "type": "error"
    },
    {
      "inputs": [
        {
          "internalType": "address",
          "name": "sender",
          "type": "address"
        },
        {
          "internalType": "uint256",
          "name": "balance",
          "type": "uint256"
        },
        {
          "internalType": "uint256",
          "name": "needed",
          "type": "uint256"
        }
      ],
      "name": "ERC20InsufficientBalance",
      "type": "error"
    },
    {
      "inputs": [
        {
          "internalType": "address",
          "name": "approver",
          "type": "address"
        }
      ],
      "name": "ERC20InvalidApprover",
      "type": "error"
    },
    {
      "inputs": [
        {
          "internalType": "address",
          "name": "receiver",
          "type": "address"
        }
      ],
      "name": "ERC20InvalidReceiver",
      "type": "error"
    },
    {
      "inputs": [
        {
          "internalType": "address",
          "name": "sender",
          "type": "address"
        }
      ],
      "name": "ERC20InvalidSender",
      "type": "error"
    },
    {
      "inputs": [
        {
          "internalType": "address",
          "name": "spender",
          "type": "address"
        }
      ],
      "name": "ERC20InvalidSpender",
      "type": "error"
    },
    {
      "inputs": [
        {
          "internalType": "address",
          "name": "owner",
          "type": "address"
        }
      ],
      "name": "OwnableInvalidOwner",
      "type": "error"
    },
    {
      "inputs": [
        {
          "internalType": "address",
          "name": "account",
          "type": "address"
        }
      ],
      "name": "OwnableUnauthorizedAccount",
      "type": "error"
    },
    {
      "anonymous": false,
      "inputs": [
        {
          "indexed": true,
          "internalType": "address",
          "name": "owner",
          "type": "address"
        },
        {
          "indexed": true,
          "internalType": "address",
          "name": "spender",
          "type": "address"
        },
        {
          "indexed": false,
          "internalType": "uint256",
          "name": "value",
          "type": "uint256"
        }
      ],
      "name": "Approval",
      "type": "event"
    },
    {
      "anonymous": false,
      "inputs": [
        {
          "indexed": true,
          "internalType": "address",
          "name": "previousOwner",
          "type": "address"
        },
        {
          "indexed": true,
          "internalType": "address",
          "name": "newOwner",
          "type": "address"
        }
      ],
      "name": "OwnershipTransferred",
      "type": "event"
    },
    {
      "anonymous": false,
      "inputs": [
        {
          "indexed": true,
          "internalType": "address",
          "name": "from",
          "type": "address"
        },
        {
          "indexed": true,
          "internalType": "address",
          "name": "to",
          "type": "address"
        },
        {
          "indexed": false,
          "internalType": "uint256",
          "name": "value",
          "type": "uint256"
        }
      ],
      "name": "Transfer",
      "type": "event"
    },
    {
      "anonymous": false,
      "inputs": [
        {
          "indexed": false,
          "internalType": "string",
          "name": "mintType",
          "type": "string"
        }
      ],
      "name": "mintFinished",
      "type": "event"
    },
    {
      "inputs": [],
      "name": "MINT_COST",
      "outputs": [
        {
          "internalType": "uint256",
          "name": "",
          "type": "uint256"
        }
      ],
      "stateMutability": "view",
      "type": "function"
    },
    {
      "inputs": [],
      "name": "TOTAL_SUPPLY",
      "outputs": [
        {
          "internalType": "uint256",
          "name": "",
          "type": "uint256"
        }
      ],
      "stateMutability": "view",
      "type": "function"
    },
    {
      "inputs": [
        {
          "internalType": "uint256",
          "name": "amount",
          "type": "uint256"
        }
      ],
      "name": "addMint",
      "outputs": [],
      "stateMutability": "nonpayable",
      "type": "function"
    },
    {
      "inputs": [
        {
          "internalType": "address",
          "name": "owner",
          "type": "address"
        },
        {
          "internalType": "address",
          "name": "spender",
          "type": "address"
        }
      ],
      "name": "allowance",
      "outputs": [
        {
          "internalType": "uint256",
          "name": "",
          "type": "uint256"
        }
      ],
      "stateMutability": "view",
      "type": "function"
    },
    {
      "inputs": [
        {
          "internalType": "address",
          "name": "spender",
          "type": "address"
        },
        {
          "internalType": "uint256",
          "name": "value",
          "type": "uint256"
        }
      ],
      "name": "approve",
      "outputs": [
        {
          "internalType": "bool",
          "name": "",
          "type": "bool"
        }
      ],
      "stateMutability": "nonpayable",
      "type": "function"
    },
    {
      "inputs": [
        {
          "internalType": "address",
          "name": "account",
          "type": "address"
        }
      ],
      "name": "balanceOf",
      "outputs": [
        {
          "internalType": "uint256",
          "name": "",
          "type": "uint256"
        }
      ],
      "stateMutability": "view",
      "type": "function"
    },
    {
      "inputs": [],
      "name": "buyTokens",
      "outputs": [],
      "stateMutability": "payable",
      "type": "function"
    },
    {
      "inputs": [],
      "name": "decimals",
      "outputs": [
        {
          "internalType": "uint8",
          "name": "",
          "type": "uint8"
        }
      ],
      "stateMutability": "view",
      "type": "function"
    },
    {
      "inputs": [
        {
          "internalType": "uint256",
          "name": "amount",
          "type": "uint256"
        },
        {
          "internalType": "address",
          "name": "adrss",
          "type": "address"
        }
      ],
      "name": "depositTokens",
      "outputs": [],
      "stateMutability": "nonpayable",
      "type": "function"
    },
    {
      "inputs": [],
      "name": "name",
      "outputs": [
        {
          "internalType": "string",
          "name": "",
          "type": "string"
        }
      ],
      "stateMutability": "view",
      "type": "function"
    },
    {
      "inputs": [],
      "name": "owner",
      "outputs": [
        {
          "internalType": "address",
          "name": "",
          "type": "address"
        }
      ],
      "stateMutability": "view",
      "type": "function"
    },
    {
      "inputs": [],
      "name": "renounceOwnership",
      "outputs": [],
      "stateMutability": "nonpayable",
      "type": "function"
    },
    {
      "inputs": [],
      "name": "symbol",
      "outputs": [
        {
          "internalType": "string",
          "name": "",
          "type": "string"
        }
      ],
      "stateMutability": "view",
      "type": "function"
    },
    {
      "inputs": [],
      "name": "totalSupply",
      "outputs": [
        {
          "internalType": "uint256",
          "name": "",
          "type": "uint256"
        }
      ],
      "stateMutability": "view",
      "type": "function"
    },
    {
      "inputs": [
        {
          "internalType": "address",
          "name": "to",
          "type": "address"
        },
        {
          "internalType": "uint256",
          "name": "value",
          "type": "uint256"
        }
      ],
      "name": "transfer",
      "outputs": [
        {
          "internalType": "bool",
          "name": "",
          "type": "bool"
        }
      ],
      "stateMutability": "nonpayable",
      "type": "function"
    },
    {
      "inputs": [
        {
          "internalType": "address",
          "name": "from",
          "type": "address"
        },
        {
          "internalType": "address",
          "name": "to",
          "type": "address"
        },
        {
          "internalType": "uint256",
          "name": "value",
          "type": "uint256"
        }
      ],
      "name": "transferFrom",
      "outputs": [
        {
          "internalType": "bool",
          "name": "",
          "type": "bool"
        }
      ],
      "stateMutability": "nonpayable",
      "type": "function"
    },
    {
      "inputs": [
        {
          "internalType": "address",
          "name": "newOwner",
          "type": "address"
        }
      ],
      "name": "transferOwnership",
      "outputs": [],
      "stateMutability": "nonpayable",
      "type": "function"
    },
    {
      "inputs": [],
      "name": "withdrawETH",
      "outputs": [],
      "stateMutability": "nonpayable",
      "type": "function"
    }
  ]

  const connectWallet = async () => {
    if (typeof window.ethereum !== 'undefined') {
      try {
        // 创建 Ethers.js Provider 并连接到 MetaMask
        const provider = new ethers.BrowserProvider(window.ethereum);

        setProvider(provider);

        // 请求用户连接 MetaMask
        await provider.send("eth_requestAccounts", []);
        const signer = await provider.getSigner();
        setSigner(signer);

        const { address }  = signer;
        setAccount(address);

        // // 创建合约实例
        const contract = new ethers.Contract(contractAddress, contractABI, signer);
        setContract(contract);

        console.log('Contract connected');
      } catch (error) {
        console.error('User rejected the request:', error);
      }
    } else {
      alert('MetaMask is not installed. Please install MetaMask to use this DApp.');
    }
  };

  // 查询代币余额
  const getTokenBalance = async () => {
    if (contract && account) {
        try {
            const balance = await  contract.balanceOf(account);
            console.log('balance', balance);
            // 代币余额通常是以最小单位返回的，需要转换为可读格式
            setBalance(ethers.formatUnits(balance, 18));
        } catch (error) {
            console.error('Error fetching token balance:', error);
        }
    }
  };

  const mint = useCallback(async () =>{
    // const writeContract = new ethers.Contract(contractAddress, contractABI, signer);
    console.log('writeContract', contract.buyTokens);
    if (contract) {
      try {
          const tx = await contract.buyTokens({ value: ethers.parseEther(`${0.00001 * mintNum}`) });
          await tx.wait(); // 等待交易被打包
          console.log("Tokens purchased successfully!");
      } catch (error) {
          console.error('Error buying tokens:', error);
      }
  }
  }, [signer, mintNum])

  useEffect(() => {
    if (window.ethereum) {
        window.ethereum.on('accountsChanged', (accounts) => {
            setAccount(accounts[0]);
            console.log('Account changed:', accounts[0]);
        });

        window.ethereum.on('chainChanged', () => {
            window.location.reload();
        });
    }

    // 尝试连接 MetaMask 并获取账户信息
    connectWallet();
}, []);

useEffect(()=>{
  getTokenBalance()
}, [account, contract]);

useEffect(() => {
  if (contract) {
      const filter = contract.filters.mintFinished();
      contract.on(filter, (message) => {
          console.log('Event received:', message);
          getTokenBalance();
      });

      // 清理事件监听器
      return () => {
          contract.removeAllListeners(filter);
      };
  }
}, [contract]);

  return (
    <div className="App">
      <header className="App-header">
        {account? `钱包地址：${account}`: <button onClick={connectWallet}>连接钱包</button>}
        <div>DogKing代币数量:<span>{ balance }</span></div>
        <div>
          mint代币个数：
          <input value={mintNum} onChange={e => setMintNum(Number(e.target.value))}/>
          <button onClick={mint}>mint</button>
        </div>
      </header>
    </div>
  );
}

export default App;

```

至此，完成了合约代码开发，合约部署，dapp交互的整个流程。

## 结尾

前面我从比特币、以太坊原理、相关技术栈介绍、具体的代码实现等三个方面进行了简要的介绍，如果要能真正的去参与构建web3世界还远远不够，区块链世界的概念更新和技术迭代相比传统的互联网简直不要太快，需要学习的地方还有很多。例如以太坊的各种借贷协议，例如Dex uniswap是怎么实现、算法稳定币dai是怎实现。再例如以太坊二层网络具体是怎么实现、原理是什么，它有什么意义，有那些应用。还有之前大火的铭文概念，到底解决了什么问题，具体是如何实现的，都需要我们去学习和了解。后面我会根据自己接触到新的知识来更新web3开发系列，愿你我共同进步。
