class Data_News {
  int iD;
  String title;
  String content;
  Null videoLink;
  Null videoID;
  String createdBy;
  String createdDate;
  Null modifiedDate;
  String thumbnail;
  int views;
  Null videoTitle;
  Null videoThumbnail;
  Null videoInfo;
  Null modifiedBy;

  Data_News(
      {this.iD,
      this.title,
      this.content,
      this.videoLink,
      this.videoID,
      this.createdBy,
      this.createdDate,
      this.modifiedDate,
      this.thumbnail,
      this.views,
      this.videoTitle,
      this.videoThumbnail,
      this.videoInfo,
      this.modifiedBy});

  Data_News.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    title = json['Title'];
    content = json['Content'];
    videoLink = json['VideoLink'];
    videoID = json['VideoID'];
    createdBy = json['CreatedBy'];
    createdDate = json['CreatedDate'];
    modifiedDate = json['ModifiedDate'];
    thumbnail = json['Thumbnail'];
    views = json['Views'];
    videoTitle = json['VideoTitle'];
    videoThumbnail = json['VideoThumbnail'];
    videoInfo = json['VideoInfo'];
    modifiedBy = json['ModifiedBy'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['Title'] = this.title;
    data['Content'] = this.content;
    data['VideoLink'] = this.videoLink;
    data['VideoID'] = this.videoID;
    data['CreatedBy'] = this.createdBy;
    data['CreatedDate'] = this.createdDate;
    data['ModifiedDate'] = this.modifiedDate;
    data['Thumbnail'] = this.thumbnail;
    data['Views'] = this.views;
    data['VideoTitle'] = this.videoTitle;
    data['VideoThumbnail'] = this.videoThumbnail;
    data['VideoInfo'] = this.videoInfo;
    data['ModifiedBy'] = this.modifiedBy;
    return data;
  }
}
