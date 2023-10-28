import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  String id;
  String text;
  String bgrImage;
  String drId;
  String drName;
  String drAvatar;
  String drSpeciality;
  int likeCount;
  Timestamp createdAt;

  PostModel({
    this.id,
    this.text,
    this.bgrImage,
    this.drId,
    this.drName,
    this.drAvatar,
    this.drSpeciality,
    this.likeCount,
    this.createdAt,
  });

  factory PostModel.fromDocument(DocumentSnapshot doc) {
    return PostModel(
      id: doc['id'],
      text: doc['text'],
      bgrImage: doc['bgr_image'],
      drId: doc['dr_id'],
      drName: doc['dr_name'],
      drAvatar: doc['dr_avatar'],
      drSpeciality: doc['dr_speciality'],
      likeCount: doc['like_count'],
      createdAt: doc['created_at'],
    );
  }
  Map<String, dynamic> convertUser(PostModel post) {
    Map<String, dynamic> map = {};
    map['id'] = post.id;
    map['text'] = post.text;
    map['bgr_image'] = post.bgrImage;
    map['dr_id'] = post.drId;
    map['dr_name'] = post.drName;
    map['dr_avatar'] = post.drAvatar;
    map['dr_speciality'] = post.drSpeciality;
    map['like_count'] = post.likeCount;
    map['created_at'] = post.createdAt;

    return map;
  }

  Map<String, dynamic> toJson(PostModel post) => {
        'id': post.id,
        'text': post.text,
        'bgr_image': post.bgrImage,
        'dr_id': post.drId,
        'dr_name': post.drName,
        'dr_avatar': post.drAvatar,
        'dr_speciality': post.drSpeciality,
        'like_count': post.likeCount,
        'created_at': FieldValue.serverTimestamp(),
      };
}
