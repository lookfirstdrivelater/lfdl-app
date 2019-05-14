import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import '../drawer.dart';

class AboutPage extends StatefulWidget {
  @override
  State createState() => AboutPageState();

  static const route = "/about";
}

class AboutPageState extends State<AboutPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("About"),
        ),
        drawer: buildDrawer(context, AboutPage.route),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(20.0),
              child: Text(
                    "Snowy roads have been a long-standing problem for car travel during wintry weather.\n"
                    "Snowy, icy, and slushy roads have all contributed to dangerous road conditions which lead to crashes, injuries, and even death.\n"
                        "In addition to this, winter weather causes traffic delays.\n"
                        "In our survey, we found that the majority of people are affected by problems with snowy roads such as it causing accidents and delays.\n"
                        "Although we cannot eliminate these road conditions, we can plan for them and hopefully take the appropriate precautions.\n"
                        "Our project aims to prevent needless deaths and reduce time wasted from traffic delays caused by wintry road conditions.\n"
                        "We have attempted to solve this by developing this app.\n"
                        "This app allows users to report road conditions and see road conditions that others have reported.\n"
                        "This app uses a software framework, which means that it works on both Android and iOS phones.\n"
                        "This app uses server with a database to store and transmit road information.\n"
                        "This solution will hopefully clearly and accurately display road conditions. This will allow users to take precautions against these conditions and make wintry roads a safer place",
                style: TextStyle(fontSize: 20)),
          ),
        ));
  }
}
