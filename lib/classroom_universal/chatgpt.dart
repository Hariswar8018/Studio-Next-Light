import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart' as d;

class ChatPage1 extends StatefulWidget {
  const ChatPage1({super.key});

  @override
  State<ChatPage1> createState() => _ChatPage1State();
}

class _ChatPage1State extends State<ChatPage1> {
  final ChatUser _user = ChatUser(
    id: '1',
    firstName: 'Charles',
    lastName: 'Leclerc',
  );

  final ChatUser _gptChatUser = ChatUser(
    id: '2',
    firstName: 'Tiara',
    lastName: 'Waleland',
    profileImage: "https://i.ibb.co/hZX0wWJ/photo-2024-10-03-09-29-14.jpg"
    // Replace with the URL of the avatar image// Update with the actual image URL
  );

  List<ChatMessage> _messages = <ChatMessage>[];  // Chat message history
  List<ChatUser> _typingUsers = <ChatUser>[];      // Typing users indicator

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(4.0),
          child: CircleAvatar(
            backgroundImage: NetworkImage("https://i.ibb.co/hZX0wWJ/photo-2024-10-03-09-29-14.jpg"),
          ),
        ),
        backgroundColor:Colors.black,
        title: const Text(
          'Ask Tiara',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          if(_messages.isEmpty)// Check if there are no messages
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  SizedBox(height: 35,),
                  Image.asset("assets/tiara.png",width: MediaQuery.of(context).size.width/2,),
                  Text(
                    '✍ Ask me Anything 😊',
                    style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black,fontSize: 16),
                  ),
                  SizedBox(height: 25,),
                  Text(
                    'Recommended Questions:',
                    style: TextStyle(fontWeight: FontWeight.bold,color: Colors.blueAccent,fontSize: 22),
                  ),
                  const SizedBox(height: 8.0),
                  r("What is Capital of India?"),
                  r("What is the formuale of Force ?"),
                  r("Why Global Warming is Threat to World?"),
                ],
              ),
            ),
          Expanded(
            child: DashChat(
              currentUser: _user,
              messageOptions: const MessageOptions(
                currentUserContainerColor: Colors.black,
                containerColor: Color.fromRGBO(0, 166, 126, 1),
                textColor: Colors.white,
              ),
              onSend: (ChatMessage m) {
                getGeminiResponse(m);  // Call the method to get Gemini response
              },
              messages: _messages,
              typingUsers: _typingUsers,
            ),
          ),

        ],
      ),
    );
  }
  Widget r(String si)=> InkWell(
    onTap: () {
      getGeminiResponse(ChatMessage(
        text:si,
        user: _user,
        createdAt: DateTime.now(),
      ));
    },
    child: Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Container(
        width: MediaQuery.of(context).size.width-40,
        height: 30,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
              color: Colors.greenAccent,
              width: 0.6
          ),
        ),
        child: Center(child: Text(si)),
      ),
    ),
  );

  Future<void> getGeminiResponse(ChatMessage m) async {
    setState(() {
      _messages.insert(0, m);  // Add user message to chat
      _typingUsers.add(_gptChatUser);  // Indicate typing
    });

    // Set up Gemini model
    const apiKey = "AIzaSyDJGQ3-DoQ5YgFk_fQqk0d3LcfCQcRw0V0";  // Replace with your Gemini API key
    final model = d.GenerativeModel(
      model: 'gemini-1.5-flash-latest',
      apiKey: apiKey,
    );

    // Prepare the prompt for Gemini
    final prompt = m.text;  // Use the user input as the prompt
    final content = [d.Content.text(prompt)];

    try {
      final response = await model.generateContent(content);  // Generate content with Gemini
      String geminiResponseText = response.text ?? "No response";  // Get the response text

      // Add Gemini's response to chat
      setState(() {
        _messages.insert(
          0,
          ChatMessage(
            user: _gptChatUser,
            createdAt: DateTime.now(),
            text: geminiResponseText,
          ),
        );
        _typingUsers.remove(_gptChatUser);  // Remove typing indicator
      });
    } catch (e) {
      print("Error fetching response from Gemini: $e");
      setState(() {
        _typingUsers.remove(_gptChatUser);  // Remove typing indicator in case of error
      });
    }
  }
}
