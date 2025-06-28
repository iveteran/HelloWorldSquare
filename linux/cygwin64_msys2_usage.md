# MinGW, Cygwin和Msys

refers:
 https://www.zhihu.com/question/22137175/answer/90908473

## MinGW (Minimalist GNU for Windows)
1. Summary
- https://www.mingw-w64.org/
- MinGW 是用于进行 Windows 应用开发的 GNU 工具链（开发环境），它的编译产物一般是原生 Windows 应用
- 它主要提供了针对 win32 应用的 GCC、GNU binutils 等工具，以及对等于 Windows SDK（的子集）的头文件和用于 MinGW 版本 linker 的库文件（.a, .so等，而不是Windows的lib, dll)。

## Cygwin
1. Summary
- https://cygwin.com/
- Cygwin是运行于Windows平台的POSIX"子系统"
- Cygwin 提供了一套抽象层 dll，用于将部分 Posix 调用转换成 Windows 的 API 调用，最基本的模拟层就是那个 cygwin1.dll

2. Package Manager
- Cygwin Setup (cygwin-setup-x86_64.exe, On Windows)
- apt-cyg

3. Access Windows drivers
ls /cygdrive/c
ls /cygdrive/d
...

## MSYS2 (Minimal SYStem 2)
1. Summary
- https://www.msys2.org/
- MSYS2基于MinGW-w64平台
- MSYS 是用于辅助 Windows 版 MinGW 进行命令行开发的配套软件包，
- 自带包管理(pacman)
- MSYS2 is a collection of tools and libraries providing you with an easy-to-use environment for building, installing and running native Windows software.
- The main focus of MSYS2 is to provide a build environment for native Windows software and the Cygwin-using parts are kept at a minimum.

2. Bash Settings:
export PATH=$PATH:/mingw64/bin
export PATH=$PATH:"/c/Program Files/dotnet"  # Optional

3. Package Manager: pacman
pacman -Syu             # Update Repo
pacman -Ss <Package>    # Search
pacman -S <Package>     # Install
pacman -R <Package>     # Remove
pacman -Sc              # Clear cache
e.g.:
pacman -S msys/vim msys/python msys/python-pip

4. Access Windows drivers
ls /c
ls /d
...

## 总结
程序经MinGW 编译后可以直接在Windows 上面运行。
程序经Cygwin 编译后运行，需要依赖安装时附带的cygwin1.dll。
Cygwin则是全面模拟了Linux的接口，提供给运行在它上面的的程序使用，并提供了大量现成的软件，更像是一个平台。
MSYS是相当于精简版的Cygwin
