import 'dart:async';
import 'package:flutter/material.dart';

Timer? countdownTimer;
String totalTime = '';
ValueNotifier<Duration> durationValue1 =
    ValueNotifier<Duration>(Duration(days: 1));
ValueNotifier<String> incrementedBalance = ValueNotifier<String>("");
bool isTimerSet = false;
double currentspeed = 0.0;
int timerValue = 0;

addCounterTime() async {
  int decrement = 1;
  int seconds = durationValue1.value.inSeconds - decrement;
  if (seconds < 0) {
    seconds = 0;
    countdownTimer!.cancel();
    totalTime = "";
  } else {
    durationValue1.value = Duration(seconds: seconds);
    var incrementedSpeed = currentspeed / 3600;

    double currentbalanceUpdate = double.parse(incrementedBalance.value);
    currentbalanceUpdate = currentbalanceUpdate + incrementedSpeed;

    incrementedBalance.value = "${currentbalanceUpdate.toStringAsFixed(5)}";
    incrementedBalance.notifyListeners();
  }
}

void setDuration(Duration duration) {
  durationValue1 = ValueNotifier<Duration>(duration);
}

void setCurrentSpeed(double speed) {
  currentspeed = speed;
}

void setCurrentBalance(String curBalance) {
  incrementedBalance = ValueNotifier<String>(curBalance);
}

resetTimer() {
  timerValue = 0;
  totalTime = "";
}

StopTimer() {
  isTimerSet = false;
  timerValue = 0;
  totalTime = "";
  if (countdownTimer != null) {
    countdownTimer!.cancel();
  }
}

void startCounterTimer() {
  if (!isTimerSet) {
    countdownTimer = Timer.periodic(Duration(seconds: 1), (_) {
      addCounterTime();
    });
    isTimerSet = true;
  }
}
