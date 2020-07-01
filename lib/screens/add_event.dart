import 'package:flutter/material.dart';
import 'package:simple_task_manager/models/event.dart';
import 'package:simple_task_manager/services/db_service.dart';

class AddEvent extends StatefulWidget {
  @override
  _AddEventState createState() => _AddEventState();
}

class _AddEventState extends State<AddEvent> {
  DbService dbService;
  final _formKey = GlobalKey<FormState>();

  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  TextEditingController _title;
  TextEditingController _description;
  DateTime _eventDate;
  TimeOfDay _time;
  bool processing;

  @override
  void initState() {
    super.initState();
    dbService = DbService();
    _title = TextEditingController();
    _description = TextEditingController();
    _eventDate = DateTime.now();
    _time = TimeOfDay.now();
    processing = false;
  }

  Future<bool> _onBackPressed() async {
    Navigator.of(context).pop(true);
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              alignment: Alignment.bottomLeft,
              height: 80,
              child: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
            ),
            Expanded(
              child: Form(
                key: _formKey,
                child: Container(
                  alignment: Alignment.center,
                  child: ListView(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0),
                        child: TextFormField(
                          controller: _title,
                          validator: (value) =>
                              (value.isEmpty) ? "Please Enter title" : null,
                          style: style,
                          decoration: InputDecoration(
                              labelText: "Title",
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10))),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0),
                        child: TextFormField(
                          controller: _description,
                          minLines: 3,
                          maxLines: 5,
                          validator: (value) => (value.isEmpty)
                              ? "Please Enter description"
                              : null,
                          style: style,
                          decoration: InputDecoration(
                              labelText: "description",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10))),
                        ),
                      ),
                      SizedBox(height: 10.0),
                      ListTile(
                        title: Text("Date of Task"),
                        subtitle: Text(
                            "${_eventDate.year} - ${_eventDate.month} - ${_eventDate.day}"),
                        onTap: () async {
                          DateTime picked = await showDatePicker(
                              context: context,
                              initialDate: _eventDate,
                              firstDate: DateTime(_eventDate.year - 5),
                              lastDate: DateTime(_eventDate.year + 5));
                          if (picked != null) {
                            setState(() {
                              _eventDate = picked;
                            });
                          }
                        },
                      ),
                      SizedBox(height: 10.0),
                      ListTile(
                        title: Text("Time of Task"),
                        subtitle: Text(_time.toString()),
                        onTap: () async {
                          TimeOfDay picked = await showTimePicker(
                              context: context, initialTime: _time);

                          if (picked != null) {
                            setState(() {
                              _time = picked;
                            });
                          }
                        },
                      ),
                      SizedBox(height: 10.0),
                      processing
                          ? Center(child: CircularProgressIndicator())
                          : Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Material(
                                elevation: 5.0,
                                borderRadius: BorderRadius.circular(30.0),
                                color: Theme.of(context).primaryColor,
                                child: MaterialButton(
                                  onPressed: () async {
                                    if (_formKey.currentState.validate()) {
                                      setState(() {
                                        processing = true;
                                      });
                                      await dbService.addEvent(EventModel(
                                          title: _title.text,
                                          description: _description.text,
                                          eventDate: _eventDate));

                                      setState(() {
                                        processing = false;
                                      });
                                      await _onBackPressed();
                                    }
                                  },
                                  child: Text(
                                    "Save",
                                    style: style.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
