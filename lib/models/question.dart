class Question {
  final String questionText;
  final List<Map<String, dynamic>> answers;
  final int correctAnswerIndex;

  Question({
    required this.questionText,
    required this.answers,
    required this.correctAnswerIndex,
  });

  static List<Question> getQuestions() {
    return [
      Question(
        questionText: "What is the capital of France?",
        answers: [
          {'text': 'Paris', 'score': 1},
          {'text': 'London', 'score': 0},
          {'text': 'Berlin', 'score': 0},
          {'text': 'Madrid', 'score': 0},
        ],
        correctAnswerIndex: 0,
      ),
      Question(
        questionText: "Which planet is known as the Red Planet?",
        answers: [
          {'text': 'Jupiter', 'score': 0},
          {'text': 'Mars', 'score': 1},
          {'text': 'Venus', 'score': 0},
          {'text': 'Mercury', 'score': 0},
        ],
        correctAnswerIndex: 1,
      ),
      Question(
        questionText: "What is 2 + 2?",
        answers: [
          {'text': '3', 'score': 0},
          {'text': '4', 'score': 1},
          {'text': '5', 'score': 0},
          {'text': '6', 'score': 0},
        ],
        correctAnswerIndex: 1,
      ),
      Question(
        questionText: "Which language is used to build Flutter apps?",
        answers: [
          {'text': 'Java', 'score': 0},
          {'text': 'Kotlin', 'score': 0},
          {'text': 'Dart', 'score': 1},
          {'text': 'Python', 'score': 0},
        ],
        correctAnswerIndex: 2,
      ),
      Question(
        questionText: "What is the largest ocean on Earth?",
        answers: [
          {'text': 'Atlantic Ocean', 'score': 0},
          {'text': 'Indian Ocean', 'score': 0},
          {'text': 'Arctic Ocean', 'score': 0},
          {'text': 'Pacific Ocean', 'score': 1},
        ],
        correctAnswerIndex: 3,
      ),
      Question(
        questionText: "Who wrote the play 'Romeo and Juliet'?",
        answers: [
          {'text': 'William Shakespeare', 'score': 1},
          {'text': 'Charles Dickens', 'score': 0},
          {'text': 'Jane Austen', 'score': 0},
          {'text': 'Mark Twain', 'score': 0},
        ],
        correctAnswerIndex: 0,
      ),
      Question(
        questionText: "What is the chemical symbol for water?",
        answers: [
          {'text': 'O2', 'score': 0},
          {'text': 'H2O', 'score': 1},
          {'text': 'CO2', 'score': 0},
          {'text': 'NaCl', 'score': 0},
        ],
        correctAnswerIndex: 1,
      ),
      Question(
        questionText: "Which country is known as the Land of the Rising Sun?",
        answers: [
          {'text': 'China', 'score': 0},
          {'text': 'Japan', 'score': 1},
          {'text': 'Thailand', 'score': 0},
          {'text': 'South Korea', 'score': 0},
        ],
        correctAnswerIndex: 1,
      ),
      Question(
        questionText: "What is the hardest natural substance on Earth?",
        answers: [
          {'text': 'Gold', 'score': 0},
          {'text': 'Iron', 'score': 0},
          {'text': 'Diamond', 'score': 1},
          {'text': 'Silver', 'score': 0},
        ],
        correctAnswerIndex: 2,
      ),
      Question(
        questionText: "Who painted the Mona Lisa?",
        answers: [
          {'text': 'Vincent van Gogh', 'score': 0},
          {'text': 'Pablo Picasso', 'score': 0},
          {'text': 'Leonardo da Vinci', 'score': 1},
          {'text': 'Claude Monet', 'score': 0},
        ],
        correctAnswerIndex: 2,
      ),
      Question(
        questionText: "What is the smallest prime number?",
        answers: [
          {'text': '0', 'score': 0},
          {'text': '1', 'score': 0},
          {'text': '2', 'score': 1},
          {'text': '3', 'score': 0},
        ],
        correctAnswerIndex: 2,
      ),
      Question(
        questionText: "Which continent is the Sahara Desert located on?",
        answers: [
          {'text': 'Asia', 'score': 0},
          {'text': 'Africa', 'score': 1},
          {'text': 'Australia', 'score': 0},
          {'text': 'South America', 'score': 0},
        ],
        correctAnswerIndex: 1,
      ),
      Question(
        questionText: "What is the main ingredient in guacamole?",
        answers: [
          {'text': 'Tomato', 'score': 0},
          {'text': 'Avocado', 'score': 1},
          {'text': 'Onion', 'score': 0},
          {'text': 'Pepper', 'score': 0},
        ],
        correctAnswerIndex: 1,
      ),
      Question(
        questionText: "Who is known as the Father of Computers?",
        answers: [
          {'text': 'Albert Einstein', 'score': 0},
          {'text': 'Charles Babbage', 'score': 1},
          {'text': 'Isaac Newton', 'score': 0},
          {'text': 'Alan Turing', 'score': 0},
        ],
        correctAnswerIndex: 1,
      ),
      Question(
        questionText: "Which gas do plants absorb from the atmosphere?",
        answers: [
          {'text': 'Oxygen', 'score': 0},
          {'text': 'Carbon Dioxide', 'score': 1},
          {'text': 'Nitrogen', 'score': 0},
          {'text': 'Hydrogen', 'score': 0},
        ],
        correctAnswerIndex: 1,
      ),
      Question(
        questionText: "What is the largest planet in our solar system?",
        answers: [
          {'text': 'Earth', 'score': 0},
          {'text': 'Jupiter', 'score': 1},
          {'text': 'Saturn', 'score': 0},
          {'text': 'Mars', 'score': 0},
        ],
        correctAnswerIndex: 1,
      ),
      Question(
        questionText: "Which element has the chemical symbol 'O'?",
        answers: [
          {'text': 'Gold', 'score': 0},
          {'text': 'Oxygen', 'score': 1},
          {'text': 'Osmium', 'score': 0},
          {'text': 'Oxide', 'score': 0},
        ],
        correctAnswerIndex: 1,
      ),
      Question(
        questionText: "Who discovered penicillin?",
        answers: [
          {'text': 'Marie Curie', 'score': 0},
          {'text': 'Alexander Fleming', 'score': 1},
          {'text': 'Louis Pasteur', 'score': 0},
          {'text': 'Gregor Mendel', 'score': 0},
        ],
        correctAnswerIndex: 1,
      ),
      Question(
        questionText: "What is the tallest mountain in the world?",
        answers: [
          {'text': 'K2', 'score': 0},
          {'text': 'Mount Everest', 'score': 1},
          {'text': 'Kangchenjunga', 'score': 0},
          {'text': 'Lhotse', 'score': 0},
        ],
        correctAnswerIndex: 1,
      ),
      Question(
        questionText: "Which country gifted the Statue of Liberty to the USA?",
        answers: [
          {'text': 'Germany', 'score': 0},
          {'text': 'France', 'score': 1},
          {'text': 'Italy', 'score': 0},
          {'text': 'Canada', 'score': 0},
        ],
        correctAnswerIndex: 1,
      ),
      Question(
        questionText: "What is the freezing point of water?",
        answers: [
          {'text': '0°C', 'score': 1},
          {'text': '100°C', 'score': 0},
          {'text': '32°C', 'score': 0},
          {'text': '50°C', 'score': 0},
        ],
        correctAnswerIndex: 0,
      ),
      Question(
        questionText: "Which organ pumps blood through the body?",
        answers: [
          {'text': 'Liver', 'score': 0},
          {'text': 'Heart', 'score': 1},
          {'text': 'Lungs', 'score': 0},
          {'text': 'Kidneys', 'score': 0},
        ],
        correctAnswerIndex: 1,
      ),
    ];
  }
}