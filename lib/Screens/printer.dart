import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:esc_pos_printer/esc_pos_printer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:restaurants_waiters/Model/Invoices.dart';
import 'package:restaurants_waiters/Model/Product.dart';
import 'package:restaurants_waiters/Model/User.dart';
import 'package:flutter/services.dart';
import 'package:restaurants_waiters/my_colors.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:printing/printing.dart'
    show Printing, PdfRaster, PdfRasterImage;
import 'package:image/image.dart' as im;
import 'package:esc_pos_utils/esc_pos_utils.dart';



class MyApp extends StatelessWidget {
   MyApp(this.inv , this.user);

  final Invoices inv;
  final User user;
   Future<Uint8List> doc ;
   GlobalKey _globalKey = GlobalKey();

   Future<void> _capturePng() async {
     try {
       print('inside');
       RenderRepaintBoundary boundary =
       _globalKey.currentContext.findRenderObject();
       ui.Image image = await boundary.toImage(pixelRatio: 0.5);
       ByteData byteData =
       await image.toByteData(format: ui.ImageByteFormat.png);
       var pngBytes = byteData.buffer.asUint8List();
       var bs64 = base64Encode(pngBytes);
       print(pngBytes);
       print(bs64);
       return pngBytes;
     } catch (e) {
       print(e);
     }
   }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Widget To Image demo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Tapping button below should capture placeholder image capture the placeholder image',
            ),
            RepaintBoundary(
              key: _globalKey,
              child: Offstage(
                child: Container(
                  width:(MediaQuery.of(context).size.width )/2,
                  child: Text("test image"),
                ),
              ),
            ),
            RaisedButton(
              child: Text('capture Image'),
              onPressed: _generatePdf,
            ),
          ],
        ),
      ),
    );
  }

 Future<Uint8List> _generatePdf() async {
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
          width: 207,
            child: pw. Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                new pw.Text("رقم الفاتوره# "+ inv.id.toString() , style: myStyle ,),
                new pw.Text("الموظف"+":" + user.userID , style: myStyle),
             /*  new pw.Divider(height: 0.5 ,color: PdfColors.grey300),
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
        new pw.Text(inv.billOpenDate,),*/


        ],
            )
        ) ;
      },));

  this.doc = doc.save() ;
  _print(this.doc )  ;
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

  Future<void> _print( Future<Uint8List> doc)   async {
    PaperSize paper = PaperSize.mm80;
    final profile = await CapabilityProfile.load();
    final printer = NetworkPrinter(paper, profile);
    final PosPrintResult res = await printer.connect('31.167.73.47', port: 9100);
    print(res.msg) ;

    await for (var page in Printing.raster(await doc , dpi: 203.0 )) {
      final image = page.asImage();
      printer.image(image);
      printer.feed(2) ;

      printer.cut();
    }

    printer.disconnect();
  }



}