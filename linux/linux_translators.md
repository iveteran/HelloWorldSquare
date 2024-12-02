# Linux translators on Console

Refer: https://worktile.com/kb/ask/360929.html

## Translate Shell
Translate Shell是一个功能全面的命令行工具，可以使用各种在线翻译服务进行翻译。它支持Google Translate、Microsoft Translator、Yandex.Translate等多个翻译服务。
Translate Shell在大多数Linux发行版的软件仓库中都有提供，可以使用包管理器来安装。例如，使用apt-get命令在Ubuntu上安装Translate Shell：

### Install
```shell
sudo apt-get install translate-shell
```
安装完成后，就可以在命令行中使用trans命令来进行翻译。例如，要将英文文本翻译成中文，可以使用以下命令：

### Usage
```shell
trans -p en:zh-CN "Hello, world!"
```

上述命令中，en:表示源语言为英文，:zh-CN表示目标语言为中文，”Hello, world!”是待翻译的文本。

Translate Shell还支持其他功能，例如将翻译结果输出到文件中、获取翻译的音频等。

## Dictd
Dictd是一个基于客户端-服务器架构的字典和翻译软件。它具有丰富的字典资源和强大的查询功能。
要使用Dictd，首先需要安装Dictd服务器和相应的字典资源。安装Dictd服务器可以使用包管理器来进行。例如，在Ubuntu上可以使用以下命令进行安装：

### Install
```sh
sudo apt-get install dictd dict-gcide
```
安装完成后，就可以使用dict命令在命令行中查询字典了。例如，要查询英文单词”hello”的翻译，可以使用以下命令：

### Usage
```sh
dict hello
```
上述命令会输出”hello”的各种解释和翻译。

除了Dictd服务器和字典资源，还可以安装Dict客户端来方便地使用Dictd。安装Dict客户端可以使用包管理器进行。例如，在Ubuntu上可以使用以下命令进行安装：

```sh
sudo apt-get install dict
```
安装完成后，可以使用dict命令直接在命令行中查询字典。
Dictd还支持其他功能，例如模糊查询、词形变化等。
