
import 'dart:io';

import 'package:path/path.dart';
import 'package:restaurants_waiters/Tools/Constant.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';


class DatabaseHelper  {


  static final _databaseName = "MyDatabase.db";
  static final _databaseVersion = 1;
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();


  // only have a single app-wide reference to the database
  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    // lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    return _database;
  }

  // this opens the database (and creates it if it doesn't exist)
  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion,
        onCreate: _onCreate);
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    String createDepTb ="CREATE TABLE $DEP_TB (\n" +
        "  $DEP_ID    INTEGER NOT NULL PRIMARY KEY, \n" +
        "  $DEP_NAME   varchar(200) NOT NULL, \n" +
        "  $DEP_IP     varchar(200) , \n" +
        "  $DEP_PORT   varchar(200) );" ;
    await db.execute(createDepTb);
    String createCatTb ="CREATE TABLE $CATEGORY_TB (\n" +
        "  $CAT_ID     INTEGER NOT NULL PRIMARY KEY, \n" +
        "  $CAT_CODE   INTEGER(200) NOT NULL, \n" +
        "  $CAT_NM_AR  varchar(200) , \n" +
        "  $CAT_NM_EN   varchar(200) ,\n" +
        "  $CAT_DEP_ID  INTEGER(200)  NOT NULL, \n" +
        "FOREIGN KEY($CAT_DEP_ID) REFERENCES $DEP_TB($DEP_ID));" ;
    await db.execute(createCatTb);
    String createProductTb ="CREATE TABLE $PRODUCT_TB (\n" +
        "  $P_CODE     INTEGER NOT NULL, \n" +
        "  $P_AR_NM  varchar(200) , \n" +
        "  $P_EN_NM  varchar(200) , \n" +
        "  $P_UNIT   INTEGER NOT NULL, \n" +
        "  $UNIT_SIZE  varchar(200) , \n" +
        "  $P_PRICE   varchar(200) , \n" +
        "  $P_COST    varchar(200) , \n" +
        "  $UNIT_NM   varchar(200) , \n" +
        "  $QTY       varchar(200) , \n" +
        "  $TAX       varchar(200) , \n" +
        "  $P_CAT_CODE  INTEGER(200)  NOT NULL, \n" +
        "PRIMARY KEY ($P_CODE , $P_UNIT), \n"+
        "FOREIGN KEY($P_CAT_CODE) REFERENCES $CATEGORY_TB($CAT_CODE));" ;
    await db.execute(createProductTb);
    String createDiscountTb ="CREATE TABLE $DISCOUNT_TB (\n" +
        "  $ID     INTEGER NOT NULL PRIMARY KEY, \n" +
        "  $FROM   varchar(200) NOT NULL, \n" +
        "  $TO     varchar(200) NOT NULL, \n" +
        "  $PERCENT     varchar(200) NOT NULL, \n" +
        "  $D_PRICE     varchar(200) NOT NULL, \n" +
        "  $D_P_CODE  INTEGER(200)  NOT NULL, \n" +
        "  FOREIGN KEY($D_P_CODE) REFERENCES $PRODUCT_TB($P_CODE));" ;
    await db.execute(createDiscountTb);
    String createCustomerTb ="CREATE TABLE $CUSTOMER_TB (\n" +
        "  $C_ID     INTEGER NOT NULL PRIMARY KEY, \n" +
        "  $C_CODE   INTEGER NOT NULL , \n" +
        "  $C_NAME   varchar(200) NOT NULL, \n" +
        "  $C_PHONE   varchar(200), \n" +
        "  $C_ADRS  varchar(200) );" ;
    await db.execute(createCustomerTb);

    String createCashTb ="CREATE TABLE $CASH_TB (\n" +
        "  $CASH_ID     INTEGER NOT NULL PRIMARY KEY, \n" +
        "  $EN_NM   varchar(200), \n" +
        "  $AR_NM   varchar(200) );" ;
    await db.execute(createCashTb);
    String createTableTb ="CREATE TABLE $TABLE_TB (\n" +
        "  $TB_CODE     INTEGER NOT NULL PRIMARY KEY, \n" +
        "  $TB_NM   varchar(200) );" ;
    await db.execute(createTableTb);
    String createInvoiceTb ="CREATE TABLE $INVOICE_TB (\n" +
        "  $INV_ID     INTEGER NOT NULL PRIMARY KEY , \n" +
        "  $INVOICE_OPEN   INTEGER, \n" +
        "  $INV_TOTALAFTERDISCOUNT   varchar(200), \n" +
        "  $INV_TOTALTAX   varchar(200), \n" +
        "  $INV_CUSTOMER   INTEGER(100), \n" +
        "  $INV_CASH       INTEGER(100), \n" +
        "  $INV_DAILY_NO       INTEGER(100), \n" +
        "  $INV_TABLE      INTEGER(100), \n" +
        "  $billGivenMoney      varchar(100), \n" +
        "  $billChange      varchar(100), \n" +
        "  $billOpenDate      varchar(200), \n" +
        "  $billCloseDate      varchar(200), \n" +
        "  $BILL_DATE      varchar(200), \n" +
        "  $isFamily      INTEGER(1), \n" +
        "  $isLocal      INTEGER(1), \n" +
        "  $tableNm      varchar(200), \n" +
        "  $INV_TOTAL      varchar(200) );" ;
    await db.execute(createInvoiceTb);
    // جدول ضايفه فيه الاصناف الي موجوده ف الفاتوره
    String createInvPrTb ="CREATE TABLE $INVOICEPRODUCT_TB (\n" +
        "  $INVP_ID     INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, \n" +
        "  $INVP_CODE     INTEGER NOT NULL, \n" +
        "  $INVV_ID     INTEGER NOT NULL, \n" +
        "  $INVP_NM    varchar(200) NOT NULL, \n" +
        "  $INVP_TAX        varchar(200), \n" +
        "  $INVP_PRICEDISC   varchar(200), \n" +
        "  $INVP_QTY         varchar(200) , \n" +
        "  $INVP_PRICE        varchar(200) , \n" +
        "  $INVP_CATCODE        INTEGER(100) , \n" +
        "  $INVP_DEP_ID        INTEGER(100) , \n" +
        "  $INVP_UNIT           INTEGER(100) , \n" +
        "  $INVP_UNITSIZE        varchar(200) , \n" +
        "  FOREIGN KEY($INVP_CODE) REFERENCES $PRODUCT_TB($P_CODE), \n" +
        "  FOREIGN KEY($INVV_ID) REFERENCES $INVOICE_TB($INV_ID));" ;

    await db.execute(createInvPrTb);
  }
  Future<int> insert(Map<String, dynamic> row ,String tableName , {Function err}) async {
    try{
    Database db = await instance.database;
    return await db.insert(tableName, row);}
    on Exception catch (e){
      err(e.toString());
      return null ;

    }
  }
  Future<int> updateCount(Map<String, dynamic> row  ,String id  , String invoice_id) async {
    Database db = await instance.database;
    return await db.update(INVOICEPRODUCT_TB, row, where: '$INVP_CODE = ? AND $INVV_ID = ?', whereArgs: [id ,invoice_id]);
  }
  Future<int> deleteOneProduct({int invoiceId  , String productId}) async {
    Database db = await instance.database;
    return await db.delete(INVOICEPRODUCT_TB, where: '$INVP_CODE = ? AND $INVV_ID = ?', whereArgs: [productId ,invoiceId]);
  }
  Future<int> updateInvoice(Map<String, dynamic> row  ,String id ) async {
    Database db = await instance.database;
    return await db.update(INVOICE_TB, row, where: '$INV_ID = ?', whereArgs: [id]);
  }
  Future<List<Map<String, dynamic>>> queryAllRows(String tableName) async {
    Database db = await instance.database;
    return await db.query(tableName);
  }
  Future<List<Map<String, dynamic>>> getProductsByInvID(String inv_id) async {
    Database db = await instance.database;
    return await db.rawQuery('select * from $INVOICEPRODUCT_TB where  $INVV_ID =? ' ,
        [inv_id] );  }
  Future<List<Map<String, dynamic>>> getInvByID(String inv_id) async {
    Database db = await instance.database;
    return await db.rawQuery('select * from $INVOICE_TB where  $INV_ID =? ' ,
        [inv_id] );  }
  Future<int> queryRowCount( String tableName) async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM $tableName'));
  }
  Future<List<Map<String, dynamic>>> getProductByCatCode(String catCode ) async {
    Database db = await instance.database;
    return await db.rawQuery('select * from $PRODUCT_TB where  $P_CAT_CODE =? ' ,
        [catCode] );
  }
  Future<List<Map<String, dynamic>>> getDepartmentsHavePrinter() async {
    Database db = await instance.database;
    return await db.rawQuery('select * from $DEP_TB where $DEP_IP IS NOT NULL') ;

  }
  Future<int> deleteCloseInvoice({int  invoiceId }) async {
    Database db = await instance.database;
    return await db.delete(INVOICE_TB, where: '$INVOICE_OPEN =? ', whereArgs:   [false] );
  }
  Future<List<Map<String, dynamic>>> getAllCloseInvoice(int isOpen ) async {
    Database db = await instance.database;
    return await db.rawQuery('select * from $INVOICE_TB where  $INVOICE_OPEN =? ' ,
        [isOpen] );
  }
  Future<List<Map<String, dynamic>>> getProductDiscount(String productCode ) async {
    Database db = await instance.database;
    return await db.rawQuery('select * from $DISCOUNT_TB where  $D_P_CODE =? ' ,
        [productCode] );
  }
  Future<List<Map<String, dynamic>>> getLastInvoice( ) async {
    Database db = await instance.database;
    return await db.query(INVOICE_TB,limit: 1,orderBy: "$INV_ID DESC");
  }
  Future<int> deleteInv({int invoiceId }) async {
    Database db = await instance.database;
    return await db.delete(INVOICE_TB, where: '$INV_ID = ?', whereArgs: [invoiceId]);
  }

  Future<int> deleteInvProducts({int  invoiceId }) async {
    Database db = await instance.database;
    return await db.delete(INVOICEPRODUCT_TB, where: '$INVV_ID = ?', whereArgs: [invoiceId]);
  }

  Future<int> deleteTb({ String table}) async {
    Database db = await instance.database;
    return await db.delete(table);
  }
  Future<int> updateDepPrinter(Map<String, dynamic> row  ,String id ) async {
    Database db = await instance.database;
    return await db.update(DEP_TB, row, where: '$DEP_ID = ?', whereArgs: [id]);
  }
}