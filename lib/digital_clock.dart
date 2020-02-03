import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'model.dart';
import 'dart:math' as math;
import 'package:intl/intl.dart';

enum _Element {
  background,
  text,
  shadow,
}

final _lightTheme = {
  _Element.background: Colors.white,
  _Element.text: Colors.black,
  _Element.shadow: Colors.grey,
};

final _darkTheme = {
  _Element.background: Colors.black,
  _Element.text: Colors.white,
  _Element.shadow: Color(0xFF174EA6),
};

class DigitalClock extends StatefulWidget {
  const DigitalClock(this.model);
  final ClockModel model;
  @override
  _DigitalClockState createState() => _DigitalClockState();
}

class _DigitalClockState extends State<DigitalClock> {
  DateTime _dateTime = DateTime.now();
  Timer _timer;

  @override
  void initState() {
    super.initState();
    widget.model.addListener(_updateModel);
    _updateTime();
    _updateModel();

//    _updateTime2();
  }

  @override
  void didUpdateWidget(DigitalClock oldWidget) {
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
      // Cause the clock to rebuild when the model changes.
      _temperature = widget.model.temperatureString;
      _temperatureRange = '(${widget.model.low} - ${widget.model.highString})';
      _condition = widget.model.weatherString;
      _location = widget.model.location;
    });
  }

  void _updateTime() {
    setState(() {
      _dateTime = DateTime.now();
      // Update once per minute. If you want to update every second, use the
      // following code.
//      _timer = Timer(
//        Duration(minutes: 1) -
//            Duration(seconds: _dateTime.second) -
//            Duration(milliseconds: _dateTime.millisecond),
//        _updateTime,
//      );
      // Update once per second, but make sure to do it at the beginning of each
      // new second, so that the clock is accurate.
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
    final hour = _dateTime.hour;

//    DateFormat(widget.model.is24HourFormat ? 'HH' : 'hh').format(_dateTime);
//    final minute = DateFormat('mm').format(_dateTime);
    final minute = _dateTime.minute;

    final fontSize = MediaQuery.of(context).size.width / 3.5;
    final offset = -fontSize / 7;
    final defaultStyle = TextStyle(
      color: colors[_Element.text],
      fontFamily: 'PressStart2P',
      fontSize: fontSize,
      shadows: [
        Shadow(
          blurRadius: 0,
          color: colors[_Element.shadow],
          offset: Offset(10, 0),
        ),
      ],
    );

    var _weatherIcons = {
      'cloudy': Icon(
        Icons.wb_cloudy,
        color: Colors.blueGrey,
      ),
      'foggy': Icon(
        Icons.cloud_off,
        color: Colors.grey,
      ),
      'rainy': Icon(
        Icons.beach_access,
        color: Colors.grey,
      ),
      'snowy': Icon(
        Icons.ac_unit,
        color: Colors.white,
      ),
      'sunny': Icon(
        Icons.wb_sunny,
        color: Colors.yellow,
      ),
      'thunderstorm': Icon(
        Icons.flash_on,
        color: Colors.white,
      ),
      'windy': Icon(
        Icons.clear_all,
        color: Colors.white,
      ),
    };

    Widget getAMPM() {
      Color amColor = _dateTime.hour > 11 ? Colors.white : Colors.yellow;
      Color pmColor = _dateTime.hour > 11 ? Colors.yellow : Colors.white;

      return Padding(
        padding: const EdgeInsets.all(8.0),
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

    Widget getWeather() {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircleAvatar(
              backgroundColor: Colors.black,
              child: _weatherIcons[_condition],
            ),
            SizedBox(
              height: 20,
            ),
            CircleAvatar(
              backgroundColor: Colors.black,
              child: AspectRatio(
                aspectRatio: 1,
                child: Center(
                  child: Text(
                    '$_temperature',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 11),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

//    Widget getTemp() {
//      return Text('22°');
//    }

    double _dateWidth = 8.0;
    Widget getDateView() {
      return Container(
        width: 60,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.black,
                border: Border.all(
                  width: 1.0,
                  color: Colors.black,
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(_dateWidth),
                  topRight: Radius.circular(_dateWidth),
                ),
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(
                    '${_dateTime.year}.${_dateTime.month}',
                    style: TextStyle(fontSize: 12, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  width: 1.0,
                  color: Colors.black,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(_dateWidth),
                  bottomRight: Radius.circular(_dateWidth),
                ),
              ),
              child: Center(
                child: Text(
                  '${_dateTime.day}',
                  style: TextStyle(fontSize: 32, color: Colors.black),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return AspectRatio(
      aspectRatio: 5/3,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
//            getDateView(),
              SizedBox(
                width: 16,
              ),
              Text(
                '$_location',
                style: TextStyle(
                  fontSize: 50,
//                fontFamily: 'NanumGothic',
                  fontFamily: 'SourceSansPro',
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
//        Text(
//          '$_condition $_temperature $_temperatureRange',
//          style: TextStyle(fontSize: 20, color: Colors.red),
//        ),
          SizedBox(
            height: 10,
          ),
          Text(
            '${DateFormat.yMMMd().format(_dateTime)}',
            style: TextStyle(fontSize: 30, color: Colors.blueGrey),
          ),
//        SizedBox(
//          height: 96,
//        ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TimeCard(widget.model, _dateTime, 1, [0, 1]),
              TimeCard(
                  widget.model, _dateTime, 2, [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]),
              getAMPM(),
              TimeCard(widget.model, _dateTime, 3, [0, 1, 2, 3, 4, 5]),
              TimeCard(
                  widget.model, _dateTime, 4, [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]),
              getWeather(),
              TimeCard(widget.model, _dateTime, 5, [0, 1, 2, 3, 4, 5]),
              TimeCard(
                  widget.model, _dateTime, 6, [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]),
            ],
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
        now = check > 9 ? 1 : 0;
        break;
      case 2:
        now = check > 9 ? check - 10 : check;
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
          _controller.forward();
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

    return Container(
      color: Colors.transparent,
      child: Stack(
        children: <Widget>[
          _flipDownCard(nextNum),
          _flipCard(pastNum),
          _flipUpCard(nextNum),
        ],
      ),
    );
  }



  var _timeStyle = TextStyle(
    fontSize: 160,
    color: Colors.blueAccent,
  );

  final double _padding = 2.0;

  Widget _timeText(num) {
    return Padding(
      padding: const EdgeInsets.all(1.0),
      child: Container(
        width: 140,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(
          color: Colors.white,
            width: 1.0,
          ),
          color: Colors.black,
        ),
        child: Center(
          child: Text(
            '$num',
            style: TextStyle(
                fontSize: 160,
                fontWeight: FontWeight.w900,
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
          padding: EdgeInsets.only(top: _padding),
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
          padding: EdgeInsets.only(top: _padding),
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
          padding: EdgeInsets.only(top: _padding),
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
