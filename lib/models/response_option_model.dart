import 'package:equatable/equatable.dart';

/// Model for generic response options that can replace yes/no buttons
class ResponseOptionModel extends Equatable {
  final String id;
  final String label;
  final String value;
  final bool isSelected;

  const ResponseOptionModel({
    required this.id,
    required this.label,
    required this.value,
    this.isSelected = false,
  });

  factory ResponseOptionModel.create({
    required String label,
    String? value,
  }) {
    return ResponseOptionModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      label: label,
      value: value ?? label,
    );
  }

  factory ResponseOptionModel.fromJson(Map<String, dynamic> json) {
    return ResponseOptionModel(
      id: json['id'] as String,
      label: json['label'] as String,
      value: json['value'] as String,
      isSelected: json['isSelected'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'label': label,
      'value': value,
      'isSelected': isSelected,
    };
  }

  ResponseOptionModel copyWith({
    String? id,
    String? label,
    String? value,
    bool? isSelected,
  }) {
    return ResponseOptionModel(
      id: id ?? this.id,
      label: label ?? this.label,
      value: value ?? this.value,
      isSelected: isSelected ?? this.isSelected,
    );
  }

  @override
  List<Object?> get props => [id, label, value, isSelected];
}
