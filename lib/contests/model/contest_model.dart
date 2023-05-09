class Contest {
  int duration;
  DateTime? start;
  DateTime? end;
  String event;
  String host;
  String href;
  String id;
  String resource;
  int resourceId;

  Contest({
    required this.duration,
    this.start,
    this.end,
    required this.event,
    required this.host,
    required this.href,
    required this.id,
    required this.resource,
    required this.resourceId,
  });
}
