String getHardshipLetter() {
  return '''query InitHardshipLetter {
      initHardshipLetter {
        msg
      }
    }''';
}

String usersByEmail() {
  return '''query UsersByEmail(\$email: String!) {
      usersByEmail(email: \$email) {
        items {
          id
          email
        }
      }
    }''';
}
