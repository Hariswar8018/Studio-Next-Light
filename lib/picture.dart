import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:social_login_buttons/social_login_buttons.dart';

class Pic extends StatelessWidget {
  String str; String name ;

  Pic({super.key, required this.str, required this.name});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          actions: [
            IconButton(onPressed: () async {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                      'Please Wait.....'),
                ),
              );
              try{
                var response = await Dio().get(
                    str,
                    options: Options(responseType: ResponseType.bytes));
                final result = await ImageGallerySaver.saveImage(
                    Uint8List.fromList(response.data),
                    quality: 60,
                    name: "$name");
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        'Done, Saved to Storage/Pictures'),
                  ),
                );
              }catch(e){

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        '${e}'),
                  ),
                );
              }

            }, icon: Icon(Icons.download)),
            SizedBox(width : 10),
          ],
        ),
        body: Center(child: Image.network(str)
        ),
    persistentFooterButtons: [
      SocialLoginButton(
        backgroundColor: Color(0xff50008e),
        height: 40,
        text: 'Download Now',
        borderRadius: 20,
        fontSize: 21,
        buttonType: SocialLoginButtonType.generalLogin,
        onPressed: () async {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  'Please Wait.....'),
            ),
          );
          try{
            var response = await Dio().get(
                str,
                options: Options(responseType: ResponseType.bytes));
            final result = await ImageGallerySaver.saveImage(
                Uint8List.fromList(response.data),
                quality: 60,
                name: "$name");
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                    'Done, Saved to Storage/Pictures'),
              ),
            );
          }catch(e){

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                    '${e}'),
              ),
            );
          }
        },
      ),
    ],
    );
  }
}
