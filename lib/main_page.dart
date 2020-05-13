import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'leopard_page.dart';
import 'styles.dart';
import 'dart:math' as Math;

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
    _animationController.addListener(_onAnimationControllerChange);
  }

  void _onAnimationControllerChange() {
    notifyListeners();
  }

  @override
  void dispose() {
    _animationController.addListener(_onAnimationControllerChange);
    super.dispose();
  }

  double get value => _animationController.value;

  get forward => _animationController.forward();
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

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
            body: SafeArea(
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
                    LeopardIconLabel()
                  ],
                ),
              ),
            ),
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
        return Align(
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
      child: Icon(
        Icons.keyboard_arrow_up,
        size: 28,
        color: lighterGrey,
      ),
    );
  }
}

class TravelDetailsLabel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer2<PageOffsetNotifier, AnimationController>(
      builder: (context, notifier, animation, child) {
        return Positioned(
          top: 128.0 + (1 - animation.value) * (400 + 32 - 4),
          left: 24.0 + MediaQuery.of(context).size.width - notifier.offset,
          child: Opacity(
              opacity: Math.max(0, 4 * notifier.page - 3), child: child),
        );
      },
      child: Text(
        'Travel Details',
        style: TextStyle(fontSize: 18),
      ),
    );
  }
}

class StartCampLabel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<PageOffsetNotifier>(
      builder: (context, notifier, child) {
        double opacity = Math.max(0, 4 * notifier.page - 3);
        return Positioned(
          top: 128.0 + 400 + 32 + 16 + 32,
          left: opacity * 24.0,
          width: (MediaQuery.of(context).size.width - 48) / 3,
          child: Opacity(opacity: Math.max(0, opacity), child: child),
        );
      },
      child: Align(
        alignment: Alignment.centerRight,
        child: Text(
          'Start Camp',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300),
        ),
      ),
    );
  }
}

class StartTimeLabel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<PageOffsetNotifier>(
      builder: (context, notifier, child) {
        double opacity = Math.max(0, 4 * notifier.page - 3);
        return Positioned(
          top: 128.0 + 400 + 32 + 16 + 32 + 40,
          left: opacity * 24.0,
          width: (MediaQuery.of(context).size.width - 48) / 3,
          child: Opacity(opacity: Math.max(0, opacity), child: child),
        );
      },
      child: Align(
        alignment: Alignment.centerRight,
        child: Text(
          '02:40 pm',
          style: TextStyle(
              fontSize: 14, fontWeight: FontWeight.w300, color: lighterGrey),
        ),
      ),
    );
  }
}

class BaseCampLabel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer2<PageOffsetNotifier, AnimationController>(
      builder: (context, notifier, animation, child) {
        double opacity = Math.max(0, 4 * notifier.page - 3);
        return Positioned(
          top: 128.0 + 32 + 16 + 4 + (1 - animation.value) * (400 + 32 - 4),
          right: opacity * 24.0,
          width: (MediaQuery.of(context).size.width - 48) / 3,
          child: Opacity(opacity: Math.max(0, opacity), child: child),
        );
      },
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          'Base Camp',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300),
        ),
      ),
    );
  }
}

class BaseTimeLabel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer2<PageOffsetNotifier, AnimationController>(
      builder: (context, notifier, animation, child) {
        double opacity = Math.max(0, 4 * notifier.page - 3);
        return Positioned(
          top:
              128.0 + 32 + 16 + 4 + 40 + (1 - animation.value) * (400 + 32 - 4),
          right: opacity * 24.0,
          width: (MediaQuery.of(context).size.width - 48) / 3,
          child: Opacity(opacity: Math.max(0, opacity), child: child),
        );
      },
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          '07:30 am',
          style: TextStyle(
              fontSize: 14, fontWeight: FontWeight.w300, color: lighterGrey),
        ),
      ),
    );
  }
}

class DistanceLabel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<PageOffsetNotifier>(
      builder: (context, notifier, child) {
        double opacity = Math.max(0, 4 * notifier.page - 3);
        return Positioned(
          top: 128.0 + 400 + 32 + 16 + 32 + 40,
          width: MediaQuery.of(context).size.width,
          // left: 24 + (MediaQuery.of(context).size.width - 48) / 3,
          child: Opacity(opacity: Math.max(0, opacity), child: child),
        );
      },
      child: Center(
        child: Text(
          '72 km',
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: white),
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
                Provider.of<AnimationController>(context, listen: false)
                    .forward();
              },
            ),
          );
        },
      ),
    );
  }
}

