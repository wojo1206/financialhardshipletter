/*
* Copyright 2021 Amazon.com, Inc. or its affiliates. All Rights Reserved.
*
* Licensed under the Apache License, Version 2.0 (the "License").
* You may not use this file except in compliance with the License.
* A copy of the License is located at
*
*  http://aws.amazon.com/apache2.0
*
* or in the "license" file accompanying this file. This file is distributed
* on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
* express or implied. See the License for the specific language governing
* permissions and limitations under the License.
*/

// NOTE: This file is generated and may not follow lint rules defined in your app
// Generated files can be excluded from analysis in analysis_options.yaml
// For more info, see: https://dart.dev/guides/language/analysis-options#excluding-code-from-analysis

// ignore_for_file: public_member_api_docs, annotate_overrides, dead_code, dead_codepublic_member_api_docs, depend_on_referenced_packages, file_names, library_private_types_in_public_api, no_leading_underscores_for_library_prefixes, no_leading_underscores_for_local_identifiers, non_constant_identifier_names, null_check_on_nullable_type_parameter, prefer_adjacent_string_concatenation, prefer_const_constructors, prefer_if_null_operators, prefer_interpolation_to_compose_strings, slash_for_doc_comments, sort_child_properties_last, unnecessary_const, unnecessary_constructor_name, unnecessary_late, unnecessary_new, unnecessary_null_aware_assignments, unnecessary_nullable_for_final_variable_declarations, unnecessary_string_interpolations, use_build_context_synchronously

import 'ModelProvider.dart';
import 'package:amplify_core/amplify_core.dart' as amplify_core;
import 'package:collection/collection.dart';


/** This is an auto generated class representing the User type in your schema. */
class User extends amplify_core.Model {
  static const classType = const _UserModelType();
  final String id;
  final String? _email;
  final List<GptSession>? _gptSessions;
  final Setting? _settings;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;
  final String? _userSettingsId;

  @override
  getInstanceType() => classType;
  
