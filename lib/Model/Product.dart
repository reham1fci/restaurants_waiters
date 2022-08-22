import 'package:flutter/material.dart';
import 'package:restaurants_waiters/Screens/Invoice.dart';
import 'package:restaurants_waiters/Tools/Constant.dart';

class Product{
  String pCode  ;
  String pNmEn  ;
  String pNmAr ;
  double cost  ;
  int unit  ;
  String unitName  ;
  double price  ;
  double unitSize  ;
  double qty  ;
  int catCode  ;
  double tax ;
  double taxAmount  ;
  int count  ;
  double priceAfterDiscount  ;
  int invoiceProductId;
  int depID  ;


  Product({ this.pCode, this.pNmEn, this.pNmAr, this.cost,
      this.unit, this.unitName, this.price, this.unitSize, this.qty,
      this.catCode , this.tax});


  Product.invoice({this.pCode, this.taxAmount, this.count, this.priceAfterDiscount , this.pNmAr , this.price ,
    this.unitSize , this.unit ,this.catCode , this.invoiceProductId , this.depID} );

  factory Product.fromJson (Map<String  ,dynamic> json ){
    return Product(
      catCode: json["cat_code"] ,
      price: json["p_price"] ,
      unit: json["unit"] ,
      cost: json["P_Cost"] ,
      pCode: json["P_CODE"] ,
      pNmAr: json ["P_ArNm"],
      pNmEn:  json["P_enNM"],
      qty: json["Qty"],
      unitName:  json["u_nm"],
      unitSize:  json["unitsize"],
      tax: json["Tax"]
    );
  }

  Map<String,dynamic> insertDb() {
    return {
      P_CAT_CODE  :this.catCode  ,
      P_PRICE :this.price  ,
      P_UNIT : this.unit,
      P_COST  :this.cost,
      P_CODE  :this.pCode,
      P_AR_NM  :this.pNmAr,
      P_EN_NM :this.pNmEn,
      QTY:this.qty,
      UNIT_NM:this.unitName  ,
      UNIT_SIZE:this.unitSize ,
     TAX :this.tax

    };
  }
  Map<String,dynamic> insertDbInvoice(int invoiceId) {
    return {
      INVP_CODE  :this.pCode  ,
      INVP_TAX :this.taxAmount  ,
      INVP_QTY : this.count,
      INVP_PRICEDISC  :this.priceAfterDiscount,
      INVP_NM  :this.pNmAr,
      INVV_ID :invoiceId ,
      INVP_PRICE: this.price ,
      INVP_CATCODE :this.catCode ,
      INVP_UNIT :this.unit ,
      INVP_UNITSIZE :this.unitSize ,
      INVP_DEP_ID: this.depID


    };
  }
  factory Product.getFromSqlInvoice(Map<String  ,dynamic> json){
    return  Product.invoice(

      priceAfterDiscount:  double.parse(json[INVP_PRICEDISC]) ,
      count:int.parse( json[INVP_QTY]),
      pCode:json[INVP_CODE].toString() ,
      taxAmount: double.parse( json[INVP_TAX]) ,
        pNmAr: json[INVP_NM] ,
        price :double.parse(json[INVP_PRICE]) ,
          catCode :json[INVP_CATCODE]  ,
      unit:  json[INVP_UNIT]  ,
      unitSize:double.parse(json[INVP_UNITSIZE])   ,
        invoiceProductId  :json[INVP_ID] ,
        depID  :json[INVP_DEP_ID]




    );

  }
  factory Product.getFromSql(Map<String  ,dynamic> json){
    return  Product(

      catCode: json[P_CAT_CODE] ,
      tax:double.parse( json[TAX]),
      unitSize:double.parse(json[UNIT_SIZE] ),
      unitName: json[UNIT_NM] ,
      qty: double.parse(json[QTY]),
      pNmEn:  json[P_EN_NM],
      pNmAr: json[P_AR_NM] ,
      pCode: json[P_CODE].toString() ,
      cost: double.parse(json[P_COST]) ,
      unit: json[P_UNIT] ,
      price:double.parse( json[P_PRICE] ) ,
    );

  }
  Map<String, dynamic> toJson(  int rcdNo , String userId) {
    return {
      "P_Code": this.pCode,
      "Unit": this.unit.toString() ,
      "UnitSize":this.unitSize.toString() ,
      "QTY": this.count.toString(),
      "priceFor1": this.price.toString(),
      "Price": (this.count*this.price).toString() , // ":"07/03/2021 05:40:44 PM",
      "Taxfor1": this.taxAmount ,
      "Tax": (this.taxAmount*this.count ),
      "Rcrd_No": rcdNo.toString() ,
      "Usr_Id": userId ,
      "Cat_Code": this.catCode ,
    };
  }






}