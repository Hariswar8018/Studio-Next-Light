import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:smart_auth/smart_auth.dart';
import 'package:student_managment_app/function/send.dart';
import 'package:student_managment_app/model/student_model.dart';

class EmailCode extends StatefulWidget {
  StudentModel user;

  bool google;
  EmailCode({super.key,required this.google,required this.user});

  @override
  State<EmailCode> createState() => _EmailCodeState();
}

class _EmailCodeState extends State<EmailCode> {
bool done=true;bool round=false;
final _emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    double w=MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation:0,
        leading: InkWell(
          onTap:()=>Navigator.pop(context),
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: Center(child: Icon(Icons.arrow_back_rounded,color:Colors.blue,size: 22,)),
            ),
          ),
        ),
        title: Text("Verify Code",style: TextStyle(color: Colors.white),),
      ),
      body: Column(
        children: [
          SizedBox(height: 40,),
          Center(
            child: Container(
                width:w-40,height:300,
                decoration:BoxDecoration(
                    image:DecorationImage(
                        image:AssetImage(widget.google?"assets/images/login/phone.gif":"assets/images/login/email.gif"),
                        fit: BoxFit.contain
                    )
                )
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 14.0,right: 14,top: 14),
            child: Center(
              child: Text("Type "+(widget.google?"Phone Number":"Email")+" to Verify",
                style: TextStyle(fontWeight: FontWeight.w800,fontSize: 24),),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 14.0,right: 14),
            child: Center(
              child: Text("Put the Number / Email as presented in ID Card",
                style: TextStyle(fontWeight: FontWeight.w400,fontSize: 16),),
            ),
          ),
          SizedBox(height: 12,),
          done?Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'Type the '+(widget.google?"Phone Number without STD Code":"Email"),  isDense: true,
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
              onChanged: (value) {

              },
            ),
          ):Padding(
            padding: const EdgeInsets.all(18.0),
            child: const FractionallySizedBox(
              widthFactor: 1,
              child: DigitCode1(),
            ),
          ),
          done?InkWell(
            onTap: () async {
              if(widget.google){
                if(_emailController.text==widget.user.Mobile){
                  if (_emailController.text.length == 10) {
                    Send.message(context, "Lets verify you are not a Robot",false);
                    try {
                      await FirebaseAuth.instance.verifyPhoneNumber(
                        phoneNumber: "+91" + _emailController.text,
                        verificationCompleted:
                            (PhoneAuthCredential credential) async {

                        },
                        verificationFailed: (FirebaseAuthException e) {
                          Send.message(context, "$e",false);
                          print(
                              'Verification failed: ${e.message}');
                        },
                        codeSent: (String verificationId,
                            int? resendToken) {
                          Send.message(context, "SMS sent to your Number",true);
                          setState(() {
                            done=false;
                          });
                          print(
                              'Verification ID: $verificationId');
                        },
                        codeAutoRetrievalTimeout:
                            (String verificationId) {
                              Send.message(context, "Code time OUT",false);
                          print(
                              'Auto Retrieval Timeout. Verification ID: $verificationId');
                        },
                      );
                      setState((){
                        round = false ;
                      });
                    } catch (e) {
                      setState((){
                        round = false ;
                      });
                      print(
                          'Error sending verification code: $e');
                      Send.message(context, "$e",false);
                    }
                  } else {
                    setState((){
                      round = false ;
                    });
                    Send.message(context, "Type 10 Digit Number",false);
                  }
                }else{
                  Send.message(context, "It's Wrong Phone Number Provided",false);
                }
              }else{
                if(_emailController.text==widget.user.Email){
                  setState(() {
                    done=false;
                  });
                  await FirebaseAuth.instance.signInWithEmailLink(email: _emailController.text,emailLink: "hv");
                }else{
                  Send.message(context, "Email not matched with Parents Databased",false);
                }
              }
            },
            child: round?Center(child: CircularProgressIndicator(),):Center(
              child: Container(
                height:45,width:w-20,
                decoration:BoxDecoration(
                  borderRadius:BorderRadius.circular(7),
                  color:Colors.blue,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.4), // Shadow color with transparency
                      spreadRadius: 5, // The extent to which the shadow spreads
                      blurRadius: 7, // The blur radius of the shadow
                      offset: Offset(0, 3), // The position of the shadow
                    ),
                  ],
                ),
                child: Center(child: Text("Confirm the "+(widget.google?"Phone":"Email"),style: TextStyle(
                    color: Colors.white,
                    fontFamily: "RobotoS",fontWeight: FontWeight.w800
                ),)),
              ),
            ),
          ):SizedBox(),
        ],
      ),
    );
  }
}


