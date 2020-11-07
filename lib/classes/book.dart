import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:weiman/crawler/http.dart';
import 'data.dart';
class Book {
  final String http;
  final String aid; // 漫画的数据库ID
  final String name; // 书本名称
  final String avatar; // 书本封面
  final String author; // 画家
  final String description; // 描述
  final List<Chapter> chapters;
  final int chapterCount;
  final int version;

  History history;

  Book({
    @required this.http,
    @required this.name,
    @required this.aid,
    @required this.avatar,
    this.author,
    this.description,
    this.chapters: const [],
    this.chapterCount: 0,
    this.history,
    this.version: 0,
  });

  @override
  String toString() {
    return jsonEncode(toJson());
  }

  bool isFavorite() {
    var books = Data.getFavorites();
    return books.containsKey(aid);
  }

  Map<String, dynamic> toJson() {
    print('book toJson');
    final Map<String, dynamic> data = {
      'http': http,
      'aid': aid,
      'name': name,
      'avatar': avatar,
      'author': author,
      'chapterCount': chapterCount,
      'version': version,
    };
    if (history != null) data['history'] = history.toJson();
    return data;
  }

  factory Book.fromJson(Map<String, dynamic> json) {
    final book = Book(
        http: json['http'],
        aid: json['aid'],
        name: json['name'],
        avatar: json['avatar'],
        author: json['author'],
        description: json['description'],
        chapterCount: json['chapterCount'] ?? 0,
        version: json['version'] ?? 0);
    if (json.containsKey('history'))
      book.history = History.fromJson(json['history']);
    return book;
  }
}

class Chapter {
  final HttpBook http;
  final String cid; // 章节cid
  final String cname; // 章节名称
  final String avatar; // 章节封面

  Chapter({
    @required this.http,
    @required this.cid,
    @required this.cname,
    @required this.avatar,
  });

  @override
  String toString() {
    final Map<String, String> data = {
      'cid': cid,
      'cname': cname,
      'avatar': avatar,
    };
    return jsonEncode(data);
  }
}

class History {
  final String cid;
  final String cname;
  final int time;
  final int image;

  History({
    @required this.cid,
    @required this.cname,
    @required this.time,
    this.image = 0,
  });

  @override
  String toString() => jsonEncode(toJson());

  Map<String, dynamic> toJson() {
    return {
      'cid': cid,
      'cname': cname,
      'time': time,
      'image': image,
    };
  }

  static History fromJson(Map<String, dynamic> json) {
    return History(
      cid: json['cid'],
      cname: json['cname'],
      time: json['time'],
      image: json['image'] ?? 0,
    );
  }

  static History fromChapter(Chapter chapter) {
    return History(
      cid: chapter.cid,
      cname: chapter.cname,
      time: DateTime.now().millisecondsSinceEpoch,
    );
  }
}
