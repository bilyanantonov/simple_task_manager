import 'package:flutter/material.dart';
import 'package:simple_task_manager/models/event.dart';
import 'package:simple_task_manager/services/db_service.dart';
import 'package:simple_task_manager/utils/database_helper.dart';

class AddEvent extends StatefulWidget {
  final EventModel event;

  const AddEvent({this.event});
  @override
  _AddEventState createState() => _AddEventState();
}

class _AddEventState extends State<AddEvent> {
  DbService dbService;
  DatabaseHelper databaseHelper;
  final _formKey = GlobalKey<FormState>();

  TextStyle style = TextStyle(fontSize: 20.0);
  TextEditingController _title;
  TextEditingController _description;
  DateTime _eventDate;
  TimeOfDay _time;
  bool processing;
  String header = "Add New Task";
  String buttonText = "Save";
  bool addNewTask = true;

  @override
  void initState() {
    super.initState();
    dbService = DbService();
    databaseHelper = DatabaseHelper();
    _title = TextEditingController();
    _description = TextEditingController();
    _eventDate = DateTime.now();
    _time = TimeOfDay.now();
    if (widget.event != null) {
      populateForm();
    }
    processing = false;
  }

  void populateForm() {
    _title.text = widget.event.title;
    _description.text = widget.event.description;
    _eventDate = widget.event.eventDate;
    _time = widget.event.time;
    header = "Update Task";
    buttonText = "Update";
    addNewTask = false;
    setState(() {});
  }

  void saveTask() async {
    if (addNewTask) {
      await databaseHelper.addTask(EventModel(
          title: _title.text,
          description: _description.text,
          eventDate: _eventDate,
          time: _time));
    } else {
      await databaseHelper.updateTask(EventModel(
          id: widget.event.id,
          title: _title.text,
          description: _description.text,
          eventDate: _eventDate,
          time: _time));
    }

    setState(() {
      processing = false;
    });
    await _onBackPressed();
  }

  void deleteTask() async {
    await databaseHelper.deleteTask(widget.event.id);
    setState(() {
      processing = false;
    });
    await _onBackPressed();
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
            Container(
                padding: EdgeInsets.symmetric(horizontal: 32),
                child: Text(header,
                    style:
                        TextStyle(fontSize: 32, fontWeight: FontWeight.bold))),
            Expanded(
              child: Form(
                key: _formKey,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: MediaQuery.removePadding(
                    context: context,
                    removeTop: true,
                    child: ListView(
                      // crossAxisAlignment: CrossAxisAlignment.stretch,
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
                            textInputAction: TextInputAction.done,
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
                          subtitle: Text(_time.format(context)),
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
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: <Widget>[
                                    Material(
                                      elevation: 5.0,
                                      borderRadius: BorderRadius.circular(30.0),
                                      color: Theme.of(context).primaryColor,
                                      child: MaterialButton(
                                        onPressed: () async {
                                          if (_formKey.currentState
                                              .validate()) {
                                            setState(() {
                                              processing = true;
                                            });
                                            saveTask();
                                            // await dbService.addEvent(EventModel(
                                            //     title: _title.text,
                                            //     description: _description.text,
                                            //     eventDate: _eventDate,
                                            //     time: _time));

                                          }
                                        },
                                        child: Text(
                                          buttonText,
                                          style: style.copyWith(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 10.0),
                                    Container(
                                      child: !addNewTask
                                          ? Material(
                                              elevation: 5.0,
                                              borderRadius:
                                                  BorderRadius.circular(30.0),
                                              color: Colors.redAccent,
                                              child: MaterialButton(
                                                onPressed: () async {
                                                  setState(() {
                                                    processing = true;
                                                  });
                                                  deleteTask();
                                                },
                                                child: Text(
                                                  "Delete",
                                                  style: style.copyWith(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                            )
                                          : Container(),
                                    ),
                                  ],
                                ),
                              ),
                      ],
                    ),
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
