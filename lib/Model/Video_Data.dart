// @dart=2.9
class Video_Data {
  int iD;
  String title;
  String createdDate;
  String thumbnail;
  int views;
  String uploadDate;
  String tags;
  String youtubeLink;
  String videoLink;
  String videoInfo;
  String uploader;

  Video_Data(
      {this.iD,
      this.title,
      this.createdDate,
      this.thumbnail,
      this.views,
      this.uploadDate,
      this.tags,
      this.youtubeLink,
      this.videoLink,
      this.videoInfo,
      this.uploader});

  Video_Data.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    title = json['Title'];
    createdDate = json['CreatedDate'];
    thumbnail = json['Thumbnail'];
    views = json['Views'];
    uploadDate = json['UploadDate'];
    tags = json['Tags'];
    youtubeLink = json['YoutubeLink'];
    videoLink = json['VideoLink'];
    videoInfo = json['VideoInfo'];
    uploader = json['Uploader'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['Title'] = this.title;
    data['CreatedDate'] = this.createdDate;
    data['Thumbnail'] = this.thumbnail;
    data['Views'] = this.views;
    data['UploadDate'] = this.uploadDate;
    data['Tags'] = this.tags;
    data['YoutubeLink'] = this.youtubeLink;
    data['VideoLink'] = this.videoLink;
    data['VideoInfo'] = this.videoInfo;
    data['Uploader'] = this.uploader;
    return data;
  }
}
