import 'dart:io';

import 'package:flutter/material.dart';
import '../../../../app/util/PopupButton.dart';

class DownloadPage extends StatefulWidget {
  final List<FileSystemEntity> folders;
  const DownloadPage({Key? key, required this.folders}) : super(key: key);

  @override
  State<DownloadPage> createState() => _DownloadPageState();
}

class _DownloadPageState extends State<DownloadPage> {
  late List<FileSystemEntity> _folders;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _folders = widget.folders;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Downloads"),
          actions: [
            PopupButton(),
          ],
        ),
        body: (_folders.isNotEmpty)
            ? ListView.builder(
                itemCount: _folders.length,
                itemBuilder: (context, index) => ListTile(
                  title: Text(_folders[index].path.split('/').last),
                  trailing: PopupMenuButton(
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        child: Text("Delete"),
                        onTap: () {
                          _folders[index].delete();

                          _folders.remove(_folders[index]);
                          setState(() {});
                        },
                      )
                    ],
                  ),
                ),
              )
            : Center(
                child: Text('No Downloads'),
              ));
  }
}
