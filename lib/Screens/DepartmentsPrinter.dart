 import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:restaurants_waiters/Database/DatabaseHelper.dart';
import 'package:restaurants_waiters/Model/Departments.dart';
import 'package:restaurants_waiters/Tools/Constant.dart';
import 'package:restaurants_waiters/app_localizations.dart';
import 'package:restaurants_waiters/my_colors.dart';

class DepPrinter  extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
   return new DepPrinterState()  ;
  }

}
class DepPrinterState extends State<DepPrinter> {
  List<Departments> depList  = new List();
  List<TextEditingController> ipEdList  = new List()  ;
  List<TextEditingController> portEdList  = new List()  ;
  final dbHelper = DatabaseHelper.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDepartments() ;
  }
  Future <void> getDepartments()  async {
    List<Departments> list = new List() ;
    final allRows = await dbHelper.queryAllRows(DEP_TB)  ;
    for(int i  =  0  ;  i  < allRows.length  ;  i++)     {
      Map<String, dynamic> map = allRows[i]  ;
      Departments category  = Departments.fromSql(map)  ;
      list.add(category) ;

    }
    setState(() {
      depList  = list ;
    });
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
        title: Text(AppLocalizations.of(context).translate("departments_printer")),
    ),
      body:
      getView(depList),
        bottomNavigationBar: BottomAppBar(
          child: addButton(),
        )

    )  ;
  }
  Padding addButton() {
    return new Padding (padding: EdgeInsets.only(bottom: 8.0 , left: 40.0  , right: 40.0 , top: 8.0),child:new Container(
      decoration:  new BoxDecoration(color:MyColors.colorPrimary
          , borderRadius:  const BorderRadius.all(
            const Radius.circular(8.0),)
      ),
      width  :   double.infinity,
      child  :   new FlatButton(
        onPressed: onAddPrinter ,
        child: new Text(AppLocalizations.of(context).translate("add_printer") , style: new TextStyle(color: Colors.white),),
      ) ,
    ) )
    ;
  }
  void onAddPrinter ()  {
    setState(()  {
      for(int i  =  0   ; i <depList.length  ; i ++) {
       String ip  = ipEdList[i].text;
       String  port  = portEdList[i].text;
       if(ip.isEmpty){
         Navigator.of(context).pop();

       }
       else{
         if(port.isEmpty){
           port = "9100" ;
         }
         savePrinter(ip, port , depList[i].id) ;
          if(i ==depList.length-1){
         Navigator.of(context).pop();}

       }
      }
      // 0 printer cashier
      // 1printer supervisor
     /* ip  = ipEd.text;
      port  = portEd.text;
      if(ip.isEmpty){
      }
      else{
        if(port.isEmpty){
          port = "9100" ;
        }
        savePrinter() ;
        Navigator.of(context).pop();

      }*/

    });

  }
  Future<void> savePrinter  (String ip  , String port  , int id ) async {
    Map  <String,dynamic>  map  = new Map();
    map[DEP_IP]=   ip;
    map[DEP_PORT]=   port;
    final idd = await dbHelper.updateDepPrinter(
        map, id.toString());
    Fluttertoast.showToast(
        msg: "printer added ",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }
  Widget getView(List<Departments>list){
    ipEdList.length = list.length ;
    portEdList.length = list.length ;
      return new ListView.builder(
        scrollDirection:Axis.vertical ,
        itemBuilder: (context  , index ){
          return listCard(list , index) ;
        } ,itemCount:  list.length , ) ;

  }
  Widget  listCard  (List <Departments> list  , int index) {
    Departments dep  = list[index] ;
    // getBackgroundColor(requestItem ) ;
    print(index) ;
    print(dep.printerPort) ;
    print(dep.printerIp) ;
    print(dep.name) ;
    ipEdList[index] = new TextEditingController( text :dep.printerIp!=null?dep.printerIp:"" ) ;
    portEdList[index] = new TextEditingController(text :dep.printerPort!=null?dep.printerPort:"" ) ;
   /* if(dep.printerIp!=null) {
      ipEdList[index].text =  dep.printerIp;
    }
    if(dep.printerPort!=null) {
      portEdList[index].text =  dep.printerPort;
    }   */


     return new Padding(padding: EdgeInsets.only(top: 4.0  ,

        right: 8.0 , left:  8.0 )  ,
        child :   new Card(
            child: InkWell(
              onTap: () {

              },
              child:Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  new  Expanded (child: Text(dep.name, textAlign:  TextAlign.center,style: TextStyle(fontSize: 20),)  ),
                  new  Expanded(child:TextField(controller:  ipEdList[index] ,
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: false,
                      labelText: "IP"
                      //  errorText: errorTxt,
                        //     prefixIcon:Image.asset('images/user_icon.png',color: MyColors.colorPrimary) ,
                      )
                  ),         ) ,

                  new  Expanded(child:TextField(controller:  portEdList[index],
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: false,
                          labelText: "PORT"

                        //  errorText: errorTxt,
                        //     prefixIcon:Image.asset('images/user_icon.png',color: MyColors.colorPrimary) ,
                      )
                  ),         ) ,

                ],
              )  ,

            )
        )
    );
  }
}