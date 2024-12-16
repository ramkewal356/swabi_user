String getInitials(String name) {
  if (name.isEmpty) {
    return '';
  }
  List<String> words = name.split(' ');

  if (words.length > 1) {
    String firstInitial = words[0].substring(0, 1).toUpperCase();
    String secondInitial = words[1].substring(0, 1).toUpperCase();
    return '$firstInitial$secondInitial';
  } else {
    return name.substring(0, 2).toUpperCase(); // Take the first two characters for a single name
  }
}