class TaskDTO {
  String taskName;
  int difficulty;
  String imageURL;

  TaskDTO(
      {required this.taskName,
      required this.difficulty,
      required this.imageURL});
}
