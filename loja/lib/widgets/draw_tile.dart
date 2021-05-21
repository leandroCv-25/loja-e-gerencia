import 'package:flutter/material.dart';

class DrawTile extends StatelessWidget {
  final IconData iconData;
  final String text;
  final PageController pageController;
  final int page;

  DrawTile(
      {@required this.iconData,
      @required this.text,
      @required this.pageController,
      @required this.page});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.of(context).pop();
          pageController.jumpToPage(page);
        },
        child: Container(
          height: 60,
          child: Row(
            children: <Widget>[
              Icon(
                iconData,
                size: 32,
                color: pageController.page.round() == page
                    ? Colors.blue
                    : Colors.white,
              ),
              SizedBox(
                width: 32,
              ),
              Text(
                text,
                style: Theme.of(context).textTheme.bodyText1,
              )
            ],
          ),
        ),
      ),
    );
  }
}
