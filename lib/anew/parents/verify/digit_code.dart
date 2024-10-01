import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pinput/pinput.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_auth/smart_auth.dart';
import 'package:student_managment_app/Parents_Portal/home.dart';
import 'package:student_managment_app/anew/parents/home/portal_student.dart';
import 'package:student_managment_app/function/send.dart';
import 'package:student_managment_app/model/student_model.dart';

class DigitCode extends StatefulWidget {

  bool google;StudentModel user;

  bool parent;String id,classid,sessionid;

  DigitCode({super.key,required this.google,required this.user,required this.parent,required this.id,required this.sessionid,required this.classid});

  @override
  State<DigitCode> createState() => _DigitCodeState();
}

class _DigitCodeState extends State<DigitCode> {
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
    double h=MediaQuery.of(context).size.height;
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
      body: Form(
        key: formKey,
        child: Column(
          children: [
            SizedBox(height: 40,),
            Center(
              child: Container(
                  width:w-40,height:300,
                  decoration:BoxDecoration(
                      image:DecorationImage(
                          image:AssetImage("assets/images/login/two-factor-authentication-concept-illustration_114360-5488.png"),
                          fit: BoxFit.contain
                      ),
                  )
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 14.0,right: 14,top: 14),
              child: Center(
                child: Text((widget.google?"Open Google Authenticator App":"BackUp 6 Digit Codes "),
                  style: TextStyle(fontWeight: FontWeight.w800,fontSize: 24),),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 14.0,right: 14),
              child: Center(
                child: Text(widget.google?"Put the 6 Digit Code inside it to Verify":"If you don't remember, contact School",
                  style: TextStyle(fontWeight: FontWeight.w400,fontSize: 16),),
              ),
            ),
            SizedBox(height: 12,),
            Directionality(
              textDirection: TextDirection.ltr,
              child: Pinput(
                smsRetriever: smsRetriever,length: 6,
                controller: pinController,
                focusNode: focusNode,
                defaultPinTheme: defaultPinTheme,
                separatorBuilder: (index) => const SizedBox(width: 8),
                validator: (value) {
                  // Check if the value exists in the list of backup codes
                  if (value != null && widget.user.backcod.contains(value)) {
                    return null; // No error
                  }
                  return 'Pin is Incorrect'; // Show error
                },
                hapticFeedbackType: HapticFeedbackType.lightImpact,
                onCompleted: (pin) async {
                  if(widget.google){
                    Send.message(context, "Wrong ! Google Authenticator Failed",false);
                  }else{
                    if(widget.user.backcod.contains(int.parse(pin))){
                      Send.message(context, "Success",true);
                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      prefs.setBool('Parent', true);
                      prefs.setString("id", widget.user.Registration_number);
                      if(widget.parent){
                        prefs.setString("What", "Parent");
                      }else{
                        prefs.setString("What", "Student");
                      }
                      prefs.setString("class", widget.classid);
                      prefs.setString("session", widget.sessionid);
                      prefs.setString("school", widget.id);
                        Navigator.push(
                          context,
                          PageTransition(
                            child: PortalStudent(st:widget.user, parent: widget.parent,),
                            type: PageTransitionType.fade,
                            duration: Duration(milliseconds: 50),
                          ),
                        );
                    }else{
                      Send.message(context, "This is not One of BackUp Code",false);
                    }
                  }
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
    double h=MediaQuery.of(context).size.height;
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