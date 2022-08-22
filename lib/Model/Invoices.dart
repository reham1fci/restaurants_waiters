import 'package:restaurants_waiters/Model/Product.dart';
import 'package:restaurants_waiters/Tools/Constant.dart';

class Invoices {
   int id  ;
   List<Product>products ;
  int isOpen ;
  double total    ;
  double totalTax;
  double totalAfterDiscount  ;
   int tableId  ;
   int customerId;
   int cashTypeId  ;
   String cashTypeName  ;
   double billGivenMoney  ;  // المدفوع
   double billChange ; // الباقي
   String billOpenDate  ;
   String billCloseDate ;
   int isFamily = 0 ;
   int isLocal  = 0 ;
   String tableNm  ;
    int invDailyNo ;
    String billDate  ;
    String customerName  ;

   Invoices({ this.tableNm  , this.id, this.isOpen, this.total , this.totalTax , this.totalAfterDiscount , this.billChange , this.billGivenMoney,
     this.tableId , this.cashTypeId , this.customerId , this.billDate  , this.isFamily , this.isLocal ,this.billOpenDate , this.invDailyNo  ,
     this.billCloseDate });

   Map<String,dynamic> insertDb() {
     return {
       INV_TOTAL :this.total  ,
       INVOICE_OPEN : this.isOpen ,
       INV_TOTALAFTERDISCOUNT :this.totalAfterDiscount ,
       INV_TOTALTAX  :this.totalTax ,
       "billOpenDate"  :this.billOpenDate  ,
       INV_DAILY_NO :this.invDailyNo ,
       BILL_DATE  :this.billDate ,
       INV_ID :this.id,
       "billGivenMoney":"0.0",
       "billChange":"0.0",

     };
   }
   factory Invoices.getFromSqlInvoice(Map<String  ,dynamic> json){
     return  Invoices(

         id:  json[INV_ID] ,
        total:double.parse( json[INV_TOTAL]) ,
        isOpen: json[INVOICE_OPEN] ,
         totalTax: double.parse( json[INV_TOTALTAX]),
         totalAfterDiscount: double.parse( json[INV_TOTALAFTERDISCOUNT]) ,
          tableId: json[INV_TABLE],
         cashTypeId:   json[INV_CASH],
        customerId:  json[INV_CUSTOMER],
         isFamily:  json["isFamily"],
        isLocal: json["isLocal"],
       tableNm:  json["tableNm"] ,
       billOpenDate:  json["billOpenDate"] ,
       invDailyNo:  json[INV_DAILY_NO] ,
       billDate: json[BILL_DATE] ,
         billGivenMoney: double.parse(json["billGivenMoney"]),
         billChange: double.parse(json["billChange"]) ,
         billCloseDate: json["billCloseDate"] ,



     );

   }

   Map<String, dynamic> toJson( String userId  , String machineNo ,
       String brnCode  ,double taxPercentage) {
     return {
       "Bill_Code": brnCode.toString().padRight(1,'0') +machineNo.padRight(1,'0')+ userId.padLeft(2,'0')+ id.toString().padLeft(4,'0') ,
       "Bill_DailyNo":invDailyNo.toString(),
       "C_CODE":this.customerId.toString() ,
       "Bill_Loc": check(this.isLocal).toString() ,
       "familyOrNot": check(this.isFamily).toString(),
       "Bill_CashType": this.cashTypeId.toString() , // ":"07/03/2021 05:40:44 PM",
       "Bill_Price": this.total.toString() ,
       "Bill_Total": this.totalAfterDiscount .toString(),
       "Bill_Tax": this.totalTax.toString() ,
       "Bill_GivenMny": this.billGivenMoney.toString(),
       "Bill_Change":  this.billChange.toString() ,
       "Usr_Id": userId ,
        "Close_User": userId ,
        "Machine_no": machineNo ,
        "BRN_Code": brnCode.toString() ,
        "Bill_Date": this.billOpenDate  ,//this.billOpenDate ,
        "Close_Date":  this.billCloseDate , //this.billCloseDate ,
        "Note": tableNm ,
        "Tax_Percent": taxPercentage ,
     };
   }

   bool  check( int num){
      if(num  == 0) {
        return false   ;
      }
      else{
      return true  ;
      }

   }

   @override
   String toString() {
     return 'Invoices{id: $id, products: $products, isOpen: $isOpen, total: $total, totalTax: $totalTax, totalAfterDiscount: $totalAfterDiscount, tableId: $tableId, customerId: $customerId, cashTypeId: $cashTypeId, billGivenMoney: $billGivenMoney, billChange: $billChange, billOpenDate: $billOpenDate, billCloseDate: $billCloseDate, isFamily: $isFamily, isLocal: $isLocal, tableNm: $tableNm, invDailyNo: $invDailyNo, billDate: $billDate}';
   }

}