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
          "Our final selection is to combine the self reporting app and API aggregation concepts. The concept would require a database system to store, send, and receive information. It would also require new APIs to be manually added to the database or an automatic system for other developers to add APIs to the database. This concept would also require a database with user-reported data. The website would access a server to get information. This server would need to be maintained and updated so that the information on the website is current and accurate. This concept would require a database and a server to provide a place for our data to be located in a central place. Then we would have an Android app that would then make requests to the server so all the phones have the same data.",
            style: TextStyle(fontSize: 20)
        ),
      ),
    );
  }
}