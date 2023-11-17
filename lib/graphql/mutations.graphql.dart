String CREATE_USER() {
  return '''mutation CreateUser(\$email: AWSEmail!) {
      createUser(input: { email: \$email }) {
        id
      }
      createUser(input: { id: \$email })
    }
  }''';
}

String CREATE_GPT_SESSION_FOR_USER_BY_EMAIL() {
  return '''mutation CreateGptSessionForUserByEmail(\$email: AWSEmail!) {
      createGptSession(input: { email: \$email }) {
        user {
          email
        }
      }
    }
  }''';
}

String INIT_GPT_QUERY() {
  return '''mutation InitGptQuery(\$message: AWSJSON!, \$userId: ID!, \$gptSessionId: ID!) {
      initGptQuery(message: \$message, userId: \$userId, gptSessionId: \$gptSessionId)
    }''';
}
