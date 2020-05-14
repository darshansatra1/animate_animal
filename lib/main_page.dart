import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'leopard_page.dart';
import 'styles.dart';
import 'dart:math' as Math;

import 'vulture_page.dart';

class PageOffsetNotifier with ChangeNotifier {
  double _offset = 0.0;
  double _page = 0;

  PageOffsetNotifier(PageController pageController) {
    pageController.addListener(() {
      _offset = pageController.offset;
      _page = pageController.page;
      notifyListeners();
    });
  }

  double get offset => _offset;
  double get page => _page;
}

class MapAnimationNotifier with ChangeNotifier {
  final AnimationController _animationController;

  MapAnimationNotifier(this._animationController) {
    _animationController.addListener(_onAnimationControllerChanged);
  }

  double get value => _animationController.value;

  void forward() => _animationController.forward();
  void reverse() => _animationController.reverse();

  void _onAnimationControllerChanged() {
    notifyListeners();
  }

  @override
  void dispose() {
    _animationController.removeListener(_onAnimationControllerChanged);
    super.dispose();
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

double startTop = 128.0 + 400 + 32 + 16 + 32 + 4;
double endTop = 128.0 + 32 + 16 + 8;
double oneThird = (startTop - endTop) / 3;

class _MainPageState extends State<MainPage> with TickerProviderStateMixin {
  AnimationController _animationController;
  AnimationController _mapAnimationController;

  final PageController _pageController = PageController();

  double get maxHeight => 400 + 32 + 24.0;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
    _mapAnimationController =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
  }

  @override
  void dispose() {
    _animationController.dispose();
    _mapAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PageOffsetNotifier(_pageController),
      child: ListenableProvider.value(
        value: _animationController,
        child: ChangeNotifierProvider(
          create: (_) => MapAnimationNotifier(_mapAnimationController),
          child: Scaffold(
            body: Stack(children: [
              MapImage(),
              SafeArea(
                child: GestureDetector(
                  onVerticalDragUpdate: _handleDragUpdate,
                  onVerticalDragEnd: _handleDragEnd,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      PageView(
                        controller: _pageController,
                        physics: BouncingScrollPhysics(),
                        children: <Widget>[LeopardPage(), VulturePage()],
                      ),
                      AppBar(),
                      LeopardImage(),
                      VultureImage(),
                      SharedButton(),
                      PageIndicator(),
                      ArrowIcon(),
                      TravelDetailsLabel(),
                      StartCampLabel(),
                      StartTimeLabel(),
                      BaseCampLabel(),
                      BaseTimeLabel(),
                      DistanceLabel(),
                      HorizontalTravelDots(),
                      VerticalTravelDots(),
                      MapButton(),
                      VultureIconLabel(),
                      LeopardIconLabel(),
                      CurvedRoute(),
                      MapBaseCamp(),
                      MapLeopards(),
                      MapVultures(),
                      MapStartCamp()
                    ],
                  ),
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    _animationController.value -= details.primaryDelta / maxHeight;
  }

  void _handleDragEnd(DragEndDetails details) {
    if (_animationController.isAnimating ||
        _animationController.status == AnimationStatus.completed) return;

    final double flingVelocity =
        details.velocity.pixelsPerSecond.dy / maxHeight;

    if (flingVelocity < 0.0) {
      _animationController.fling(velocity: Math.max(2.0, -flingVelocity));
    } else if (flingVelocity > 0.0) {
      _animationController.fling(velocity: Math.max(-2.0, -flingVelocity));
    } else {
      _animationController.fling(
          velocity: _animationController.value < 0.5 ? -2.0 : 2.0);
    }
  }
}

class MapImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<MapAnimationNotifier>(
      builder: (context, notifier, child) {
        double scale = 1 + 0.3 * (1 - notifier.value);
        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..scale(scale)
            ..rotateZ(Math.pi * 0.05 * (1 - notifier.value)),
          child: Opacity(opacity: notifier.value, child: child),
        );
      },
      child: Container(
        height: double.infinity,
        width: double.infinity,
        child: Image.asset(
          'assets/map.png',
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class MapButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 8,
      left: 8,
      child: Consumer<PageOffsetNotifier>(
        builder: (context, notifier, child) {
          double opacity = Math.max(0, 4 * notifier.page - 3);
          return Opacity(
            opacity: opacity,
            child: FlatButton(
              child: Text(
                'On MAP',
                style: TextStyle(fontSize: 12),
              ),
              onPressed: () {
                final notifier =
                    Provider.of<MapAnimationNotifier>(context, listen: false);
                notifier.value == 0 ? notifier.forward() : notifier.reverse();
              },
            ),
          );
        },
      ),
    );
  }
}

class MapHider extends StatelessWidget {
  final Widget child;

  const MapHider({Key key, this.child}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Consumer<MapAnimationNotifier>(
      builder: (context, notifier, child) {
        return Opacity(
          opacity: Math.max(0, 1 - 2 * notifier.value),
          child: child,
        );
      },
      child: child,
    );
  }
}

class AppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
        child: Row(
          children: <Widget>[
            Text(
              'SY',
              style: TextStyle(
                  fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 2),
            ),
            Spacer(),
            Icon(Icons.menu),
          ],
        ),
      ),
    );
  }
}

class SharedButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 20,
      bottom: 16,
      child: Icon(Icons.share),
    );
  }
}

class PageIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<PageOffsetNotifier>(
      builder: (context, notifier, _) {
        return MapHider(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    height: notifier.page.round() == 0 ? 20 : 6,
                    width: 8,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: notifier.page.round() == 0 ? white : lightGrey),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Container(
                    height: notifier.page.round() == 1 ? 20 : 6,
                    width: 8,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: notifier.page.round() == 0 ? lightGrey : white),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class ArrowIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AnimationController>(
      builder: (context, animation, child) {
        return Positioned(
          top: 128.0 + (1 - animation.value) * (400 + 32 - 4),
          right: 24,
          child:
              Transform.rotate(angle: Math.pi * animation.value, child: child),
        );
      },
      child: MapHider(
        child: Icon(
          Icons.keyboard_arrow_up,
          size: 28,
          color: lighterGrey,
        ),
      ),
    );
  }
}

class VerticalTravelDots extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer2<AnimationController, MapAnimationNotifier>(
        builder: (context, animation, notifier, child) {
      if (animation.value < 1 / 6 || notifier.value > 0) {
        return Container();
      }
      double startTop = 128.0 + 400 + 32 + 16 + 32 + 4;
      double bottom = MediaQuery.of(context).size.height - startTop - 32;
      double endTop = 128.0 + 32 + 16 + 8;
      double top =
          endTop + (1 - (1.2 * (animation.value - 1 / 6))) * (400 + 32 - 4);

      double oneThird = (startTop - endTop) / 3;

      return Positioned(
        top: top,
        bottom: bottom,
        child: Center(
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: <Widget>[
              Container(
                width: 2,
                height: double.infinity,
                color: white,
              ),
              Positioned(
                top: top > oneThird + endTop ? 0 : oneThird + endTop - top,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                      border: Border.all(color: white, width: 2.5),
                      shape: BoxShape.circle,
                      color: mainBlack),
                ),
              ),
              Positioned(
                top: top > 2 * oneThird + endTop
                    ? 0
                    : 2 * oneThird + endTop - top,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                      border: Border.all(color: white, width: 2.5),
                      shape: BoxShape.circle,
                      color: mainBlack),
                ),
              ),
              Align(
                alignment: Alignment(0, 1),
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                      border: Border.all(color: white, width: 2),
                      shape: BoxShape.circle,
                      color: mainBlack),
                ),
              ),
              Align(
                alignment: Alignment(0, -1),
                child: Container(
                  width: 8,
                  height: 8,
                  decoration:
                      BoxDecoration(shape: BoxShape.circle, color: white),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}

class HorizontalTravelDots extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer2<PageOffsetNotifier, AnimationController>(
      builder: (context, notifier, animation, child) {
        if (animation.value == 1) {
          return Container();
        }
        double spacingFactor;
        double opacity;
        if (animation.value == 0) {
          spacingFactor = Math.max(0, 4 * notifier.page - 3);
          opacity = spacingFactor;
        } else {
          spacingFactor = Math.max(0, 1 - 6 * animation.value);
          opacity = 1;
        }
        return Positioned(
          top: 128.0 + 400 + 32 + 16 + 32 + 4,
          left: 0,
          right: 0,
          child: Center(
            child: Opacity(
              opacity: opacity,
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(left: spacingFactor * 10.0),
                    width: 4,
                    height: 4,
                    decoration:
                        BoxDecoration(shape: BoxShape.circle, color: lightGrey),
                  ),
                  Container(
                    margin: EdgeInsets.only(right: spacingFactor * 10.0),
                    width: 4,
                    height: 4,
                    decoration:
                        BoxDecoration(shape: BoxShape.circle, color: lightGrey),
                  ),
                  Container(
                    margin: EdgeInsets.only(right: spacingFactor * 40.0),
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: mainBlack,
                        border: Border.all(color: white)),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: spacingFactor * 40.0),
                    width: 8,
                    height: 8,
                    decoration:
                        BoxDecoration(shape: BoxShape.circle, color: white),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class CurvedRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer2<AnimationController, MapAnimationNotifier>(
        builder: (context, notifier, animation, child) {
      if (animation.value == 0) {
        return Container();
      }
      double startTop = 128.0 + 400 + 32 + 16 + 32 + 4;
      double bottom = MediaQuery.of(context).size.height - startTop - 32;
      double endTop = 128.0 + 32 + 16 + 8;

      double oneThird = (startTop - endTop) / 3;
      double width = MediaQuery.of(context).size.width;

      return Positioned(
        top: endTop,
        bottom: bottom,
        left: 0,
        right: 0,
        child: CustomPaint(
          painter: CurvedPainter(animation.value),
          child: Center(
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: <Widget>[
                Positioned(
                  top: oneThird,
                  right: width / 2 - 4 - 60 * animation.value,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                        border: Border.all(color: white, width: 2.5),
                        shape: BoxShape.circle,
                        color: mainBlack),
                  ),
                ),
                Positioned(
                  top: 2 * oneThird,
                  right: width / 2 - 4 - 50 * animation.value,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                        border: Border.all(color: white, width: 2.5),
                        shape: BoxShape.circle,
                        color: mainBlack),
                  ),
                ),
                Align(
                  alignment: Alignment(0, 1),
                  child: Container(
                    margin: EdgeInsets.only(right: 100 * animation.value),
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                        border: Border.all(color: white, width: 2.5),
                        shape: BoxShape.circle,
                        color: white),
                  ),
                ),
                Align(
                  alignment: Alignment(0, -1),
                  child: Container(
                    margin: EdgeInsets.only(left: 40 * animation.value),
                    width: 8,
                    height: 8,
                    decoration:
                        BoxDecoration(shape: BoxShape.circle, color: white),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}

class CurvedPainter extends CustomPainter {
  final double animationValue;

  CurvedPainter(this.animationValue);
  double width;

  double interpolate(double x) {
    return width / 2 + (x - width / 2) * animationValue;
  }

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint();
    width = size.width;
    paint.style = PaintingStyle.stroke;
    paint.color = white;
    paint.strokeWidth = 2;
    var path = Path();
    var startPoint = Offset(interpolate(width / 2 + 20), 4);
    var controlPoint1 = Offset(interpolate(width / 2 + 60), size.height / 4);
    var controlPoint2 = Offset(interpolate(width / 2 + 20), size.height / 4);
    var endPoint = Offset(interpolate(width / 2 + 55 + 4), size.height / 3);

    path.moveTo(startPoint.dx, startPoint.dy);
    path.cubicTo(controlPoint1.dx, controlPoint1.dy, controlPoint2.dx,
        controlPoint2.dy, endPoint.dx, endPoint.dy);

    startPoint = endPoint;
    controlPoint1 = Offset(interpolate(width / 2 + 100), size.height / 2);
    controlPoint2 = Offset(interpolate(width / 2 + 40), size.height / 2 + 40);
    endPoint = Offset(interpolate(width / 2 + 50), 2 * size.height / 3 - 1);

    path.cubicTo(controlPoint1.dx, controlPoint1.dy, controlPoint2.dx,
        controlPoint2.dy, endPoint.dx, endPoint.dy);

    startPoint = endPoint;
    controlPoint1 =
        Offset(interpolate(width / 2 + 70), 2 * size.height / 3 + 30);
    controlPoint2 =
        Offset(interpolate(width / 2 + 20), 5 * size.height / 6 - 10);
    endPoint = Offset(interpolate(width / 2), 5 * size.height / 6);

    path.cubicTo(controlPoint1.dx, controlPoint1.dy, controlPoint2.dx,
        controlPoint2.dy, endPoint.dx, endPoint.dy);

    startPoint = endPoint;
    controlPoint1 = Offset(interpolate(width / 2 - 10), size.height - 60);
    controlPoint2 = Offset(interpolate(width / 2 - 10), size.height - 50);
    endPoint = Offset(interpolate(width / 2 - 50), size.height - 4);

    path.cubicTo(controlPoint1.dx, controlPoint1.dy, controlPoint2.dx,
        controlPoint2.dy, endPoint.dx, endPoint.dy);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return oldDelegate != animationValue;
  }
}

class MapBaseCamp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<MapAnimationNotifier>(
      builder: (context, notifier, child) {
        double opacity = Math.max(0, 4 * (notifier.value - 3 / 4));
        return Positioned(
          top: 128.0 + 32 + 16 + 4,
          right: 30.0,
          width: (MediaQuery.of(context).size.width - 48) / 3,
          child: Opacity(opacity: opacity, child: child),
        );
      },
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          'Base Camp',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
        ),
      ),
    );
  }
}

class MapLeopards extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<MapAnimationNotifier>(
      builder: (context, notifier, child) {
        double opacity = Math.max(0, 4 * (notifier.value - 3 / 4));
        return Positioned(
          top: 128.0 + 32 + 16 + oneThird,
          width: (MediaQuery.of(context).size.width - 48) / 3,
          child: Opacity(opacity: opacity, child: child),
        );
      },
      child: Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: SmallAnimalIconLabel(isVulture: false, showLine: false),
          )),
    );
  }
}

class MapVultures extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<MapAnimationNotifier>(
      builder: (context, notifier, child) {
        double opacity = Math.max(0, 4 * (notifier.value - 3 / 4));
        return Positioned(
          top: 128.0 + 32 + 16 + 2 * oneThird,
          right: 24,
          width: (MediaQuery.of(context).size.width - 48) / 3,
          child: Opacity(opacity: opacity, child: child),
        );
      },
      child: Align(
          alignment: Alignment.centerLeft,
          child: SmallAnimalIconLabel(isVulture: true, showLine: false)),
    );
  }
}

class MapStartCamp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<MapAnimationNotifier>(
      builder: (context, notifier, child) {
        double opacity = Math.max(0, 4 * (notifier.value - 3 / 4));
        return Positioned(
          top: startTop + 4,
          left: MediaQuery.of(context).size.width / 3 + 30,
          width: (MediaQuery.of(context).size.width - 48) / 3,
          child: Opacity(opacity: opacity, child: child),
        );
      },
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          'Start Camp',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
        ),
      ),
    );
  }
}
