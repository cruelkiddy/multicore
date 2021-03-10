#### 3.4 21:52
libpng12-0:i386 安装失败，正在下载modelsim安装器...先下班了今天

#### 3.4 10:50
又开始搞了

#### 3.5 1:09

[主要参考这个解决bug](https://gist.github.com/PrieureDeSion/e2c0945cc78006b00d4206846bdb7657)
[需要这样一下](https://askubuntu.com/questions/496549/error-you-must-put-some-source-uris-in-your-sources-list)


#### 3.5 1:24
都弄好了，又回到了最初的起点。还是没办法仿真 不过可以正常编译了
/bin/sh: 1: hdldep: not found
还是这样

#### 3.5 11:35
没有make wav的rule是因为没有\%.tb 看看编译的步骤到底编译出了什么

#### 3.5 12:31
Makefile order prerequisite'

vlog编译之后会在work文件夹出现些东西，再vsim就能在work中看到design了



#### 3.10 18：00

program 无法在starter edition运行，在linux上安装modelsim10.2c se

