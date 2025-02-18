import 'package:flutter/material.dart';

class TaskWidget extends StatelessWidget {
  final VoidCallback btnOnClick;
  final String content;
  final String title;
  final Widget widget;

  const TaskWidget({
    Key? key,
    required this.btnOnClick,
    required this.content,
    required this.title,
    required this.widget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: btnOnClick,
      child: Container(
        margin: EdgeInsets.only(
          left: MediaQuery.of(context).size.width * 0.05,
          right: MediaQuery.of(context).size.width * 0.05,
          top: MediaQuery.of(context).size.height * 0.01,
        ),
        child: Row(
          children: [
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    content,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            // Spacer
            SizedBox(width: MediaQuery.of(context).size.width * 0.02), // Add space between content and widget
            widget,
          ],
        ),
      ),
    );
  }
}
