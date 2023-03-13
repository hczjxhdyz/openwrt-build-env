# 支持Apple silicon的Mac在Docker下编译openwrt固件的Docker镜像

## 用法

### 拉取/创建镜像

- 拉取镜像.
  
  ```shell
  docker pull hczjxhdyz/openwrt-build-env
  ```

- build镜像.
  
  ```shell
  docker build -t hczjxhdyz/openwrt-build-env github.com/hczjxhdyz/openwrt-build-env
  ```

### 运行容器

```shell
docker run \
    -itd \
    --name openwrt-build-env \
    -h openwrt-build-env \
    -p 8080:8080 \
    -v lede-project:/home/openwrt/openwrt \
    hczjxhdyz/openwrt-build-env
```
>这个命令回创建一个名为lede-projec的volume并挂载到/home/openwrt/lede目录

>注意不要用v挂载本机目录到docker镜像里面，我尝试挂载本机镜像没有编译成功过

>其实直接运行容器他就会从dockerhub上拉取镜像，不需要手动拉取

### 进入容器
```shell
docker exec -it openwrt-build-env bash
```
>这个命令会默认以用户openwrt的身份进入到/home/openwrt目录
### 拉取openwrt代码并编译

```shell
git clone https://github.com/openwrt/openwrt ./lede
cd openwrt
./scripts/feeds update -a
./scripts/feeds install -a
make menuconfig
make download -j8
make -j8
```
>这个-j8 可以改为你的你的处理器的线程数，M1是8核心，下载好编译需要的文件之后之后首次编译的时常为40+分钟

### 获取编译结果
#### 1、使用python3 创建http服务器共享编译结果目录
``` shell
cd /home/openwrt/lede/bin
python3 -m http.server 8080
```
#### 1、用docker cp复制编译结果目录
``` shell
cd ~/Downloads
docker cp openwrt-build-env:/home/openwrt/lede/bin  ./bin
```

## 常见问题
### 1、编译出现go-bootstrap错误
进入make menuconfig   
进入在Languages->Go->Configuration->External bootstrap Go root directory菜单
写入go命令地址 `/usr/bin/go` 即可

```shell
make menuconfig 
```
