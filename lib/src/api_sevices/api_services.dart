// To parse this JSON data, do
//
//     final fileList = fileListFromJson(jsonString);

import 'dart:convert';

List<FileList> fileListFromJson(String str) => List<FileList>.from(json.decode(str).map((x) => FileList.fromJson(x)));

String fileListToJson(List<FileList> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class FileList {
  String? tittle;
  String? description;
  String? url;
  DateTime? date;
  String? user;
  String? folder;

  FileList({
    this.tittle,
    this.description,
    this.url,
    this.date,
    this.user,
    this.folder,
  });

  factory FileList.fromJson(Map<String, dynamic> json) => FileList(
    tittle: json["tittle"],
    description: json["description"],
    url: json["url"],
    date: json["date"] == null ? null : DateTime.parse(json["date"]),
    user: json["user"],
    folder: json["folder"],
  );

  Map<String, dynamic> toJson() => {
    "tittle": tittle,
    "description": description,
    "url": url,
    "date": date?.toIso8601String(),
    "user": user,
    "folder": folder,
  };
}
