# PlainTextQuickLook
OS X 上的快速预览插件，支持文本文件预览，不限扩展名

## 安装

从[这里下载][Download]插件包，解压缩之后把`PlainTextQuickLook.qlgenerator`文件拷贝到`/Library/QuickLook`或者`~/Library/Quicklook`目录下。

注销系统重新登录或执行下面命令

```
/usr/bin/qlmanage -r
```

[Download]: https://github.com/pljhonglu/PlainTextQuickLook/releases "Download"

## 调试

调试依赖 qlmanager

1. 删除 `~/Library/Quicklook` 下的`PlainTextQuickLook.qlgenerator`文件
2. 执行 `cp /usr/bin/qlmanager PROJECT_PATH`，把 qlmanager 复制到工程目录下
3. Xcode 选择 `product -> scheme -> edit scheme`，选择 run 选项，info 下面的 executable 选择 other，找到刚刚的拷贝过来的 qlmanager，同时勾选 `debug executable`
4. 选择 argument ，在 `arguments passed on launch` 中添加 `-p text.md`

接下来就可以像平时开发一样做断点调试了

参考:

[Debugging Quicklook Plugin in Xcode 4.6](http://stackoverflow.com/questions/16811547/debugging-quicklook-plugin-in-xcode-4-6)  
[Debugging and Testing a Generator](https://developer.apple.com/library/mac/documentation/UserExperience/Conceptual/Quicklook_Programming_Guide/Articles/QLDebugTest.html)
