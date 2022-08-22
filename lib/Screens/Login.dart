import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:restaurants_waiters/ApiConnection/Api.dart';
import 'package:restaurants_waiters/Database/DatabaseHelper.dart';
import 'package:restaurants_waiters/Model/Category.dart';
import 'package:restaurants_waiters/Model/Invoices.dart';
import 'package:restaurants_waiters/Model/Settings.dart';
import 'package:restaurants_waiters/Model/User.dart';
import 'package:restaurants_waiters/Screens/MainScreen.dart';
import 'package:restaurants_waiters/Screens/Synchronization.dart';
import 'package:restaurants_waiters/Tools/Constant.dart';
import 'package:restaurants_waiters/Tools/MethodsTools.dart';
import 'package:restaurants_waiters/app_localizations.dart';
import 'package:restaurants_waiters/my_colors.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'Setting.dart';


class Login  extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
   return new  LoginState()  ;
  }

}
class LoginState  extends State<Login>{
  TextEditingController userNameEd  = new TextEditingController()  ;
  TextEditingController machNmEd  = new TextEditingController()  ;
  TextEditingController passEd  = new TextEditingController()  ;
  TextEditingController orgEd  = new TextEditingController()  ;
  TextEditingController ipEd  = new TextEditingController()  ;
  TextEditingController portEd  = new TextEditingController()  ;
  String nameError , passError  , orgIdError , ipError , portError;
  SharedPreferences sharedPrefs ;
  final dbHelper = DatabaseHelper.instance;
  ProgressDialog pr  ;
  bool loading = false ;
  Api api  = new Api();
  bool isLoading = false ;
  bool isFirstLogin  = true  ;
  bool configFound  = false  ;
  bool invoicesFound  = false  ;
  Settings  setting ;
  User  user;
  bool  loginDataEnable  = true ;
  bool  connectionData  = false ;
  @override
  void initState()  {
    // TODO: implement initState
    super.initState();
   checkLogin()  ;
     }
void checkLogin()async {
   sharedPrefs = await SharedPreferences.getInstance();
  if( sharedPrefs.containsKey("settings")) {
    setting = Settings.fromJson(json.decode(sharedPrefs.getString("settings") )) ;
    configFound  = true  ;
  }
  if(sharedPrefs.containsKey(IP)) {
    ipEd.text = sharedPrefs.getString(IP) ;
    portEd.text  = sharedPrefs.get(PORT)  ;
  }
  else{
    loginDataEnable = false  ;
  }
  if(sharedPrefs.containsKey("user")){

     user = User.fromJsonShared(json.decode(sharedPrefs.getString("user") )) ;

    isLoading  = true  ;
    isFirstLogin  = false  ;
   Navigator.pushReplacement( context, MaterialPageRoute(builder: (context) => MainScreen())) ;


    // api.login( onError:  onError, onLogin:
  //  onLogin, password: user.password , username: user.userName ) ;
  }
  else{
    setState(() {
      isLoading  = false   ;
    });
  }
}
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: new AppBar(backgroundColor: MyColors.colorPrimary,),

