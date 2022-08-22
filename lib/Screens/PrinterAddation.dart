import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:restaurants_waiters/Model/Printer.dart';
import 'package:restaurants_waiters/app_localizations.dart';
import 'package:restaurants_waiters/my_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class PrinterAddition  extends StatefulWidget{
 int printerType  ;
 String title ;


 PrinterAddition({this.printerType , this.title});

 @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new PrinterState();
  }


}
class PrinterState  extends State<PrinterAddition>{
  int _printerType  ;
  String _title  ;
  String ip  ;
  String port =  "9100"  ;
  String sharedName  ;
  String errorTxt  =  null;
  TextEditingController ipEd  = new TextEditingController()  ;
  TextEditingController portEd  = new TextEditingController()  ;
  SharedPreferences sharedPrefs;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    setState(() {
      _printerType  = widget.printerType  ;
      _title  = widget.title  ;
      portEd.text  = port  ;
       isPrinterFound();
    });

  }
   isPrinterFound() async {
     sharedPrefs = await SharedPreferences.getInstance();

     if(sharedPrefs.containsKey("printer"+_printerType.toString())) {
        Printer printer = Printer.fromJsonShared(
           json.decode(sharedPrefs.getString("printer"+_printerType.toString())));
        setState(() {
          ipEd.text  = printer.ip;

        });
     }
   }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
          appBar:  AppBar( backgroundColor :MyColors.colorPrimary, title: new Text(_title),) ,
       body:  new Container(
         padding:EdgeInsets.only(left: 40 , right: 40 , top: 10 ),
         child:

       new Column(children: [
       Row(
         mainAxisAlignment: MainAxisAlignment.spaceBetween,

         children: [
           new  Expanded (child: Text("IP" , textAlign:  TextAlign.center,style: TextStyle(fontSize: 20),)  ),
           new  Expanded(child:TextField(controller:  ipEd,
               decoration: InputDecoration(
                 hintText: "31.167.73.47" ,
                 fillColor: Colors.white,
                 filled: false,
                 errorText: errorTxt,
            //     prefixIcon:Image.asset('images/user_icon.png',color: MyColors.colorPrimary) ,
               )
           ),         )],
       )  ,
         new Padding(padding: EdgeInsets.only(top: 10 ), child: Row(
         mainAxisAlignment: MainAxisAlignment.spaceBetween,

           children: [
             new  Expanded (child: Text("PORT" , textAlign:  TextAlign.center,style: TextStyle(fontSize: 20),)  ),
             new Expanded(child:TextField(controller:  portEd,
                 decoration: InputDecoration(
                  // hintText: "" ,
                   fillColor: Colors.white,
                   filled: false,
                   // errorText: nameError,
                   //     prefixIcon:Image.asset('images/user_icon.png',color: MyColors.colorPrimary) ,
                 )
             ),        ) ],
         )
         ) ,
         //addButton(),


       ]
         ,)

         ,),

         bottomNavigationBar: BottomAppBar(
           child: addButton(),
         )
         );
        }
   void onAddPrinter ()  {
    setState(()  {


            errorTxt = null ;
    // 0 printer cashier
        // 1printer supervisor
        ip  = ipEd.text;
        port  = portEd.text;
        if(ip.isEmpty){
          errorTxt  = "ip";
        }
        else{
         if(port.isEmpty){
          port = "9100" ;
        }
         savePrinter() ;
         Navigator.of(context).pop();

        }

    });

        }
        Future<void> savePrinter  () async {
          SharedPreferences   sharedPrefs = await SharedPreferences.getInstance();
          sharedPrefs.setString("printer"+_printerType.toString(), json.encode(Printer(ip:ip  , port:port ).toJson()) );
          sharedPrefs.commit() ;
        }
  Padding addButton() {
    return new Padding (padding: EdgeInsets.only(bottom: 8.0 , left: 40.0  , right: 40.0 , top: 8.0),child:new Container(
      decoration:  new BoxDecoration(color:MyColors.colorPrimary
          , borderRadius:  const BorderRadius.all(
            const Radius.circular(8.0),)
      ),
      width  :   double.infinity,
      child  :   new FlatButton(
        onPressed: onAddPrinter ,
        child: new Text(AppLocalizations.of(context).translate("add_printer") , style: new TextStyle(color: Colors.white),),
      ) ,
    ) )
    ;
  }

}