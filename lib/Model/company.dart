class Company {
  String name  ;
  String logo  ;
  String companyMark ;
  String taxNum ;

  Company({this.name, this.logo, this.companyMark , this.taxNum});
  factory Company.fromJson (Map<String  ,dynamic> json ){
    return Company(
      name :json['CompanyNm'] ,
      logo :json['logo'] ,
      companyMark :json['CompanyMark'] ,
      taxNum :json['TAX_ID'] ,

    );
  }

  factory Company.fromJsonShared (Map<String  ,dynamic> json ){
    return Company(
      name :json['companyName'] ,
      logo :json['companyLogo'] ,
      companyMark :json['companyMark'] ,
      taxNum :json['taxNum'] ,
    );
  }
  Map<String, dynamic> toJson( ) {
    return {
      "companyName": this.name,
      "companyLogo": this.logo ,
      "companyMark": this.companyMark ,
      "taxNum": this.taxNum ,

    };
  }
}