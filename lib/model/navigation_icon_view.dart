import 'package:flutter/material.dart';

class NavigationIconView {
  NavigationIconView(String title, String iconPath, String activeIconPath)
      : assert(title != null),
        assert(iconPath != null),
        assert(activeIconPath != null),
        this.item = BottomNavigationBarItem(title: Text(title),
          icon: Image.asset(iconPath,width: 20, height: 20,),
          activeIcon: Image.asset(activeIconPath, width: 20, height: 20,)
        );

  final BottomNavigationBarItem item;
}
