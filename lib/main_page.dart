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

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PageOffsetNotifier(_pageController),
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            alignment: Alignment.centerLeft,
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
              TravelDots(),
              MapButton(),
            ],
          ),
        ),
      ),
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
    return Positioned(
      top: 128.0 + 400 + 32 - 8,
      right: 24,
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
    return Consumer<PageOffsetNotifier>(
      builder: (context, notifier, child) {
        return Positioned(
          top: 128.0 + 400 + 32 - 4,
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
    return Consumer<PageOffsetNotifier>(
      builder: (context, notifier, child) {
        double opacity = Math.max(0, 4 * notifier.page - 3);
        return Positioned(
          top: 128.0 + 400 + 32 + 16 + 32,
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
    return Consumer<PageOffsetNotifier>(
      builder: (context, notifier, child) {
        double opacity = Math.max(0, 4 * notifier.page - 3);
        return Positioned(
          top: 128.0 + 400 + 32 + 16 + 32 + 40,
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
    return Consumer<PageOffsetNotifier>(
      builder: (context, notifier, child) {
        double opacity = Math.max(0, 4 * notifier.page - 3);

        return Positioned(
          bottom: 8,
          left: 8,
          child: Opacity(
            opacity: opacity,
            child: FlatButton(
              child: Text(
                'On MAP',
                style: TextStyle(fontSize: 12),
              ),
              onPressed: () {},
            ),
          ),
        );
      },
    );
  }
}

class TravelDots extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<PageOffsetNotifier>(
      builder: (context, notifier, child) {
        double opacity = Math.max(0, 4 * notifier.page - 3);
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
                    margin: EdgeInsets.only(left: opacity * 40.0),
                    width: 8,
                    height: 8,
                    decoration:
                        BoxDecoration(shape: BoxShape.circle, color: white),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: opacity * 10.0),
                    width: 4,
                    height: 4,
                    decoration:
                        BoxDecoration(shape: BoxShape.circle, color: lightGrey),
                  ),
                  Container(
                    margin: EdgeInsets.only(right: opacity * 10.0),
                    width: 4,
                    height: 4,
                    decoration:
                        BoxDecoration(shape: BoxShape.circle, color: lightGrey),
                  ),
                  Container(
                    margin: EdgeInsets.only(right: opacity * 40.0),
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: mainBlack,
                        border: Border.all(color: white)),
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
    return Consumer<PageOffsetNotifier>(
      builder: (context, notifier, child) {
        double multiplier = Math.max(0, 4 * notifier.page - 3);
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
    return Consumer<PageOffsetNotifier>(
      builder: (context, provider, child) {
        return Positioned(
            left: 1.21 * width - provider.offset * 0.87, child: child);
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
