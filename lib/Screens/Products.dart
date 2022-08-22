import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:restaurants_waiters/Database/DatabaseHelper.dart';
import 'package:restaurants_waiters/Model/Category.dart';
import 'package:restaurants_waiters/Model/Invoices.dart';
import 'package:restaurants_waiters/Model/Product.dart';
import 'package:restaurants_waiters/Model/Settings.dart';
import 'package:restaurants_waiters/Screens/Invoice.dart';
import 'package:restaurants_waiters/Tools/Constant.dart';
import 'package:restaurants_waiters/Tools/MethodsTools.dart';
import 'package:restaurants_waiters/app_localizations.dart';
import 'package:restaurants_waiters/my_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
typedef Null ItemSelectedCallback(Product value);

class Products extends StatefulWidget{
 final int cateCode ;

 final ItemSelectedCallback onItemSelected;

  Products(this.cateCode,this.onItemSelected);

  @override
  ProductState createState()=>ProductState() ;


}
class ProductState  extends State<Products>{

  final dbHelper = DatabaseHelper.instance;
  List<Product>productList  = new List()  ;
  bool unitShow ;
  bool qtyShow ;
  Settings  settings;
  double priceAfterDiscount  ;
    static int invoice_id  ;
     double total  ;
     double total_tax  ;
     double total_afterDisc  ;
     int catCode  = 2 ;

