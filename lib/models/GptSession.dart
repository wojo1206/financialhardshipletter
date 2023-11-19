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

/** This is an auto generated class representing the GptSession type in your schema. */
class GptSession extends amplify_core.Model {
  static const classType = const _GptSessionModelType();
  final String id;
  final String? _subject;
  final String? _original;
  final String? _modified;
  final List<GptMessage>? _gptMessages;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;

  @Deprecated(
      '[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;

  GptSessionModelIdentifier get modelIdentifier {
    return GptSessionModelIdentifier(id: id);
  }

  String? get subject {
    return _subject;
  }

  String? get original {
    return _original;
  }

  String? get modified {
    return _modified;
  }

  List<GptMessage>? get gptMessages {
    return _gptMessages;
  }

  amplify_core.TemporalDateTime? get createdAt {
    return _createdAt;
  }

  amplify_core.TemporalDateTime? get updatedAt {
    return _updatedAt;
  }

  const GptSession._internal(
      {required this.id,
      subject,
      original,
      modified,
      gptMessages,
      createdAt,
      updatedAt})
      : _subject = subject,
        _original = original,
        _modified = modified,
        _gptMessages = gptMessages,
        _createdAt = createdAt,
        _updatedAt = updatedAt;

  factory GptSession(
      {String? id,
      String? subject,
      String? original,
      String? modified,
      List<GptMessage>? gptMessages,
      amplify_core.TemporalDateTime? createdAt,
      amplify_core.TemporalDateTime? updatedAt}) {
    return GptSession._internal(
        id: id == null ? amplify_core.UUID.getUUID() : id,
        subject: subject,
        original: original,
        modified: modified,
        gptMessages: gptMessages != null
            ? List<GptMessage>.unmodifiable(gptMessages)
            : gptMessages,
        createdAt: createdAt,
        updatedAt: updatedAt);
  }

  bool equals(Object other) {
    return this == other;
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GptSession &&
        id == other.id &&
        _subject == other._subject &&
        _original == other._original &&
        _modified == other._modified &&
        DeepCollectionEquality().equals(_gptMessages, other._gptMessages) &&
        _createdAt == other._createdAt &&
        _updatedAt == other._updatedAt;
  }

  @override
  int get hashCode => toString().hashCode;

  @override
  String toString() {
    var buffer = new StringBuffer();

    buffer.write("GptSession {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("subject=" + "$_subject" + ", ");
    buffer.write("original=" + "$_original" + ", ");
    buffer.write("modified=" + "$_modified" + ", ");
    buffer.write("createdAt=" +
        (_createdAt != null ? _createdAt!.format() : "null") +
        ", ");
    buffer.write(
        "updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");

    return buffer.toString();
  }

  GptSession copyWith(
      {String? subject,
      String? original,
      String? modified,
      List<GptMessage>? gptMessages,
      amplify_core.TemporalDateTime? createdAt,
      amplify_core.TemporalDateTime? updatedAt}) {
    return GptSession._internal(
        id: id,
        subject: subject ?? this.subject,
        original: original ?? this.original,
        modified: modified ?? this.modified,
        gptMessages: gptMessages ?? this.gptMessages,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt);
  }

  GptSession copyWithModelFieldValues(
      {ModelFieldValue<String?>? subject,
      ModelFieldValue<String?>? original,
      ModelFieldValue<String?>? modified,
      ModelFieldValue<List<GptMessage>?>? gptMessages,
      ModelFieldValue<amplify_core.TemporalDateTime?>? createdAt,
      ModelFieldValue<amplify_core.TemporalDateTime?>? updatedAt}) {
    return GptSession._internal(
        id: id,
        subject: subject == null ? this.subject : subject.value,
        original: original == null ? this.original : original.value,
        modified: modified == null ? this.modified : modified.value,
        gptMessages: gptMessages == null ? this.gptMessages : gptMessages.value,
        createdAt: createdAt == null ? this.createdAt : createdAt.value,
        updatedAt: updatedAt == null ? this.updatedAt : updatedAt.value);
  }

  GptSession.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        _subject = json['subject'],
        _original = json['original'],
        _modified = json['modified'],
        _gptMessages = json['gptMessages'] is List
            ? (json['gptMessages'] as List)
                .where((e) => e?['serializedData'] != null)
                .map((e) => GptMessage.fromJson(
                    new Map<String, dynamic>.from(e['serializedData'])))
                .toList()
            : null,
        _createdAt = json['createdAt'] != null
            ? amplify_core.TemporalDateTime.fromString(json['createdAt'])
            : null,
        _updatedAt = json['updatedAt'] != null
            ? amplify_core.TemporalDateTime.fromString(json['updatedAt'])
            : null;

  Map<String, dynamic> toJson() => {
        'id': id,
        'subject': _subject,
        'original': _original,
        'modified': _modified,
        'gptMessages':
            _gptMessages?.map((GptMessage? e) => e?.toJson()).toList(),
        'createdAt': _createdAt?.format(),
        'updatedAt': _updatedAt?.format()
      };

  Map<String, Object?> toMap() => {
        'id': id,
        'subject': _subject,
        'original': _original,
        'modified': _modified,
        'gptMessages': _gptMessages,
        'createdAt': _createdAt,
        'updatedAt': _updatedAt
      };

  static final amplify_core.QueryModelIdentifier<GptSessionModelIdentifier>
      MODEL_IDENTIFIER =
      amplify_core.QueryModelIdentifier<GptSessionModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final SUBJECT = amplify_core.QueryField(fieldName: "subject");
  static final ORIGINAL = amplify_core.QueryField(fieldName: "original");
  static final MODIFIED = amplify_core.QueryField(fieldName: "modified");
  static final GPTMESSAGES = amplify_core.QueryField(
      fieldName: "gptMessages",
      fieldType: amplify_core.ModelFieldType(
          amplify_core.ModelFieldTypeEnum.model,
          ofModelName: 'GptMessage'));
  static final CREATEDAT = amplify_core.QueryField(fieldName: "createdAt");
  static final UPDATEDAT = amplify_core.QueryField(fieldName: "updatedAt");
  static var schema = amplify_core.Model.defineSchema(
      define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "GptSession";
    modelSchemaDefinition.pluralName = "GptSessions";

    modelSchemaDefinition.authRules = [
      amplify_core.AuthRule(
          authStrategy: amplify_core.AuthStrategy.OWNER,
          ownerField: "owner",
          identityClaim: "cognito:username",
          provider: amplify_core.AuthRuleProvider.USERPOOLS,
          operations: const [
            amplify_core.ModelOperation.CREATE,
            amplify_core.ModelOperation.UPDATE,
            amplify_core.ModelOperation.DELETE,
            amplify_core.ModelOperation.READ
          ])
    ];

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.id());

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: GptSession.SUBJECT,
        isRequired: false,
        ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.string)));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: GptSession.ORIGINAL,
        isRequired: false,
        ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.string)));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: GptSession.MODIFIED,
        isRequired: false,
        ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.string)));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.hasMany(
        key: GptSession.GPTMESSAGES,
        isRequired: false,
        ofModelName: 'GptMessage',
        associatedKey: GptMessage.GPTSESSION));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: GptSession.CREATEDAT,
        isRequired: false,
        ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.dateTime)));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: GptSession.UPDATEDAT,
        isRequired: false,
        ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.dateTime)));
  });
}

class _GptSessionModelType extends amplify_core.ModelType<GptSession> {
  const _GptSessionModelType();

  @override
  GptSession fromJson(Map<String, dynamic> jsonData) {
    return GptSession.fromJson(jsonData);
  }

  @override
  String modelName() {
    return 'GptSession';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [GptSession] in your schema.
 */
class GptSessionModelIdentifier
    implements amplify_core.ModelIdentifier<GptSession> {
  final String id;

  /** Create an instance of GptSessionModelIdentifier using [id] the primary key. */
  const GptSessionModelIdentifier({required this.id});

  @override
  Map<String, dynamic> serializeAsMap() => (<String, dynamic>{'id': id});

  @override
  List<Map<String, dynamic>> serializeAsList() => serializeAsMap()
      .entries
      .map((entry) => (<String, dynamic>{entry.key: entry.value}))
      .toList();

  @override
  String serializeAsString() => serializeAsMap().values.join('#');

  @override
  String toString() => 'GptSessionModelIdentifier(id: $id)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is GptSessionModelIdentifier && id == other.id;
  }

  @override
  int get hashCode => id.hashCode;
}
