import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hamstart/models/product.dart';

class EditItemScreen extends StatefulWidget {
  static const routeName = '/edit_item';
  final String categoryId;
  final Product product;

  EditItemScreen({@required this.categoryId, this.product});

  @override
  _EditItemScreenState createState() => _EditItemScreenState();
}

class _EditItemScreenState extends State<EditItemScreen> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

  bool _isSaving = false;
  double _qty = 1;
  File _image;
  File _painting;

  @override
  void initState() {
    if (widget.product != null) {
      _titleController.text = widget.product.title;
      _descriptionController.text = widget.product.description;
      _qty = widget.product.quantity;
    }

    super.initState();
  }

  Future<void> _loadImage() async {}
  Future<void> _loadPainting() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit item'),
      ),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    TextField(
                      decoration: InputDecoration(labelText: 'Title'),
                      controller: _titleController,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    TextField(
                      decoration: InputDecoration(labelText: 'Description'),
                      controller: _descriptionController,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: <Widget>[
                        Text('QTY:'),
                        Expanded(
                          child: Slider(
                            label: 'QTY: ',
                            value: _qty,
                            onChanged: (val) {
                              setState(() {
                                _qty = val;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text('Image'),
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                          height: 200,
                          width: 200,
                          child: FutureBuilder(
                            future: _loadImage(),
                            builder: (ctx, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting)
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              return _image != null
                                  ? Image.file(
                                      _image,
                                      fit: BoxFit.cover,
                                    )
                                  : Image.asset('assets/images/s1200.jpg');
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text('Painting'),
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                          height: 200,
                          width: 200,
                          child: FutureBuilder(
                            future: _loadImage(),
                            builder: (ctx, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting)
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              return _painting != null
                                  ? Image.file(
                                      _painting,
                                      fit: BoxFit.cover,
                                    )
                                  : Image.asset('assets/images/s1200.jpg');
                            },
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            _isSaving
                ? Center(child: CircularProgressIndicator())
                : RaisedButton.icon(
                    onPressed: () {},
                    icon: Icon(Icons.add),
                    label: Text('Save item'),
                    elevation: 0,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    color: Theme.of(context).accentColor,
                  )
          ],
        ),
      ),
    );
  }
}