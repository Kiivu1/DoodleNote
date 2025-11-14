
class TabItem{
  String title;
  String body;

  TabItem({required this.title, required this.body});


  copyWith({String? title, String? body}){
    return TabItem(
      title: title ?? this.title,
      body: body ?? this.body,
    );
  }

  Map<String, dynamic> toJson(){
    return {
      'title': title,
      'body': body,
    };
  }

  factory TabItem.fromJson(Map<String, dynamic> json){
    return TabItem(
      title: json['title'],
      body: json['body'],
    );
  }
}
