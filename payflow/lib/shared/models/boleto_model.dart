import 'dart:convert';

class BoletoModel {
  final String? name;
  final String? dueDate;
  final double? value;
  final String? barcode;
  BoletoModel({
    this.name,
    this.dueDate,
    this.value,
    this.barcode,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'dueDate': dueDate,
      'value': value,
      'barcode': barcode,
    };
  }

  factory BoletoModel.fromMap(Map<String, dynamic> map) {
    return BoletoModel(
      name: map['name'],
      dueDate: map['dueDate'],
      value: map['value'],
      barcode: map['barcode'],
    );
  }

  String toJson() => json.encode(toMap());

  factory BoletoModel.fromJson(String source) =>
      BoletoModel.fromMap(json.decode(source));
  
  //se o parameto que passa for nulo
  //ele deixa com o valor anterior
  BoletoModel copyWith({
    String? name,
    String? dueDate,
    double? value,
    String? barcode,
  }) {
    return BoletoModel(
      name: name ?? this.name,
      dueDate: dueDate ?? this.dueDate,
      value: value ?? this.value,
      barcode: barcode ?? this.barcode,
    );
  }

  @override
  String toString() {
    return 'BoletoModel(name: $name, dueDate: $dueDate, value: $value, barcode: $barcode)';
  }
  
  //hascode e operator
  //serve pra verificar o hash do dado
  //verifica se um elemento é igual ao outro
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is BoletoModel &&
      other.name == name &&
      other.dueDate == dueDate &&
      other.value == value &&
      other.barcode == barcode;
  }

  @override
  int get hashCode {
    return name.hashCode ^
      dueDate.hashCode ^
      value.hashCode ^
      barcode.hashCode;
  }
}
