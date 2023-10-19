String createGptSessionForUserByEmail() {
  return '''mutation CreateGptSessionForUserByEmail(\$email: String!) {
      createGptSession(input: { email: \$email }) {
        user {
          email
        }
      }
    }
  }''';
}
