import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import 'PopupButton.dart';

class About extends StatelessWidget {
  About({Key? key}) : super(key: key);
  final Uri _youtube = Uri.parse('https://youtube.com/@ldrp-itr578');
  final Uri _facebook =
      Uri.parse('https://www.facebook.com/ldrpitr?mibextid=ZbWKwL');
  final Uri _twitter =
      Uri.parse('https://twitter.com/askldrp?t=xsFMJGm0-7MDODLd58YAfg&s=08');
  final Uri _instagram =
      Uri.parse('https://instagram.com/ldrp_gandhinagar?igshid=YmMyMTA2M2Y=');
  final Uri _linkedIn = Uri.parse(
      'https://www.linkedin.com/school/ldrp-institute-of-technology-research-gujarat-technological-university-india/');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("About LDRP-ITR"),
        actions: [
          PopupButton(),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  height: 150,
                  child: Image(
                    image: AssetImage("assets/images/collage.jpg"),
                    fit: BoxFit.cover,
                  )),
              SizedBox(
                height: 15,
              ),
              Text(
                "Welcome to LDRP – ITR (A Constituent College of KSV)",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                  "          LDRP INSTITUTE OF TECHNOLOGY AND RESEARCH, Gandhinagar was established in 2005 – 2006. The college has made steady progress during the past one year of its existence. Established as a pace setting Institute of Technical Education imparting undergraduate and postgraduate education, it has played a vital role in engineering colleges of Gujarat. In this mission today it has progressed to offering several B.E., M.B.A. and M.C.A. Programs and facilities."),
              Divider(),
              Center(
                  child: Text(
                "Contact",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              )),
              SizedBox(
                height: 10,
              ),
              Text(
                "Address : ",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                  "\t\tLDRP Institute of Technology & Research,\n\t\tNear KH-5,\n\t\tSector-15,\n\t\tGandhinagar - 382015."),
              SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  Text("Email : ",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text("info@ldrp.ac.in")
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  Text("Phone : ",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(" + 91 - 079 - 23241492")
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  Text("Fax : ", style: TextStyle(fontWeight: FontWeight.bold)),
                  Text("+ 91 - 079 - 23241493")
                ],
              ),
              Divider(),
              SizedBox(
                height: 10,
              ),
              Center(
                  child: Text("Follow US on",
                      style: TextStyle(
                          fontSize: 15, fontWeight: FontWeight.bold))),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap: () async {
                      await _launchUrl(_youtube);
                    },
                    child: Container(
                      child: FaIcon(
                        FontAwesomeIcons.youtube,
                        color: Colors.red,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      await _launchUrl(_facebook);
                    },
                    child: Container(
                      child: FaIcon(
                        FontAwesomeIcons.facebook,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      await _launchUrl(_twitter);
                    },
                    child: Container(
                      child:
                          FaIcon(FontAwesomeIcons.twitter, color: Colors.blue),
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      await _launchUrl(_instagram);
                    },
                    child: Container(
                      child: FaIcon(
                        FontAwesomeIcons.instagram,
                        color: Colors.pink,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      await _launchUrl(_linkedIn);
                    },
                    child: Container(
                      child: FaIcon(FontAwesomeIcons.linkedinIn,
                          color: Colors.blueGrey),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _launchUrl(_url) async {
    if (!await launchUrl(_url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $_url');
    }
  }
}
