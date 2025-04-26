# 从零开始配置 Neovim(Nvim)
Refer: https://martinlwx.github.io/zh-cn/config-neovim-from-scratch/

## 配置文件路径

Nvim 的配置目录在 ~/.config/nvim 下。在 Linux/Mac 系统上，Nvim 会默认读取 ~/.config/nvim/init.lua 文件，理论上来说可以将所有配置的东西都放在这个文件里面，但这样不是一个好的做法，因此我划分不同的文件和目录来分管不同的配置

首先看下按照本篇教程配置 Nvim 之后，目录结构看起来会是怎么样⬇️
.
├── init.lua
└── lua
    ├── colorscheme.lua
    ├── keymaps.lua
    ├── lsp.lua
    ├── options.lua
    └── plugins.lua

解释如下
    init.lua 为 Nvim 配置的 Entry point，我们主要用来导入其他 *.lua 文件
        colorscheme.lua 配置主题
        keymaps.lua 配置按键映射
        lsp.lua 配置 LSP
        options.lua 配置选项
        plugins.lua 配置插件
    lua 目录。当我们在 Lua 里面调用 require 加载模块（文件）的时候，它会自动在 lua 文件夹里面进行搜索
        将路径分隔符从 / 替换为 .，然后去掉 .lua 后缀就得到了 require 的参数格式


## 选项配置

主要用到的就是 vim.g、vim.opt、vim.cmd 等，我制造了一个快速参照对比的表格
In Vim 	            In Nvim 	                Note
----------------------------------------------------
let g:foo = bar 	vim.g.foo = bar 	
set foo = bar 	    vim.opt.foo = bar 	        set foo = vim.opt.foo = true
some_vimscript 	    vim.cmd(some_vimscript) 	

## 按键配置
在 Nvim 里面进行按键绑定的语法如下，具体的解释可以看 :h vim.keymap.set
vim.keymap.set(<mode>, <key>, <action>, <opts>)
