import 'package:flutter/material.dart';
import 'package:restaurants_waiters/Model/Invoices.dart';
import 'package:restaurants_waiters/Model/Order.dart';
import 'package:restaurants_waiters/Model/Product.dart';
import 'package:restaurants_waiters/my_colors.dart';

import '../app_localizations.dart';

class OrderDetails extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
   return new  DetailsState();
  }


}
class DetailsState extends State<OrderDetails>{
  Order order ;

  @override
  Widget build(BuildContext context) {
    List<Product> dataList  = new List();

    // TODO: implement build
    return Scaffold(
      body: new Container(child: new Column(
        children: [
          new Padding(padding: EdgeInsets.all(8) , child:
          orderInfoCard()) ,
      new Padding(padding: EdgeInsets.only(left: 8 , right: 8 ,) , child:

      getView(dataList)) ,
        ],
      ),),
      bottomNavigationBar: BottomAppBar(child:new Container(
          padding: EdgeInsets.all(16),
          color: MyColors.colorPrimary,

          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              new Text(AppLocalizations.of(context).translate("total")  , style: new TextStyle(color:Colors.white),),
              new Text(order.total.toString() +   AppLocalizations.of(context).translate("currency") , style: new TextStyle(color:Colors.white),),


            ],) ),),
    )
    ;
  }
  GestureDetector  orderInfoCard  () {
    // getBackgroundColor(requestItem ) ;
    return  GestureDetector(
        onTap:(){
        } ,
        child : new Padding(padding: EdgeInsets.only(top: 4.0  ,
            right: 8.0 , left:  8.0 )  ,
            child :   new Card(

              child:new Container(
                child:new Column(children: [
                  new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      new Text(AppLocalizations.of(context).translate("order_num")),
                      new Text(order.orderNum),
                      //  new Padding(padding: EdgeInsets.all(16.0)  , child: new Text(inv.invDesc) ,) ,
                    ],

                  ) ,
                  new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      new Text(AppLocalizations.of(context).translate("customer")),
                      new Text(order.customer),
                      //  new Padding(padding: EdgeInsets.all(16.0)  , child: new Text(inv.invDesc) ,) ,
                    ],

                  ) ,
                  new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      new Text(AppLocalizations.of(context).translate("table_num")),
                      new Text(order.table),
                      //  new Padding(padding: EdgeInsets.all(16.0)  , child: new Text(inv.invDesc) ,) ,
                    ],

                  ) ,
                  new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      new Text(AppLocalizations.of(context).translate("pay_way")),
                      new Text(order.payWay),
                      //  new Padding(padding: EdgeInsets.all(16.0)  , child: new Text(inv.invDesc) ,) ,
                    ],

                  ) ,
                  new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      new Text(AppLocalizations.of(context).translate("invoice")),
                      new Text(order.invoiceType),
                      //  new Padding(padding: EdgeInsets.all(16.0)  , child: new Text(inv.invDesc) ,) ,
                    ],

                  ) ,
                  new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      new Text(AppLocalizations.of(context).translate("date")),
                      new Text(order.date),
                      //  new Padding(padding: EdgeInsets.all(16.0)  , child: new Text(inv.invDesc) ,) ,
                    ],

                  ) ,

                ],)


              ) ,

              color: Theme.of(context).cardColor,
            ) ));
  }
  Widget getView(List<Product>list){
    if(list.length>0){
      return new ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemBuilder: (context  , index ){
          return listCard(list , index) ;
        } ,itemCount:  list.length , ) ;

    }
    else{
      return SizedBox();
    }


  }



  GestureDetector  listCard  (List <Product> list  , int index) {
    Product item  = list[index] ;
    // getBackgroundColor(requestItem ) ;
    return  GestureDetector(
        onTap:(){

          /*  Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Products()),
          );*/

          // String name  =  list[index].  name ;
          //  print(name )  ;
        } ,
        child : new Padding(padding: EdgeInsets.only(
          top:  4.0  ,
        )  ,
            child :   new Card(
                child:new Container(
                  // color: backgroundReq,
                  padding:  new EdgeInsets.all(8.0),

                  child:  new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      new Text(item.pNmAr),
                      new Text(item.qty.toString()),
                      new Text(item.price.toString()),

                      //  new Padding(padding: EdgeInsets.all(16.0)  , child: new Text(inv.invDesc) ,) ,
                    ],

                  ) ,

                  color: Theme.of(context).cardColor,
                ) )));
  }
}