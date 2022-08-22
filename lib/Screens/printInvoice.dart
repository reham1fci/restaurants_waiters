import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'dart:typed_data';
import 'package:enough_convert/windows/windows1252.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as im;
import 'package:path_provider/path_provider.dart';
import 'package:restaurants_waiters/ApiConnection/Api.dart';
import 'package:restaurants_waiters/Database/DatabaseHelper.dart';
import 'package:restaurants_waiters/Model/AESEncryption.dart';
import 'package:restaurants_waiters/Model/Departments.dart';
import 'package:restaurants_waiters/Model/Invoices.dart';
import 'package:restaurants_waiters/Model/Printer.dart';
import 'package:restaurants_waiters/Model/Product.dart';
import 'package:restaurants_waiters/Model/Settings.dart';
import 'package:restaurants_waiters/Model/User.dart';
import 'package:restaurants_waiters/Model/company.dart';
import 'package:restaurants_waiters/Screens/DepatmentsInvoice.dart';
import 'package:restaurants_waiters/Tools/MethodsTools.dart';
import 'package:restaurants_waiters/app_localizations.dart';
import 'package:restaurants_waiters/my_colors.dart';
import 'package:screenshot/screenshot.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:esc_pos_printer/esc_pos_printer.dart';
import 'package:charset_converter/charset_converter.dart';
import 'package:shared_preferences/shared_preferences.dart';



 class printInvoice  extends StatefulWidget{

   Invoices invv;
   User userr;
   double taxPercent ;
   Company company  ;
    Printer cashierPrinter  ;
    Printer supervisorPrinter  ;
    String qrStr  ;
    bool printQr  ;
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return printState();
  }

   printInvoice({this.invv, this.userr , this.taxPercent , this.company  ,
     this.cashierPrinter , this.supervisorPrinter,this.qrStr ,this.printQr});

}
class printState extends State<printInvoice>{
   Company _company;
   String _qrStr ;
   bool _printQr ;
   Printer p1 , p2  ;
   bool count  =  true  ;
    double discount  =  0 ;
   AESEncryption encrypt  = new AESEncryption()  ;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    inv  = widget.invv  ;
    _qrStr = widget.qrStr ;
    _printQr = widget.printQr ;
    user  = widget.userr  ;
    taxPercentage  = widget.taxPercent  ;
    _company  = widget.company  ;
     p1  = widget.cashierPrinter  ;
     p2= widget.supervisorPrinter ;
     discount  =  inv.total-inv.totalAfterDiscount  ;

  }

  Uint8List _imageFile;

  //Create an instance of ScreenshotController
  ScreenshotController screenshotController = ScreenshotController();
  Invoices inv;
  User user;
 double taxPercentage = 0  ;
  Api  api  = new Api()  ;
  Methods tools  = new Methods()  ;
  final dbHelper = DatabaseHelper.instance;
  @override
  Widget build(BuildContext context) {

    // TODO: implement build
    return
     ScreenUtilInit(
       //  allowFontScaling: false,
         builder: () =>
      new Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context).translate("the_invoice")),
        ),
     // bottomNavigationBar: new BottomAppBar(child: new IconButton(onPressed: null, icon: new Icon(Icons.cancel)),),
        floatingActionButton: new FloatingActionButton(onPressed: test ,child: new Text(AppLocalizations.of(context).translate("print")),),
    //  floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      body: invoiceScreen(),
)
    );
  }
   Future<void> test() async {
  _imageFile = null;
    screenshotController
      .capture(delay: Duration(milliseconds: 20))
      .then((Uint8List image) async {
      setState(() {
        _imageFile = image;
        print(_imageFile)  ;
        print("printer")  ;
      showAlertDialog(context ,"جاري تنفيذ طلبك") ;

      });
  final profile = await CapabilityProfile.load();
  NetworkPrinter   printer = NetworkPrinter(PaperSize.mm58, profile);
  NetworkPrinter   printer2 = NetworkPrinter(PaperSize.mm58, profile);
  final PosPrintResult res = await printer.connect(p1.ip, port:int.parse(p1.port));
  PosPrintResult res2 = null;

      final im.Image image2 = im.decodeImage(_imageFile);
     print(p1.ip) ;
     print("testttt"+res.msg) ;

      setState(() {
  if(res.msg == "Success"){
  printer.image(image2);
  printer.feed(1) ;
  printer.cut();
   printer.disconnect();
  print("printer");
 /*tools.Dialog(context: context  , message:"Print Done"  , title: "Success" , isCancelBtn: false ,onOkClick:(){
    Navigator.of(context).pop();
  // Navigator.of(context).pop();

  }) ;*/
  Navigator.of(context).pop();
printSupervisor(printer2, image2) ;
  print(res.msg);
        }
  else{
          print(res.msg);
setState(() {


          tools.Dialog(context: context  , title:res.msg  , message: " Casher Printer"+ p1.ip+" Faild to Connect", isCancelBtn: false ,onOkClick:(){
            Navigator.of(context).pop();
            printSupervisor(printer2, image2) ;

            // Navigator.of(context).pop();

          } ) ;
});

       }

 //
      });
    /*  if(p2!=null) {
        showAlertDialog(context , "جاري تنفيذ طباعةالمراجعه") ;
        print(p2.ip) ;
        res2 = await printer2.connect(p2.ip, port:int.parse( p2.port));
        setState(() {
          if(res2.msg== "Success"){
            printer2.image(image2);
            printer2.feed(1) ;
            printer2.cut();
            printer2.disconnect();

            print(res2.msg);
         /*   tools.Dialog(context: context  , message:"Print Done"  , title: "Success" , isCancelBtn: false ,onOkClick:(){
              Navigator.of(context).pop();*
              Navigator.of(context).pop();

            }) ;*/
            Navigator.of(context).pop();
          //  Navigator.of(context).pop();
          }
          else{
            tools.Dialog(context: context  , title:res.msg  , message: " Supervisor Printer"+ p2.ip+" Faild to Connect" , isCancelBtn: false ,onOkClick:(){
              Navigator.of(context).pop();
             // Navigator.of(context).pop();
            }) ;

            // window not connect supervisor printer
          }

        });

      }
       else{
      }*/

      //    getDepartmentWithPrinters  () ;
      //Navigator.of(context).pop();


    /*tools.checkInternet((){
  api.saveInvoices(invList: [inv] ,  taxPercentage: taxPercentage,onError:( String msg){
  print(msg)  ;
  Navigator.of(context).pop();

  } ,onSuccess:(String msg){
  print(msg)  ;
  Navigator.of(context).pop();

  dbHelper.deleteInvProducts(invoiceId: inv.id)  ;
  dbHelper.deleteInv(invoiceId: inv.id)  ;

  }

  ) ;

  } , (){
  Navigator.of(context).pop();

  });*/



  }).catchError((onError) {
    //Navigator.of(context).pop();
    print("errorrr");
  // test();
    print(onError);
  });



  }
    Future<String> createQr() async {

    var tag_1 = String.fromCharCode(1) ;
    var tag_2 = String.fromCharCode(2) ;
    var tag_3 = String.fromCharCode(3) ;
    var tag_4 = String.fromCharCode(4) ;
    var tag_5 = String.fromCharCode(5) ;
    String companyName  =  "AljazeeraSoft" ;
    String num  =  "300581086200003" ;
    List <int> companyByte  = [];
    companyByte  = utf8.encode(companyName);  // تحويل اسم الشركه ل byte
    String companyByteToStr = utf8.decode(companyByte);
    String unicodeToWindows  = await CharsetConverter.decode("windows1252", companyByte);
 var length_1   = String.fromCharCode(unicodeToWindows.length);
 var length_2   = String.fromCharCode(num.length);
 var length_3   = String.fromCharCode(inv.billOpenDate.length);
 var length_4   = String.fromCharCode(inv.total.toString().length);
 var length_5   = String.fromCharCode(inv.totalTax.toString().length);
    String Line_01 =tag_1  +""+ length_1 +""+ companyByteToStr ;
    String Line_02 =tag_2  +""+ length_2 +""+ num ;
    String Line_03 = tag_3 +""+ length_3 +""+ inv.billOpenDate ;
    String Line_04 = tag_4 +""+ length_4 +""+ inv.totalAfterDiscount.toString() ;
    String Line_05 = tag_5 +""+ length_5 +""+ inv.totalTax.toString() ;

    String Final = Line_01 +""+ Line_02 +""+Line_03 +""+Line_04 +""+Line_05 ;
List<int> finalByteArr  = utf8.encode(Final) ;
 //qrStr  = base64.encode(finalByteArr);
 //print(qrStr) ;
 // dXNlcm5hbWU6cGFzc3dvcmQ=
   //   return qrStr ;
    /*String credentials = ""+"aljazeera company     "+""+"300800474700003"+""+"2021-12-03 11:13:48 PM"+""+"1000"+""+"150" ;
    //  String credentials = user.qrtest().toString();
    print(credentials) ;
    convert.Codec<String, String> stringToBase64 = convert.utf8.fuse(convert.base64);
    String encoded = stringToBase64.encode(credentials);
    // String encoded  = "AUjYtNix2YPYqSDYp9mE2YLZhNin2K/YqSDYp9mE2LnYp9mE2YXZitipINin2YTYqtis2KfYsdipINin2YTZhdit2K/ZiNiv2KkCDzMwMDU4MTA4NjIwMDAwMwMUMjAyMS0xMi0xMFQxOTowOToyNloEBzE3NTAuMDEFBjIyOC4yNg==" ;
    print(encoded) ;
    String decoded = stringToBase64.decode(encoded);
    print(decoded) ;*/




  }
  printSupervisor(NetworkPrinter   printer2  , im.Image image2) async {
    PosPrintResult res2 = null;

    if(p2!=null) {
      showAlertDialog(context , "جاري تنفيذ طباعةالمراجعه") ;
      print(p2.ip) ;
      res2 = await printer2.connect(p2.ip, port:int.parse( p2.port));
      setState(() {
        if(res2.msg== "Success"){
          printer2.image(image2);
          printer2.feed(1) ;
          printer2.cut();
          printer2.disconnect();

          print(res2.msg);
          /*   tools.Dialog(context: context  , message:"Print Done"  , title: "Success" , isCancelBtn: false ,onOkClick:(){
              Navigator.of(context).pop();*
              Navigator.of(context).pop();

            }) ;*/
          Navigator.of(context).pop();
          getDepartmentWithPrinters  () ;

          //  Navigator.of(context).pop();
        }
        else{
          tools.Dialog(context: context  , title:res2.msg  , message: " Supervisor Printer"+ p2.ip+" Faild to Connect" , isCancelBtn: false ,onOkClick:(){
            Navigator.of(context).pop();
            getDepartmentWithPrinters  () ;

            // Navigator.of(context).pop();
          }) ;

          // window not connect supervisor printer
        }

      });

    }
    else{
      getDepartmentWithPrinters  () ;

    }
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
            Image.memory(base64Decode(_company.logo) , width: 121,  height: 100,),
           //  new Image.asset('images/synchronize.png', width: 121,  height: 100,) ,
             new Text(_company.name, style:  TextStyle(fontFamily: 'assets/Hacen_Tunisia.ttf'
                 ,fontWeight: FontWeight.bold) , ),
               new Text(_company.companyMark , style: myStyle ,),
             new Divider(height: 1 , color: Colors.black, ),
             new Text("Sales Invoice | فاتوره مبيعات", style: myStyle ,),
             new Divider(height: 1 , color: Colors.black ),
           //  new Text(inv.cashTypeId.toString(), style: TextStyle(fontFamily: 'assets/Hacen_Tunisia.ttf' ,fontWeight: FontWeight.bold) ,),
             new Row(
               mainAxisAlignment: MainAxisAlignment.spaceBetween,
               children: [
                 Container(decoration: BoxDecoration(border: Border.all(
               color: Colors.black,
               width: 2,
             ),),padding: EdgeInsets.all(4) ,margin: EdgeInsets.only(left:4 , right: 4)
                   ,child:  new Text(inv.id.toString(), style: TextStyle(fontFamily:'assets/Hacen_Tunisia.ttf' ,fontWeight: FontWeight.bold , )
                   ,textAlign: TextAlign.center, ), width: width*0.3,),
                 Container(child:  new Column (
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                   new Text(AppLocalizations.of(context).translate("customer")+":"+inv.customerName.toString() ,style: myStyle , ),
                   new Text(inv.billOpenDate ,style: myStyle , ),
                 ],),width: width*0.6,)
               ],
             ),
             new Text(AppLocalizations.of(context).translate("user")+ ": " +user.userName , style: myStyle),
             //new Divider(height: 0.5 ,color: MyColors.black),
             new Padding(padding: EdgeInsets.only(top: 5) ,child: new Divider(height: 1 , color: Colors.black )),
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
             getView(inv.products,myStyleBoldSmall , width),
             new Align(alignment:Alignment.centerLeft ,child:Padding(padding: EdgeInsets.only(left: 16),child:
             Text( AppLocalizations.of(context).translate("amount")+
                 Methods.priceFormat(inv.total),style: myStyleBold ,textAlign: TextAlign.end,) ,)),
             inv.totalTax>0? new Align(alignment:Alignment.centerLeft ,
               child: Padding(padding: EdgeInsets.only(left: 16),child:
             new Text( AppLocalizations.of(context).translate("contain_tax")+"("+
                 Methods.priceFormat( taxPercentage)+"%)"+Methods.priceFormat(inv.totalTax),
               style: myStyleBold ,textAlign: TextAlign.end,)) ,):SizedBox(),
             new Divider(height: 1 , color: Colors.black , ),
             discount>0? new Align(alignment:Alignment.centerLeft ,child: Padding(padding: EdgeInsets.only(left: 16)
                  ,child: new Text( AppLocalizations.of(context).translate("discount")+
                      Methods.priceFormat(discount),style: myStyleBold ,textAlign: TextAlign.end,) ),):SizedBox(),
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
              //  new Divider(height: 0.5 ,color: MyColors.grey),
         _printQr?   QrImage(
               data: _qrStr ,
               version: QrVersions.auto,
               size: 100.0,
             ):SizedBox(),
             new Text(AppLocalizations.of(context).translate("thanks"),),

           ],
         )
       ) ) );



}
   showAlertDialog(BuildContext context ,String msg){
     AlertDialog alert=AlertDialog(
       content: new Row(
         children: [
           CircularProgressIndicator(),
           Container(margin: EdgeInsets.only(left: 5),child:Text(msg)),
         ],),
     );
     showDialog(
       context:context,
       builder:(BuildContext context){
         return alert;
       },
     );
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
  takescrshot(Widget w , NetworkPrinter printer) async {
    var scr= new GlobalKey();
    RepaintBoundary(
        key: scr,
        child: w) ;
    RenderRepaintBoundary boundary =scr.currentContext.findRenderObject();
    var image = await boundary.toImage();
    var byteData = await image.toByteData(format: ImageByteFormat.png);
    var pngBytes = byteData.buffer.asUint8List();
    print(pngBytes);
    Methods.printImage(printer, pngBytes) ;
   // printer.image(pngBytes);
    printer.feed(1);

    printer.cut();

  }
  Future<void>  getDepartmentWithPrinters() async {
    List<Departments> list = new List() ;
    final allRows = await dbHelper.getDepartmentsHavePrinter()  ;
    if(allRows.length>0){
    for(int i  =  0  ;  i  < allRows.length  ;  i++)     {

      Map<String, dynamic> map = allRows[i]  ;
      Departments dep  = Departments.fromSql(map)  ;
      print(dep.id) ;
      print(inv.products[0].depID) ;
      final List<Product> productsList = inv.products
          .where((Product product) =>

      product.depID == dep.id).toList();

      Navigator.pushReplacement( context,
          MaterialPageRoute(builder: (context) =>
              DepInvoice(dep2:dep, inv2: inv,products2: productsList,))) ;

    }}

    else {
       print("test close ") ;
       setState(() {
         Navigator.of(context).pop();
       });
    }

  }
  void _saveImage(Uint8List uint8List, Directory dir, String fileName,
      {Function success, Function fail}) async {
    bool isDirExist = await Directory(dir.path).exists();
    if (!isDirExist) Directory(dir.path).create();
    String tempPath = '${dir.path}$fileName';
    File image = File(tempPath);
    bool isExist = await image.exists();
    if (isExist) await image.delete();
    File(tempPath).writeAsBytes(uint8List).then((_) {
      if (success != null) print("save");
    });
  }

  }
