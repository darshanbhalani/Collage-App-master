import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class EventPage extends StatefulWidget {
  final String title;
  final String coverPhoto;
  final String about;
  final String link;
  final String coordinator;
  final String dueDate;

  const EventPage(
      {Key? key,
      required this.title,
      required this.coverPhoto,
      required this.about,
      required this.link,
      required this.coordinator,
      required this.dueDate})
      : super(key: key);

  @override
  State<EventPage> createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    print(width);
    bool isMobile = false;
    bool isDesktop = false;
    if(width<=800){
      setState(() {
        isMobile = true;
      });
    }
    else {
      setState(() {
        isDesktop = true;
      });
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: !isDesktop ? ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Container(
              height: isMobile ? 220:width/2,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage(widget.coverPhoto), fit: BoxFit.cover),
                color: Colors.white54,
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
                    widget.dueDate.toString().substring(0, 10)),
                SizedBox(height: 5),
                Text("Coordinator :- " + widget.coordinator),
                Divider(),
                Text(
                  "          " + widget.about,
                  style: (TextStyle(fontSize: 16)),
                ),
                SizedBox(height: 20),
                Visibility(
                  visible: widget.link != null && widget.link != "",
                  child: Center(
                    child: ElevatedButton(
                        onPressed: () async {
                          final Uri _url = Uri.parse(widget.link!);
                          await _launchUrl(_url);
                        },
                        child: Text("Register Now..")),
                  ),
                ),
              ],
            )),
          )
        ],
      ):
      Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: Container(
            height: isMobile ? MediaQuery.of(context).size.width:MediaQuery.of(context).size.width/2,
            width: isMobile ? MediaQuery.of(context).size.width:MediaQuery.of(context).size.width/2,
            // height: 220,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: NetworkImage(widget.coverPhoto!), fit: BoxFit.fill),
              color: Colors.white54,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        // SizedBox(width: 10),
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Last Date of Registration :- " +
                          widget.dueDate.toString().substring(0, 10)),
                      SizedBox(height: 5),
                      Text("Coordinator :- " + widget.coordinator),
                      Divider(),
                      Text(
                        "          " + widget.about,
                        style: (TextStyle(fontSize: 16)),
                      ),
                      SizedBox(height: 20),
                      Visibility(
                        visible: widget.link != null && widget.link != "",
                        child: Center(
                          child: ElevatedButton(
                              onPressed: () async {
                                final Uri _url = Uri.parse(widget.link!);
                                await _launchUrl(_url);
                              },
                              child: Text("Register Now..")),
                        ),
                      ),
                    ],
                  )),
            ),
          ),
        ),
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
