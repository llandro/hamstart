import 'package:flutter/material.dart';

class PropertiesInput extends StatefulWidget {
  final Map<String, dynamic> properties;
  PropertiesInput(this.properties);

  @override
  _PropertiesInputState createState() => _PropertiesInputState();
}

class ItemProperty {
  String title;
  String value;
  ItemProperty({this.title, this.value});
}

class _PropertiesInputState extends State<PropertiesInput> {
  List<TextEditingController> titles = [];
  List<TextEditingController> values = [];
  List<ItemProperty> properties = [];

  @override
  void initState() {
    super.initState();
    widget.properties.forEach(
      (key, value) {
        titles.add(
          TextEditingController(
            text: key,
          ),
        );
        values.add(
          TextEditingController(
            text: value,
          ),
        );
        properties.add(
          ItemProperty(
            title: key,
            value: value,
          ),
        );
      },
    );
  }

  void addNewField() {
    titles.add(
      TextEditingController(),
    );
    values.add(
      TextEditingController(),
    );
    setState(() {
      properties.add(
        ItemProperty(title: '', value: ''),
      );
    });
  }

  void removeField(int idx) {
    titles.removeAt(idx);
    values.removeAt(idx);
    setState(() {
      properties.removeAt(idx);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ...properties.map(
          (e) {
            final idx = properties.indexOf(e);
            return Row(
              children: <Widget>[
                Container(
                  child: TextField(
                    controller: titles[idx],
                  ),
                  width: 100,
                ),
                SizedBox(
                  width: 10,
                ),
                Container(
                  child: TextField(
                    controller: values[idx],
                  ),
                  width: 200,
                ),
                SizedBox(
                  width: 10,
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    removeField(idx);
                  },
                )
              ],
            );
          },
        ).toList(),
        RaisedButton(
          child: Text('Add new field'),
          color: Colors.blue,
          onPressed: addNewField,
        )
      ],
    );
  }
}
