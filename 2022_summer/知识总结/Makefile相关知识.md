# Makefile文件语法及相关知识



## 程序的编译和链接

UNIX环境下需要依赖Makefile文件对程序源代码的自动化编译工作作出

充分地描述。

一般编译一个工程分为两步走：

* **编译**：将源代码文件编译成 中间代码文件（.o），这一步只要求源码文件中的语法正确，函数与变量的声明正确即可，一般每个源码文件会编译出一个对应的O文件。由于大型项目编译生成的O文件数量众多，所以一般会采取将多个O文件链接在一起生成一个Archive文件（.a）。
* **链接**：将一套O文件连接成可执行文件，在链接过程中会去寻找函数及变量声明的对应实现，如果找不到就会链接失败。



## Makefile简介

* 何时编译？：

  * 1.如果这个工程没有编译过，那么我们的所有C文件都要编译并被链接。
  * 2.如果这个工程的某几个C文件被修改，那么我们只编译被修改的C文件，并链接目标程序。
  * 3.如果这个工程的头文件被改变了，那么我们需要编译引用了这几个头文件的C文件，并链接目标程序。

* 规则：

  <img src="E:\github_repository\Rust_TEE-OS\2022_summer\知识总结\pic\Snipaste_2022-08-01_13-30-22.png" style="zoom:50%;" />

  规则：图中这三个部分组成的完整个体叫一个规则

  * target（想要生成的目标，可以是伪目标）
  * prerequisites（想要达到目标需要的前提条件，比如需要哪些文件）
  * command（满足前提条件后，想要达到目标所有执行的命令，包括shell命令及各种编译语句等等

  规则的处理方式是在进行一次编译时如果发现某个prerequisites的产生时间比target要晚（prerequisite更新了，target还没有），就会执行一遍command，否则不会。

* 工作过程：

  <img src="E:\github_repository\Rust_TEE-OS\2022_summer\知识总结\pic\Snipaste_2022-08-01_16-41-29.png" style="zoom:50%;" />

  * 在某个目录录下使用make命令，make将自动寻找该目录下名字是"Makefile"的文件。
  * 以该文件中定义的第一个target作为根目标，递归地去一步一步满足prerequisite，以最终产出根target。
  * make不会管某些命令执行的不成功，报错之类的问题。它只会看是不是由prerequisite的文件，没有就去找怎么生成它，假如执行对应command之后还是没有找到prerequisite文件，就报错退出。
  * Makefile中的变量何时被替换进来：真正执行command的时候。



## Makefile语法

Makefile文件的五个基本组成部分：**显式规则、隐晦规则、变量定义、文件指示和注释**

### 最终目标

一个Makefile文件会存在一个最终目标，当单单执行make命令时，就会以生成这个最终目标为首要目的。最终目标默认是所有规则中的第一条规则，而假如第一条规则里有多个target，那就是第一个target。

### 规则的两种写法

<img src="E:\github_repository\Rust_TEE-OS\2022_summer\知识总结\pic\Snipaste_2022-08-01_17-09-32.png" style="zoom:50%;" />

### 通配符

三种通配符："*", "?", "[...]"。在变量中展开通配符："objects := $(wildcard *.o)"

![](E:\github_repository\Rust_TEE-OS\2022_summer\知识总结\pic\Snipaste_2022-08-01_17-15-21.png)

### 文件搜寻

规则的prerequisite中声明的文件会去以下定义的三个地方寻找：

* Makefile所在本目录下

* "VPATH"变量定义的路径下：

  如`VPATH = src:../header`，路径之间由":"分隔。

* "vpath"语句定义的路径下：

  ![](E:\github_repository\Rust_TEE-OS\2022_summer\知识总结\pic\Snipaste_2022-08-01_17-26-18.png)

  * \<pattern>中要有通配符"%"来表示文件名中若干个字符：

    `vpath %.h ../headers`

  * 如果有重复的pattern，按顺序来。

### 引用其他Makefile文件

* 基本语法：include \<filename>

* make会去哪里寻找这些文件呢？
  * 本目录下
  * 执行make时带有 "-I" 或 "--include-dir" 参数
  * /include目录（"/usr/local/bin" 或 "/usr/include"）\
* 没找到文件会怎么样：先找其他的，所有的都找完一遍之后回来再找一下没找到的，如果还是没找到就报错停止。假如想不让make报错停止，可以使用 "-include \<filename>"。
* 环境变量里也有"MAKEFILE"这个变量，make会把里面的文件include进来，而里面的目标并不会起作用，建议不用。

### 伪目标

* 用".PHONY"语句声明该目标是一个伪目标，避免与其他文件重名。
* 伪目标一定会执行
* 伪目标可以依赖别的目标，也可以成为别的目标的依赖

## 静态模式

* Makefile支持多目标（一条规则里可以有多个目标），但所有目标执行的命令都是同一条。静态模式可以帮助我们更灵活地书写多目标规则。

* 语法：<img src="E:\github_repository\Rust_TEE-OS\2022_summer\知识总结\pic\Snipaste_2022-08-01_17-56-42.png" style="zoom:50%;" />

  * \<targets>: 一系列目标文件，一个集合。
  * \<target-pattern>: 目标模式，过滤出前面目标集合中符合模式的目标，形成一个新的集合。
  * \<prereq-pattern>: 依赖模式，对目标模式中的文件名进行重组作为依赖（文件名不变，后缀换掉1）

  举个例子：

  <img src="E:\github_repository\Rust_TEE-OS\2022_summer\知识总结\pic\Snipaste_2022-08-01_18-01-47.png" style="zoom: 50%;" />

  

