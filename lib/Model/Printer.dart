class Printer{
  String ip  ;
  String port  ;
  int id  ;

  Printer({this.ip, this.port});

  factory Printer.fromJsonShared (Map<String  ,dynamic> json ){
    return Printer(
        ip:json['ip'] ,
        port:json['port'] ,

    );
  }
  Map<String, dynamic> toJson( ) {
    return {
      "ip": this.ip,
      "port": this.port ,
    };
  }
}