import 'package:flutter/material.dart';
import 'package:restaurants_waiters/Database/DatabaseHelper.dart';
import 'package:restaurants_waiters/Model/Category.dart';
import 'package:restaurants_waiters/Screens/Products.dart';
import 'package:restaurants_waiters/Tools/Constant.dart';
import 'package:restaurants_waiters/app_localizations.dart';
import 'package:restaurants_waiters/my_colors.dart';
typedef Null ItemSelectedCallback(int value);

class ProductGroups extends StatefulWidget{
  final ItemSelectedCallback onItemSelected;


  @override
  GroupsState createState() => GroupsState();

  ProductGroups(this.onItemSelected);

}
class GroupsState  extends State<ProductGroups> {
  final dbHelper = DatabaseHelper.instance;
  List<Category>categoryList  = new List() ;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCategories();
  }
  @override
  Widget build(BuildContext context) {

    // TODO: implement build
    return new Scaffold(
      body:
getView(categoryList),


    )  ;
  }
  Widget getView(List<Category>list){
    if(list.length>0){
      return new ListView.builder(
        scrollDirection:Axis.horizontal ,
        itemBuilder: (context  , index ){
          return listCard(list , index) ;
        } ,itemCount:  list.length , ) ;

    }
    else{

      return noThingView();

    }

  }

  Widget noThingView(){
    return new Container(child:
    new Center(
      child:  new Column( children: <Widget>[
        //  Image.asset('images/nothing.png', fit: BoxFit.contain),
        Text (AppLocalizations.of(context).translate("not_found"))
      ], mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,),
    ) , height: double.infinity, ) ;
  }






  Widget  listCard  (List <Category> list  , int index) {
    Category category  = list[index] ;
    // getBackgroundColor(requestItem ) ;
    return new Padding(padding: EdgeInsets.only(top: 4.0  ,
              right: 8.0 , left:  8.0 )  ,
            child :   new Card(
                child: InkWell(
                  onTap: () {
                    widget.onItemSelected(category.catCode);
                    print(category.catCode) ;
                  },

              child:new Container(
               child: new Padding(padding: EdgeInsets.all(16 )  , child: new Text(category.catNmAr)),
              ) ,

            )
            )
    );
  }

  Future <void> getCategories() async{
    List<Category> list = new List() ;
    final allRows = await dbHelper.queryAllRows(CATEGORY_TB)  ;
    for(int i  =  0  ;  i  < allRows.length  ;  i++)     {
      Map<String, dynamic> map = allRows[i]  ;
      Category category  = Category.fromSql(map)  ;
      list.add(category) ;

    }
    setState(() {
      categoryList  = list ;
    });

  }
}