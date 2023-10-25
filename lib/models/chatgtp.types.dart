class Message {
  final String role;
  final String content;
  final String id = "${DateTime.now().millisecondsSinceEpoch}";
  final Map<String, dynamic>? functionCall;

  Message({required this.role, required this.content, this.functionCall});

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        role: json["role"] ?? "",
        content: json["content"] ?? "",
        functionCall: json["function_call"],
      );

  Map<String, dynamic> toJson() => {
        "role": role,
        "content": content,
        "function_call": functionCall,
      };
}

class ChatResponseSSE {
  final String id;
  final String object;
  final int? created;
  final List<ChatChoiceSSE>? choices;
  final Usage? usage;
  final String? model;
  String conversionId = "${DateTime.now().millisecondsSinceEpoch}";

  ChatResponseSSE({
    required this.id,
    required this.object,
    required this.created,
    required this.choices,
    required this.usage,
    this.model,
  });

  factory ChatResponseSSE.fromJson(Map<String, dynamic> json) =>
      ChatResponseSSE(
        id: json["id"],
        object: json["object"],
        created: json["created"],
        model: json["model"],
        choices: (json["choices"] == null)
            ? null
            : (json["choices"] as List)
                .map((e) => ChatChoiceSSE.fromJson(e))
                .toList(),
        usage: json["usage"] == null ? null : Usage.fromJson(json["usage"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "object": object,
        "created": created,
        "choices": choices?.map((e) => e.toJson()).toList(),
        "usage": usage?.toJson(),
        "model": model,
      };
}

class ChatChoiceSSE {
  final String id = "${DateTime.now().millisecondsSinceEpoch}";
  final int index;
  final Message? message;
  final String? finishReason;

  ChatChoiceSSE({
    required this.index,
    required this.message,
    this.finishReason,
  });

  factory ChatChoiceSSE.fromJson(Map<String, dynamic> json) => ChatChoiceSSE(
        index: json["index"],
        message: json["delta"] == null ? null : Message.fromJson(json["delta"]),
        finishReason:
            json["finish_reason"] == null ? "" : json["finish_reason"],
      );

  Map<String, dynamic> toJson() => {
        "index": index,
        "delta": message?.toJson(),
        "finish_reason": finishReason ?? "",
      };
}

class Usage {
  final int? promptTokens;
  final int? completionTokens;
  final int? totalTokens;
  final String id = "${DateTime.now().millisecondsSinceEpoch}";

  Usage(this.promptTokens, this.completionTokens, this.totalTokens);

  factory Usage.fromJson(Map<String, dynamic> json) => Usage(
        json['prompt_tokens'],
        json['completion_tokens'],
        json['total_tokens'],
      );
  Map<String, dynamic> toJson() => usageToJson(this);

  Map<String, dynamic> usageToJson(Usage instance) => <String, dynamic>{
        'prompt_tokens': instance.promptTokens,
        'completion_tokens': instance.completionTokens,
        'total_tokens': instance.totalTokens,
      };
}
