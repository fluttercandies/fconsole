# fconsole

一个用于调试的面板组件，类似微信小程序的v-console：在页面上创建一个可拖拽的悬浮窗，点击悬浮窗可启用log列表面板。


## 开发中

此组件仍在开发中，无法提供稳定的使用体验

## 使用

你需要将`ConsoleWidget`嵌套在`MaterialApp`外

```dart
ConsoleWidget(
  child: MaterialApp(
    home: Scaffold(),
  ),
)
```
然后才可以使用下列方法：

### 启动悬浮窗

只需要调用顶层方法就可以打开悬浮窗

```dart
// 启动悬浮窗
showConsole();
// 隐藏悬浮窗
hideConsole();
```

### 拦截原生print函数和未捕获的异常

`fconsole`可以拦截原先的`print`函数，包括其他库中的`print`语句和未捕获的`throw`同样可以被拦截。

拦截后，`print`将等效于`FConsole.log`，未捕获的错误将等效于`FConsole.error`。

要使用此功能，请将`runApp`替换为`runFConsoleApp`:

```dart
void main() => runFConsoleApp(MyApp());
```

然后，原生`print`和`throw`将被拦截:

```dart
// 具体代码见example
SettingRow(
  icon: Icons.warning,
  text: '原生Print',
  right: Container(),
  onTap: () {
    print('${DateTime.now().toIso8601String()}');
  },
),
SettingRow(
  icon: Icons.warning,
  text: '原生Throw',
  right: Container(),
  onTap: () {
    throw '${DateTime.now().toIso8601String()}';
  },
),
```


### 添加log
使用FConsole添加log非常简单：

```dart
// 添加log
FConsole.log("打印了一行log");
FConsole.log("打印了一行log");
FConsole.log("打印了一行log");
// 添加error
FConsole.error("打印了一行error");
FConsole.error("打印了一行error");
FConsole.error("打印了一行error");
FConsole.error("打印了一行error");
```

然后就可以在FConsole内查看log记录。

### 创建FlowLog(未完成)

可以使用`FlowLog`的形式记录Log:

```dart
FlowLog.of('分享启动').log('用户进入页面 $id');
FlowLog.of('分享启动').log('获取到分享值1 $shareId');
FlowLog.of('分享启动').log('查询分享信息1 成功');
FlowLog.of('分享启动').log('获取到分享值2 $shareId');
FlowLog.of('分享启动').log('查询分享信息2 成功');
FlowLog.of('分享启动').log('获取到分享值3 $shareId');
FlowLog.of('分享启动').log('查询分享信息3 成功');
FlowLog.of('分享启动').log('获取到分享值4 $shareId');
FlowLog.of('分享启动').error('查询分享信息4错误: $map');
FlowLog.of('分享启动').end();
```

也可以使用变量来记录

```dart
var logger = FlowLog.of('分享启动');
logger.log('用户进入页面 $id');
logger.log('获取到分享值 $shareId');
logger.error('查询分享信息错误: $map');
logger.end();
```
FlowLog可以记录用户的一系列行为，在用户出现问题时，通过Console信息即可快速定位问题。

FlowLog的优势在于，在同一页面上的操作可以分开记录，不会互相干扰，例如同时处理两张图片，一张成功而另一张失败，会按id形成两个不同的FlowLog。

