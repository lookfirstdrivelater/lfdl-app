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
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Text(
            "Snowy roads have been a long-standing problem for car travel during wintry weather. Snowy, icy, and slushy roads have all contributed to dangerous road conditions which lead to crashes, injuries, and even death. In addition, winter weather causes traffic delays. In our survey, we found that the majority of people are affected by problems with snowy roads including delays. Although we cannot eliminate these road conditions, we can plan for them and hopefully take the appropriate precautions. Our project aims to prevent needless deaths and reduce time wasted from traffic delays caused by wintry road conditions. We will accomplish this by developing an app that allows users to report road conditions and see road conditions that others have reported. This app will use Flutter to ensure cross-compatibility with both Android and iOS phones. It will have a database and a server to store information in a central place. The app would send/receive data to/from this server. This solution will hopefully clearly and accurately display road conditions. This will allow users to take precautions against these conditions and make wintry roads a safer place",
            style: TextStyle(fontSize: 20)
        ),
      ),
    );
  }
}