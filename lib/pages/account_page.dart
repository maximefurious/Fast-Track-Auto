import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountPage extends StatefulWidget {
  final Function setIsDark;
  final Function setImmatriculation;
  final Function updateData;
  final Color textcolor;
  final Color backgroundcolor;
  final String immatriculation;
  final int isDark;

  AccountPage(this.setIsDark, this.setImmatriculation, this.updateData,
      this.isDark, this.immatriculation, this.textcolor, this.backgroundcolor);

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final _formKey = GlobalKey<FormState>();
  String newImmatriculation = '';

  void _submitImmatriculation(value) {
    widget.setImmatriculation(value);
    widget.updateData();
    Navigator.of(context).pop();
  }

  ListTile _buildImmatriculationListTile() {
    return ListTile(
      title: Text(
        'Immatriculation',
        style: TextStyle(
          fontSize: 16,
          color: widget.textcolor,
        ),
      ),
      tileColor: widget.backgroundcolor,
      trailing: Text(
        widget.immatriculation,
        style: TextStyle(
          fontSize: 16,
          color: widget.textcolor,
        ),
      ),
      onTap: () => {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              backgroundColor: widget.backgroundcolor,
              title: Text(
                'Immatriculation',
                style: TextStyle(
                  fontSize: 16,
                  color: widget.textcolor,
                ),
              ),
              content: Form(
                key: _formKey,
                child: TextFormField(
                  initialValue: widget.immatriculation,
                  style: TextStyle(
                    fontSize: 16,
                    color: widget.textcolor,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Immatriculation',
                    hintStyle: TextStyle(
                      fontSize: 16,
                      color: widget.textcolor,
                    ),
                  ),
                  onChanged: (value) {
                    newImmatriculation = value;
                  },
                ),
              ),
              actions: <Widget>[
                TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: widget.textcolor,
                  ),
                  child: Text(
                    'Annuler',
                    style: TextStyle(
                      fontSize: 16,
                      color: widget.textcolor,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: widget.textcolor,
                  ),
                  child: Text(
                    'Valider',
                    style: TextStyle(
                      fontSize: 16,
                      color: widget.textcolor,
                    ),
                  ),
                  onPressed: () {
                    _submitImmatriculation(newImmatriculation);
                  },
                ),
              ],
            );
          },
        ),
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Paramètres',
              style: TextStyle(
                fontSize: 20,
                color: widget.textcolor,
              ),
            ),
          ),
          Card(
            child: Column(
              children: <Widget>[
                ListTile(
                  title: Text(
                    'Theme sombre',
                    style: TextStyle(
                      fontSize: 16,
                      color: widget.textcolor,
                    ),
                  ),
                  tileColor:
                      widget.backgroundcolor,
                  trailing: Switch(
                    value: widget.isDark == 1 ? true : false,
                    thumbIcon: MaterialStateProperty.all(
                      widget.isDark == 1
                          ? const Icon(
                              Icons.brightness_2,
                              color: Colors.yellow,
                            )
                          : const Icon(
                              Icons.sunny,
                              color: Colors.black,
                            ),
                    ),
                    activeTrackColor: Colors.blue[100],
                    onChanged: (value) async {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      await prefs.setInt('isDark', value ? 1 : 0);
                      widget.setIsDark(value);
                    },
                  ),
                ),
                Divider(
                  height: 1,
                  color: widget.textcolor,
                ),
                _buildImmatriculationListTile(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
