import 'package:flutter/material.dart';
//import 'package:image_picker/image_picker.dart';
//import 'dart:io';

class ImagePickerWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ImagePickerWidgetState();
  }
}

class ImagePickerWidgetState extends State<ImagePickerWidget> {
 /*  void _getImage(BuildContext context, ImageSource source) {
    ImagePicker.pickImage(source: source, maxWidth: 400.0)
        .then((File image) {
          Navigator.pop(context);
        });
  } */

  void _openImagePicker(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 150.0,
            padding: EdgeInsets.all(10.0),
            child: Column(
              children: <Widget>[
                Text(
                  'Pick an image',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10.0,
                ),
                FlatButton(
                  textColor: Theme.of(context).primaryColor,
                  child: Text('Use camera'),
                  onPressed: () {
                    //_getImage(context, ImageSource.camera);
                  },
                ),
                SizedBox(
                  height: 5.0,
                ),
                FlatButton(
                  textColor: Theme.of(context).primaryColor,
                  child: Text('Open gallery'),
                  onPressed: () {
                    //_getImage(context, ImageSource.gallery);
                  },
                ),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        OutlineButton(
          onPressed: () {
            _openImagePicker(context);
          },
          borderSide: BorderSide(
            color: Theme.of(context).primaryColor,
            width: 1.5,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.camera_alt,
                color: Theme.of(context).primaryColor,
              ),
              SizedBox(width: 5.0),
              Text(
                'Take a photo',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
