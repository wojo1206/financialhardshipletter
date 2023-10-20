String CREATE_USER() {
  return '''mutation CreateUser(\$email: String!) {
      createUser(input: { email: \$email }) {
        id
      }
      createUser(input: { id: \$email })
    }
  }''';
}

String CREATE_GPT_SESSION_FOR_USER_BY_EMAIL() {
  return '''mutation CreateGptSessionForUserByEmail(\$email: String!) {
      createGptSession(input: { email: \$email }) {
        user {
          email
        }
      }
    }
  }''';
}
