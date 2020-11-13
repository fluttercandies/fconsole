part of 'console.dart';

Widget _consoleBtn() {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
    decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        color: ColorPlate.blue,
        shadows: [
          BoxShadow(
            color: ColorPlate.gray.withOpacity(0.5),
            blurRadius: 4,
            offset: Offset(0, 2),
          )
        ]),
    child: StText.normal(
      'FConsole',
      style: TextStyle(color: ColorPlate.white),
    ),
  );
}

class ConsoleContainer extends StatefulWidget {
  final Widget consoleBtn;
  final Alignment consolePosition;

  const ConsoleContainer({Key key, this.consoleBtn, this.consolePosition})
      : super(key: key);

  @override
  _ConsoleContainerState createState() => _ConsoleContainerState();
}

class _ConsoleContainerState extends State<ConsoleContainer> {
  GlobalKey _childGK = GlobalKey();
  double xPosition = 0;
  double yPosition = 0;
  double childWidth = 0;
  double childHeight = 0;

  bool isCalculateSize = true;
  bool isShowConsoleBtn = true;

  ///是否要计算大小

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((d) {
      Size childSize = _childGK.currentContext.size;
      setState(() {
        childWidth = childSize.width;
        childHeight = childSize.height;
        calculatePosition();
        isCalculateSize = false;
      });
    });
  }

  void calculatePosition() {
    double width = MediaQueryData.fromWindow(window).size.width;
    double height =
        MediaQueryData.fromWindow(window).removePadding().size.height;

    Alignment position = widget.consolePosition;
    xPosition = position.x * width / 2 + width / 2;
    yPosition = position.y * height / 2 + height / 2;
    if (xPosition < 0) {
      xPosition = 0;
    } else if (xPosition > width - childWidth) {
      xPosition = width - childWidth;
    }
    if (yPosition < 0) {
      yPosition = 0;
    } else if (yPosition > height - childHeight) {
      yPosition = height - childHeight;
    }
  }

  @override
  void dispose() {
    FConsole.instance.isShow.value = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
            child: isCalculateSize
                ? Opacity(
                    opacity: 0.0001,
                    child: Container(
                      key: _childGK,
                      child: widget.consoleBtn ?? _consoleBtn(),
                    ))
                : _TouchMoveView(
                    childWidth: childWidth,
                    childHeight: childHeight,
                    xPosition: xPosition,
                    yPosition: yPosition,
                    child: Visibility(
                      child: widget.consoleBtn ?? _consoleBtn(),
                      visible: isShowConsoleBtn,
                    ),
                    onTap: () {
                      isShowConsoleBtn = false;
                      showConsolePanel(() {
                        isShowConsoleBtn = true;
                      });
                    },
                  )),
      ],
    );
  }
}

class _TouchMoveView extends StatefulWidget {
  final Widget child;
  final Function onTap;

  final double xPosition;

  final double yPosition;

  final double childWidth;

  final double childHeight;

  _TouchMoveView(
      {@required this.child,
      this.onTap,
      this.xPosition = 0,
      this.yPosition = 0,
      this.childWidth = 0,
      this.childHeight = 0});

  @override
  State<StatefulWidget> createState() {
    return _TouchMoveState();
  }
}

class _TouchMoveState extends State<_TouchMoveView> {
  double xPosition = 0;
  double yPosition = 0;
  double childWidth = 0;
  double childHeight = 0;

  @override
  void initState() {
    xPosition = widget.xPosition;
    yPosition = widget.yPosition;
    childWidth = widget.childWidth;
    childHeight = widget.childHeight;

    super.initState();
  }

  @override
  void didUpdateWidget(_TouchMoveView oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQueryData.fromWindow(window).size.width;
    double height = MediaQueryData.fromWindow(window).size.height;
    return Transform.translate(
        offset: Offset(xPosition, yPosition),
        child: GestureDetector(
          onTap: () {
            widget.onTap?.call();
          },
          onPanUpdate: (detail) {
            setState(() {
              xPosition += detail.delta.dx;
              yPosition += detail.delta.dy;
              if (xPosition < 0) {
                xPosition = 0;
              } else if (xPosition > width - childWidth) {
                xPosition = width - childWidth;
              }
              if (yPosition < 0) {
                yPosition = 0;
              } else if (yPosition > height - childHeight) {
                yPosition = height - childHeight;
              }
            });
          },
          child: widget.child,
        ));
  }
}