class DigitCode1 extends StatefulWidget {
  const DigitCode1({super.key});

  @override
  State<DigitCode1> createState() => _DigitCodeState1();
}

class _DigitCodeState1 extends State<DigitCode1> {
  late final SmsRetriever smsRetriever;

  late final TextEditingController pinController;

  late final FocusNode focusNode;

  late final GlobalKey<FormState> formKey;

  @override
  void initState() {
    super.initState();
    formKey = GlobalKey<FormState>();
    pinController = TextEditingController();
    focusNode = FocusNode();

    /// In case you need an SMS autofill feature
    smsRetriever = SmsRetrieverImpl(
      SmartAuth(),
    );
  }

  @override
  void dispose() {
    pinController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double w=MediaQuery.of(context).size.width;
    const focusedBorderColor = Color.fromRGBO(23, 171, 144, 1);
    const fillColor = Color.fromRGBO(243, 246, 249, 0);
    const borderColor = Color.fromRGBO(23, 171, 144, 0.4);

    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(
        fontSize: 22,
        color: Color.fromRGBO(30, 60, 87, 1),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(19),
        border: Border.all(color: borderColor),
      ),
    );
    return Form(
      key: formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Directionality(
            // Specify direction if desired
            textDirection: TextDirection.ltr,
            child: Pinput(
              smsRetriever: smsRetriever,length: 6,
              controller: pinController,
              focusNode: focusNode,
              defaultPinTheme: defaultPinTheme,
              separatorBuilder: (index) => const SizedBox(width: 8),
              validator: (value) {
                return value == '222222' ? null : 'Pin is Incorrect';
              },
              hapticFeedbackType: HapticFeedbackType.lightImpact,
              onCompleted: (pin) {
                debugPrint('onCompleted: $pin');
              },
              onChanged: (value) {
                debugPrint('onChanged: $value');
              },
              cursor: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 9),
                    width: 22,
                    height: 1,
                    color: focusedBorderColor,
                  ),
                ],
              ),
              focusedPinTheme: defaultPinTheme.copyWith(
                decoration: defaultPinTheme.decoration!.copyWith(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: focusedBorderColor),
                ),
              ),
              submittedPinTheme: defaultPinTheme.copyWith(
                decoration: defaultPinTheme.decoration!.copyWith(
                  color: fillColor,
                  borderRadius: BorderRadius.circular(19),
                  border: Border.all(color: focusedBorderColor),
                ),
              ),
              errorPinTheme: defaultPinTheme.copyBorderWith(
                border: Border.all(color: Colors.redAccent),
              ),
            ),
          ),
          SizedBox(height: 20,),
          InkWell(
            onTap: () {
              focusNode.unfocus();
              formKey.currentState!.validate();
            },
            child: Center(
              child: Container(
                height:45,width:w-20,
                decoration:BoxDecoration(
                  borderRadius:BorderRadius.circular(7),
                  color:Colors.blue,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.4), // Shadow color with transparency
                      spreadRadius: 5, // The extent to which the shadow spreads
                      blurRadius: 7, // The blur radius of the shadow
                      offset: Offset(0, 3), // The position of the shadow
                    ),
                  ],
                ),
                child: Center(child: Text("Confirm OTP",style: TextStyle(
                    color: Colors.white,
                    fontFamily: "RobotoS",fontWeight: FontWeight.w800
                ),)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// You, as a developer should implement this interface.
/// You can use any package to retrieve the SMS code. in this example we are using SmartAuth
class SmsRetrieverImpl implements SmsRetriever {
  const SmsRetrieverImpl(this.smartAuth);

  final SmartAuth smartAuth;

  @override
  Future<void> dispose() {
    return smartAuth.removeSmsListener();
  }

  @override
  Future<String?> getSmsCode() async {
    final signature = await smartAuth.getAppSignature();
    debugPrint('App Signature: $signature');
    final res = await smartAuth.getSmsCode(
      useUserConsentApi: true,
    );
    if (res.succeed && res.codeFound) {
      return res.code!;
    }
    return null;
  }

  @override
  bool get listenForMultipleSms => false;
}