 Future<void> getProductsByCategory(int catCode  ) async{
    final allRows = await dbHelper.getProductByCatCode(catCode.toString());
    List<Product>itemList  = new List() ;
    for(int i  =  0  ;  i  <allRows.length  ;  i++)     {
      Map<String, dynamic> map = allRows[i]  ;
      Product item  = Product.getFromSql(map)  ;
      itemList.add(item) ;
    }
   onGetItemSuccess(itemList)  ;
  }
  onGetItemSuccess(List<Product>list){
   print("test her")  ;

   setState(() {
    //  loading = false ;
     productList  = list  ;});


  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("testproduct"+widget.cateCode.toString()) ;
    getLastInv();
    getSetting() ;
    getCategories();
  }
  Future <void> getLastInv() async{
    final allRows = await dbHelper.getLastInvoice()  ;
     print("length"+allRows.length.toString()) ;
    for(int i  =  0  ;  i  < allRows.length  ;  i++) {
      Map<String, dynamic> map = allRows[i];
      Invoices inv = Invoices.getFromSqlInvoice(map);
      if (inv.isOpen == 1) {
      setState(() {
        invoice_id = inv.id;
      });
    }
      else{
        List<String> dates  =  Methods.getDateTime(settings.hoursLate.toInt());
        int dailyNo = 1 ;
        if(inv.billDate==dates[1]){
          dailyNo = inv.invDailyNo +1 ;
        }


        Invoices invv  =  new Invoices(isOpen: 1  , total: 0 , totalAfterDiscount: 0 , totalTax: 0 , billOpenDate: dates[0] , invDailyNo: dailyNo , billDate: dates[1]) ;
        final id = await dbHelper.insert(invv.insertDb() , INVOICE_TB);
         invoice_id = id;

      }
       }



  }
  Future<void> getSetting() async {
    SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    settings = Settings.fromJson(json.decode(sharedPrefs.getString("settings") )) ;
    unitShow = settings.showUnitInSales;
    qtyShow = settings.showQtyOnSalesItem ;
  }
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.height) / 2;
    final double itemWidth = size.width / 2;
    var _crossAxisSpacing = 8;
    var _screenWidth = MediaQuery.of(context).size.width;
    var _crossAxisCount = 2;
    var _width = ( _screenWidth - ((_crossAxisCount - 1) * _crossAxisSpacing)) / _crossAxisCount;
    var cellHeight = 150;
    int widthCard= 200;
    var _aspectRatio = widthCard /cellHeight;

    double width=MediaQuery.of(context).size.width;

    int countRow=width~/widthCard;
    getProductsByCategory(catCode) ;

    // TODO: implement build
    return
      new Scaffold(

    body:  Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/background2.png" ),
            fit: BoxFit.fill,
          ),
        ),
   child:
   Column( children: [







       getView(categoryList) ,

    /* Expanded(
       flex: 0,
         child: Divider()
     ),*/
     Expanded(child:GridView.builder(
       shrinkWrap: true,

        // Create a grid with 2 columns. If you change the scrollDirection to
        // horizontal, this produces 2 rows.
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount( crossAxisCount: countRow, childAspectRatio: _aspectRatio
         ),

        itemBuilder: (context  , index ){

          return listCard(productList , index) ;
        } ,itemCount:  productList.length , ) ,flex: 1, )

   ],)   )) ;

  }
  Widget  listCard  (List <Product> list  , int index) {
    Product item  = list[index] ;
    // getBackgroundColor(requestItem ) ;
    return
     // new Padding(padding: EdgeInsets.only(top: 4.0  ,right: 8.0 , left:  8.0 ,bottom: 2.0 )  , child :
      new Card(
        elevation: 30,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),

            side: BorderSide(
              color: Colors.blue,
              width: 1.0,
            )),
            child: InkWell(
            onTap: () async {
              item.priceAfterDiscount = await  checkDiscount(item)  ;
              print( "priceAfterDiscount"+item.priceAfterDiscount.toString()) ;
              item.count = 1;
              if(settings.taxIsPer) {
              item.taxAmount  =  calcTaxAmount(item) ;}
              else{
                item.taxAmount = settings.taxPrice ;
              }
              print("tax"+ item.taxAmount.toString()) ;
              print("taxp"+ item.tax.toString()) ;
              item.depID = selectedCategory.sCode ;
              print( "priceAfterDiscount"+item.taxAmount.toString()) ;
              print( "invoiceID"+invoice_id.toString()) ;
              final id = await dbHelper.insert(item.insertDbInvoice(invoice_id) ,
                  INVOICEPRODUCT_TB);
              print(id) ;
              getInvoice(item);

              //   widget.onItemSelected(item);
           // print(category.catCode) ;
            },
              child:new Container(
                // color: backgroundReq,
                //  padding:  new EdgeInsets.all(8.0),

                child:  new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      new  Padding(padding: EdgeInsets.all(2.0) , child:Text(item.pNmAr , textAlign: TextAlign.center,
      ),) ,
      new Padding(padding: EdgeInsets.all(2)  , child:  new Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,

        children: [
        new Text(Methods.priceFormat(item.price)),
        unitShow?new Text(item.unitName.toString()):SizedBox(),
      ],),) ,


    qtyShow?  new Text(item.qty>0&&item.qty<1000?item.qty.toString():SizedBox()):SizedBox(),

      //  new Padding(padding: EdgeInsets.all(16.0)  , child: new Text(inv.invDesc) ,) ,
    ],

              ) ,

              color: Theme.of(context).cardColor,
            ) )
     // )
    );
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
  Future <void> getInvoice(Product p ) async{
    List<Product> list = new List() ;
     Invoices inv;
    print( "invoiceID2"+invoice_id.toString()) ;

    final allRows = await dbHelper.getInvByID(invoice_id.toString())  ;
    for(int i  =  0  ;  i  < allRows.length  ;  i++)     {
      Map<String, dynamic> map = allRows[i]  ;
       inv  = Invoices.getFromSqlInvoice(map)  ;

    }
      total = inv.total ;
     total_tax= inv.totalTax ;
    total_afterDisc  =  inv.totalAfterDiscount  ;

    Map  <String,dynamic> m  = new Map();
       double d = total+(p.count*p.price);
       double tax = total_tax+(p.count*p.taxAmount);
       double afterDisc = total_afterDisc+(p.count*p.priceAfterDiscount);
       m[INV_TOTAL]=d ;
    m[INV_TOTALTAX]=tax ;
    m[INV_TOTALAFTERDISCOUNT]=afterDisc ;
      final l = await dbHelper.updateInvoice(m , invoice_id.toString());
    //Invoice().callGetProduct(invoice_id) ;

  }
  double calcTaxAmount ( Product product) {
   double taxPercent ;
   if(settings.useTax) {
     taxPercent  = settings.taxPercent  ;
   }
   else {
     taxPercent  = product.tax  ;

   }
   if(settings.isAddTax){
      return product.priceAfterDiscount*(taxPercent/100) ;
   }
   else{

    double x=(product.priceAfterDiscount*100)/(100+taxPercent)  ;
    return x*(taxPercent/100)  ;

  }
  }

  Widget getView(List<Category>list){
    if(list.length>0){
      return   Expanded(
child:


          ClipRRect( child:
new Container(
    decoration: BoxDecoration(
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: Colors.grey,
          offset: Offset(0.0, 1.0), //(x,y)
          blurRadius: 6.0,
        ),
      ],
    ),
          margin: const EdgeInsets.only(bottom: 6.0), //Same as `blurRadius` i guess

 // color: MyColors.colorPrimary,
          height: 50,
           child:new ListView.builder(
             shrinkWrap: true,

             scrollDirection:Axis.horizontal ,
        itemBuilder: (context  , index ){
          return listCardGroups(list , index) ;
        } ,itemCount:  list.length , ))  ),flex: 0, );

    }
    else{

      return noThingView();

    }

  }

  Widget noThingView(){
    return new Container(child:
    new Center(
      child:  new Column( children: <Widget>[
        //  Image.asset('images/nothing.png', fit: BoxFit.contain),
        Text (AppLocalizations.of(context).translate("not_found"))
      ], mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,),
    ) , ) ;
  }
  Category selectedCategory ;
  Widget  listCardGroups  (List <Category> list  , int index) {
    Category category  = list[index] ;
    selectedCategory  = category  ;

    // getBackgroundColor(requestItem ) ;
    return
     // new Padding(padding: EdgeInsets.only(top: 4.0  , right: 8.0 , left:  8.0 )  , child :
      new Container(
           // height: 50,
          //  color: MyColors.colorPrimary,

            child: new Card(
              color: MyColors.blue,
              child: InkWell(
                highlightColor: MyColors.grey,
                splashColor: MyColors.black,
              focusColor:MyColors.greyDark ,
              hoverColor:Colors.redAccent ,
             // overlayColor:Colors.redAccent ,
              onTap: () {
                setState(() {
                  catCode  =  category.catCode  ;

                });
              //  widget.onItemSelected(category.catCode);
                print(category.catCode) ;
              },

              child:new Container(
               padding: EdgeInsets.all(8.0),
                child: new Text(category.catNmAr  , style: TextStyle(color: MyColors.white),)),
              ) ,

        )
      //  )
    );
  }

  Future <void> getCategories() async{
    List<Category> list = new List() ;
    final allRows = await dbHelper.queryAllRows(CATEGORY_TB)  ;
    for(int i  =  0  ;  i  < allRows.length  ;  i++)     {
      Map<String, dynamic> map = allRows[i]  ;
      Category category  = Category.fromSql(map)  ;
      list.add(category) ;

    }
    setState(() {
      categoryList  = list ;
    });

  }
  List<Category>categoryList  = new List() ;

}