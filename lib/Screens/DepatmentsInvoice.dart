import 'dart:typed_data';

import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:esc_pos_printer/esc_pos_printer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:restaurants_waiters/Database/DatabaseHelper.dart';
import 'package:restaurants_waiters/Model/Departments.dart';
import 'package:restaurants_waiters/Model/Invoices.dart';
import 'package:restaurants_waiters/Model/Product.dart';
import 'package:restaurants_waiters/Tools/MethodsTools.dart';
import 'package:restaurants_waiters/app_localizations.dart';
import 'package:screenshot/screenshot.dart';
import 'package:image/image.dart' as im;


class DepInvoice extends StatefulWidget {
  Invoices inv2  ;
  Departments dep2 ;
  List<Product> products2   ;

  DepInvoice({this.inv2, this.dep2, this.products2});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return DepInvoiceState();
  }

}
class DepInvoiceState extends State<DepInvoice>{
  Invoices inv  ;
  Departments dep ;
  Uint8List _imageFile;

  List<Product> products   ;
  ScreenshotController screenshotController = ScreenshotController();
  final dbHelper = DatabaseHelper.instance;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    inv= widget.inv2  ;
    dep= widget.dep2  ;
    products= widget.products2  ;
    test() ;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return
      ScreenUtilInit(
        //  allowFontScaling: false,
          builder: () =>
          new Scaffold(
            body: invoiceScreen(),
          )
      );
      }


  Widget invoiceScreen ()   {


    //final data = await rootBundle.load("assets/Hacen_Tunisia.ttf");
    // var myFont = Font.
    double unitHeightValue = MediaQuery.of(context).size.height * 0.01;
    double multiplier = 25;
    int fontSize = 10  ;
    double width  = 207;

    var myStyle = TextStyle(fontFamily: 'assets/Hacen_Tunisia.ttf' ,
      // ScreenUtil().setSp(10, allowFontScalingSelf: true )
      fontSize: 10,);
    var myStyleBold = TextStyle(fontFamily: 'assets/Hacen_Tunisia.ttf' ,
      fontSize:10,fontWeight: FontWeight.bold ,);
    var myStyleBoldSmall = TextStyle(fontFamily: 'assets/Hacen_Tunisia.ttf' ,
      fontSize:8,fontWeight: FontWeight.bold ,);
    return
      Container(
          width:width,

          //padding: EdgeInsets.only(left: 5 ),
          child:  SingleChildScrollView(child:
          Screenshot(
              controller: screenshotController,
              child:
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  //Image.memory(base64Decode(_company.logo) , width: 121,  height: 100,),
                  //  new Image.asset('images/synchronize.png', width: 121,  height: 100,) ,
                 // new Text(_company.name, style:  TextStyle(fontFamily: 'assets/Hacen_Tunisia.ttf'
                     // ,fontWeight: FontWeight.bold) , ),
                //  new Text(_company.companyMark),
                //  new Divider(height: 1 , color: Colors.black, ),
                  new Text(dep.name+"فاتوره قسم", style: myStyle ,),
                  new Divider(height: 1 , color: Colors.black ),
                  //  new Text(inv.cashTypeId.toString(), style: TextStyle(fontFamily: 'assets/Hacen_Tunisia.ttf' ,fontWeight: FontWeight.bold) ,),
                  new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(

                        decoration: BoxDecoration(border: Border.all(
                          color: Colors.black,
                          width: 2,
                        ),),padding: EdgeInsets.all(4) ,margin: EdgeInsets.only(left:4 , right: 4)

                        ,child:  new Text(inv.id.toString(), style: TextStyle(fontFamily:'assets/Hacen_Tunisia.ttf' ,fontWeight: FontWeight.bold , )
                        ,textAlign: TextAlign.center, ), width: width*0.3,),
                      new Text(inv.billOpenDate ,style: myStyle , ),

                      /*   Container(child:  new Column (
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          new Text(AppLocalizations.of(context).translate("customer")+":"+inv.customerId.toString() ,style: myStyle , ),
                          new Text(inv.billOpenDate ,style: myStyle , ),

                        ],),width: width*0.6,)*/
                    ],
                  ),
                 /* new Text(AppLocalizations.of(context).translate("user")+ ": " +user.userName , style: myStyle),
                  //new Divider(height: 0.5 ,color: MyColors.black),
                  new Padding(padding: EdgeInsets.only(top: 5) ,child: new Divider(height: 1 , color: Colors.black )),*/
                  new Row(
                    //  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(

                        padding:EdgeInsets.only(right: 4) ,
                        child:  new Text(AppLocalizations.of(context).translate("item"),
                          style: myStyleBold , ) , width: width*0.6,),
                      Container(child:  new Text(AppLocalizations.of(context).translate("qty") ,
                          style: myStyleBold , textAlign:TextAlign.center) , width: width*0.2,),
                      Container(child:  new Text(AppLocalizations.of(context).translate("price") ,
                          style: myStyleBold ,textAlign:TextAlign.center ) , width: width*0.2,),
                    ],
                  ),
                  new Divider(height: 1 , color: Colors.black ),
                  getView(products,myStyleBoldSmall , width),
               /*   new Align(alignment:Alignment.centerLeft ,child:Padding(padding: EdgeInsets.only(left: 16),child:
                  Text( AppLocalizations.of(context).translate("amount")+
                      Methods.priceFormat(inv.total),style: myStyleBold ,textAlign: TextAlign.end,) ,)),
                  new Align(alignment:Alignment.centerLeft ,child: Padding(padding: EdgeInsets.only(left: 16),child:
                  new Text( AppLocalizations.of(context).translate("contain_tax")+"("+
                      Methods.priceFormat( taxPercentage)+"%)"+Methods.priceFormat(inv.totalTax),style: myStyleBold ,textAlign: TextAlign.end,)) ,),
                  new Divider(height: 1 , color: Colors.black , ),
                  new Align(alignment:Alignment.centerLeft ,child: Padding(padding: EdgeInsets.only(left: 16)
                      ,child: new Text( AppLocalizations.of(context).translate("total")+Methods.priceFormat(inv.totalAfterDiscount),style: myStyleBold ,textAlign: TextAlign.end,) ),),
                  new Divider(height: 1 , color: Colors.black , ),



                  Row(
                    mainAxisAlignment:MainAxisAlignment.spaceBetween,
                    children: [
                      new Container(padding: EdgeInsets.only(right: 4) , child:
                      Text( AppLocalizations.of(context).translate("paid")+":"+
                          Methods.priceFormat(inv.billGivenMoney),style: myStyleBold ,)) ,
                      new Container(padding: EdgeInsets.only(left: 4) , child:

                      new Text( AppLocalizations.of(context).translate("remainder")+":"+
                          Methods.priceFormat(inv.billChange),style: myStyleBold ,) ),
                    ],),
                  //  new Divider(height: 0.5 ,color: MyColors.grey),
                  //  new Divider(height: 0.5 ,color: MyColors.grey),*/

                  new Text(AppLocalizations.of(context).translate("thanks"),),


                    ],
            )


           ) ));



  }

  Widget getView(List<Product> list , var myStyle , double width ){

    return

      new Expanded(

        child: new ListView.builder(
          scrollDirection:Axis.vertical,
          physics: NeverScrollableScrollPhysics(),

          shrinkWrap: true,
          padding:EdgeInsets.zero  ,
          itemBuilder: (context  , index ){
            return  listCardInvoice( list ,index, myStyle , width) ;
          } ,itemCount:  list.length ,) ,flex: 0, );





  }
  Widget listCardInvoice  (List<Product> list , int index , var myStyle , double width)  {
    Product item  = list[index] ;
    return
      new Container(
          child:Column(children: [
            new  Row(
              children: [
                Container(
                  padding:EdgeInsets.only(right: 4) ,

                  child:  new Text(item.pNmAr ,style: myStyle , ) ,            width: width*0.6,),
                Container(child:  new Text(item.count.toString() ,style: myStyle ,textAlign:TextAlign.center ) , width: width*0.2,),
                Container(child:  new Text(Methods.priceFormat(item.price) ,style: myStyle ,textAlign:TextAlign.center ) , width: width*0.2,),
              ],

            ) ,
            new Divider(height: 1 , color: Colors.black ),

          ],)
        // color: Theme.of(context).cardColor,
      );
  }
  Future<void> test() async {
    _imageFile = null;
    print(dep.printerPort) ;
    print(dep.printerIp) ;
    screenshotController
        .capture(delay: Duration(seconds: 1))
        .then((Uint8List image) async {
      setState(() {
        _imageFile = image;
        print(_imageFile);
        print("printer");
      });
      print(dep.printerPort) ;
      print(dep.printerIp) ;
      final profile = await CapabilityProfile.load();
      NetworkPrinter printer = NetworkPrinter(PaperSize.mm58, profile);
      final PosPrintResult res = await printer.connect(
          dep.printerIp, port: int.parse(dep.printerPort));
      final im.Image image2 = im.decodeImage(_imageFile);
      printer.image(image2);
      printer.feed(1);
      printer.cut();
      printer.disconnect();
      print("printer");
      print(res.msg);
      Navigator.of(context).pop();
    }).catchError((onError) {
      //Navigator.of(context).pop();
      print("errorrr");
      // test();
      print(onError);
    });
  }

  }