  @Deprecated('[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;
  
  UserModelIdentifier get modelIdentifier {
      return UserModelIdentifier(
        id: id
      );
  }
  
  String get email {
    try {
      return _email!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  List<GptSession>? get gptSessions {
    return _gptSessions;
  }
  
  Setting? get settings {
    return _settings;
  }
  
  amplify_core.TemporalDateTime? get createdAt {
    return _createdAt;
  }
  
  amplify_core.TemporalDateTime? get updatedAt {
    return _updatedAt;
  }
  
  String? get userSettingsId {
    return _userSettingsId;
  }
  
  const User._internal({required this.id, required email, gptSessions, settings, createdAt, updatedAt, userSettingsId}): _email = email, _gptSessions = gptSessions, _settings = settings, _createdAt = createdAt, _updatedAt = updatedAt, _userSettingsId = userSettingsId;
  
  factory User({String? id, required String email, List<GptSession>? gptSessions, Setting? settings, String? userSettingsId}) {
    return User._internal(
      id: id == null ? amplify_core.UUID.getUUID() : id,
      email: email,
      gptSessions: gptSessions != null ? List<GptSession>.unmodifiable(gptSessions) : gptSessions,
      settings: settings,
      userSettingsId: userSettingsId);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is User &&
      id == other.id &&
      _email == other._email &&
      DeepCollectionEquality().equals(_gptSessions, other._gptSessions) &&
      _settings == other._settings &&
      _userSettingsId == other._userSettingsId;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("User {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("email=" + "$_email" + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null") + ", ");
    buffer.write("userSettingsId=" + "$_userSettingsId");
    buffer.write("}");
    
    return buffer.toString();
  }
  
  User copyWith({String? email, List<GptSession>? gptSessions, Setting? settings, String? userSettingsId}) {
    return User._internal(
      id: id,
      email: email ?? this.email,
      gptSessions: gptSessions ?? this.gptSessions,
      settings: settings ?? this.settings,
      userSettingsId: userSettingsId ?? this.userSettingsId);
  }
  
  User copyWithModelFieldValues({
    ModelFieldValue<String>? email,
    ModelFieldValue<List<GptSession>?>? gptSessions,
    ModelFieldValue<Setting?>? settings,
    ModelFieldValue<String?>? userSettingsId
  }) {
    return User._internal(
      id: id,
      email: email == null ? this.email : email.value,
      gptSessions: gptSessions == null ? this.gptSessions : gptSessions.value,
      settings: settings == null ? this.settings : settings.value,
      userSettingsId: userSettingsId == null ? this.userSettingsId : userSettingsId.value
    );
  }
  
  User.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _email = json['email'],
      _gptSessions = json['gptSessions'] is List
        ? (json['gptSessions'] as List)
          .where((e) => e?['serializedData'] != null)
          .map((e) => GptSession.fromJson(new Map<String, dynamic>.from(e['serializedData'])))
          .toList()
        : null,
      _settings = json['settings']?['serializedData'] != null
        ? Setting.fromJson(new Map<String, dynamic>.from(json['settings']['serializedData']))
        : null,
      _createdAt = json['createdAt'] != null ? amplify_core.TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? amplify_core.TemporalDateTime.fromString(json['updatedAt']) : null,
      _userSettingsId = json['userSettingsId'];
  
  Map<String, dynamic> toJson() => {
    'id': id, 'email': _email, 'gptSessions': _gptSessions?.map((GptSession? e) => e?.toJson()).toList(), 'settings': _settings?.toJson(), 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format(), 'userSettingsId': _userSettingsId
  };
  
  Map<String, Object?> toMap() => {
    'id': id,
    'email': _email,
    'gptSessions': _gptSessions,
    'settings': _settings,
    'createdAt': _createdAt,
    'updatedAt': _updatedAt,
    'userSettingsId': _userSettingsId
  };

  static final amplify_core.QueryModelIdentifier<UserModelIdentifier> MODEL_IDENTIFIER = amplify_core.QueryModelIdentifier<UserModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final EMAIL = amplify_core.QueryField(fieldName: "email");
  static final GPTSESSIONS = amplify_core.QueryField(
    fieldName: "gptSessions",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'GptSession'));
  static final SETTINGS = amplify_core.QueryField(
    fieldName: "settings",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'Setting'));
  static final USERSETTINGSID = amplify_core.QueryField(fieldName: "userSettingsId");
  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "User";
    modelSchemaDefinition.pluralName = "Users";
    
    modelSchemaDefinition.indexes = [
      amplify_core.ModelIndex(fields: const ["email"], name: "usersByEmail")
    ];
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.id());
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: User.EMAIL,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.hasMany(
      key: User.GPTSESSIONS,
      isRequired: false,
      ofModelName: 'GptSession',
      associatedKey: GptSession.USER
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.hasOne(
      key: User.SETTINGS,
      isRequired: false,
      ofModelName: 'Setting',
      associatedKey: Setting.USER
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.nonQueryField(
      fieldName: 'createdAt',
      isRequired: false,
      isReadOnly: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.dateTime)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.nonQueryField(
      fieldName: 'updatedAt',
      isRequired: false,
      isReadOnly: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.dateTime)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: User.USERSETTINGSID,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
  });
}

class _UserModelType extends amplify_core.ModelType<User> {
  const _UserModelType();
  
  @override
  User fromJson(Map<String, dynamic> jsonData) {
    return User.fromJson(jsonData);
  }
  
  @override
  String modelName() {
    return 'User';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [User] in your schema.
 */
class UserModelIdentifier implements amplify_core.ModelIdentifier<User> {
  final String id;

  /** Create an instance of UserModelIdentifier using [id] the primary key. */
  const UserModelIdentifier({
    required this.id});
  
  @override
  Map<String, dynamic> serializeAsMap() => (<String, dynamic>{
    'id': id
  });
  
  @override
  List<Map<String, dynamic>> serializeAsList() => serializeAsMap()
    .entries
    .map((entry) => (<String, dynamic>{ entry.key: entry.value }))
    .toList();
  
  @override
  String serializeAsString() => serializeAsMap().values.join('#');
  
  @override
  String toString() => 'UserModelIdentifier(id: $id)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    
    return other is UserModelIdentifier &&
      id == other.id;
  }
  
  @override
  int get hashCode =>
    id.hashCode;
}