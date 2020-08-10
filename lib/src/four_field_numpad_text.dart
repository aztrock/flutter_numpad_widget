import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

import 'numpad_controller.dart';

class FourFieldNumpadText extends StatefulWidget {
  ///The [NumpadController] this NumpadText shares with its parent Numpad.
  final NumpadController controller;

  ///The style adopted by the Text portion of this widget.
  final TextStyle style;
  final TextAlign textAlign;

  ///If true, the text will turn red, play a shaking animation, and clear itself
  ///when [NumpadController.notifyErrorResetListener] is called on [controller].
  final bool animateError;

  ///The color to apply to the text when the error animation is playing.
  final Color errorColor;

  final isObscureText;

  FourFieldNumpadText({
    @required this.controller,
    this.style,
    this.textAlign = TextAlign.center,
    this.animateError = false,
    this.errorColor = Colors.red,
    this.isObscureText = true
  });

  @override
  _FourFieldNumpadTextState createState() => _FourFieldNumpadTextState();
}

class _FourFieldNumpadTextState extends State<FourFieldNumpadText>
    with SingleTickerProviderStateMixin {
  ///The text being currently displayed by this widget.
  String displayedText;

  NumpadController _controller;

  AnimationController _errorAnimator;
  Animation _errorAnimation;
  final _totalErrorShakes = 3;
  var _errorShakes = 0;
  bool _isErrorColor = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller
      ..addListener(_listener)
      ..setErrorResetListener(_handleError);

    displayedText = _controller.formattedString;

    _errorAnimator = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 100))
      ..addStatusListener(_errorAnimationStatusListener);

    _errorAnimation =
        Tween<Offset>(begin: const Offset(0, 0), end: const Offset(0.2, 0))
            .animate(_errorAnimator);
  }

  void _listener() {
    setState(() {
      displayedText = _controller.formattedString;
    });
  }

  void _handleError() {
    if (widget.animateError) {
      setState(() {
        _isErrorColor = true;
      });
      _errorAnimator.forward();
    } else {
      _controller.clear();
    }
  }

  void _errorAnimationStatusListener(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      _errorAnimator.reverse();
    }
    if (status == AnimationStatus.dismissed) {
      _errorShakes += 1;
      if (_errorShakes < _totalErrorShakes) {
        _errorAnimator.forward();
      } else {
        _errorShakes = 0;
        _isErrorColor = false;
        _controller.clear();
      }
    }
  }

  TextStyle _getTextStyle() {
    TextStyle style = TextStyle(
        fontFamily: 'RobotoMono', color: _isErrorColor ? Colors.red : null);
    return widget.style?.merge(style);
  }

  final edges = EdgeInsets.symmetric(vertical: 5, horizontal: 8);
  final shape = NeumorphicBoxShape.roundRect(BorderRadius.circular(15));
  final list = new List<int>.generate(4, (i) => i);

  @override
  Widget build(BuildContext context) {
    List items = <Widget>[];
    final chars = displayedText.split('');

    list.forEach((index) { 
      items.add(
        getBox(NeumorphicText(chars != null && chars.isNotEmpty && index < chars.length? chars[index] :'',
          style: NeumorphicStyle(depth: 3, intensity: 0.7),
          textStyle: NeumorphicTextStyle(
          fontSize: 44
        ))));
    });

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: items
    );
  }

getBox(Widget w){
  return SizedBox(
          height: 75,
          width: 70,
              child: Neumorphic(
                margin: EdgeInsets.only(left: 8, right: 8, top: 2, bottom: 4),
                    style: NeumorphicStyle(
                      // depth: NeumorphicTheme.embossDepth(context),
                      depth: -4,
                      intensity: 1,
                      surfaceIntensity: 1,
                      // lightSource: LightSource.left,
                      boxShape: shape,
                    ),
                    padding: edges,
                child: SlideTransition(
              position: _errorAnimation,
              child: w
            )));
}

  @override
  void dispose() {
    _controller.removeListener(_listener);
    super.dispose();
  }
}
