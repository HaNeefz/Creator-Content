import 'package:flutter/material.dart';

class ModelData {
  late List<KeepData>? data;

  ModelData({this.data});

  ModelData.fromJson(Map<String, dynamic> json) {
    if (json['Data'] != null) {
      data = <KeepData>[];
      json['Data'].forEach((v) {
        data?.add(new KeepData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Data'] = this.data?.map((v) => v.toJson()).toList();

    return data;
  }
}

class KeepData {
  late String id;
  late String type;
  late dynamic rawData;
  late dynamic data;
  late String createDate;
  Styles? styles;

  KeepData({
    required this.id,
    required this.type,
    required this.rawData,
    required this.data,
    required this.createDate,
    this.styles,
  });

  KeepData.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    type = json['Type'];
    rawData = json['RawData'];
    data = json['Data'];
    createDate = json['CreateDate'];
    styles =
        json['Styles'] != null ? new Styles.fromJson(json['Styles']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.id;
    data['Type'] = this.type;
    data['RawData'] = this.rawData.toString();
    data['Data'] = this.data;
    data['CreateDate'] = this.createDate;
    if (this.styles != null) {
      data['Styles'] = this.styles?.toJson();
    }
    return data;
  }
}

class Styles {
  late bool bold;
  late bool italic;
  late bool large;
  late bool underline;
  Color? color;

  Styles(
      {this.bold = false,
      this.italic = false,
      this.large = false,
      this.underline = false,
      this.color});

  Styles.fromJson(Map<String, dynamic> json) {
    bold = json['Bold'] ?? false;
    italic = json['Italic'] ?? false;
    large = json['Large'] ?? false;
    underline = json['Underline'] ?? false;
    if (json['Color'].toString().contains('0x'))
      color = json['Color'];
    else {
      int _color = int.parse("0x${json['Color']}");
      color = Color(_color);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Bold'] = this.bold;
    data['Italic'] = this.italic;
    data['Large'] = this.large;
    data['Underline'] = this.underline;
    if (data['Color'].toString().contains("0x"))
      data['Color'] = "${this.color!.value.toRadixString(16)}";
    else
      data['Color'] = "0x${this.color!.value.toRadixString(16)}";
    return data;
  }
}
