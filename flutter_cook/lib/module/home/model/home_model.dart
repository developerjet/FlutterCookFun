import 'package:flutter/material.dart';

class HomeDataModel {
  List<HomeFoodListData> data = [];

  HomeDataModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <HomeFoodListData>[];
      json['data'].forEach((v) {
        data.add(HomeFoodListData.fromJson(v));
      });
    }
  }
}

class HomeFoodListData {
  String? image;
  String? id;
  String? text;
  int? type;
  int? orderNo;
  int? tagIsselfdefine;
  List<FoodSubData>? data;

  HomeFoodListData({
    this.image,
    this.id,
    this.text,
    this.type,
    this.orderNo,
    this.tagIsselfdefine,
    this.data,
  });

  HomeFoodListData.fromJson(Map<String, dynamic> json) {
    image = json['image'];
    id = json['id'];
    text = json['text'];
    type = json['type'];
    orderNo = json['order_no'];
    tagIsselfdefine = json['tag_isselfdefine'];
    if (json['data'] != null) {
      data = <FoodSubData>[];
      json['data'].forEach((v) {
        data!.add(new FoodSubData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['image'] = this.image;
    data['id'] = this.id;
    data['text'] = this.text;
    data['type'] = this.type;
    data['order_no'] = this.orderNo;
    data['tag_isselfdefine'] = this.tagIsselfdefine;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class FoodSubData {
  String? id;
  String? text;
  int? tagIsselfdefine;
  int? type;
  int? orderNo;
  String? image;

  FoodSubData(
      {this.id,
      this.text,
      this.tagIsselfdefine,
      this.type,
      this.orderNo,
      this.image});

  FoodSubData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    text = json['text'];
    tagIsselfdefine = json['tag_isselfdefine'];
    type = json['type'];
    orderNo = json['order_no'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['text'] = this.text;
    data['tag_isselfdefine'] = this.tagIsselfdefine;
    data['type'] = this.type;
    data['order_no'] = this.orderNo;
    data['image'] = this.image;
    return data;
  }
}
