import 'package:restaurants_waiters/Tools/Constant.dart';

class Tables  {
String tableNm ;
int tableId  ;

Tables({this.tableNm, this.tableId});

factory Tables.fromJson (Map<String  ,dynamic> json ){
  return Tables(
    tableId:  json["TB_CODE"] ,
    tableNm:json["TB_NM"] ,
  );
}

Map<String,dynamic> insertDb() {
  return {
    TB_CODE: this.tableId ,
    TB_NM: this.tableNm ,

  };
}
factory Tables.fromSql(Map<String  ,dynamic> json){
  return Tables(
      tableId: json[TB_CODE] ,
      tableNm: json[TB_NM] ,
  );

}

}