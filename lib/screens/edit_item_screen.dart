import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hamstart/models/product.dart';
import 'package:hamstart/providers/products.dart';
import 'package:hamstart/screens/image_picker_screen.dart';
import 'package:hamstart/widgets/input/properties_input.dart';
import 'package:provider/provider.dart';
import 'package:hamstart/widgets/input/image_getter.dart';
import 'package:hamstart/models/item_property.dart';
import 'package:hamstart/services/image_loader.dart';

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
  Map<String, dynamic> _properties = {};

  @override
  void initState() {
    if (widget.product != null) {
      _titleController.text = widget.product.title;
      _descriptionController.text = widget.product.description;
      _qty = widget.product.quantity;
      _properties = widget.product.additionalFields;
    }

    super.initState();
  }

  Future<void> _loadImage() async {
    File file = await ImageLoader.loadImage(widget.product.imageURL);
    _image = file;
  }

  Future<void> _loadPainting() async {
    File file = await ImageLoader.loadImage(widget.product.paintingURL);
    _painting = file;
  }

  Future<void> _saveItem() async {
    setState(() {
      _isSaving = true;
    });
    if (widget.product != null) {
      await Provider.of<Products>(context, listen: false).updateItem(
        productId: widget.product.productId,
        categoryId: widget.categoryId,
        title: _titleController.text,
        description: _descriptionController.text,
        quantity: _qty,
        image: _image,
        painting: _painting,
        additionalFields: _properties,
        additionalImages: [],
      );
    } else {
      await Provider.of<Products>(context, listen: false).addProduct(
        categoryId: widget.categoryId,
        title: _titleController.text,
        description: _descriptionController.text,
        quantity: _qty,
        image: _image,
        painting: _painting,
        additionalFields: _properties,
        additionalImages: [],
      );
    }
    Navigator.of(context).pop();
  }

  void _onPropertiesChanged(List<ItemProperty> newProperties) {
    if (newProperties != null) {
      Map<String, dynamic> newPropertiesMap = {};
      for (int i = 0; i < newProperties.length; i++) {
        if (newProperties[i].title.trim() != '') {
          newPropertiesMap[newProperties[i].title] = newProperties[i].value;
        }
      }
      _properties = newPropertiesMap;
    }
  }

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
                    FutureBuilder(
                      future: _loadImage(),
                      builder: (ctx, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting)
                          return Container();
                        return ImageGetter(
                          title: 'Image',
                          loadImage: _loadImage,
                          image: _image,
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => ImagePickerScreen(
                                  title: 'Image',
                                  previousImage: _image,
                                  onSelectImage: (File newImage) {
                                    setState(() {
                                      _image = newImage;
                                    });
                                  },
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),

                    SizedBox(
                      height: 5,
                    ),
                    FutureBuilder(
                      future: _loadPainting(),
                      builder: (ctx, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting)
                          return Container();
                        return ImageGetter(
                          title: 'Painting',
                          loadImage: _loadPainting,
                          image: _painting,
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => ImagePickerScreen(
                                  title: 'Painting',
                                  previousImage: _painting,
                                  onSelectImage: (File newImage) {
                                    setState(() {
                                      _painting = newImage;
                                    });
                                  },
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                    //additional fields
                    PropertiesInput(
                      properties: _properties,
                      onPropertiesChanged: _onPropertiesChanged,
                    ),
                  ],
                ),
              ),
            ),
            _isSaving
                ? Center(child: CircularProgressIndicator())
                : RaisedButton.icon(
                    onPressed: _saveItem,
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
