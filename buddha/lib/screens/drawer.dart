import 'package:buddha/utils/colors.dart';
import 'package:buddha/widgets/text.dart';
import 'package:flutter/material.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({Key? key}) : super(key: key);

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.25,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [parrotGreen, blue],
                end: Alignment.bottomRight,
                begin: Alignment.topLeft,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                displayText(text: "WELCOME TO", fontSize: 13, color: white),
                const SizedBox(
                  height: 5,
                ),
                displayText(text: "BUDDHA LOUNGE", fontSize: 22, color: white),
              ],
            ),
          ),
          options("How To Use?", () {}),
          divider(),
          options("About Us", () {}),
          divider(),
          options("Rate Us", () {}),
          divider(),
          options("Feedback", () {}),
          divider(),
          options("Contact Us", () {}),
        ],
      ),
    );
  }

  Widget options(text, VoidCallback ontap) {
    return InkWell(
      onTap: ontap,
      child: ListTile(
        title: displayText(text: text, fontSize: 15),
      ),
    );
  }

  Widget divider() {
    return const Divider();
  }
}
