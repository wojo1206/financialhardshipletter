String USERS_BY_EMAIL() {
  return '''query UsersByEmail(\$email: AWSEmail!) {
      usersByEmail(email: \$email) {
        items {
          id
          email
        }
      }
    }''';
}
