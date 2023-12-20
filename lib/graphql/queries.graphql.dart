String SETTINGS_BY_EMAIL() {
  return '''query SettingsByEmail(\$email: AWSEmail!) {
      settingsByEmail(email: \$email) {
        items {
          id
          email
          tokens
        }
      }
    }''';
}
