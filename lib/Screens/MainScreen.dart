import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:restaurants_waiters/ApiConnection/Api.dart';
import 'package:restaurants_waiters/Database/DatabaseHelper.dart';
import 'package:restaurants_waiters/Model/Category.dart';
import 'package:restaurants_waiters/Model/Printer.dart';
import 'package:restaurants_waiters/Model/Product.dart';
import 'package:restaurants_waiters/Model/Settings.dart';
import 'package:restaurants_waiters/Screens/Invoice.dart';
import 'package:restaurants_waiters/Screens/Orders.dart';
import 'package:restaurants_waiters/Screens/ProductGroups.dart';
import 'package:restaurants_waiters/Screens/Products.dart';
import 'package:restaurants_waiters/Screens/Setting.dart';
import 'package:restaurants_waiters/Screens/Synchronization.dart';
import 'package:restaurants_waiters/app_localizations.dart';
import 'package:restaurants_waiters/Tools/Constant.dart';
import 'package:shared_preferences/shared_preferences.dart';


import '../my_colors.dart';
import 'Login.dart';
import 'ProductsPortrait.dart';
class MainScreen  extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
     return new MainState();
  }

}
class MainState extends State<MainScreen>{
  var selectedValue = 0;
  var isLargeScreen = false;
  Api api = new Api() ;
  var cat_code =2  ;
  Product selectedProduct ;
  List<Product> productList  = new List()  ;
  double totalPrice =0  ;
  double totalTax   =0;
  double  totalPriceAfterDiscount  =0;
  double priceAfterDiscount  =0 ;
  //static int invoice_id  ;
  final dbHelper = DatabaseHelper.instance;
  Settings settings ;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
getSetting()  ;

  }
  @override
  Widget build(BuildContext context) {
    List <String>settings   = new List();

    settings.add(AppLocalizations.of(context).translate("settings")) ;
    settings.add(AppLocalizations.of(context).translate("the_Syncing") );
    settings.add(AppLocalizations.of(context).translate("orders")) ;
    settings.add(AppLocalizations.of(context).translate("logout")) ;

    // TODO: implement build
    return new Scaffold(
      /*  appBar:  AppBar(backgroundColor: MyColors.colorPrimary,actions: <Widget>[
    PopupMenuButton<String>(
    onSelected: (String value) {
      switch (settings.indexOf(value)) {
        case 0 :
          Navigator.push( context,
              MaterialPageRoute(builder: (context) => Setting())) ;
          break;
        case 1:
          Navigator.push( context,
              MaterialPageRoute(builder: (context) => Synchronization())) ;
          break;
        case 2:
          Navigator.push( context,
              MaterialPageRoute(builder: (context) => Orders())) ;
          break;
        case 3:
          break;
      }
    },
    itemBuilder: (BuildContext context) {
    return
    settings.map((String choice) {
    return PopupMenuItem<String>(
    value: choice,
    child: Text(choice),
    );
    }).toList();
    },
    ),
    ],
    ),*/
    body: OrientationBuilder(builder: (context, orientation) {

      if (MediaQuery.of(context).size.width > 600) {
        isLargeScreen = true;
      } else {
        //isLargeScreen = false;
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight,
        ]);
        isLargeScreen = true;

      }

      return


        Row(
         mainAxisSize: MainAxisSize.max,
          children: <Widget>[
       // Expanded(
       //   flex: 1,
         // child:
       /*   Container(
            child:
      ProductGroups((cateCode){
      if(isLargeScreen){
        cat_code= cateCode ;
        setState(() {});

        print(cat_code)  ;
      }
      else{
      Navigator.push( context,
      MaterialPageRoute(builder: (context) =>   Products(cat_code, (product){

        product.count  = 1  ;

        this.selectedProduct  = product ;
        productList.add(product)  ;
        setState(() {
        });
      }),)) ;

      }
      }),
            width: MediaQuery.of(context).size.width * (isLargeScreen? 0.2:1),
            decoration: BoxDecoration(
              border: Border.all(width: 1 ,color: MyColors.colorPrimary),

            ),
          ),*/
       // ),
        isLargeScreen ?
       // Expanded(flex: 1, child:
        Container(
        child:
       Products(cat_code, (product)  {
      // test(product)  ;
         product.count  = 1  ;

         this.selectedProduct  = product ;
         productList.add(product)  ;

         setState(() {
         });
       } ),
          width: MediaQuery.of(context).size.width * 0.7,

         /* decoration: BoxDecoration(
        border: Border.all(width: 1 ,color: MyColors.colorPrimary),

        ),*/
        )
       // )
            : Container(),
        isLargeScreen ?
       // Expanded(flex: 1, child:
        Container(
            child:
            Invoice(productList: productList  , totalPrice:totalPrice  , totalPriceAfterDiscount:totalPriceAfterDiscount  , totalTax: totalTax,),
            width: MediaQuery.of(context).size.width * 0.3,
            decoration: BoxDecoration(
              border: Border.all(width: 1 ,color: MyColors.colorPrimary),

            ),
          )
        //)
            : Container(),
      ]);
    }),
    );

}
 Future<void> logout () async {
   SharedPreferences    sharedPrefs = await SharedPreferences.getInstance();
   sharedPrefs.remove("user");
  // sharedPrefs.clear()  ;
   sharedPrefs.commit()  ;
   int delete = await dbHelper.deleteTb(table: TABLE_TB)  ;
   int delete2 = await dbHelper.deleteTb(table:   CASH_TB)  ;
   int delete3 = await dbHelper.deleteTb(table: CUSTOMER_TB)  ;
   int delete8 = await dbHelper.deleteTb(table: DISCOUNT_TB)  ;
   int delete4 = await dbHelper.deleteTb(table: PRODUCT_TB)  ;
   int delete5 = await dbHelper.deleteTb(table:CATEGORY_TB)  ;
   int delete6 = await dbHelper.deleteTb(table:INVOICEPRODUCT_TB)  ;
   int delete7 = await dbHelper.deleteTb(table:INVOICE_TB)  ;
   Navigator.pushReplacement( context,
       MaterialPageRoute(builder: (context) => Login())) ;


 }
 Printer printer ;
  Future<void> getSetting() async {
    SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    settings = Settings.fromJson(json.decode(sharedPrefs.getString("settings") )) ;


  }
  Future<double> checkDiscount(Product product ) async{
    final allRows = await dbHelper.getProductDiscount(product.pCode);
    print("1-"+allRows.length.toString()) ;

    if(allRows.length<=0) {
      // no discount
      priceAfterDiscount  = product.price  ;
      return priceAfterDiscount  ;
      print("1-"+priceAfterDiscount.toString()) ;
    }
    else{
      for(int i  =  0  ;  i  < allRows.length  ;  i++)     {
        Map<String, dynamic> map = allRows[i]  ;
        String from  = map[FROM];
        String to  = map[TO];
        DateTime now = DateTime.now();
        String formattedDate = DateFormat('dd/MM/yyyy').format(now);
        DateTime fromD = DateTime.parse(from);
        DateTime toD = DateTime.parse(to);
        DateTime nowD = DateTime.parse(formattedDate);
        if(nowD.compareTo(fromD)>0&& toD.compareTo(nowD)>0){
          double percent  =   map[PERCENT]  ;
          double d_price  =   map[D_PRICE]  ;
          if(percent>0){
            double discount  = product.price  * (percent/100)  ;
            priceAfterDiscount  = product.price - discount  ;
            print("2-"+priceAfterDiscount.toString()) ;
            return priceAfterDiscount  ;

          }
          else{
            priceAfterDiscount  = product.price - d_price  ;
            print("3-"+priceAfterDiscount.toString()) ;
            return priceAfterDiscount  ;

          }

        }
        else{
          priceAfterDiscount  = product.price  ;
          print("4-"+priceAfterDiscount.toString()) ;
          return priceAfterDiscount  ;


          // no discount
        }

      }
      return priceAfterDiscount  ;

    }
  }


  Future<void> test( Product product) async {
    this.selectedProduct  = product ;
    totalPriceAfterDiscount  = totalPriceAfterDiscount  +product.priceAfterDiscount ;
    totalPrice  = totalPrice  +product.price ;
    totalTax  = totalTax  +product.taxAmount  ;
  }
  double calcTaxAmount ( Product product) {
    double taxPercent ;
    if(settings.useTax) {
      taxPercent  = settings.taxPercent /100 ;
    }
    else {
      taxPercent  = product.tax / 100  ;

    }
    if(settings.isAddTax){
      return product.priceAfterDiscount*(taxPercent/100) ;
    }
    else{

      double x=(product.priceAfterDiscount*100)/(100+taxPercent)  ;
      return x*(taxPercent/100)  ;

    }
  }


}