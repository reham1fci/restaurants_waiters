import 'package:restaurants_waiters/Tools/Constant.dart';

class Departments {
  int id  ;
  String name  ;
  String printerIp  ;
  String printerPort  ;

  Departments({this.id, this.name, this.printerIp, this.printerPort});
  factory Departments.fromJson (Map<String  ,dynamic> json ){
    return Departments(
      id:   json["S_CODE"],
      name: json["S_arNM"] ,
    );
  }

  Map<String,dynamic> insertDb() {
    return {
      DEP_ID: this.id ,
      DEP_NAME: this.name ,
      DEP_PORT:"9100",

    };
  }

  factory Departments.fromSql (Map<String  ,dynamic> json ){
    return Departments(
        id:  json[DEP_ID],
        name: json[DEP_NAME] ,
        printerIp:  json[DEP_IP] ,
        printerPort: json[DEP_PORT]
    );
  }


}