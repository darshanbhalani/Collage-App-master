import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../app/util/VariablesFile.dart';

class EventPage extends StatefulWidget {
  const EventPage({Key? key}) : super(key: key);

  @override
  State<EventPage> createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(clicked_event_title),
      ),
      // drawer: SideMenu(),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Container(
              height: 220,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage(clicked_event_coverphoto!),
                    fit: BoxFit.cover),
                color: Colors.lightBlueAccent[100],
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Last Date of Registration :- " +
                    clicked_event_duedate.toString().substring(0, 10)),
                SizedBox(height: 5),
                Text("Coordinator :- " + clicked_event_coordinator),
                Divider(),
                Text(
                  "          " + clicked_event_about,
                  style: (TextStyle(fontSize: 16)),
                ),
                SizedBox(height: 20),
                Visibility(
                  visible:
                      clicked_event_link != null && clicked_event_link != "",
                  child: Center(
                    child: ElevatedButton(
                        onPressed: () async {
                          final Uri _url = Uri.parse(clicked_event_link!);
                          await _launchUrl(_url);
                          print(clicked_event_link);
                        },
                        child: Text("Register Now..")),
                  ),
                ),
              ],
            )),
          )
        ],
      ),
    );
  }

  Future<void> _launchUrl(_url) async {
    if (!await launchUrl(_url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $_url');
    }
  }
}
