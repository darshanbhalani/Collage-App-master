import 'package:flutter/material.dart';

class PopupButton extends StatefulWidget {
  const PopupButton({Key? key}) : super(key: key);

  @override
  State<PopupButton> createState() => _PopupButtonState();
}

class _PopupButtonState extends State<PopupButton> {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
        position: PopupMenuPosition.under,
        itemBuilder: ((context) {
          return [
            PopupMenuItem(
              child: const Text('Refresh'),
              onTap: () {
                setState(() {});
              },
            ),
          ];
        }));
  }
}
