import 'package:flutter/material.dart';

// Local Flashcard model (moved inline to avoid an unused import warning)
class Flashcard {
  String question;
  String answer;
  Flashcard({required this.question, required this.answer});
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Flashcard> flashcards = [
    Flashcard(question: "What is Flutter?", answer: "A UI toolkit by Google."),
    Flashcard(question: "What language does Flutter use?", answer: "Dart."),
  ];

  int currentIndex = 0;
  bool showAnswer = false;

  final _questionController = TextEditingController();
  final _answerController = TextEditingController();

  void nextCard() {
    setState(() {
      if (currentIndex < flashcards.length - 1) {
        currentIndex++;
        showAnswer = false;
      }
    });
  }

  void prevCard() {
    setState(() {
      if (currentIndex > 0) {
        currentIndex--;
        showAnswer = false;
      }
    });
  }

  void addCard() {
    _questionController.clear();
    _answerController.clear();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Add Flashcard"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _questionController,
              decoration: InputDecoration(labelText: "Question"),
            ),
            TextField(
              controller: _answerController,
              decoration: InputDecoration(labelText: "Answer"),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                flashcards.add(
                  Flashcard(
                    question: _questionController.text,
                    answer: _answerController.text,
                  ),
                );
              });
              Navigator.pop(context);
            },
            child: Text("Add"),
          ),
        ],
      ),
    );
  }

  void editCard() {
    _questionController.text = flashcards[currentIndex].question;
    _answerController.text = flashcards[currentIndex].answer;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Edit Flashcard"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _questionController,
              decoration: InputDecoration(labelText: "Question"),
            ),
            TextField(
              controller: _answerController,
              decoration: InputDecoration(labelText: "Answer"),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                flashcards[currentIndex].question = _questionController.text;
                flashcards[currentIndex].answer = _answerController.text;
              });
              Navigator.pop(context);
            },
            child: Text("Save"),
          ),
        ],
      ),
    );
  }

  void deleteCard() {
    setState(() {
      flashcards.removeAt(currentIndex);
      if (currentIndex >= flashcards.length) {
        currentIndex = flashcards.length - 1;
      }
      showAnswer = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Flashcard Quiz App"),
        actions: [
          IconButton(icon: Icon(Icons.add), onPressed: addCard),
          if (flashcards.isNotEmpty)
            IconButton(icon: Icon(Icons.edit), onPressed: editCard),
          if (flashcards.isNotEmpty)
            IconButton(icon: Icon(Icons.delete), onPressed: deleteCard),
        ],
      ),
      body: flashcards.isEmpty
          ? Center(child: Text("No flashcards yet. Add some!"))
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  flashcards[currentIndex].question,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                if (showAnswer)
                  Text(
                    flashcards[currentIndex].answer,
                    style: TextStyle(fontSize: 20, color: Colors.green),
                    textAlign: TextAlign.center,
                  ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => setState(() => showAnswer = !showAnswer),
                  child: Text(showAnswer ? "Hide Answer" : "Show Answer"),
                ),
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: prevCard,
                      child: Text("Previous"),
                    ),
                    ElevatedButton(onPressed: nextCard, child: Text("Next")),
                  ],
                ),
              ],
            ),
    );
  }
}