      body: new Container(
         child:  new Center(child:
         isLoading? new Center(
           child: CircularProgressIndicator(),
         ):
    SingleChildScrollView(

  child:  new Column(
           mainAxisAlignment: MainAxisAlignment.center,
           crossAxisAlignment: CrossAxisAlignment.center,
           children: [
             loading? new Center(
               child: CircularProgressIndicator(),
             ):SizedBox(),
          //   machNm(),
             ip_portEdFun() ,
             new  Image.asset('images/logo.png'  , height: 100, width: 150,),
             userNameEdFun(),
             passEdFun(),
             loginBtn(),


           ],)))) ,
    )  ;
  }
  void onLoginBtn() {
    setState(() {

String userName  = userNameEd.text ;
String machNm  = machNmEd.text ;
String password  = passEd.text ;
String ip  = ipEd.text ;
String port  = portEd.text ;
setState(() {
  bool isValidate = loginValidation( machNm  ,userName ,password , ip , port )  ;
  if(isValidate){
    loading = true  ;
    isLoading  = false ;
    api.login( username: userName, password: password , ip: ip ,port: port,onError: (String err){
      print(err) ;
      onError(err)  ;
    } , onLogin: onLogin ) ;
  }
  else{
    onError(AppLocalizations.of(context).translate("fill_data"))  ;
  }
});
    });
  }
  void onLogin (User  user  , String ip , String port ) {
    setState(()  {
      loading = false ;
      isLoading = false  ;
     // print(user.toString());
      saveUserData(user , ip , port );

      if(configFound) {
        Methods m  = new Methods()  ;
        m.Dialog(context: context  , title:""  , message: AppLocalizations.of(context).translate("async_data") , onOkClick: (){
          Navigator.pushReplacement( context, MaterialPageRoute(builder: (context) => Synchronization())) ;

        } , isCancelBtn: true , onCancelClick: (){
          Navigator.pushReplacement( context, MaterialPageRoute(builder: (context) => MainScreen())) ;

        }) ;

      }
      else{
        getDefinition();

      }

      /* if(isFirstLogin) {
      saveUserData(user);
      getDefinition();

      }
      else{
        Navigator.pushReplacement( context, MaterialPageRoute(builder: (context) => MainScreen())) ;

      }*/
    });
  }
  void getDefinition(){
    progressDialog()  ;
    api.getDefinition(onError:(String err){
      Methods m  = new Methods()  ;
      m.Dialog(context: context  , title:err  ,
          message: AppLocalizations.of(context).translate("error") , onOkClick: (){
      } , isCancelBtn: false ,);

      }
      , onSuccess:()async{

      pr.hide().then((isHidden) async {
        print(isHidden);
        int isFound = await dbHelper.queryRowCount(INVOICE_TB)  ;
        setting = Settings.fromJson(json.decode(sharedPrefs.getString("settings") )) ;
        user = User.fromJsonShared(json.decode(sharedPrefs.getString("user") )) ;

        if(isFound==0) { // مفيش جدول فواتير
          List<String> dates  =  Methods.getDateTime(setting.hoursLate.toInt());
          int daily = (int.parse(user.dailyNo)) ;
          int inv_id = (int.parse(user.invoiceIndex))+1  ;
          Invoices inv  =  new Invoices(id:inv_id ,isOpen: 1  ,
              billDate: dates[1] ,
              invDailyNo: daily,total: 0 ,
              totalAfterDiscount: 0 ,
              totalTax: 0 ,
              billOpenDate: dates[0]) ;
          final id = await dbHelper.insert(inv.insertDb() , INVOICE_TB);

          // create first invoice
        }
        Navigator.pushReplacement( context, MaterialPageRoute(builder: (context) => MainScreen())) ;
      });

        }
    ) ;
  }
  Future<void> progressDialog() async {
     pr = ProgressDialog(context);
    pr = ProgressDialog(context,type: ProgressDialogType.Normal, isDismissible: false, showLogs: false);
    pr.style(
        message: 'Downloading file...',
        borderRadius: 10.0,
        backgroundColor: Colors.white,
        progressWidget: Container(
            padding: EdgeInsets.all(8.0),child:
        SizedBox( width: 30, height: 30,
            child: CircularProgressIndicator())),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        progress: 0.0,
        maxProgress: 100.0,
        progressTextStyle: TextStyle(
            color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
        messageTextStyle: TextStyle(
            color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600)
    );

    await pr.show();
  }
  void saveUserData (User user , String ip , String port )async {
    sharedPrefs = await SharedPreferences.getInstance();
    sharedPrefs.setString("user", json.encode(user.toJson()) );
    if(sharedPrefs.containsKey(IP)) {
      String oldIp  = sharedPrefs .getString(IP)  ;
      String oldPort  = sharedPrefs .getString(PORT)  ;
      if(oldIp == ip  && oldPort==port){


      }
      else {
        SharedPreferences    sharedPrefs = await SharedPreferences.getInstance();
        // sharedPrefs.clear()  ;
        sharedPrefs.remove("settings");
        sharedPrefs.commit()  ;
        int delete = await dbHelper.deleteTb(table: TABLE_TB)  ;
        int delete2 = await dbHelper.deleteTb(table:   CASH_TB)  ;
         int delete3 = await dbHelper.deleteTb(table: CUSTOMER_TB)  ;
        int delete8 = await dbHelper.deleteTb(table: DISCOUNT_TB)  ;
        int delete4 = await dbHelper.deleteTb(table: PRODUCT_TB)  ;
        int delete5 = await dbHelper.deleteTb(table:CATEGORY_TB)  ;
         int delete6 = await dbHelper.deleteTb(table:INVOICEPRODUCT_TB)  ;
         int delete7 = await dbHelper.deleteTb(table:INVOICE_TB)  ;
       // delete all  ;
      }

      sharedPrefs.setString(IP,  ip);
      sharedPrefs.setString(PORT, port);
    }
    else{
    sharedPrefs.setString(IP,  ip);
    sharedPrefs.setString(PORT, port);
    }
    sharedPrefs.commit() ;

  }
  Future<void> onError(String message ) async {
    setState(() {
      loading = false ;
    });
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context).translate("error")),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(message),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  bool loginValidation ( String machNm  ,  String name  , String password  , String ip  , String port){
    if(name.isEmpty) {
      return false  ;
    }
   else if(password.isEmpty){
      return false  ;
    }
   else if(ip.isEmpty)
    {
      return false  ;
    }

    else if(port.isEmpty)
    {
      return false  ;
    }

     else{
    return true ;}

  }



  Padding loginBtn() {
    return new Padding (padding: EdgeInsets.only(bottom: 8.0 , left: 40.0  , right: 40.0 , top: 8.0),child:new Container(
      decoration:  new BoxDecoration(color:MyColors.colorPrimary
          , borderRadius:  const BorderRadius.all(
            const Radius.circular(8.0),)
      ),
      width  :   double.infinity,
      child  :   new FlatButton(
        onPressed: onLoginBtn ,
        child: new Text(AppLocalizations.of(context).translate("login") , style: new TextStyle(color: Colors.white),),
      ) ,
    ) )
    ;
  }
  Padding machNm() {
    return new Padding(padding:new EdgeInsets.only(bottom: 8.0 , left: 30.0  , right: 30.0 , top: 8.0) ,
      child:  new TextField(controller:  machNmEd,
          decoration: InputDecoration(
            hintText: AppLocalizations.of(context).translate("user_name") ,
            fillColor: Colors.white,
            filled: false,
            errorText: nameError,
            prefixIcon:Image.asset('images/user_icon.png',color: MyColors.colorPrimary) ,
          )
      ),)

    ;
  }
  Padding userNameEdFun() {
    return new Padding(padding:new EdgeInsets.only(bottom: 8.0 , left: 30.0  , right: 30.0 , top: 8.0) ,
      child:  new TextField(controller:  userNameEd,
          decoration: InputDecoration(
            hintText: AppLocalizations.of(context).translate("user_name") ,
            fillColor: Colors.white,
            filled: false,
            enabled: loginDataEnable,
            errorText: nameError,
            prefixIcon:Image.asset('images/user_icon.png',color: MyColors.colorPrimary) ,
          )
      ),)

    ;
  }
  Padding passEdFun() {
    return  new Padding(padding:new EdgeInsets.only(bottom: 8.0 , left: 30.0  , right: 30.0 , top: 8.0) ,
        child:
        new TextField(controller:  passEd,
          decoration: InputDecoration(
            hintText: AppLocalizations.of(context).translate("password"),
            fillColor: Colors.white,
            filled: false,
            errorText: passError,
            enabled: loginDataEnable,
            prefixIcon:Image.asset('images/pass_icon.png' ,color: MyColors.colorPrimary,) ,
          ) ,) )
    ;
  }
  Padding ip_portEdFun() {
    return  new Padding(padding:new EdgeInsets.only(bottom: 8.0 , left: 30.0  , right: 30.0 , top: 8.0) ,
        child:
            new Row(children: [
        new Expanded(child:  TextField(controller:  ipEd,
          decoration: InputDecoration(
            hintText:"Ip",
            fillColor: Colors.white,
            filled: false,
            enabled: connectionData,
          //  prefixIcon:Image.asset('images/pass_icon.png' ,color: MyColors.colorPrimary,) ,
          ) ,) )
            ,
              new Expanded(child:
              Padding(padding: new EdgeInsets.only(left: 10.0) , child:

              TextField(controller:  portEd,
                decoration: InputDecoration(
                  hintText:"Port",
                  fillColor: Colors.white,
                  filled: false,
                  enabled: connectionData,

                  //  prefixIcon:Image.asset('images/pass_icon.png' ,color: MyColors.colorPrimary,) ,
                ) ,) )


              ) ,

           new IconButton(icon: new Icon( Icons.edit ,color: MyColors.colorPrimary,),onPressed:(){
connectDialog()  ;
           } ,) ],) ,

    )

    ;
  }
  Future<void> connectDialog() async {
    List<bool> _list = [true, false, true, false];
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
       // portEd.text =
        return AlertDialog(
          content:
          StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return
                  SingleChildScrollView(

                      child: Container(
                        // height:MediaQuery.of(context).size.height,
                          child:Column (
                              mainAxisSize: MainAxisSize.min,

                              children: [

                                new Row(children: [
                                  new Expanded(child:  TextField(controller:  ipEd,
                                    decoration: InputDecoration(
                                      hintText:"Ip",
                                      fillColor: Colors.white,
                                      filled: false,
                                      //  prefixIcon:Image.asset('images/pass_icon.png' ,color: MyColors.colorPrimary,) ,
                                    ) ,) )
                                  ,
                                  new Expanded(child:
                                  Padding(padding: new EdgeInsets.only(left: 10.0) , child:

                                  TextField(controller:  portEd,
                                    decoration: InputDecoration(
                                      hintText:"Port",
                                      fillColor: Colors.white,
                                      filled: false,
                                      //  prefixIcon:Image.asset('images/pass_icon.png' ,color: MyColors.colorPrimary,) ,
                                    ) ,) )


                                  ) ,



                                  ],
                                ),

                              ]
                          )));}),
          actions: <Widget>[
            FlatButton(
              child: Text('Connect'),
              onPressed: () {
                api.connection(port:  portEd.text , ip: ipEd.text ,
                  onError:( var error){
                   // Navigator.of(context).pop();
                    print(error) ;
                    Methods.toastMessage(error)  ;
                    ipEd.text  =""  ;
                    portEd.text  =""  ;
                    loginDataEnable  = false  ;

                    // toast not connect
                  }  ,
                  onConnect:(){
                  setState(() {
                    Navigator.of(context).pop();

                    loginDataEnable  = true  ;

                  });

                  }
                   )  ;

                // setState(()  {
                // updateCash(selectCashType)  ;
                // });
              },
            ),
            FlatButton(
              child: Text('cancel'),
              onPressed: () {
                Navigator.of(context).pop();


              },
            ),
          ],
        );
      },
    );
  }
}