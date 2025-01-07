// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'puzzle.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Puzzle _$PuzzleFromJson(Map<String, dynamic> json) => Puzzle(
      title: json['title'] as String,
      imageUrl: json['imageUrl'] as String,
      description: json['description'] as String,
      difficulty: json['difficulty'] as String,
      id: json['id'] as String,
    );

Map<String, dynamic> _$PuzzleToJson(Puzzle instance) => <String, dynamic>{
      'title': instance.title,
      'imageUrl': instance.imageUrl,
      'description': instance.description,
      'difficulty': instance.difficulty,
      'id': instance.id,
    };
