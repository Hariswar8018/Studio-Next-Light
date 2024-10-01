import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:student_managment_app/Parents_Portal/as.dart';
import 'package:student_managment_app/anew/school_service/click_photo/session.dart';
import 'package:student_managment_app/loginnow_function/homescreen.dart';
import 'package:student_managment_app/model/school_model.dart';
import 'package:student_managment_app/model/usermodel.dart';
import 'package:student_managment_app/aextra/marksheet.dart';

class ClickPicPortal extends StatelessWidget {
  UserModel user;
  ClickPicPortal({super.key,required this.user});
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    double w=MediaQuery.of(context).size.width;
    return user.school.isNotEmpty&&(user.probation)?Scaffold(
        drawer:Global.buildDrawer(context),
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: Color(0xff029A81),
          leading:InkWell(
            onTap:() {
              _scaffoldKey.currentState?.openDrawer();  // Opens the drawer
            },
            child: Padding(
              padding: const EdgeInsets.all(6.0),
              child: CircleAvatar(
                backgroundColor: Colors.white,
                child: Center(child: Icon(Icons.more_vert,color: Color(0xff029A81),size: 22,)),
              ),
            ),
          ),
          title: Text("Photographer Portal",style:TextStyle(color:Colors.white)),
        ),
      body: Column(
        children: [
          Image.network("https://img.freepik.com/free-vector/organic-printing-industry-illustration_23-2148899175.jpg",width: MediaQuery.of(context).size.width,),
          Center(
            child: Container(
              width: w-15,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10)
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 10.0,bottom: 15),
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("    Print Related",style: TextStyle(fontWeight: FontWeight.w700),textAlign: TextAlign.start,),
                      SizedBox(height: 9,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          InkWell(
                              onTap: () async {
                                try {
                                  CollectionReference usersCollection = FirebaseFirestore.instance.collection('School');
                                  QuerySnapshot querySnapshot = await usersCollection.where('id', isEqualTo: user.schoolid).get();

                                  if (querySnapshot.docs.isNotEmpty) {
                                    SchoolModel school = SchoolModel.fromSnap(querySnapshot.docs.first);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) =>SessionPicJust(id: user.schoolid, reminder: true, newb: false, school: school,),
                                      ),
                                    );
                                  } else {
                                    return null;
                                  }
                                } catch (e) {
                                  print("Error fetching user by uid: $e");
                                  return null;
                                }

                              },
                              child: q(context,"assets/first/picture-svgrepo-com.svg","Pictures")),
                          InkWell(
                              onTap: () async {
                                try {
                                  CollectionReference usersCollection = FirebaseFirestore.instance.collection('School');
                                  QuerySnapshot querySnapshot = await usersCollection.where('id', isEqualTo: user.schoolid).get();

                                  if (querySnapshot.docs.isNotEmpty) {
                                    SchoolModel school = SchoolModel.fromSnap(querySnapshot.docs.first);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) =>SessionPicJust(id: user.schoolid, reminder: false, newb: false, school: school,),
                                      ),
                                    );
                                  } else {
                                    return null;
                                  }
                                } catch (e) {
                                  print("Error fetching user by uid: $e");
                                  return null;
                                }


                              },
                              child: q(context,"assets/first/csv-svgrepo-com.svg","CSV")),
                          InkWell(
                              onTap: () async {
                                try {
                                  CollectionReference usersCollection = FirebaseFirestore.instance.collection('School');
                                  QuerySnapshot querySnapshot = await usersCollection.where('id', isEqualTo: user.schoolid).get();

                                  if (querySnapshot.docs.isNotEmpty) {
                                    SchoolModel school = SchoolModel.fromSnap(querySnapshot.docs.first);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) =>SessionPicJust(id: user.schoolid, reminder: false, newb: true, school: school,),
                                      ),
                                    );
                                  } else {
                                    return null;
                                  }
                                } catch (e) {
                                  print("Error fetching user by uid: $e");
                                  return null;
                                }


                              },
                              child: q(context,"assets/first/upload-svgrepo-com.svg","ID Cards")),
                          InkWell(
                            onTap: () async {
                              try {
                                CollectionReference usersCollection = FirebaseFirestore.instance.collection('School');
                                QuerySnapshot querySnapshot = await usersCollection.where('id', isEqualTo: user.schoolid).get();
                                if (querySnapshot.docs.isNotEmpty) {
                                  SchoolModel school = SchoolModel.fromSnap(querySnapshot.docs.first);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Mark(user: school)),
                                  );
                                } else {
                                  return null;
                                }
                              } catch (e) {
                                print("Error fetching user by uid: $e");
                                return null;
                              }
                            },
                            child:q(context,"assets/first/checkmarks-checkmark-svgrepo-com.svg","Marsheets")),
                        ],
                      ),
                      SizedBox(height: 9,),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height:10),
        /*  Center(
            child: Container(
              width: w-15,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10)
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 10.0,bottom: 15),
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("    School Related",style: TextStyle(fontWeight: FontWeight.w700),textAlign: TextAlign.start,),
                      SizedBox(height: 9,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          q(context,"assets/images/school/law-book-law-svgrepo-com.svg","School QR"),
                          q(context,"assets/images/school/law-book-law-svgrepo-com (1).svg","Upload Info"),
                          q(context,"assets/images/school/law-svgrepo-com.svg","Announce"),
                          q(context,"assets/images/school/profile-user-svgrepo-com.svg","Verification"),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),*/
        ],
      )

    ):DefaultHome(user: user, name: "Apply for Photographer");
  }

  Widget q(BuildContext context, String asset, String str) {
    double d = MediaQuery.of(context).size.width / 4 - 35;
    return Column(
      children: [
        Container(
            width: d,
            height: d,
            decoration: BoxDecoration(
              color: Colors.white,

              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SvgPicture.asset(
                asset,
                semanticsLabel: 'Acme Logo',
                height: d-50,
              ),
            )),
        SizedBox(height: 7),
        Text(str, style: TextStyle(fontWeight: FontWeight.w400,fontSize: 9)),
      ],
    );
  }
}
