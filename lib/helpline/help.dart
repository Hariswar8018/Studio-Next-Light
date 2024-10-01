import 'package:flutter/material.dart';

class Emergency extends StatelessWidget {
  const Emergency({super.key});

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("Declare Emergency"),
      ),
      body: Column(
        children: [
          Center(
            child: Card(
              color: Colors.white,
              child: Container(
                width: w-10,
                height: 220,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      Text("RUN SOS ( Serious Help )",style: TextStyle(fontWeight: FontWeight.w800,fontSize: 20),),
                      LinearProgressIndicator(
                        backgroundColor: Colors.red,
                        color: Colors.yellow,
                      ),

                    ],
                  ),
                ),
              ),
            ),
          ),

        ],
      ),
    );
  }
  Widget c(double w,String str){
    return  Center(
      child: Card(
        color: Colors.white,
        child: Container(
          width: w-10,
          height: 80,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                Text("RUN SOS ( Serious Help )",style: TextStyle(fontWeight: FontWeight.w800,fontSize: 20),),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
