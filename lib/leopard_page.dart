import 'dart:math' as Math;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'main_page.dart';
import 'styles.dart';

class LeopardImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Consumer<PageOffsetNotifier>(
      builder: (context, provider, child) {
        return Positioned(
            left: -0.87 * provider.offset, width: width * 1.6, child: child);
      },
      child: IgnorePointer(child: Image.asset('assets/leopard.png')),
    );
  }
}

class TheNumber extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<PageOffsetNotifier>(
      builder: (context, notifier, child) {
        return Transform.translate(
          offset: Offset(-40 - 0.5 * notifier.offset, 0),
          child: child,
        );
      },
      child: RotatedBox(
        quarterTurns: 1,
        child: SizedBox(
          width: 400,
          child: FittedBox(
            fit: BoxFit.cover,
            child: Text(
              '72',
              style: TextStyle(
                // fontSize: 320,
                fontWeight: FontWeight.bold,
                // shadows: [Shadow(color: Colors.white, blurRadius: 0.3)]
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class TravelDescriptionLabel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<PageOffsetNotifier>(
      builder: (context, notifier, child) {
        return Opacity(
          opacity: Math.max(0, 1 - 4 * notifier.page),
          child: child,
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 24.0),
        child: Text(
          'Travel Description',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}

class LeopardDescription extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<PageOffsetNotifier>(
      builder: (context, notifier, child) {
        return Opacity(
          opacity: Math.max(0, 1 - 4 * notifier.page),
          child: child,
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Text(
          'The leopard is distinguished by its well-camouflaged fur, opportunistic hunting behaviour, broad diet, and strength.',
          style: TextStyle(fontSize: 14, color: lightGrey),
        ),
      ),
    );
  }
}

class LeopardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          height: 128,
        ),
        TheNumber(),
        SizedBox(
          height: 32,
        ),
        TravelDescriptionLabel(),
        SizedBox(
          height: 32,
        ),
        LeopardDescription(),
      ],
    );
  }
}
