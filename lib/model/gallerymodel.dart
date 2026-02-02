class GalleryAlbumModel {
  final String id;
  final String title;
  final String coverImage;
  final DateTime dateCreated;

  GalleryAlbumModel({
    required this.id,
    required this.title,
    required this.coverImage,
    required this.dateCreated,
  });

  factory GalleryAlbumModel.fromJson(Map<String, dynamic> json) {
    return GalleryAlbumModel(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? '',
      coverImage: json['cover_image'] ?? '',
      dateCreated: DateTime.parse(json['date_created']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'cover_image': coverImage,
      'date_created': dateCreated.toIso8601String(),
    };
  }
}




class GalleryImageModel {
  final String id;
  final String albumId;
  final String image;
  final DateTime dateUploaded;

  GalleryImageModel({
    required this.id,
    required this.albumId,
    required this.image,
    required this.dateUploaded,
  });

  factory GalleryImageModel.fromJson(Map<String, dynamic> json) {
    return GalleryImageModel(
      id: json['id']?.toString() ?? '',
      albumId: json['album_id']?.toString() ?? '',
      image: json['image'] ?? '',
      dateUploaded: DateTime.parse(json['date_uploaded']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'album_id': albumId,
      'image': image,
      'date_uploaded': dateUploaded.toIso8601String(),
    };
  }
}
