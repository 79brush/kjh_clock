import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'model.dart';
import 'dart:math' as math;
import 'package:intl/intl.dart';

enum _Color {
  background,
  text,
  shadow,
  dot,
}

final _lightTheme = {
  _Color.background: Colors.white,
  _Color.text: Colors.black,
  _Color.shadow: Colors.grey,
  _Color.dot: Color(0xFF2F3436),
};

final _darkTheme = {
  _Color.background: Colors.black,
  _Color.text: Colors.white,
  _Color.shadow: Color(0xFF174EA6),
  _Color.dot: Colors.yellow,
};

class KjhClock extends StatefulWidget {
  const KjhClock(this.model);
  final ClockModel model;
  @override
  _KjhClockState createState() => _KjhClockState();
}

class _KjhClockState extends State<KjhClock> {
  DateTime _dateTime = DateTime.now();
  Timer _timer;

  @override
  void initState() {
    super.initState();
    widget.model.addListener(_updateModel);
    _updateTime();
    _updateModel();
  }

  @override
  void didUpdateWidget(KjhClock oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.model != oldWidget.model) {
      oldWidget.model.removeListener(_updateModel);
      widget.model.addListener(_updateModel);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    widget.model.removeListener(_updateModel);
    widget.model.dispose();
    super.dispose();
  }

  var _temperature = '';
  var _temperatureRange = '';
  var _condition = '';
  var _location = '';

  void _updateModel() {
    setState(() {
      _temperature = widget.model.temperatureString;
      _temperatureRange = '(${widget.model.low} - ${widget.model.highString})';
      _condition = widget.model.weatherString;
      _location = widget.model.location;
    });
  }

  void _updateTime() {
    setState(() {
      _dateTime = DateTime.now();
      _timer = Timer(
        Duration(seconds: 1),
        _updateTime,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).brightness == Brightness.light
        ? _lightTheme
        : _darkTheme;

    final fontTitle = MediaQuery.of(context).size.width / 16;
    final fontSubTitle = MediaQuery.of(context).size.width / 30;

    final fontTimeLarge = MediaQuery.of(context).size.width / 5;
    final fontTimeNormal = MediaQuery.of(context).size.width / 20;
    final fontSmall = MediaQuery.of(context).size.width / 40;

    final iconSize = MediaQuery.of(context).size.width / 10;

    final defaultStyle = TextStyle(
      color: colors[_Color.text],
      fontFamily: 'PressStart2P',
      fontSize: fontTitle,
    );

    var _weatherIcons = {
      'cloudy': Icon(
        Icons.wb_cloudy,
        size: iconSize,
      ),
      'foggy': Icon(
        Icons.cloud_off,
        size: iconSize,
      ),
      'rainy': Icon(
        Icons.beach_access,
        size: iconSize,
      ),
      'snowy': Icon(
        Icons.ac_unit,
        size: iconSize,
      ),
      'sunny': Icon(
        Icons.wb_sunny,
        size: iconSize,
      ),
      'thunderstorm': Icon(
        Icons.flash_on,
        size: iconSize,
      ),
      'windy': Icon(
        Icons.clear_all,
        size: iconSize,
      ),
    };

    Widget getAMPM() {
      String ampm = _dateTime.hour > 11 ? 'PM' : 'AM';
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          '$ampm',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'SourceSansPro',
          ),
          textAlign: TextAlign.end,
        ),
      );
    }