class VerticalTravelDots extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AnimationController>(builder: (context, animation, child) {
      if (animation.value < 1 / 6) {
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
        double spacingFactor;
        double opacity;
        if (animation.value == 0.0) {
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
                  // Container(
                  //   margin: EdgeInsets.only(left: spacingFactor * 40.0),
                  //   width: 8,
                  //   height: 8,
                  //   decoration:
                  //       BoxDecoration(shape: BoxShape.circle, color: white),
                  // ),
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

class VultureCircle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer2<PageOffsetNotifier, AnimationController>(
      builder: (context, notifier, animation, child) {
        double multiplier;
        if (animation.value == 0) {
          multiplier = Math.max(0, 4 * notifier.page - 3);
        } else {
          multiplier = Math.max(0, 1 - 6 * animation.value);
        }
        double size = MediaQuery.of(context).size.width * 0.5 * multiplier;
        return Container(
          margin: const EdgeInsets.only(bottom: 250.0, left: 20),
          height: size,
          width: size,
          decoration: BoxDecoration(shape: BoxShape.circle, color: lightGrey),
        );
      },
    );
  }
}

class VultureImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Consumer2<PageOffsetNotifier, AnimationController>(
      builder: (context, provider, animation, child) {
        return Positioned(
            left: 1.21 * width - provider.offset * 0.87,
            child: Transform.scale(
                scale: 1 - 0.1 * animation.value,
                child:
                    Opacity(opacity: 1 - 0.6 * animation.value, child: child)));
      },
      child: IgnorePointer(
          child: Padding(
        padding: const EdgeInsets.only(bottom: 100.0),
        child: Image.asset(
          'assets/vulture.png',
          height: height / 2.7,
        ),
      )),
    );
  }
}

class VulturePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: VultureCircle());
  }
}

class SmallAnimalIconLabel extends StatelessWidget {
  final bool isVulture;
  final bool showLine;
  const SmallAnimalIconLabel({Key key, this.isVulture, this.showLine})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        if (showLine && isVulture)
          Container(
            margin: EdgeInsets.only(bottom: 8),
            width: 16,
            height: 1,
            color: white,
          ),
        SizedBox(
          width: 24,
        ),
        Column(
          children: <Widget>[
            Image.asset(
              isVulture ? 'assets/vultures.png' : 'assets/leopards.png',
              width: 28,
              height: 28,
            ),
            SizedBox(
              height: 16,
            ),
            Text(
              isVulture ? 'Vultures' : 'Leopards',
              style: TextStyle(fontSize: 14),
            )
          ],
        ),
        SizedBox(
          width: 24,
        ),
        if (showLine && !isVulture)
          Container(
            margin: EdgeInsets.only(bottom: 8),
            width: 16,
            height: 1,
            color: white,
          ),
      ],
    );
  }
}

class VultureIconLabel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AnimationController>(
      builder: (context, animation, child) {
        double startTop = 128.0 + 400 + 32 + 16 + 32 + 4;
        double endTop = 128.0 + 32 + 16 + 8;
        double oneThird = (startTop - endTop) / 3;
        double opacity;
        if (animation.value < 2 / 3) {
          opacity = 0;
        } else {
          opacity = 3 * (animation.value - 2 / 3);
        }
        return Positioned(
          top: endTop + 2 * oneThird - 28 - 16 - 7,
          right: 10 + opacity * 16,
          child: Opacity(opacity: opacity, child: child),
        );
      },
      child: SmallAnimalIconLabel(
        isVulture: true,
        showLine: true,
      ),
    );
  }
}

class LeopardIconLabel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AnimationController>(
      builder: (context, animation, child) {
        double startTop = 128.0 + 400 + 32 + 16 + 32 + 4;
        double endTop = 128.0 + 32 + 16 + 8;
        double oneThird = (startTop - endTop) / 3;
        double opacity;
        if (animation.value < 3 / 4) {
          opacity = 0;
        } else {
          opacity = 4 * (animation.value - 3 / 4);
        }
        return Positioned(
          top: endTop + oneThird - 28 - 16 - 7,
          left: 10 + opacity * 16,
          child: Opacity(opacity: opacity, child: child),
        );
      },
      child: SmallAnimalIconLabel(
        isVulture: false,
        showLine: true,
      ),
    );
  }
}
