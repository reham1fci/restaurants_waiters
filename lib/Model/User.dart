class User{
  String userName  ;
  String password  ;
  String name  ;
  String machNm  ;
  String machNo  ;
  String userID ;
  String branchId  ;
  int permissionCode  ;
  String invoiceIndex  ;
  String dailyNo  ;




  User({this.userName, this.password, this.machNm});
  User.jsonParsing({this.userName, this.password, this.machNm , this.userID , this.branchId , this.permissionCode , this.name , this.machNo
  , this.dailyNo , this.invoiceIndex} );
  Map loginMap() {
    var map = new Map<String, dynamic>();
    map["Mach_Nm"]  = machNm ;
    map["username"] = userName ;
    map["Password"] = password;
    return map;
  }Map qrtest() {
    var map = new Map<String, dynamic>();
    map["Seller Name"]  = "test" ;
    map["Registration Number "]  = 300581086200003 ;
    map["Date and time "]  = "10-12-2021 19:09:02" ;
    map["Tax Total "] = 500;
    map["VAT total "] = 5;
    return map;
  }
  factory User.fromJson (Map<String  ,dynamic> json , String password , String userName , String machNm){
    return User.jsonParsing(
     name :json['user_L_Name'] ,
     userName : userName,
      userID:json['user_Id'] ,
      machNo:json['mach_no']  ,
      machNm:machNm ,
      branchId:json['brn_Id']  ,
      permissionCode:json['Per_Code']  ,
      dailyNo:json['bill_daliy_no']  ,
      invoiceIndex:json['bill_serial_index']  ,
      password:password ,
    );
}

  factory User.fromJsonShared (Map<String  ,dynamic> json ){
    return User.jsonParsing(
        userName:json['userName'] ,
        branchId:json['branchId'] ,
        password: json['password']  ,
        machNm: json['machNm']  ,
        machNo: json['machNo']  ,
        userID: json['userID']  ,
        dailyNo: json['dailyNo'],
        invoiceIndex: json['invoiceIndex'],
        permissionCode: json['permissionCode']
    );
  }
  Map<String, dynamic> toJson( ) {
    return {
      "userID": this.userID,
      "userName": this.userName ,
      "machNm": this.machNm ,
      "machNo" :this.machNo  ,
      "branchId": this.branchId ,
      "permissionCode": this.permissionCode ,
      "password": this.password ,
      "invoiceIndex":this.invoiceIndex  ,
      "dailyNo":this.dailyNo
    };
  }


}