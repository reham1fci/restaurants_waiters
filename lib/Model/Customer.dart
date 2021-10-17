import 'package:restaurants_waiters/Tools/Constant.dart';

class Customer  {
  int cID  ;
  int cCode  ;
  String cAddress  ;
  String cNm  ;
  String phone  ;
  Customer({this.cID, this.cCode, this.cAddress, this.cNm , this.phone});
  factory Customer.fromJson (Map<String  ,dynamic> json ){
    return Customer(
      cAddress:  json["C_ADRS"],
      cCode: json["C_CODE"] ,
      cID:   json["ID"] ,
      cNm:  json["C_NAME"],
      phone:  json["C_PHONE"]
    );
  }

  Map<String,dynamic> insertDb() {
    return {
      C_ID: this.cID ,
      C_CODE: this.cCode ,
      C_ADRS : this.cAddress ,
      C_NAME: this.cNm ,
      C_PHONE :this.phone

    };
  }
  factory Customer.fromSql(Map<String  ,dynamic> json){
    return Customer(
      cNm: json[C_NAME] ,
      cID: json[C_ID] ,
      cCode: json[C_CODE] ,
        cAddress: json[C_ADRS] ,
        phone:json[C_PHONE]
     );

  }



}