import 'package:restaurants_waiters/Tools/Constant.dart';


class CashTypes  {

int id  ;
String enNm ;
String arNm  ;

CashTypes({this.id, this.enNm, this.arNm});
factory CashTypes.fromJson (Map<String  ,dynamic> json ){
  return CashTypes(
    id: json["ID"] ,
    arNm: json["Arabic"] ,
    enNm: json["English"]  ,
  );
}

Map<String,dynamic> insertDb() {
  return {
    CASH_ID: this.id ,
    EN_NM: this.enNm ,
    AR_NM : this.arNm ,

  };
}
factory CashTypes.fromSql(Map<String  ,dynamic> json){
  return CashTypes(
      id: json[CASH_ID] ,
      arNm: json[AR_NM] ,
      enNm: json[EN_NM]
  );

}
}