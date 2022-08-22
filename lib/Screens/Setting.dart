import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:restaurants_waiters/Model/Settings.dart';
import 'package:restaurants_waiters/app_localizations.dart';
import 'package:restaurants_waiters/my_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Setting extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new SettingState();
  }

}


class SettingState  extends State<Setting>{
  List <String> radioList  = new List()  ;
  int  _character =  0  ;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSetting();

  }
  Future<void> getSetting() async {
    SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    Settings  settings = Settings.fromJson(json.decode(sharedPrefs.getString("settings") )) ;
    print(settings.calcTaxAfterSrvs)  ;
  }
  @override
  Widget build(BuildContext context) {

    radioList.add(AppLocalizations.of(context).translate("local"));
    radioList.add(AppLocalizations.of(context).translate("delivery"));
    radioList.add(AppLocalizations.of(context).translate("family"));
    // TODO: implement build
    return new Scaffold(
        appBar: new AppBar(backgroundColor: MyColors.colorPrimary,),

        body:
      createRadio() ,);
  }

  Column createRadio (){
  return Column(
    crossAxisAlignment:CrossAxisAlignment.start,
      children: <Widget>[
        Text(AppLocalizations.of(context).translate("invoice_type")),
    ListTile(
      title: new Text(radioList[0]),
      leading: Radio(
        value:0,
        groupValue: _character,
        onChanged: (int value) {
          setState(() {
            _character = value;
          });
        },
      ),
    ),
    ListTile(
    title: new Text(radioList[1]),
    leading: Radio(
    value:1,
    groupValue: _character,
    onChanged: (int value) {
    setState(() {
    _character = value;
    });
    },
    ),
    ),  ListTile(
          title: new Text(radioList[2]),
          leading: Radio(
            value:2,
            groupValue: _character,
            onChanged: (int value) {
              setState(() {
                _character = value;
              });
            },
          ),
        ),
        Divider(color: Colors.grey,) ,
        addPrinterBtn()  ,
        Divider(color: Colors.grey,) ,

      ]);
  }
  Padding addPrinterBtn() {

    return new Padding (padding: EdgeInsets.all(4),child:new Container(
      width  :   double.infinity,
      child  :   new FlatButton(
        onPressed: null ,
        child: new Text(AppLocalizations.of(context).translate("add_printer") ,textAlign: TextAlign.start,),
      ) ,
    ) )
    ;
  }

}