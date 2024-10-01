import 'package:flutter/material.dart';
import 'package:student_managment_app/after_login/school_history.dart';

class Options extends StatelessWidget {
  String id ;
   Options({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar : AppBar(
        automaticallyImplyLeading: true,
        iconTheme: IconThemeData(
          color: Colors.white
        ),
        title : Text("Check History", style : TextStyle(color : Colors.white)),
        backgroundColor: Color(0xff50008e),
      ),
      body : Column(
        children :[
          ListTile(
            onTap: (){
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Order_K(s: 'Orders', name: 'Pending Orders', school_id: id,)
                ),
              );
            },
            leading: Icon(Icons.shopping_cart_rounded, color : Colors.red),
            title : Text("Pending Orders", style : TextStyle(fontWeight: FontWeight.w700, fontSize: 18)),
            subtitle: Text("Check ordered history"),
            trailing : Icon(Icons.arrow_forward_ios),
            splashColor: Colors.orangeAccent, tileColor: Colors.white,
          ),
          ListTile(
            onTap: (){
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Order_K(s: 'Progress', name: 'ID being Printed', school_id: id,)
                ),
              );
            },
            leading: Icon(Icons.print, color : Colors.green),
            title : Text("Inprogress Orders", style : TextStyle(fontWeight: FontWeight.w700, fontSize: 18)),
            subtitle: Text("Check ID cards being printed"),
            trailing : Icon(Icons.arrow_forward_ios),
            splashColor: Colors.orangeAccent, tileColor: Colors.white,
          ),
          ListTile(
            onTap: (){
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Order_K(s: 'Complete', name: 'Order Completed', school_id: id,)
                ),
              );
            },
            leading: Icon(Icons.verified, color : Colors.blue),
            title : Text("Completed Orders", style : TextStyle(fontWeight: FontWeight.w700, fontSize: 18)),
            subtitle: Text("Check History for ID cards shipped"),
            trailing : Icon(Icons.arrow_forward_ios),
            splashColor: Colors.orangeAccent, tileColor: Colors.white,
          ),
        ]
      )
    );
  }
}
