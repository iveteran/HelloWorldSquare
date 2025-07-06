# Git Server基本配置

## 创建 Git 用户
为了安全起见，我们通常会为 Git 操作创建一个专用的用户。这个账户只做 Git 私服的操作
```
sudo adduser git
sudo passwd git
```
切换到刚刚创建的 git 用户：
```
su - git
```

## 初始化仓库
mkdir -p /home/git/repos/myrepo.git
cd /home/git/repos/myrepo.git
git init --bare

## 配置 SSH 访问
为了方便和安全地访问 Git 服务器，我们需要配置 SSH 访问
1. 收集公钥
收集所有需要登录的用户的公钥（即他们自己的 id_rsa.pub 文件），并将所有公钥导入到 /home/git/.ssh/authorized_keys 文件中，一行一个。
2. 设置权限
```
chmod 700 /home/git/.ssh/
chmod 600 /home/git/.ssh/authorized_keys
```
3. 禁用 Shell 登录
出于安全考虑，禁用 git 用户的 shell 登录：
sudo vim /etc/passwd
找到类似下面的一行：
git:x:1001:1001:,,,:/home/git:/bin/bash
改为：
git:x:1001:1001:,,,:/home/git:/usr/bin/git-shell
4. ssh服务端口配置(可选)
Git 的配置文件(~/.gitconfig)
[core]
  sshCommand = "ssh -p <custom_port>"
5. 测试
ssh [-p <custom_port>] git@yourserver

## 克隆或关联远程仓库
1. 克隆远程仓库
```
git clone git@yourserver:/home/git/repos/myrepo.git
```
2. 关联远程仓库
```
git remote add origin git@yourserver:/home/git/repos/myrepo
```

## Q&A
If nobody is working in that remote non-bare repo, then it should be possible to push to a checked out branch.
But to be more secure in that operation, you now can (with Git 2.3.0, February 2015), do in that remote repo:
(在远程仓库目录中执行，远程仓库应该是空的否则可能破坏已有的数据:)
```
git config receive.denyCurrentBranch updateInstead
```
It is more secure than config receive.denyCurrentBranch=ignore: it will allow the push only if you are not overriding modification in progress.
