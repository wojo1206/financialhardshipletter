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


/** This is an auto generated class representing the GptMessage type in your schema. */
class GptMessage extends amplify_core.Model {
  static const classType = const _GptMessageModelType();
  final String id;
  final String? _chunk;
  final int? _createdAtTimestamp;
  final GptSession? _gptSession;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;
  
  @Deprecated('[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;
  
  GptMessageModelIdentifier get modelIdentifier {
      return GptMessageModelIdentifier(
        id: id
      );
  }
  
  String get chunk {
    try {
      return _chunk!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  int get createdAtTimestamp {
    try {
      return _createdAtTimestamp!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  GptSession? get gptSession {
    return _gptSession;
  }
  
  amplify_core.TemporalDateTime? get createdAt {
    return _createdAt;
  }
  
  amplify_core.TemporalDateTime? get updatedAt {
    return _updatedAt;
  }
  
  const GptMessage._internal({required this.id, required chunk, required createdAtTimestamp, gptSession, createdAt, updatedAt}): _chunk = chunk, _createdAtTimestamp = createdAtTimestamp, _gptSession = gptSession, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory GptMessage({String? id, required String chunk, required int createdAtTimestamp, GptSession? gptSession}) {
    return GptMessage._internal(
      id: id == null ? amplify_core.UUID.getUUID() : id,
      chunk: chunk,
      createdAtTimestamp: createdAtTimestamp,
      gptSession: gptSession);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GptMessage &&
      id == other.id &&
      _chunk == other._chunk &&
      _createdAtTimestamp == other._createdAtTimestamp &&
      _gptSession == other._gptSession;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("GptMessage {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("chunk=" + "$_chunk" + ", ");
    buffer.write("createdAtTimestamp=" + (_createdAtTimestamp != null ? _createdAtTimestamp!.toString() : "null") + ", ");
    buffer.write("gptSession=" + (_gptSession != null ? _gptSession!.toString() : "null") + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  GptMessage copyWith({String? chunk, int? createdAtTimestamp, GptSession? gptSession}) {
    return GptMessage._internal(
      id: id,
      chunk: chunk ?? this.chunk,
      createdAtTimestamp: createdAtTimestamp ?? this.createdAtTimestamp,
      gptSession: gptSession ?? this.gptSession);
  }
  
  GptMessage copyWithModelFieldValues({
    ModelFieldValue<String>? chunk,
    ModelFieldValue<int>? createdAtTimestamp,
    ModelFieldValue<GptSession?>? gptSession
  }) {
    return GptMessage._internal(
      id: id,
      chunk: chunk == null ? this.chunk : chunk.value,
      createdAtTimestamp: createdAtTimestamp == null ? this.createdAtTimestamp : createdAtTimestamp.value,
      gptSession: gptSession == null ? this.gptSession : gptSession.value
    );
  }
  
  GptMessage.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _chunk = json['chunk'],
      _createdAtTimestamp = (json['createdAtTimestamp'] as num?)?.toInt(),
      _gptSession = json['gptSession']?['serializedData'] != null
        ? GptSession.fromJson(new Map<String, dynamic>.from(json['gptSession']['serializedData']))
        : null,
      _createdAt = json['createdAt'] != null ? amplify_core.TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? amplify_core.TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'chunk': _chunk, 'createdAtTimestamp': _createdAtTimestamp, 'gptSession': _gptSession?.toJson(), 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };
  
  Map<String, Object?> toMap() => {
    'id': id,
    'chunk': _chunk,
    'createdAtTimestamp': _createdAtTimestamp,
    'gptSession': _gptSession,
    'createdAt': _createdAt,
    'updatedAt': _updatedAt
  };

  static final amplify_core.QueryModelIdentifier<GptMessageModelIdentifier> MODEL_IDENTIFIER = amplify_core.QueryModelIdentifier<GptMessageModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final CHUNK = amplify_core.QueryField(fieldName: "chunk");
  static final CREATEDATTIMESTAMP = amplify_core.QueryField(fieldName: "createdAtTimestamp");
  static final GPTSESSION = amplify_core.QueryField(
    fieldName: "gptSession",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'GptSession'));
  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "GptMessage";
    modelSchemaDefinition.pluralName = "GptMessages";
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.id());
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: GptMessage.CHUNK,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: GptMessage.CREATEDATTIMESTAMP,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.int)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.belongsTo(
      key: GptMessage.GPTSESSION,
      isRequired: false,
      targetNames: ['gptSessionGptMessagesId'],
      ofModelName: 'GptSession'
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
  });
}

class _GptMessageModelType extends amplify_core.ModelType<GptMessage> {
  const _GptMessageModelType();
  
  @override
  GptMessage fromJson(Map<String, dynamic> jsonData) {
    return GptMessage.fromJson(jsonData);
  }
  
  @override
  String modelName() {
    return 'GptMessage';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [GptMessage] in your schema.
 */
class GptMessageModelIdentifier implements amplify_core.ModelIdentifier<GptMessage> {
  final String id;

  /** Create an instance of GptMessageModelIdentifier using [id] the primary key. */
  const GptMessageModelIdentifier({
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
  String toString() => 'GptMessageModelIdentifier(id: $id)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    
    return other is GptMessageModelIdentifier &&
      id == other.id;
  }
  
  @override
  int get hashCode =>
    id.hashCode;
}