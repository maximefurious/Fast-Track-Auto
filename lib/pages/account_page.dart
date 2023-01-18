import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountPage extends StatefulWidget {
  
  final Function setIsDark;
  final int isDark;

  AccountPage(this.setIsDark, this.isDark);

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  @override
  Widget build(BuildContext context) {

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          // widget with Main settings and a slider to change the theme
          Card(
            child: Column(
              children: <Widget>[
                ListTile(
                  title: Text('Dark Theme'),
                  trailing: Switch(
                    value: widget.isDark == 1 ? true : false,
                    onChanged: (value) async {
                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      await prefs.setInt('isDark', value ? 1 : 0);
                      widget.setIsDark(value);
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
