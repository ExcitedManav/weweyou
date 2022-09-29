class ItineraryListModel {
  int? statusCode;
  bool? status;
  List<ItineraryRecordList>? itineraryRecord;

  ItineraryListModel({this.statusCode, this.status, this.itineraryRecord});

  ItineraryListModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['status'];
    status = json['success'];
    if (json['record'] != null) {
      itineraryRecord = <ItineraryRecordList>[];
      itineraryRecord = json["record"]
          .map<ItineraryRecordList>((e) => ItineraryRecordList.fromJson(e))
          .toList();
    }
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> _data = <String, dynamic>{};
    _data['status'] = statusCode;
    _data['success'] = status;
    if (_data['record'] != null) {
      _data['record'] = itineraryRecord!.map((v) => v.toJson()).toList();
    }
    return _data;
  }
}

class ItineraryRecordList {
  int? itineraryId;
  String? catId,
      userId,
      mainDate,
      image,
      title,
      description,
      startDate,
      endDate,
      location;

  ItineraryRecordList({
    this.itineraryId,
    this.catId,
    this.userId,
    this.mainDate,
    this.image,
    this.title,
    this.description,
    this.startDate,
    this.endDate,
    this.location,
  });

  ItineraryRecordList.fromJson(Map<String, dynamic> json) {
    itineraryId = json['id'];
    catId = json['category_id'];
    userId = json['user_id'];
    mainDate = json['date'];
    image = json['image'];
    title = json['title'];
    description = json['description'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    location = json['location'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data['id'] = itineraryId;
    _data['category_id'] = catId;
    _data['user_id'] = userId;
    _data['date'] = mainDate;
    _data['image'] = image;
    _data['title'] = title;
    _data['description'] = description;
    _data['start_date'] = startDate;
    _data['end_date'] = endDate;
    _data['location'] = location;
    return _data;
  }
}


