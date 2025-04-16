import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:intl/intl.dart';

class EWasteChatBotScreen extends StatefulWidget {
  const EWasteChatBotScreen({super.key});

  @override
  State<EWasteChatBotScreen> createState() => _EWasteChatBotScreenState();
}

class _EWasteChatBotScreenState extends State<EWasteChatBotScreen> {
  final TextEditingController _controller = TextEditingController();
  final FlutterTts _flutterTts = FlutterTts();
  final stt.SpeechToText _speech = stt.SpeechToText();
  final ImagePicker _picker = ImagePicker();
  List<Map<String, String>> messages = [];
  File? selectedImage;
  bool isListening = false;
  bool isLoading = false;
  bool isSpeaking = false;
  bool isBotTyping = false;
  late GenerativeModel model;

  @override
  void initState() {
    super.initState();
    model = GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: 'AIzaSyCwLE8LlVNh3vOGikSI6Fgfi-JmCcKwbcU',
    );
    _initTTS();
  }

  void _initTTS() async {
    await _flutterTts.setLanguage("en-US");
    await _flutterTts.setPitch(1.0);
    await _flutterTts.setSpeechRate(0.5);
    await _flutterTts.awaitSpeakCompletion(true);
  }

  void _sendMessage() async {
    String prompt = _controller.text.trim();
    if (prompt.isEmpty && selectedImage == null) return;

    setState(() {
      messages.add({"role": "user", "content": prompt, "timestamp": _getCurrentTime()});
      isLoading = true;
      isBotTyping = true;
    });

    final content = Content.multi([
      if (selectedImage != null)
        DataPart('image/jpeg', selectedImage!.readAsBytesSync()),
      TextPart(prompt),
    ]);

    final response = await model.generateContent([content]);
    final reply = response.text ?? "Sorry, I couldn't understand that.";

    setState(() {
      messages.add({"role": "bot", "content": reply, "timestamp": _getCurrentTime()});
      isLoading = false;
      isBotTyping = false;
      _controller.clear();
      selectedImage = null;
    });
  }

  void _startListening() async {
    bool available = await _speech.initialize();
    if (available) {
      setState(() => isListening = true);
      _speech.listen(onResult: (result) {
        setState(() => _controller.text = result.recognizedWords);
      });
    }
  }

  void _stopListening() {
    _speech.stop();
    setState(() => isListening = false);
  }

  void _toggleSpeaking(String text) async {
    if (isSpeaking) {
      await _flutterTts.stop();
      setState(() => isSpeaking = false);
    } else {
      try {
        await _flutterTts.speak(text);
        setState(() => isSpeaking = true);
      } catch (e) {
        print("TTS error: $e");
      }
    }
  }

  void _pickImage() async {
    final image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() => selectedImage = File(image.path));
    }
  }

  void _clearChat() {
    setState(() {
      messages.clear();
    });
  }

  String _getCurrentTime() {
    return DateFormat('hh:mm a').format(DateTime.now());
  }

  Widget _buildMessage(Map<String, String> message) {
    bool isUser = message['role'] == 'user';
    String content = message['content'] ?? '';
    String time = message['timestamp'] ?? '';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Align(
        alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
        child: Column(
          crossAxisAlignment:
              isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            if (!isUser)
              GestureDetector(
                onTap: () => _toggleSpeaking(content),
                child: Icon(
                  isSpeaking ? Icons.stop_circle_outlined : Icons.volume_up,
                  size: 20,
                  color: Colors.green.shade700,
                ),
              ),
            Container(
              constraints: const BoxConstraints(maxWidth: 300),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isUser ? Colors.green.shade100 : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: const Offset(2, 2),
                  )
                ],
              ),
              child: MarkdownBody(
                data: content,
                styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              time,
              style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFAQs() {
    final faqs = [
      "What is e-waste?",
      "How can I dispose of e-waste properly?",
      "What are the benefits of recycling e-waste?",
      "What items are considered e-waste?",
      "Where can I find the nearest recycling center?",
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: faqs
            .map((faq) => Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ActionChip(
                    backgroundColor: Colors.green.shade50,
                    label: Text(faq),
                    onPressed: () {
                      _controller.text = faq;
                      _sendMessage();
                    },
                  ),
                ))
            .toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('E-Waste Assistant'),
        backgroundColor: Colors.white,
        elevation: 2,
        shadowColor: Theme.of(context).primaryColor,
        leading: BackButton(onPressed: ()=> Navigator.of(context).pop(),),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_forever),
            onPressed: _clearChat,
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 8),
            const Text(
              "Ask Me Anything ♻️",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            _buildFAQs(),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: messages.length + (isBotTyping ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == messages.length && isBotTyping) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text("Gemini is typing...",
                            style: TextStyle(color: Colors.grey)),
                      ),
                    );
                  }
                  return _buildMessage(messages[index]);
                },
              ),
            ),
            if (selectedImage != null)
              Container(
                height: 150,
                margin: const EdgeInsets.only(top: 8),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.file(selectedImage!),
                ),
              ),
            const SizedBox(height: 10),
            Container(
              margin: const EdgeInsets.all(12),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.green.shade300, width: 1.4),
                borderRadius: BorderRadius.circular(16),
                color: Colors.white,
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.image, color: Colors.green),
                    onPressed: _pickImage,
                  ),
                  IconButton(
                    icon: Icon(
                      isListening ? Icons.mic : Icons.mic_none,
                      color: Colors.green.shade700,
                    ),
                    onPressed: isListening ? _stopListening : _startListening,
                  ),
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: const InputDecoration(
                        hintText: "Ask something...",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  isLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : IconButton(
                          icon: const Icon(Icons.send, color: Colors.green),
                          onPressed: _sendMessage,
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
