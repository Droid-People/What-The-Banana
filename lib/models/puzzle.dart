import 'package:json_annotation/json_annotation.dart';

part 'puzzle.g.dart';

@JsonSerializable()
class Puzzle {
  Puzzle({
    required this.title,
    required this.imageUrl,
    required this.description,
    required this.difficulty,
    required this.id,
  });

  factory Puzzle.fromJson(Map<String, dynamic> json) => _$PuzzleFromJson(json);
  Map<String, dynamic> toJson() => _$PuzzleToJson(this);

  final String title;
  final String imageUrl;
  final String description;
  final String difficulty;
  final String id;
}
