import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CustomPicker extends StatefulWidget {
  final void Function(File _pickedImage) imageFn;

  const CustomPicker(
    this.imageFn, {
    Key? key,
  }) : super(key: key);
  @override
  _CustomPickerState createState() => _CustomPickerState();
}

class _CustomPickerState extends State<CustomPicker> {
  File? _pickedFile;

  void _pickImage() async {
    final picker = ImagePicker();
    PickedFile? pickedFile;
    int? mode;

    FocusScope.of(context).unfocus();
    await showModalBottomSheet(
        context: context,
        builder: (_) {
          final theme = Theme.of(context);
          return Container(
            height: 100,
            color: theme.primaryColor,
            child: ButtonBar(
              alignment: MainAxisAlignment.start,
              children: [
                Column(
                  children: [
                    IconButton(
                      color: theme.primaryIconTheme.color,
                      icon: Icon(Icons.camera),
                      onPressed: () {
                        mode = 0;
                        Navigator.pop(context);
                      },
                    ),
                    Text(
                      'Camera',
                      style: theme.primaryTextTheme.subtitle1,
                    ),
                  ],
                ),
                SizedBox(width: 10),
                Column(
                  children: [
                    IconButton(
                      color: theme.primaryIconTheme.color,
                      icon: Icon(Icons.image),
                      onPressed: () {
                        mode = 1;
                        Navigator.pop(context);
                      },
                    ),
                    Text(
                      'Gallery',
                      style: theme.primaryTextTheme.subtitle1,
                    ),
                  ],
                ),
              ],
            ),
          );
        });
    if (mode == null) return;
    if (mode == 0) {
      pickedFile = await picker.getImage(
        source: ImageSource.camera,
        maxWidth: 150,
        // imageQuality: 50,
      );
    } else {
      pickedFile = await picker.getImage(
        source: ImageSource.gallery,
        maxWidth: 150,
        // imageQuality: 50,
      );
    }
    if (pickedFile != null) {
      setState(() {
        _pickedFile = File(pickedFile!.path);
      });
      widget.imageFn(_pickedFile!);
    }
  }

  @override
  Widget build(BuildContext context) {
    ImageProvider backgroundImage;

    /// Background Image for CircleAvatar
    if (_pickedFile == null)
      backgroundImage = ExactAssetImage('assets/images/placeholder.jpg');
    else
      backgroundImage = FileImage(_pickedFile!);

    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundImage: backgroundImage,
        ),
        TextButton.icon(
          icon: Icon(Icons.image),
          label: Text('Pick Image'),
          style: ButtonStyle(
              foregroundColor:
                  MaterialStateProperty.all(Theme.of(context).primaryColor)),
          onPressed: _pickImage,
        ),
      ],
    );
  }
}
