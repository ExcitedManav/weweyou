class CreateEventModel {
  bool? status;
  String? message;
  Record? createEventData;

  CreateEventModel({this.status, this.message, this.createEventData});

  CreateEventModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    createEventData =
        json['record'] != null ? Record.fromJson(json['record']) : null;
  }
}

class Record {
  int? userId;
  int? eventId;
  Record({this.userId, this.eventId});
  factory Record.fromJson(Map<String, dynamic> json) {
    return Record(
      userId: json['user_id'],
      eventId: json['id'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data['user_id'] = userId;
    _data['id'] = eventId;
    return _data;
  }
}

class TicketTypeListModel {
  bool? status;
  List<TicketListData>? ticketListData = [];

  TicketTypeListModel({this.status, this.ticketListData});

  TicketTypeListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['record'] != null) {
      ticketListData = <TicketListData>[];
      ticketListData = json["record"]
          .map<TicketListData>((e) => TicketListData.fromJson(e))
          .toList();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (ticketListData != null) {
      data['record'] = ticketListData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TicketListData {
  int? id;
  String? name;

  TicketListData({this.id, this.name});

  TicketListData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}

class CoverImageModel {
  int? status;
  bool? success;
  List<CoverImageData>? coverImageData;

  CoverImageModel({this.status, this.success, this.coverImageData});

  CoverImageModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    success = json['success'];
    if (json['data'] != null) {
      coverImageData = <CoverImageData>[];
      coverImageData = json["data"]
          .map<CoverImageData>((e) => CoverImageData.fromJson(e))
          .toList();
    }
  }
}

class CoverImageData {
  int? id;
  String? imageUrl;

  CoverImageData({this.id, this.imageUrl});

  CoverImageData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    imageUrl = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data['id'] = id;
    _data['image'] = imageUrl;
    return _data;
  }
}
