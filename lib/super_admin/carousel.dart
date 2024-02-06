import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../upload/storage.dart';

class Carousel extends StatefulWidget {
   Carousel({super.key});

  @override
  State<Carousel> createState() => _CarouselState();
}

class _CarouselState extends State<Carousel> {
  List<Carousell> list = [];

  late Map<String, dynamic> userMap;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title : Text("Ad Carousel")
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add_a_photo,),
        onPressed: () async {
          Uint8List? _file = await pickImage(ImageSource.gallery);
          String photoUrl = await StorageMethods()
              .uploadImageToStorage('students', _file!, true);
          String gg = DateTime.now().microsecondsSinceEpoch.toString();
          Carousell gggg = Carousell(pic: photoUrl, name: gg);
          await FirebaseFirestore.instance.collection('Admin').doc("C").collection("C").doc(gg).set(gggg.toJson());
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Profile Pic uploaded"),
            ),
          );
        },
      ),
      body : StreamBuilder(
        stream: FirebaseFirestore.instance.collection('Admin').doc("C").collection("C").snapshots(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.none:
              return Center(child: CircularProgressIndicator());
            case ConnectionState.active:
            case ConnectionState.done:
              final data = snapshot.data?.docs;
              list =
                  data?.map((e) => Carousell.fromJson(e.data())).toList() ??
                      [];
              return ListView.builder(
                itemCount: list.length,
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  return Super(
                    user: list[index],
                  );
                },
              );
          }
        },
      ),
    );
  }

   pickImage(ImageSource source) async {
     final ImagePicker _imagePicker = ImagePicker();
     XFile? _file = await _imagePicker.pickImage(source: source);

     if (_file != null) {
       final croppedFile = await ImageCropper().cropImage(
         sourcePath: _file.path,
         aspectRatioPresets: [
           CropAspectRatioPreset.square,
           CropAspectRatioPreset.ratio3x2,
           CropAspectRatioPreset.original,
           CropAspectRatioPreset.ratio4x3,
           CropAspectRatioPreset.ratio16x9,
         ],
         uiSettings: [
           AndroidUiSettings(
               toolbarTitle: 'Crop Student Image',
               toolbarColor: Colors.deepOrange,
               toolbarWidgetColor: Colors.white,
               initAspectRatio: CropAspectRatioPreset.original,
               lockAspectRatio: false),
           IOSUiSettings(
             title: 'Cropper',
           ),

         ],
       );
       if (croppedFile != null) {
         final Uint8List data = await croppedFile.readAsBytes();
         return data;
       }
     }
     print('No Image Selected');
     return null;
   }
}

class Super extends StatelessWidget{
  Carousell user ;
  Super({required this.user });
  @override
  Widget build(BuildContext context){
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: ListTile(
        leading: Image.network(user.pic),
        title: Text(user.name),
        trailing: IconButton(
          onPressed: () async {
            await FirebaseFirestore.instance.collection('Admin').doc("C").collection("C").doc(user.name).delete();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Deleting"),
              ),
            );
          },
          icon: Icon(Icons.delete, color : Colors.red),
        ), tileColor: Colors.grey.shade50,
      ),
    );
  }

}

class Carousell {
  Carousell({ required this.pic, required this.name });
  
  late final String pic ;
  late final String name ;
  
  Carousell.fromJson(Map<String, dynamic> json) {
    pic = json['pic'] ?? "hh";
    name = json['Name'] ?? "Ad" ;
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['pic'] = pic ;
    data['Name'] = name ;
    return data;
  }
}