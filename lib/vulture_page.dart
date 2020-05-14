import 'package:animate_animal/styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math' as Math;
import 'main_page.dart';

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
      child: MapHider(
        child: Text(
          'Travel Details',
          style: TextStyle(fontSize: 18),
        ),
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
      child: MapHider(
        child: Align(
          alignment: Alignment.centerRight,
          child: Text(
            'Start Camp',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300),
          ),
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
      child: MapHider(
        child: Align(
          alignment: Alignment.centerRight,
          child: Text(
            '02:40 pm',
            style: TextStyle(
                fontSize: 14, fontWeight: FontWeight.w300, color: lighterGrey),
          ),
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
      child: MapHider(
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Base Camp',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300),
          ),
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
      child: MapHider(
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            '07:30 am',
            style: TextStyle(
                fontSize: 14, fontWeight: FontWeight.w300, color: lighterGrey),
          ),
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
      child: MapHider(
        child: Center(
          child: Text(
            '72 km',
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: white),
          ),
        ),
      ),
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
        return MapHider(
          child: Container(
            margin: const EdgeInsets.only(bottom: 250.0, left: 20),
            height: size,
            width: size,
            decoration: BoxDecoration(shape: BoxShape.circle, color: lightGrey),
          ),
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
      child: MapHider(
        child: IgnorePointer(
            child: Padding(
          padding: const EdgeInsets.only(bottom: 100.0),
          child: Image.asset(
            'assets/vulture.png',
            height: height / 2.7,
          ),
        )),
      ),
    );
  }
}

class VulturePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: MapHider(child: VultureCircle()));
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
              height: showLine ? 16 : 0,
            ),
            Text(
              isVulture ? 'Vultures' : 'Leopards',
              style: TextStyle(fontSize: showLine ? 14 : 12),
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
    return Consumer2<AnimationController, MapAnimationNotifier>(
      builder: (context, animation, notifier, child) {
        double startTop = 128.0 + 400 + 32 + 16 + 32 + 4;
        double endTop = 128.0 + 32 + 16 + 8;
        double oneThird = (startTop - endTop) / 3;
        double opacity;
        if (animation.value < 2 / 3) {
          opacity = 0;
        } else if (notifier.value == 0) {
          opacity = 3 * (animation.value - 2 / 3);
        } else if (notifier.value < 0.33) {
          opacity = 1 - 3 * notifier.value;
        } else {
          opacity = 0;
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
    return Consumer2<AnimationController, MapAnimationNotifier>(
      builder: (context, animation, notifier, child) {
        double startTop = 128.0 + 400 + 32 + 16 + 32 + 4;
        double endTop = 128.0 + 32 + 16 + 8;
        double oneThird = (startTop - endTop) / 3;
        double opacity;
        if (animation.value < 3 / 4) {
          opacity = 0;
        } else if (notifier.value == 0) {
          opacity = 4 * (animation.value - 3 / 4);
        } else if (notifier.value < 0.33) {
          opacity = 1 - 3 * notifier.value;
        } else {
          opacity = 0;
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
