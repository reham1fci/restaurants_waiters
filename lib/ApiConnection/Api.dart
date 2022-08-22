import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart'  as http ;
import 'package:restaurants_waiters/Database/DatabaseHelper.dart';
import 'package:restaurants_waiters/Model/CashTypes.dart';
import 'package:restaurants_waiters/Model/Category.dart';
import 'package:restaurants_waiters/Model/Customer.dart';
import 'package:restaurants_waiters/Model/Departments.dart';
import 'package:restaurants_waiters/Model/Invoices.dart';
import 'package:restaurants_waiters/Model/Product.dart';
import 'package:restaurants_waiters/Model/Settings.dart';
import 'package:restaurants_waiters/Model/Tables.dart';
import 'package:restaurants_waiters/Model/User.dart';
import 'package:restaurants_waiters/Model/company.dart';
import 'package:restaurants_waiters/Tools/Constant.dart';
import 'package:restaurants_waiters/Tools/MethodsTools.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:device_info/device_info.dart';



class Api  {
  final dbHelper = DatabaseHelper.instance;
  String BASEURL   ;


  Future login({String username , String password  , String ip  , String port   ,  Function  onLogin  , Function onError}  ) async{
    String machNm  = await _getId();
  //  SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    http://174.142.60.74:8090/API/WeatherForecast/
   String url   = "http://"+ip+":"+port+ LOGIN_URL;


    User user  = new User(password: password , userName: username , machNm: machNm)  ;
    http.post(url ,body:jsonEncode(user.loginMap()),headers: {"Content-type": "application/json", "Accept": "application/json"}) .then((http.Response response) {
      print(url) ;
      print(response)  ;
      print(response.statusCode)  ;
      print(user.loginMap())  ;
      print(response.body)  ;
      if(response.statusCode == 200) {
        var jsonObj = json.decode(response.body);
        print(jsonObj) ;
        String  result  = jsonObj['result']  ;
        String  msg  = jsonObj['msg']  ;
        print(msg)  ;
       if(result  == "success") {
          print(jsonObj) ;
          User c = User.fromJson(jsonObj ,password , username , machNm ) ;
        onLogin(c , ip , port)  ;
         return c ;
        }
        else
        {
          onError(msg) ;
          return null  ;
        }
      }
      else {
        onError("Connection Error") ;
        return null ;
      }

    }
    );

  }
  Future connection({String ip  , String port   ,  Function  onConnect  , Function onError}  ) async{
    //  SharedPreferences sharedPrefs = await SharedPreferences.getInstance();

    String url   = "http://"+ip+":"+port+TEST;

print(url)  ;
    http.get(url ,headers:
    {"Content-type": "application/json", "Accept": "application/json"}) .timeout(
      Duration(seconds: 5),
      onTimeout: () {
        onError("Connection Error") ;

        // time has run out, do what you wanted to do
        return null;
      },
    ).
    then((http.Response response) {
print(response.statusCode) ;
      if(response.statusCode == 200) {
        var jsonObj = json.decode(response.body);

        if(jsonObj  == "connect") {
          print(jsonObj) ;
         // User c = User.fromJson(jsonObj ,password , username , machNm ) ;
          onConnect()  ;
        }
        else
        {
          onError(jsonObj) ;
          return null  ;
        }
      }
      else {
        onError("Connection Error") ;
        return null ;
      }

    }
    );

  }
  Future getDefinition({Function  onSuccess  , Function onError}  ) async{
      SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
      String ip   = sharedPrefs.getString(IP)  ;
      String port   = sharedPrefs.getString(PORT)  ;
      String url   = "http://"+ip+":"+port+ DEFINITION_URL;

    print(url) ;
    http.get(url  , headers: {"Content-type": "application/json", "Accept": "application/json"}).then((http.Response response) async {
      print(response.statusCode)  ;
      print(response.body)  ;
      if(response.statusCode == 200) {
        String jsonStr = json.decode(response.body);
        var jsonObj = json.decode(jsonStr);

        print(jsonObj)  ;
        var jsonSetting =jsonObj["JS_Config"] ;
        var jsonCatArr =jsonObj["JS_Categories"] ;
        var jsonDepartments =jsonObj["JS_Section"] ;
        var jsonProductArr =jsonObj["vw_Product_data"] ;
        var jsonCustomerArr =jsonObj["JS_CUSTOMER"] ;
        var jsonTablesArr =jsonObj["JS_Tables"] ;
        var jsonCashArr =jsonObj["JS_CashType"] ;
        var jsonCompanyArr =jsonObj["JS_CompanyConfig"] ;
        //////////////category/////////////////////

        for(int i = 0 ; i<jsonCatArr.length ; i++) {
        var catJsonObj  = jsonCatArr[i] ;
        Category cat  =  new Category.fromJson(catJsonObj)  ;
        final id = await dbHelper.insert(cat.insertDb() , CATEGORY_TB,err: (e){
          onError(e)  ;

        });
        print(id) ;
       // onError(id)  ;
        }
        /////////////////////////////////////////////////////
        for(int i = 0 ; i< jsonDepartments.length ; i++) {
          var depJsonObj  = jsonDepartments[i] ;
          Departments dep  =  new Departments.fromJson(depJsonObj)  ;
          final id = await dbHelper.insert(dep.insertDb() , DEP_TB,err: (e){
            onError(e)  ;

          });
          print(id) ;
         // onError(id)  ;

        }
        ///////////////////////products//////////////////////
        for(int i  =  0  ; i  <jsonProductArr.length  ; i++) {
          var productJsonObj  = jsonProductArr[i] ;
          Product product  =  new Product.fromJson(productJsonObj)  ;
          final id = await dbHelper.insert(product.insertDb() , PRODUCT_TB,err: (e){
            onError(e)  ;

          });
          print(id)  ;
          //onError(id)  ;


        }
        ///////////////////customers///////////////////////////
        for(int i  =  0  ; i  <jsonCustomerArr.length  ; i++) {
          var customerJsonObj  = jsonCustomerArr[i] ;
          Customer customer  =  new Customer.fromJson(customerJsonObj)  ;
          final id = await dbHelper.insert(customer.insertDb() , CUSTOMER_TB,err: (e){
            onError(e)  ;

          });
          print(id)  ;
         // onError(id)  ;


        }
        for(int i  =  0  ; i  <jsonTablesArr.length  ; i++) {
          var tableJson  = jsonTablesArr[i] ;
          Tables table  =  new Tables.fromJson(tableJson)  ;
          final id = await dbHelper.insert(table.insertDb() , TABLE_TB ,err: (e){
            onError(e)  ;

          });
          print(id)  ;
          //onError(id)  ;

        }
        for(int i  =  0  ; i  <jsonCashArr.length  ; i++) {
          var cashJson  = jsonCashArr[i] ;
          CashTypes cashObj  =  new CashTypes.fromJson(cashJson)  ;
          final id = await dbHelper.insert(cashObj.insertDb() , CASH_TB , err: (e){
            onError(e)  ;

          });
         print(id)  ;


        }
        for(int i  =  0  ; i  <jsonCompanyArr.length  ; i++) {
          var companyArr  = jsonCompanyArr[i] ;
          print(companyArr)  ;
          Company companyObj  =  new Company.fromJson(companyArr)  ;
          SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
          sharedPrefs.setString("company",json.encode(companyObj.toJson()));
          sharedPrefs.commit() ;          //  print(id)  ;
        }
        for(int i  =  0  ; i  <jsonSetting.length  ; i++) {
          var settingObj  = jsonSetting[i] ;
         // print(settingObj) ;
          Settings s  =  new Settings.fromJson(settingObj)  ;
          SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
          sharedPrefs.setString("settings",json.encode(s.toJson()));
          sharedPrefs.commit() ;
         // List<String> dates  =  Methods.getDateTime(s.hoursLate.toInt());
         // Invoices inv  =  new Invoices(isOpen: 1  , billDate: dates[1] , invDailyNo: 1,total: 0 , totalAfterDiscount: 0 , totalTax: 0 , billOpenDate: dates[0]) ;
         // final id = await dbHelper.insert(inv.insertDb() , INVOICE_TB);
        }
        print(jsonObj) ;
         onSuccess();

      }
      else {
        onError("connection error") ;
        return null ;
      }

    }
    );

  }
  Future <void> saveInvoices( { List <Invoices> invList, double taxPercentage,  Function onSuccess ,Function onError  }
      ) async {

    var map = new Map<String, dynamic>();
    SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    User user = User.fromJsonShared(json.decode(sharedPrefs.getString("user") )) ;
    String ip   = sharedPrefs.getString(IP)  ;
    String port   = sharedPrefs.getString(PORT)  ;
    String url   = "http://"+ip+":"+port+ ORDER_URL;
    List invoicesMap = new List< Map<String, dynamic>>();
    for (int i = 0; i < invList.length; i++) {
  var invoiceMap  =  invList[i].toJson(user.userID, user.machNo,
      user.branchId , taxPercentage) ;
  List itemsMap = new List< Map<String, dynamic>>();
  List<Product> items = invList[i].products ;
  for (int j = 0; j < items.length; j++) {
    itemsMap.add(items[j].toJson(j+1 ,user.userID));
  }
 invoiceMap["JS_Bills_Details"]  = itemsMap  ;
 invoicesMap.add(invoiceMap)  ;

    }
    map["JS_Bills_Master"]  = invoicesMap  ;
    print(map.toString()) ;
    print( jsonEncode(map) ) ;

    http.post(url ,body  :jsonEncode(map)  ,headers: {"Content-Type": "application/json"}, ) .then((http.Response response) {
      print( response.statusCode)  ;
      print( url)  ;
      if(response.statusCode == 200) {
        var jsonObj = json.decode(response.body);
        print( jsonObj)  ;

        String  msg  = jsonObj['result']  ;
        String  newDaily  = jsonObj['new_Daliy_No']  ;
        String  newInvoiceId  = jsonObj['new_Bill_Code']  ;
        bool  hasError  = jsonObj['hasErrors']  ;
        if(msg  == "success" && !hasError) {
          onSuccess(msg ,newDaily , newInvoiceId ) ;
          return msg;
        }
        else
        {
          onError(msg) ;
          return msg  ;
        }
      }
      else {
        onError("Connection Error") ;
        return null ;
      }

    });

  }
  Future<String> _getId() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) { // import 'dart:io'
      var iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor; // unique ID on iOS
    } else {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo.androidId; // unique ID on Android
    }
  }

}