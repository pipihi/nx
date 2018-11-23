
官网 http://www.cycript.org/

macOS上cycript运行错误
```
BeautyjhudeiMac:nx jishubu-001$ cycript
dyld: Library not loaded: /System/Library/Frameworks/Ruby.framework/Versions/2.0/usr/lib/libruby.2.0.0.dylib
  Referenced from: /Users/jishubu-001/Desktop/nx/./cycript/Cycript.lib/cycript-apl
  Reason: image not found
Abort trap: 6
```
解决方法（参考https://www.cnblogs.com/WinJayQ/p/8886978.html）
```
$ cd /System/Library/Frameworks/Ruby.framework/Versions/
$ sudo ln -s 2.3 2.0
$ cd /System/Library/Frameworks/Ruby.framework/Versions/2.0/usr/lib
$ sudo ln -s libruby.2.3.0.dylib libruby.2.0.0.dylib
```

注入进程失败
```
_assert($mach_task_self != NULL)
*** _assert(status == 0):../Inject.cpp(143):InjectLibrary
```
解决办法

关闭System Integrity Protection (SIP)或者退回10.12，参考http://bbs.iosre.com/t/cycript-osx10-13/10953
