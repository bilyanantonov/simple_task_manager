import 'package:flutter/material.dart';

class EventModel {
  final int id;
  final String title;
  final String description;
  final DateTime eventDate;
  final TimeOfDay time;

  EventModel(
      {this.id, this.title, this.description, this.eventDate, this.time});

  factory EventModel.fromMap(Map data) {
    return EventModel(
        id: data['id'],
        title: data['title'],
        description: data['description'],
        eventDate: DateTime.parse(data['eventDate']),
        time: TimeOfDay(
            hour: int.parse(data['time'].split(":")[0]),
            minute: int.parse(data['time'].split(":")[1])));
  }

  factory EventModel.fromJson(int id, Map<String, dynamic> data) {
    return EventModel(
        id: id,
        title: data['title'],
        description: data['description'],
        eventDate: data['eventDate'].toDate(),
        time: TimeOfDay(
            hour: data['time'].split(":")[0],
            minute: data['time'].split(":")[1]));
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "title": title,
      "description": description,
      "eventDate": eventDate,
      "time": time
    };
  }
}
