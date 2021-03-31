import 'package:flutter/material.dart';

class CustomDialog extends StatelessWidget {
  const CustomDialog({
    Key? key,
    required this.theme,
  }) : super(key: key);

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    final TextEditingController _controller = TextEditingController();
    return Dialog(
      child: Container(
        margin: const EdgeInsets.fromLTRB(24, 24, 24, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 20),
              child: Text('Delete Account',
                  textAlign: TextAlign.left, style: theme.textTheme.headline6),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 20),
              child: Text(
                'Enter Password to continue',
                textAlign: TextAlign.left,
                style: theme.textTheme.subtitle1,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              child: TextField(
                controller: _controller,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Password',
                  contentPadding: EdgeInsets.fromLTRB(20, 5, 10, 5),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  child: Text('Cancel'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                TextButton(
                  child: Text('Delete'),
                  onPressed: () {
                    Navigator.pop(context, _controller.text);
                  },
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
