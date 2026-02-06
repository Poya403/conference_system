enum CommentTargetType{
    course,
    hall,
}

extension TargetTypeExtention on CommentTargetType {
  String get title {
    switch(this){
      case CommentTargetType.course: return 'Course';
      case CommentTargetType.hall: return 'Hall';
    }
  }
}