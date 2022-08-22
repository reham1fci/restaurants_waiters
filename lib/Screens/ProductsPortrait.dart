import 'package:flutter/material.dart';
import 'package:restaurants_waiters/Screens/Products.dart';
class ProductsPortrait  extends StatefulWidget{
  final int data;


  ProductsPortrait(this.data);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ProductsPortraitState();
  }




}
class ProductsPortraitState extends State<ProductsPortrait> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
    //  body: Products(widget.data),
    );
  }


}