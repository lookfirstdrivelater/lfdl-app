import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'drawer.dart';


//Self-reporting page
class ReportPage extends StatefulWidget {

  @override
  State createState() => ReportPageState();

  static const route = "/report";
}

class ReportPageState extends State<ReportPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Report")),
      drawer: buildDrawer(context, ReportPage.route),
      body: Text("Report"),
    );
  }
}