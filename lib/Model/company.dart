class Company {
  String name  ;
  String logo  ;
  String companyMark ;

  Company({this.name, this.logo, this.companyMark});
  factory Company.fromJson (Map<String  ,dynamic> json ){
    return Company(
      name :json['CompanyNm'] ,
      logo :json['logo'] ,
      companyMark :json['CompanyMark'] ,

    );
  }

  factory Company.fromJsonShared (Map<String  ,dynamic> json ){
    return Company(
      name :json['companyName'] ,
      logo :json['companyLogo'] ,
      companyMark :json['companyMark'] ,
    );
  }
  Map<String, dynamic> toJson( ) {
    return {
      "companyName": this.name,
      "companyLogo": this.logo ,
      "companyMark": this.companyMark ,

    };
  }
}