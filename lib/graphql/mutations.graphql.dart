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

String CREATE_SETTING() {
  return '''mutation CreateSetting(\$email: AWSEmail!, \$tokens: int) {
      createSetting(input: { email: \$email, tokens: \$tokens }) {
        user {
          id
          email
          tokens
        }
      }
    }
  }''';
}

String INIT_GPT_QUERY() {
  return '''mutation InitGptQuery(\$message: AWSJSON!, \$email: AWSEmail!, \$gptSessionId: ID!) {
      initGptQuery(message: \$message, email: \$email, gptSessionId: \$gptSessionId)
    }''';
}
