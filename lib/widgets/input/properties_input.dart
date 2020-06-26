import 'package:flutter/material.dart';
import 'package:hamstart/models/item_property.dart';

class PropertiesInput extends StatefulWidget {
  final Map<String, dynamic> properties;
  final Function onPropertiesChanged;
  PropertiesInput({this.properties, this.onPropertiesChanged});

  @override
  _PropertiesInputState createState() => _PropertiesInputState();
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

  void updateProperties() {
    for (int i = 0; i < properties.length; i++) {
      properties[i].title = titles[i].text;
      properties[i].value = values[i].text;
    }
    widget.onPropertiesChanged(properties);
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
                    onChanged: (_) {
                      updateProperties();
                    },
                  ),
                  width: 100,
                ),
                SizedBox(
                  width: 10,
                ),
                Container(
                  child: TextField(
                    controller: values[idx],
                    onChanged: (_) {
                      updateProperties();
                    },
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
