import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_login_buttons/social_login_buttons.dart';

class Forgot extends StatefulWidget {
  const Forgot({super.key});

  @override
  State<Forgot> createState() => _ForgotState();
}

class _ForgotState extends State<Forgot> {
  final _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title : Text("Reset Password"),
        automaticallyImplyLeading: true,
        backgroundColor:  Color(0xff50008e),
      ),
      body : Column(
        children: [
          SizedBox(height: 20,),
          Center(child: Text("Forgot Password ?", style: TextStyle( color : Colors.black,fontFamily: "font1", fontSize: 30, fontWeight: FontWeight.w700))),
          SizedBox(height : 20),
          Image.network("https://assets-v2.lottiefiles.com/a/4a774176-1171-11ee-ae48-bf87d1dea7a3/votYo4X96y.gif", height : 200),
          SizedBox(height : 15),
          Center(child: Text("No Worries ! Just write your Email, and we would send you reset link", style: TextStyle( color : Colors.black,fontFamily: "font1", fontSize: 17, fontWeight: FontWeight.w400), textAlign: TextAlign.center,)),
          SizedBox(height : 5),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'Your Email',  isDense: true,
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter your School email';
                }
                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                  return 'Please enter a valid email';
                }
                return null;
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(15.0),
            child: SocialLoginButton(
              backgroundColor:  Color(0xff50008e),
              height: 40,
              text: 'Send Reset Link',
              borderRadius: 20,
              fontSize: 21,
              buttonType: SocialLoginButtonType.generalLogin,
              onPressed: () async {
                if(_emailController.text.isEmpty){
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Email Can\'t be left Empty '),
                    ),
                  );
                }else{
                  try{
                    final credential = await FirebaseAuth.instance.sendPasswordResetEmail(email: _emailController.text);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Sent Successful ! Check your Mail'),
                      ),
                    );
                    Navigator.pop(context);
                  }catch(e){
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${e}'),
                      ),
                    );
                  }
                }
                 },
            ),
          ),
        ],
      )
    );
  }
}
