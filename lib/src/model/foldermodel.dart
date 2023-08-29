class FolderModel {
  final String? id;
  final String folder;

  const FolderModel({
    this.id,
    required this.folder,
  });

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "folder": folder,
    };
  }
}
