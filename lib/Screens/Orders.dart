import 'package:flutter/material.dart';
import 'package:restaurants_waiters/Model/Order.dart';
import 'package:restaurants_waiters/Screens/Products.dart';

import '../app_localizations.dart';

class Orders extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
   return new OrdersState();
  }
}
class OrdersState extends State<Orders>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    List<Order>_itemList  = new List() ;
    // TODO: implement build
    return new Scaffold(
      body:
      getView(_itemList),
    )  ;
  }
  Widget getView(List<Order>list){
    if(list.length>0){
      return new ListView.builder(
        itemBuilder: (context  , index ){
          return listCard(list , index) ;
        } ,itemCount:  list.length , ) ;

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
    ) , height: double.infinity, ) ;
  }
  GestureDetector  listCard  (List <Order> list  , int index) {
    Order item  = list[index] ;
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
        child : new Padding(padding: EdgeInsets.only(top: 4.0  ,
            right: 8.0 , left:  8.0 )  ,
            child :   new Card(
              child: new Column(children: [
                new Text("Order#"+item.orderNum),
                new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    new Text(item.customer),
                    new Text(item.table),

                  ],),
                new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    new Text(item.payWay),
                    new Text(item.invoiceType),

                  ],),



              ],),

              color: Theme.of(context).cardColor,
            ) ));
  }



}