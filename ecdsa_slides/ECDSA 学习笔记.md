# ECDSA	学习笔记

孙永康	11911409

## 理论部分

椭圆曲线数字签名算法（ECDSA）是使用椭圆曲线密码（ECC）对数字签名算法（DSA）的模拟。

* ECC : 基于椭圆曲线数学理论实现的一种非对称加密算法。 相比RSA，ECC优势是可以使用更短的密钥，来实现与RSA相当或更高的安全。 160位ECC加密安全性相当于1024位RSA加密，210位ECC加密安全性相当于2048位RSA加密（有待考证）。[椭圆曲线加密算法（ECC） - 知乎 (zhihu.com)](https://zhuanlan.zhihu.com/p/101907402)

  （后续会对其有更详细的介绍）

* DSA : 数字签名算法，Schnorr和ElGamal签名算法的变形， 该算法的安全性依赖于计算模数的离散对数的难度。[DSA-数据签名算法（理论）_aaqian1的博客-CSDN博客_dsa算法](https://blog.csdn.net/aaqian1/article/details/89299520)



### 详细介绍ECDSA ：

* #### What is `ECDSA` ?

  `ECDSA`是一个签名算法，用于发布者Alice对自己的文件进行签名，与现实生活中的签名十分类似。接收者Bob有能力验证接收文件上的签名是否是发布者Alice亲手签的，但是它也能保证恶意的接收者Bob不存在伪造Alice签名的能力。

  `ECDSA`不会对数据进行加密、或阻止别人看到或访问你的数据，它可以防止的是确保数据没有被篡改。

  

* #### Basic Understanding

  选一条椭圆曲线，选一个原点，选一个随机数作为你的`私钥(Private key)`， 用原点和私钥计算出一个`公钥(Public key)`。

  一个数字签名包含两个数字，`R`和`S`：使用一个私钥和原文哈希值带入一个数学方程来产生`R`和`S`，如果将公钥和`S`代入另一个数学方程给出`R`的话，这个签名就是有效的。仅仅知道公钥是无法知道私钥或者创建出数字签名。

  

* #### The Hash

  `ECDSA`与消息的`SHA-1加密哈希`一起使用来对文件进行签名。哈希是你作用于数据的每一个字节然后给你一个代替该数据的整数的一个数学函数。SHA1算法将给出一个非常巨大的数（160位或者比特，如果用十进制表示的话将由49个数字组成），并且随着文件的一点细微的小变化，它也能够产生显著的变化。这个不可预测的特性让SHA1算法成为一个非常好的哈希算法，非常安全且产生“碰撞(collision)”（两个不同文件有相同的哈希）的可能性非常低，使得通过伪造数据获得特定的哈希的变得不可能。

  

* ####  Something About `ECC`

  * ##### 有限空间中的椭圆曲线：

    ![](C:\Users\jerichosun\Desktop\Snipaste_2021-11-21_02-21-28.png)

    取模运算的底![[公式]](https://www.zhihu.com/equation?tex=p)是一个素数且确保所有得到的数值在160比特所能够表示的范围之内，允许采用模平方根和模的乘法逆元来简化运算。

    `ECDSA`方程给出了一条曲线，这条曲线上面一共有![[公式]](https://www.zhihu.com/equation?tex=N)个有效的点，因为![[公式]](https://www.zhihu.com/equation?tex=Y)轴的取值区间由模底![[公式]](https://www.zhihu.com/equation?tex=p)来确定，并且需要满足完美平方（![[公式]](https://www.zhihu.com/equation?tex=Y%5E2)）并关于![[公式]](https://www.zhihu.com/equation?tex=X)轴对称。我们一共有![[公式]](https://www.zhihu.com/equation?tex=N%2F2)个有效的![[公式]](https://www.zhihu.com/equation?tex=x)坐标。

  * ##### 椭圆曲线上的加法与数乘：

    ###### 加法：

    ![](C:\Users\jerichosun\Desktop\Snipaste_2021-11-21_02-28-07.png)

    ###### 数乘：

    ![](C:\Users\jerichosun\Desktop\Snipaste_2021-11-21_02-29-25.png)

    ![](C:\Users\jerichosun\Desktop\Snipaste_2021-11-21_02-29-55.png)

  * ##### 单向陷门函数：

    一个椭圆曲线乘法的特性是你有一个点![[公式]](https://www.zhihu.com/equation?tex=R%3Dk%5Ctimes+P)，你知道![[公式]](https://www.zhihu.com/equation?tex=R)和 ![[公式]](https://www.zhihu.com/equation?tex=P)，但是你无法据此求出![[公式]](https://www.zhihu.com/equation?tex=k)，因为这里并没有椭圆曲线减法或者椭圆曲线除法可用，你并不能通过![[公式]](https://www.zhihu.com/equation?tex=k%3DR%2FP)得到![[公式]](https://www.zhihu.com/equation?tex=k)。并且，因为你可以做成千上万次的加法，最终你只是知道在曲线上面结束的点，但是具体是如何到达这个点你也并不知道。你无法进行反向操作，得到与点![[公式]](https://www.zhihu.com/equation?tex=P)相乘以后给你点![[公式]](https://www.zhihu.com/equation?tex=R)的 ![[公式]](https://www.zhihu.com/equation?tex=k)。

    

* #### The Beginning of `ECDSA` Algorithm

  * ##### A Curve:

    ![](C:\Users\jerichosun\Desktop\Snipaste_2021-11-21_02-21-28.png)

    一条曲线及其相关参数：![[公式]](https://www.zhihu.com/equation?tex=a%2Cb%2Cp%2CN%2CG)（基点，参考点）

    一些相关机构**[NIST(National Institute of Standards and Technology)](https://link.zhihu.com/?target=https%3A//www.nist.gov/)**和**[SECG(Standards for Efficient Cryptography Group)](https://link.zhihu.com/?target=http%3A//www.secg.org/)**已经提供了预处理的已知高效和安全的标准化曲线参数。

    

  * ##### 公钥和私钥：

    首先，你有一对密钥：公钥和私钥，私钥是一个随机数，也是160比特大小，公钥是将曲线上的点![[公式]](https://www.zhihu.com/equation?tex=G)与私钥相乘以后的曲线上的点。令![[公式]](https://www.zhihu.com/equation?tex=dA)表示私钥，一个随机数，![[公式]](https://www.zhihu.com/equation?tex=Qa)表示公钥，曲线上面的一个点，我们有![[公式]](https://www.zhihu.com/equation?tex=Qa+%3D+dA+%5Ctimes+G)，其中![[公式]](https://www.zhihu.com/equation?tex=G)是曲线上面的参考点。

    

  * ##### Creating a Signature

    什么是一个signature：签名本身是40字节，由各20字节的两个值来进行表示，第一个值叫作![[公式]](https://www.zhihu.com/equation?tex=R)，第二个叫作![[公式]](https://www.zhihu.com/equation?tex=S)。值对![[公式]](https://www.zhihu.com/equation?tex=%28R%2CS%29)放到一起就是你的`ECDSA`签名。

    生成过程：

    - 产生一个随机数![[公式]](https://www.zhihu.com/equation?tex=k)，20字节
    - 利用点乘法计算![[公式]](https://www.zhihu.com/equation?tex=P%3Dk+%5Ctimes+G)
    - 点![[公式]](https://www.zhihu.com/equation?tex=P)的 ![[公式]](https://www.zhihu.com/equation?tex=x)坐标即为![[公式]](https://www.zhihu.com/equation?tex=R)
    - 利用SHA1计算信息的哈希，得到一个20字节的巨大的整数![[公式]](https://www.zhihu.com/equation?tex=z)
    - 利用方程![[公式]](https://www.zhihu.com/equation?tex=S%3Dk%5E%7B-1%7D%28z+%2B+dA+%5Ctimes+R%29+%5Cmod+p)计算![[公式]](https://www.zhihu.com/equation?tex=S)

  

  * ##### **Verifying the Signature**

    将公钥和签名还有hash值代入下式中即可完成验证。

    ![](C:\Users\jerichosun\Desktop\Snipaste_2021-11-21_02-38-23.png)

    ###### 数学推导：

    首先，我们有：

    ![[公式]](https://www.zhihu.com/equation?tex=P%3DS%5E%7B-1%7D%5Ctimes+z+%5Ctimes+G+%2B+S%5E%7B-1%7D+%5Ctimes+R+%5Ctimes+Qa+%5C%5C)

    由于![[公式]](https://www.zhihu.com/equation?tex=Qa%3DdA%5Ctimes+G)，代入上式，则有：

    ![[公式]](https://www.zhihu.com/equation?tex=P%3DS%5E%7B-1%7D%5Ctimes+z+%5Ctimes+G+%2B+S%5E%7B-1%7D+%5Ctimes+R+%5Ctimes+dA+%5Ctimes+G%3DS%5E%7B-1%7D%28z%2BdA%5Ctimes+R%29%5Ctimes+G+%5C%5C)

    再由点![[公式]](https://www.zhihu.com/equation?tex=P)的 ![[公式]](https://www.zhihu.com/equation?tex=x)坐标必须与![[公式]](https://www.zhihu.com/equation?tex=R)匹配，且![[公式]](https://www.zhihu.com/equation?tex=R)是点![[公式]](https://www.zhihu.com/equation?tex=k%5Ctimes+P)的 ![[公式]](https://www.zhihu.com/equation?tex=x)坐标，即 ![[公式]](https://www.zhihu.com/equation?tex=P%3Dk%5Ctimes+G)，于是有：

    ![[公式]](https://www.zhihu.com/equation?tex=k%5Ctimes+G%3DS%5E%7B-1%7D%28z%2BdA%5Ctimes+R%29%5Ctimes+G+%5C%5C)

    两边将![[公式]](https://www.zhihu.com/equation?tex=G)拿掉，有：

    ![[公式]](https://www.zhihu.com/equation?tex=k%3DS%5E%7B-1%7D%28z%2BdA%5Ctimes+R%29+%5C%5C)

    两边求逆，即：

    ![[公式]](https://www.zhihu.com/equation?tex=S%3Dk%5E%7B-1%7D%28z+%2B+dA+%5Ctimes+R%29+%5C%5C)

* #### **The Security of ECDSA**

  需要同时知道随机数![[公式]](https://www.zhihu.com/equation?tex=k)和私钥![[公式]](https://www.zhihu.com/equation?tex=dA)才能够计算出![[公式]](https://www.zhihu.com/equation?tex=S)，但是需要![[公式]](https://www.zhihu.com/equation?tex=R)和公钥![[公式]](https://www.zhihu.com/equation?tex=Qa)来对签名进行确认和验证。并且由于![[公式]](https://www.zhihu.com/equation?tex=R%3Dk%5Ctimes+G)以及![[公式]](https://www.zhihu.com/equation?tex=Qa+%3D+dA%5Ctimes+G)再加上`ECDSA`点乘法当中的单向陷门函数的特性，我们无法通过![[公式]](https://www.zhihu.com/equation?tex=Qa)和 ![[公式]](https://www.zhihu.com/equation?tex=R)来计算![[公式]](https://www.zhihu.com/equation?tex=dA)或 ![[公式]](https://www.zhihu.com/equation?tex=k)，这使得`ECDSA`算法非常安全，没有办法找到私钥，也无法在不知道私钥的情况下伪造签名。

  

  但是 随机数`k`的随机性是尤其重要的， 假如一直使用一个确定的数据`k`，我们可以很轻易地破解到`ECDSA`的私钥。

  由于两次加密使用同一随机数k， 可得：

  ![[公式]](https://www.zhihu.com/equation?tex=S+%E2%80%93+S%E2%80%99+%3D+k%5E%7B-1%7D+%28z+%2B+dA%5Ctimes+R%29+%E2%80%93+k%5E%7B-1%7D+%28z%E2%80%99+%2B+dA%5Ctimes+R%29+%3D+k%5E%7B-1%7D+%28z+%2B+dA%5Ctimes+R+%E2%80%93+z%E2%80%99+-dA%5Ctimes+R%29+%3D+k%5E%7B-1%7D+%28z+%E2%80%93+z%E2%80%99%29+%5C%5C)

  于是有：

  ![[公式]](https://www.zhihu.com/equation?tex=k+%3D+%5Cfrac%7Bz-z%27%7D%7BS-S%27%7D+%5C%5C)

  有了随机数k被破解，可以轻松计算出私钥![[公式]](https://www.zhihu.com/equation?tex=dA)：

  ![[公式]](https://www.zhihu.com/equation?tex=dA%3D%EF%BC%88S%5Ctimes+k%E2%80%93z%EF%BC%89%2FR+%5C%5C)

reference : 

* [Understanding how ECDSA protects your data](https://link.zhihu.com/?target=https%3A//www.instructables.com/id/Understanding-how-ECDSA-protects-your-data/)
* 上文的中文翻译版：[一文读懂ECDSA算法如何保护数据](https://zhuanlan.zhihu.com/p/97953640)
* 一个很好的可以跟着学习并python实现的ECDSA教程：[Lecture14.pdf (purdue.edu)](https://engineering.purdue.edu/kak/compsec/NewLectures/Lecture14.pdf)



## 代码部分

### 签名：

<img src="C:\Users\jerichosun\Desktop\Snipaste_2021-11-21_11-37-27.png" style="zoom: 150%;" />

### 验证：

![](C:\Users\jerichosun\Desktop\Snipaste_2021-11-21_11-36-37.png)