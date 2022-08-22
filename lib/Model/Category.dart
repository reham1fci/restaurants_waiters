import 'package:restaurants_waiters/Tools/Constant.dart';

class Category  {
int catID  ;
int catCode  ;
String catNmAr;
String catNmEn;
int sCode  ;

Category({this.catID, this.catCode, this.catNmAr, this.catNmEn , this.sCode});
factory Category.fromJson (Map<String  ,dynamic> json ){
  return Category(
    catCode:  json["Cat_Code"],
    catID: json["ID"] ,
    catNmAr:  json["Cat_arNM"] ,
    catNmEn: json["Cat_enNM"]  ,
    sCode: json["S_CODE"]  ,
  );
}

Map<String,dynamic> insertDb() {
  return {
    CAT_ID: this.catID ,
    CAT_CODE: this.catCode ,
    CAT_NM_AR : this.catNmAr ,
    CAT_NM_EN: this.catNmEn ,
    CAT_DEP_ID: this.sCode ,

  };
}

factory Category.fromSql (Map<String  ,dynamic> json ){
  return Category(
    catCode:  json[CAT_CODE],
    catID: json[CAT_ID] ,
    catNmAr:  json[CAT_NM_AR] ,
    catNmEn: json[CAT_NM_EN] ,
      sCode: json[CAT_DEP_ID]
  );
}



}