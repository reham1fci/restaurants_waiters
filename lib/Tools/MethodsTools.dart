import 'dart:io';
import 'dart:typed_data';

import 'package:esc_pos_printer/esc_pos_printer.dart';
import 'package:flutter/material.dart' hide Image;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image/image.dart';
import 'package:intl/intl.dart';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:restaurants_waiters/Model/Invoices.dart';
import 'package:restaurants_waiters/Model/Product.dart';
import 'package:restaurants_waiters/Model/User.dart';

class Methods {
  Future<void> Dialog({BuildContext context , String title  , String message   , bool isCancelBtn ,Function onOkClick , Function onCancelClick}) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(message),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
                onOkClick();
              },
            ),
           isCancelBtn? FlatButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
                 onCancelClick();
              },
            ):SizedBox(),
          ],
        );
      },
    );
  }
  Future<void> checkInternet( Function onConnect , Function notConnected) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
        onConnect() ;
      }
    } on SocketException catch (_) {
      print('not connected');
      notConnected() ;
    }

  }
   static List<String>  getDateTime( int lateHour) {
    List<String> dates = new List() ;
    var now = new DateTime.now();
    String  timeFormat = new DateFormat('hh:mm:ss a').format(now);
    var duration = new Duration(hours : lateHour);
    var date  =  now.add(duration)  ;
    String dateFormat  = new DateFormat('dd/MM/yyyy').format(date)  ;
    dates.add(dateFormat +" " +timeFormat)  ;
    dates.add(dateFormat)  ;
    return dates;



  }
   static printImage( NetworkPrinter printer , Uint8List bytes,){
    // final Image image2 = decodeImage(bytes);
    // printer.image(image2);
   }

  Future<Uint8List> generatePdf(Invoices inv,  User user) async {
    final data = await rootBundle.load("assets/Hacen_Tunisia.ttf");
    var myFont = pw.Font.ttf(data);
    var myStyle = pw.TextStyle(font: myFont ,);
    final doc = pw.Document();
    doc.addPage(pw.Page(
      pageFormat: PdfPageFormat.a4 ,
      theme:pw.ThemeData.withFont(base: myFont),
      textDirection: pw.TextDirection.rtl,
      build: (context) {
        return    pw.Container(
            child: pw. Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                new pw.Text("N# "+ inv.id.toString() , style: myStyle ,),
                new pw.Text("employee"+":" + user.userID , style: myStyle),
                new pw.Divider(height: 0.5 ,color: PdfColors.grey300),
                // new DottedLine(dashLength: 30, dashGapLength: 30),

                new pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,

                  children: [
                    new pw.Text("الصنف" ,style: myStyle),
                    new pw.Text("الكميه" , style: myStyle),
                    new pw.Text("السعر", style: myStyle),

                    //  new Padding(padding: EdgeInsets.all(16.0)  , child: new Text(inv.invDesc) ,) ,



                    // getView(inv.products)
                  ],
                ),
                getView(inv.products,myStyle),
                new pw.Divider(height: 0.5 ,color: PdfColors.grey300),

                pw. Row(
                  mainAxisAlignment:pw.MainAxisAlignment.spaceBetween,
                  children: [
                    new pw.Text("الاجمالي" ,style: myStyle) ,
                    //style: pw.TextStyle(fontSize:20.0 , ),),
                    new pw.Text(inv.totalAfterDiscount.toString() +  "ريال",style: myStyle)
                    //style: pw.TextStyle(fontSize:20.0 ,fontWeight: pw.FontWeight.bold  ,


                  ],),
                new pw.Divider(height: 0.5 ,color: PdfColors.grey300),
                new pw.Divider(height: 0.5 ,color: PdfColors.grey300),
                new pw.Align(child: pw.Text("cash "+ inv.billGivenMoney.toString() , style: myStyle ,)
                    , alignment: pw.Alignment.topRight),

                // pw.Text("cash "+ inv.billGivenMoney.toString() , style: myStyle ,),
                new pw.Align(child: pw.Text("Change "+ inv.billChange.toString() , style: myStyle ,)
                    , alignment: pw.Alignment.topRight),
                new pw.Text('Thank you!',),
                new pw.Text(inv.billOpenDate,),


              ],
            )
        ) ;
      },));



    return doc.save();
  }

  pw.Widget getView(List<Product> list , covariant myStyle ){

    if(list.length>0){
      return new pw.ListView.builder(
        direction:pw.Axis.vertical,

        itemBuilder: (context  , index ){
          return  listCardInvoice( list ,index, myStyle) ;
        } ,itemCount:  list.length , );

    }
    else{
      return pw.SizedBox();
    }


  }
  pw.Widget listCardInvoice  (List<Product> list , int index , var myStyle)  {
    Product item  = list[index] ;
    return
      new pw.Container(
        width: double.infinity,

        // color: backgroundReq,
        //  margin:   pw.EdgeInsets.all(8.0),
        child:  new  pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            new pw.Text(item.pNmAr , style: myStyle),
            new pw.Text(item.count.toString() , style: myStyle) ,
            new pw.Text(item.price.toString() , style: myStyle),

            //  new Padding(padding: EdgeInsets.all(16.0)  , child: new Text(inv.invDesc) ,) ,
          ],

        ) ,

        // color: Theme.of(context).cardColor,
      );
  }
  static  String priceFormat(double n) {
    return n.toStringAsFixed(n.truncateToDouble() == n ? 0 : 2);
  }
  static void toastMessage(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }

}