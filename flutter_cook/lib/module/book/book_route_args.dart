class BookDetailArguments {
  final int sceneId;
  final String title;

  BookDetailArguments({required this.sceneId, required this.title});

  factory BookDetailArguments.fromMap(Map<String, dynamic>? map) {
    return BookDetailArguments(
      sceneId: int.tryParse('${map?['scene_id']}') ?? 0,
      title: map?['title']?.toString() ?? '',
    );
  }

  bool get isValid => sceneId > 0;
}
