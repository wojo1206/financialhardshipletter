String GET_HARDSHIP_LETTER() {
  return '''query InitHardshipLetter {
      initHardshipLetter {
        msg
      }
    }''';
}

String INIT_GPT_QUERY() {
  return '''query InitGptQuery(\$prompt: String!, \$gptSessionId: ID!) {
      initGptQuery(prompt: \$prompt, gptSessionId: \$gptSessionId) {
        id
      }
    }''';
}

String USERS_BY_EMAIL() {
  return '''query UsersByEmail(\$email: String!) {
      usersByEmail(email: \$email) {
        items {
          id
          email
        }
      }
    }''';
}
