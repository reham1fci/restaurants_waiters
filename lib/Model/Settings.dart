import 'dart:convert';

class Settings {
    double hoursLate  ;
    bool useSectionInBill ;
    bool useOpenPrice;
    bool useTax ;
    bool useProductTax ;
    bool taxIsPer ;
    double taxPercent ;
    bool isAddTax; //     دا معناه اضيف الضريه بعد الجمع الفاتوره والسعر غير شامل الضريبه
    bool taxFunc1 ;
    bool taxFunc2 ;
    bool useServiceTax ;
    bool taxIsPrice ;
    double taxPrice ;
   double servicePercent  ;
   bool calcTaxAfterSrvs;
   bool taxAftrDisc ;
   bool showUnitInSales ;
   bool showQtyOnSalesItem ;
   bool printQrCode ;

  Settings({this.hoursLate, this.useSectionInBill,
      this.useOpenPrice, this.useTax, this.useProductTax, this.taxIsPer,
      this.taxPercent, this.isAddTax, this.taxFunc1, this.taxFunc2,
      this.useServiceTax, this.taxIsPrice, this.taxPrice, this.servicePercent,
      this.calcTaxAfterSrvs, this.taxAftrDisc, this.showUnitInSales,
      this.showQtyOnSalesItem , this.printQrCode});

  factory Settings.fromJson(Map<String  ,dynamic> json){
    return Settings(
      calcTaxAfterSrvs: json["CalcTaxAfterSrvs"] ,
      hoursLate: json["HoursToLate"] ,
      isAddTax: json["isAddTax"] ,
      servicePercent:json["ServicePercent"],
      showQtyOnSalesItem:  json["ShowQtyOnSalesItem"],
      showUnitInSales: json["ShowUnitInSales"] ,
      taxAftrDisc:json["TaxAftrDisc"] ,
      taxFunc1: json["TaxFunc1"]
      , taxFunc2:  json["TaxFunc2"]
      , taxIsPer: json["taxIsPer"]
      , taxIsPrice: json["taxIsPrice"],
      taxPercent: json["taxPercent"]
      , taxPrice: json["taxPrice"]
      , useOpenPrice: json["useOpenPrice"] ,
      useProductTax: json["useProductTax"] ,
      useSectionInBill: json["useSectionInBill"] ,
      useServiceTax: json["UseServiceTax"] ,
      useTax: json["useTax"] ,
        printQrCode: json["Print_QRCode"] ,



    );
  }
    Map<String  ,dynamic> toJson(){
    return {
      "CalcTaxAfterSrvs":this.calcTaxAfterSrvs,
      "HoursToLate":this.hoursLate  ,
      "isAddTax": this.isAddTax ,
      "ServicePercent": this.servicePercent ,
      "ShowQtyOnSalesItem":this.showQtyOnSalesItem ,
      "ShowUnitInSales": this.showUnitInSales  ,
      "TaxAftrDisc" :this.taxAftrDisc  ,
      "TaxFunc1": this.taxFunc1 ,
      "TaxFunc2":this.taxFunc2  ,
      "taxIsPer":this.taxIsPer ,
      "taxIsPrice":this.taxIsPrice  ,
      "taxPercent":this.taxPercent ,
      "taxPrice":this.taxPrice ,
       "useOpenPrice":this.useOpenPrice  ,
     "useProductTax":this.useProductTax,
   "useSectionInBill":this.useSectionInBill ,
"UseServiceTax":this.useServiceTax ,
     "useTax":this.useTax,
      "Print_QRCode":this.printQrCode



    };

    }















    }