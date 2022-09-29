import 'package:flutter/material.dart';

@immutable
class ResponseC {
  final bool isSuccessFul;
  final String message;

  const ResponseC(this.isSuccessFul, this.message);

  factory ResponseC.fromJson(Map<String, dynamic> json){
    final s = json['success'] as bool;
    final m = json['message'] as String;
    return ResponseC(s, m);
  }
}