    Widget getAMPM2() {
      Color amColor = _dateTime.hour > 11 ? Colors.white : Colors.yellow;
      Color pmColor = _dateTime.hour > 11 ? Colors.yellow : Colors.white;

      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircleAvatar(
              backgroundColor: Colors.black,
              child: Text(
                'AM',
                style: TextStyle(color: amColor),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            CircleAvatar(
              backgroundColor: Colors.black,
              child: Text(
                'PM',
                style: TextStyle(color: pmColor),
              ),
            ),
          ],
        ),
      );
    }

    Widget getDot() {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircleAvatar(
              radius: 10,
              backgroundColor: colors[_Color.dot],
            ),
            SizedBox(
              height: 30,
            ),
            CircleAvatar(
              radius: 10,
              backgroundColor: colors[_Color.dot],
            ),
          ],
        ),
      );
    }

    Widget getTemp() {
      return Column(
        children: <Widget>[
          Text(
            '$_temperature',
            style: TextStyle(
              fontSize: 100,
              fontWeight: FontWeight.w900,
              color: _temperature.startsWith('-') ? Colors.blue : Colors.red,
            ),
          ),
          Text(
            '${widget.model.lowString} / ${widget.model.highString}',
            style: TextStyle(fontSize: 36),
          ),
        ],
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Align(
                      child: FittedBox(
                        fit: BoxFit.contain,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              '$_location',
                              style: TextStyle(
                                fontSize: fontTitle,
//                          fontFamily: 'SourceSansPro',
                                fontFamily: 'SourceSansPro',
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            Text(
                              '${DateFormat.yMMMEd().format(_dateTime)}',
                              style: TextStyle(
                                  fontSize: fontSubTitle,
                                  fontFamily: 'SourceSansPro',
                                  color: Colors.blueGrey),
                            ),
                          ],
                        ),
                      ),
                      alignment: Alignment.centerLeft,
                    ),
                  ),
                  SizedBox(
                    width: 32,
                  ),
                  _weatherIcons[_condition],
                ],
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  flex: 4,
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Row(
                        children: <Widget>[
                          Stack(
                            children: <Widget>[
                              TimeCard(widget.model, _dateTime, 1, [0, 1, 2]),
                              widget.model.is24HourFormat
                                  ? SizedBox()
                                  : _dateTime.hour > 11
                                      ? Positioned(
                                          child: getAMPM(),
                                          left: 0,
                                          bottom: 0,
                                        )
                                      : Positioned(
                                          child: getAMPM(),
                                          left: 0,
                                          top: 0,
                                        ),
                            ],
                          ),
                          TimeCard(widget.model, _dateTime, 2,
                              [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]),
                          getDot(),
                          TimeCard(
                              widget.model, _dateTime, 3, [0, 1, 2, 3, 4, 5]),
                          TimeCard(widget.model, _dateTime, 4,
                              [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: Align(
                            alignment: Alignment.center,
                            child: FittedBox(
                              fit: BoxFit.contain,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 60),
                                child: getTemp(),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: FittedBox(
                              fit: BoxFit.contain,
                              child: Row(
                                children: <Widget>[
                                  TimeCard(widget.model, _dateTime, 5,
                                      [0, 1, 2, 3, 4, 5]),
                                  TimeCard(widget.model, _dateTime, 6,
                                      [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]),
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TimeCard extends StatefulWidget {
  TimeCard(this.model, this.dt, this.type, this.numArr);
  final ClockModel model;
  final DateTime dt;
  final type;
  final numArr;

  @override
  _TimeCardState createState() => _TimeCardState();
}

class _TimeCardState extends State<TimeCard>
    with SingleTickerProviderStateMixin {
  int pastNum;
  Animation _animation;
  AnimationController _controller;

  double _startAngle = 0;
  double _endAngle = math.pi / 2;
  int _row = 3;
  int _col = 2;
  double _v = 0.003;
  final double _padding = 1.0;
  bool _isRevers = false;

  @override
  void initState() {
    super.initState();

    _controller = new AnimationController(
        duration: Duration(milliseconds: 400), vsync: this);

    _animation = Tween(begin: _startAngle, end: _endAngle).animate(_controller)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _isRevers = true;
          _controller.reverse();
        }
      });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  void initTime() {
    int now;

    var check = widget.dt.hour;
    if (!widget.model.is24HourFormat) {
      if (check >= 13) {
        check = widget.dt.hour - 12;
      }
    }

    switch (widget.type) {
      case 1:
        now = check > 9 ? (check > 19 ? 2 : 1) : 0;
        break;
      case 2:
        now = check > 9 ? (check > 19 ? check - 20 : check - 10) : check;
        break;
      case 3:
        now = widget.dt.minute > 9 ? (widget.dt.minute / 10).floor() : 0;
        break;
      case 4:
        now = widget.dt.minute > 9
            ? int.parse(widget.dt.minute.toString().substring(1))
            : widget.dt.minute;
        break;
      case 5:
        now = widget.dt.second > 9 ? (widget.dt.second / 10).floor() : 0;
        break;
      case 6:
        now = widget.dt.second > 9
            ? int.parse(widget.dt.second.toString().substring(1))
            : widget.dt.second;
        break;
    }

    // 시간 타입 2인 경우 pastNum 이 0이고 타입1이 1이상이면 다시생각해야함!
    if (widget.type == 2 && !widget.model.is24HourFormat) {
      if (widget.dt.hour == 13 || widget.dt.hour == 24) {
        now = 3;
      }
    }

    now--;

    setState(() {
      if (now == -1) {
        now = widget.numArr[widget.numArr.length - 1];
      }
    });

    if (pastNum != null) {
      if (pastNum != now) {
        setState(() {
          pastNum = now;

          _isRevers = false;
          int d = -(-6 + widget.type) * 200;
          Future.delayed(Duration(milliseconds: d), () {
            _controller.forward();
          });
        });
      }
    } else {
      setState(() {
        pastNum = now;
        _controller.forward();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    initTime();

    int nextNum = pastNum + 1;

    if (widget.numArr.length == nextNum) {
      nextNum = widget.numArr[0];
    }

    // 12시 or 24시 -> 01
    if (widget.type == 2 && !widget.model.is24HourFormat) {
      if (widget.dt.hour == 13 || widget.dt.hour == 24) {
        nextNum = 1;
      }
    }

    var _timeCardDecoration = BoxDecoration(
      borderRadius: BorderRadius.circular(16.0),
      color: Colors.black87,
    );

    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: Container(
        decoration: _timeCardDecoration,
        child: Stack(
          children: <Widget>[
            _flipDownCard(nextNum),
            _flipCard(pastNum),
            _flipUpCard(nextNum),
          ],
        ),
      ),
    );
  }

  Widget _timeText(num) {
    return Padding(
      padding: const EdgeInsets.all(1.0),
      child: Container(
        width: 140,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(
            width: 1.0,
            color: Colors.black,
          ),
          color: Color(0xFF2F3436),
//          gradient: LinearGradient(
//            begin: Alignment.topCenter,
//            end: Alignment.bottomCenter,
//            colors: const <Color>[
//              Colors.black,
//              Color(0xFF2F3436),
//              Colors.black,
//            ],
//          ),
        ),
        child: Center(
          child: Text(
            '$num',
            style: TextStyle(
                fontSize: 160,
                fontWeight: FontWeight.w900,
                fontFamily: 'NanumGothic',
//                color: widget.type > 4 ? Colors.blueAccent : Colors.yellow),
                color: widget.type > 4 ? Colors.white : Colors.yellow),
          ),
        ),
      ),
    );
  }

  Widget _flipCard(int num) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Transform(
          transform: Matrix4.identity()
            ..setEntry(_row, _col, _v)
            ..rotateX(_startAngle),
          child: ClipRect(
            child: Align(
              heightFactor: 0.5,
              alignment: Alignment.topCenter,
              child: _timeText(num),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: _padding, bottom: _padding),
        ),
        Transform(
          alignment: Alignment.topCenter,
          transform: Matrix4.identity()
            ..setEntry(_row, _col, _v)
            ..rotateX(_isRevers ? _endAngle : -_animation.value),
          child: ClipRect(
            child: Align(
              heightFactor: 0.5,
              alignment: Alignment.bottomCenter,
              child: _timeText(num),
            ),
          ),
        ),
      ],
    );
  }

  Widget _flipUpCard(int num) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Transform(
          alignment: Alignment.bottomCenter,
          transform: Matrix4.identity()
            ..setEntry(_row, _col, _v)
            ..rotateX(_isRevers ? (_animation.value) : -_endAngle),
          child: ClipRect(
            child: Align(
              heightFactor: 0.5,
              alignment: Alignment.topCenter,
              child: _timeText(num),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: _padding, bottom: _padding),
        ),
        Transform(
          alignment: Alignment.topCenter,
          transform: Matrix4.identity()
            ..setEntry(_row, _col, _v)
            ..rotateX(math.pi / 2),
          child: ClipRect(
            child: Align(
              heightFactor: 0.5,
              alignment: Alignment.bottomCenter,
              child: _timeText(num),
            ),
          ),
        ),
      ],
    );
  }

  Widget _flipDownCard(int num) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Transform(
          alignment: Alignment.topCenter,
          transform: Matrix4.identity()
            ..setEntry(_row, _col, _v)
            ..rotateX(0),
          child: ClipRect(
            child: Align(
              heightFactor: 0.5,
              alignment: Alignment.topCenter,
              child: _timeText(num),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: _padding, bottom: _padding),
        ),
        Transform(
          alignment: Alignment.topCenter,
          transform: Matrix4.identity()
            ..setEntry(_row, _col, _v)
            ..rotateX(0),
          child: ClipRect(
            child: Align(
              heightFactor: 0.5,
              alignment: Alignment.bottomCenter,
              child: _timeText(num),
            ),
          ),
        ),
      ],
    );
  }
}
