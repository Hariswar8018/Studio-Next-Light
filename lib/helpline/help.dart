import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Emergency extends StatelessWidget {
  const Emergency({super.key});

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("Declare Emergency"),
      ),
      body: SingleChildScrollView(
        child: Column(
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
                        Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.call_made,color: Colors.green,),Text(" Toll Free"),SizedBox(width: 8,),
                            Icon(Icons.wifi_calling_3,color: Colors.red,),Text(" 24 Hour Call")
                          ],
                        ),
                        SizedBox(height: 1,)
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // Child Helpline
            c(w, "Children Helpline", "112", "dial1098@childlineindia.org.in", "https://childlineindia.org/", true, true),
            // Women Helpline
             c(w, "Women Helpline", "181", "whl@wcd.nic.in", "https://wcd.nic.in/", true, true),
        
        // Police Emergency
            c(w, "Police Emergency", "100", "police@india.gov.in", "https://police.gov.in/", true, false),
        
        // Fire Emergency
        
        // Ambulance
            c(w, "Ambulance", "102", "ambulance@india.gov.in", "https://ambulance.gov.in/", true, false),
        
        // National Cyber Crime Reporting
            c(w, "Cyber Crime Helpline", "1930", "cybercrime@india.gov.in", "https://cybercrime.gov.in/", true, true),
        
        // Emergency Response Support System (ERSS)
            c(w, "ERSS", "112", "erss@india.gov.in", "https://112.gov.in/", true, true),
        
        // Anti-Bullying Helpline
            c(w, "Anti-Bullying Helpline", "1800-11-8004", "antibullying@cbse.gov.in", "https://cbse.gov.in/", true, true),
        
        // Child Protection Services
            c(w, "Child Protection Services", "011-23381611", "childprotection@wcd.nic.in", "https://wcd.nic.in/", true, false),
        
        // National Human Rights Commission (NHRC)
            c(w, "Human Rights Helpline", "14433", "nhrc@nic.in", "https://nhrc.nic.in/", true, true),

            c(w, "Mental Health Helpline", "1800-599-0019", "mentalhealth@manodarpan.nic.in", "https://manodarpan.nic.in/", true, true),
        
        
        // Missing Children Helpline
            c(w, "Missing Children Helpline", "1800-102-7333", "missingchild@india.gov.in", "https://missionvatsalya.wcd.gov.in/", true, true),
            c(w, "Fire Emergency", "101", "fire@india.gov.in", "https://fire.gov.in/", true, false),
            c(w, "Poison Control Helpline", "1800-11-6111", "poisoncontrol@aiims.edu", "https://aiims.edu/", true, true),
        
        // Disaster Management Helpline
            c(w, "Disaster Management Helpline", "108", "disaster@ndma.gov.in", "https://ndma.gov.in/", true, true),
        
            ],
        ),
      ),
    );
  }
  Widget c(double w,String str,String number, String email,String website,bool is24hours,bool istollfree){
    return  Center(
      child: InkWell(
        onTap: () async {
          Uri url=Uri.parse("tel:"+number);
          await launchUrl(url);
        },
        child: Card(
          color: Colors.white,
          child: Container(
            width: w-10,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(str,style: TextStyle(fontWeight: FontWeight.w800,fontSize: 20),),
                      Spacer(),
                      istollfree?Icon(Icons.call_made,color: Colors.green,):SizedBox(),
                      SizedBox(width: 10,),
                      is24hours?Icon(Icons.wifi_calling_3,color: Colors.red,):SizedBox(),
                    ],
                  ),
                  SizedBox(height: 7,),
                  InkWell(
                    onTap: () async {
                      Uri url=Uri.parse("tel:"+number);
                      await launchUrl(url);
                    },
                    child: Row(
                      children: [
                        Icon(Icons.phone,color: Colors.green,),
                        Text(number,style: TextStyle(fontSize: 20),),
                      ],
                    ),
                  ),
                  SizedBox(height: 7,),
                  InkWell(
                    onTap: () async {
                      Uri url=Uri.parse("mailto:"+email);
                      await launchUrl(url);
                    },
                    child: Row(
                      children: [
                        Icon(Icons.mail,color: Colors.orange,size: 15,),
                        Text("  "+email,style: TextStyle(fontSize: 13,color: Colors.orange),),
                      ],
                    ),
                  ),
                  SizedBox(height: 4,),
                  InkWell(
                    onTap: () async {
                      Uri url=Uri.parse(website);
                      await launchUrl(url);
                    },
                    child: Row(
                      children: [
                        Icon(Icons.language,color: Colors.indigo,size: 15,),
                        Text("  "+website,style: TextStyle(fontSize: 13,color: Colors.indigo),),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
