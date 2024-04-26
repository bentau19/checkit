class Tools {
  double durationMaker(int time) {
    return ((time).toDouble() / 6) * 7.6;
  }

  String fromNumToStringTime(int time) {
    int hour = (time / 60).floor();
    int minute = time % 60;
    String shour = (hour < 10) ? "0$hour" : hour.toString();
    String sminute = (minute < 10) ? "0$minute" : minute.toString();
    return "$shour:$sminute";
  }
}
