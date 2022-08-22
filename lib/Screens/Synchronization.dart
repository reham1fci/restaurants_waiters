import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:restaurants_waiters/ApiConnection/Api.dart';
import 'package:restaurants_waiters/Database/DatabaseHelper.dart';
import 'package:restaurants_waiters/Model/Invoices.dart';
import 'package:restaurants_waiters/Model/Product.dart';
import 'package:restaurants_waiters/Model/Settings.dart';
import 'package:restaurants_waiters/Model/Tables.dart';
import 'package:restaurants_waiters/Tools/Constant.dart';
import 'package:restaurants_waiters/Tools/MethodsTools.dart';
import 'package:restaurants_waiters/app_localizations.dart';
import 'package:restaurants_waiters/my_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Synchronization  extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new SyncState();
  }

}
class SyncState extends State<Synchronization> {
  final dbHelper = DatabaseHelper.instance;
  Api api  = new Api() ;
  ProgressDialog pr  ;
  Methods tools  ;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tools = new Methods()  ;
    getSetting() ;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: new AppBar(backgroundColor: MyColors.colorPrimary,),
      body: new Container(
          child:  new Center(child:
          new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
             new Padding(padding: EdgeInsets.only(bottom: 40),child:
          new  Image.asset('images/synchronize.png'  , height: 100, width: 150,)),
              importToolsBtn(),
              exportInvoiceBtn(),


            ],))) ,
    )  ;  }


  // functions ////////////////////////////////////////////////////////////////
  void onImportToolsClick() async{
     int deleteCustomers  =  await dbHelper.deleteTb(table:CUSTOMER_TB)  ;
     int deleteTables     =    await dbHelper.deleteTb(table:TABLE_TB)  ;
     int deleteCategory   =  await dbHelper.deleteTb(table:CATEGORY_TB)  ;
     int deleteProduct    =  await dbHelper.deleteTb(table:PRODUCT_TB)  ;
     int deleteCashTypes  =  await dbHelper.deleteTb(table:CASH_TB)  ;
     int deleteDep  =  await dbHelper.deleteTb(table:DEP_TB)  ;
     SharedPreferences    sharedPrefs = await SharedPreferences.getInstance();
     sharedPrefs.remove("settings");
     sharedPrefs.commit() ;
     setState(()  {
     if(deleteCustomers>=1 && deleteTables>=1 &&
         deleteCategory>=1 && deleteProduct>=1 &&
         deleteCashTypes>=1&& deleteDep>=1){
          print("done Delete") ;
          tools.Dialog(title:" تم المسح كامل"  , message:"" ,
              onOkClick: (){


              }  , isCancelBtn:false  , context: context) ;
          progressDialog('Downloading file...')  ;
          api.getDefinition(onSuccess: (){

            pr.hide();
            tools.Dialog(title:""  , message: "تم مزامنه التعريفات بنجاح" ,
                onOkClick: (){
                  setState(() {
                    //pr.hide() ;

                  });

                }  , isCancelBtn:false  , context: context) ;
          } , onError:  (String e){
            tools.Dialog(title:""  , message: "error"+ e ,
                onOkClick: (){
                  setState(() {
                    //pr.hide() ;

                  });

                }  , isCancelBtn:false  , context: context) ;
          }) ;
     }
     else{
       String s  =
       deleteCustomers.toString()+"&&"+deleteTables.toString()+ "&&"+
           deleteCategory.toString() +"&"+ deleteProduct.toString() +"&&"+
           deleteCashTypes.toString()+"&&"+ deleteDep.toString() ;
       tools.Dialog(title:"لم يتم المسح كامل"  , message: s,
           onOkClick: (){

           }  , isCancelBtn:false  , context: context) ;
     }

    }
    );
  }
  void onExportInvoiceClick(){
    setState(() {
      progressDialog('جاري تنفيذ طلبكم...')  ;

      getCloseInvoices()  ;
    });
  }
  Future<void> getCloseInvoices() async {
    List<Invoices> list = new List() ;
    final allRows = await dbHelper.getAllCloseInvoice(0)  ;
    print(" length  " + allRows.length.toString()  )  ;
    if(allRows.length>0) {
      for (int i = 0; i < allRows.length; i++) {
        Map<String, dynamic> map = allRows[i];
        Invoices invoice = Invoices.getFromSqlInvoice(map);

        List<Product>productList = new List();

        final productRows = await dbHelper.getProductsByInvID(
            invoice.id.toString());
        for (int j = 0; j < productRows.length; j++) {
          Map<String, dynamic> productMap = productRows[j];
          Product product = Product.getFromSqlInvoice(productMap);
          productList.add(product);
        }
        invoice.products = productList;
       print( invoice.products[0].pNmAr) ;
        list.add(invoice);
      }
      if(list.length==allRows.length){
      double taxPercentage = 0;
      if (settings.taxIsPer) {
        taxPercentage = settings.taxPercent;
      }
      api.saveInvoices(
          invList: list, taxPercentage: taxPercentage, onError: () {

      }, onSuccess: (String msg , String daily , String inv_id) {
        deleteInvoices();
      });
      }
    }
    else{
      setState(() {

        tools.Dialog(title:""  , message: "لا يوجد  فواتير للتصدير " ,
            onOkClick: (){
          setState(() {
            pr.hide() ;

          });

            }  , isCancelBtn:false  , context: context) ;

      });
      // لايوجد  فواتير للتصدير
    }
  }
  Future<void>  deleteInvoices() async {
    final allRows = await dbHelper.getAllCloseInvoice(0)  ;
    int i  ;
    for( i=0;  i  < allRows.length  ;  i++)     {
      Map<String, dynamic> map = allRows[i]  ;
      Invoices invoice  = Invoices.getFromSqlInvoice(map) ;
      final deleteProduct = await dbHelper.deleteInvProducts(invoiceId: invoice.id)  ;
      if(deleteProduct>=1){
        final deleteInv = await dbHelper.deleteInv(invoiceId: invoice.id)  ;
        // dialog تم تصدير الفواتير
      }

    }
    if(allRows.length==i) {
      pr.hide();
      tools.Dialog(title:""  , message: "تم تصدير جميع الفواتير " , onOkClick: (){}  , isCancelBtn:false  , context: context) ;
    }

  }
  Settings  settings ;
  Future<void> getSetting() async {
    SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    settings = Settings.fromJson(json.decode(sharedPrefs.getString("settings") )) ;

  }
  Future<void> progressDialog( String msg) async {
    pr = ProgressDialog(context);
    pr = ProgressDialog(context,type: ProgressDialogType.Normal, isDismissible: false, showLogs: false);
    pr.style(
        message: msg,
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
  // design////////////////////////////////////////////////////////////////////
  Padding importToolsBtn() {
    return new Padding (padding: EdgeInsets.only(bottom: 8.0 , left: 40.0  , right: 40.0 , top: 8.0),child:new Container(
      decoration:  new BoxDecoration(color:MyColors.colorPrimary
          , borderRadius:  const BorderRadius.all(
            const Radius.circular(8.0),)
      ),
      width  :   double.infinity,
      child  :   new FlatButton(
        onPressed: onImportToolsClick ,
        child: new Text(AppLocalizations.of(context).translate("import_tools") , style: new TextStyle(color: Colors.white),),
      ) ,
    ) )
    ;
  }

  Padding exportInvoiceBtn () {
    return new Padding (padding: EdgeInsets.only(bottom: 8.0 , left: 40.0  , right: 40.0 , top: 8.0),child:new Container(
      decoration:  new BoxDecoration(color:MyColors.colorPrimary
          , borderRadius:  const BorderRadius.all(
            const Radius.circular(8.0),)
      ),
      width  :   double.infinity,
      child  :   new FlatButton(
        onPressed: onExportInvoiceClick ,
        child: new Text(AppLocalizations.of(context).translate("export_invoice") , style: new TextStyle(color: Colors.white),),
      ) ,
    ) )
    ;
  }

}