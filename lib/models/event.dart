class EventModel{
  final String id;
  final String title;
  final String description;
  final DateTime eventDate;

  EventModel({this.id,this.title, this.description, this.eventDate});

  factory EventModel.fromMap(Map data) {
    return EventModel(
      title: data['title'],
      description: data['description'],
      eventDate: data['event_date'],
    );
  }

  factory EventModel.froJson(String id, Map<String,dynamic> data) {
    return EventModel(
      id: id,
      title: data['title'],
      description: data['description'],
      eventDate: data['event_date'].toDate(),
    );
  }

  Map<String,dynamic> toMap() {
    return {
      "title":title,
      "description": description,
      "event_date":eventDate,
      "id":id,
    };
  }
}