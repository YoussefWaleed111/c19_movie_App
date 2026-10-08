import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/cast_entity.dart';

part 'cast_model.g.dart';

@JsonSerializable()
class CastModel {
  final String? name;
  @JsonKey(name: 'character_name')
  final String? characterName;
  @JsonKey(name: 'url_small_image')
  final String? urlSmallImage;

  const CastModel({
    this.name,
    this.characterName,
    this.urlSmallImage,
  });

  factory CastModel.fromJson(Map<String, dynamic> json) =>
      _$CastModelFromJson(json);

  Map<String, dynamic> toJson() => _$CastModelToJson(this);

  CastEntity toEntity() {
    return CastEntity(
      name: name ?? '',
      characterName: characterName ?? '',
      urlSmallImage: urlSmallImage ?? '',
    );
  }
}
