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
