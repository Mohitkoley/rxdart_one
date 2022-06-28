List<String> helloString = [
  "Hello String 1",
  "Hello String 2",
  "Hello String 3",
  "Hello String 4",
  "Hello String 5"
];

List<String> welcomeString = [
  "Welcome String 1",
  "Welcome String 2",
  "Welcome String 3",
  "Welcome Strong 4",
  "Welcome String 5"
];

Future<List<String>> fetchHelloString() async {
  await Future.delayed(const Duration(seconds: 2));
  return helloString;
}

Future<List<String>> fetchWelcomeString() async {
  await Future.delayed(const Duration(seconds: 1));
  return welcomeString;
}
