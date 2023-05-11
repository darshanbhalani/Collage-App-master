import 'package:flutter/material.dart';

class PopupButton extends StatelessWidget {
  const PopupButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
        position: PopupMenuPosition.under,
        itemBuilder: ((context) {
          return [
            PopupMenuItem(
              child: const Text('Refresh'),
              onTap: () {},
            ),
            PopupMenuItem(
              child: const Text('Scanner'),
            ),
            PopupMenuItem(
              child: const Text('Report'),
              onTap: () {},
            ),
          ];
        }));
  }
}
