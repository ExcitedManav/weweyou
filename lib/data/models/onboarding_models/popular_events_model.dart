class CreatedEventListModel {
  bool? status;
  CreatedEventListRecord? record;

  CreatedEventListModel({this.status, this.record});

  CreatedEventListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    record = json['record'] != null
        ? CreatedEventListRecord.fromJson(json['record'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (record != null) {
      data['record'] = record!.toJson();
    }
    return data;
  }
}

class CreatedEventListRecord {
  List<CreatedAllEvent>? allEvent;
  int? currentPage, lastPage, totalRecord, perPage;

  CreatedEventListRecord({
    this.allEvent,
    this.currentPage,
    this.lastPage,
    this.totalRecord,
    this.perPage,
  });

  CreatedEventListRecord.fromJson(Map<String, dynamic> json) {
    if (json['all_event'] != null) {
      allEvent = <CreatedAllEvent>[];
      json['all_event'].forEach((v) {
        allEvent!.add(CreatedAllEvent.fromJson(v));
      });
    }
    currentPage = json['currentPage'];
    lastPage = json['last_page'];
    totalRecord = json['total_record'];
    perPage = json['per_page'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (allEvent != null) {
      data['all_event'] = allEvent!.map((v) => v.toJson()).toList();
    }
    data['currentPage'] = currentPage;
    data['last_page'] = lastPage;
    data['total_record'] = totalRecord;
    data['per_page'] = perPage;
    return data;
  }
}

class CreatedAllEvent {
  int? eventId;
  String? eventTitle,
      userId,
      eventService,
      description,
      endDate,
      startDate,
      startTime,
      endTime,
      ticketCount,
      eventImage,
      location,
      ticketSaleOption;

  CreatedAllEvent({
    this.eventId,
    this.eventTitle,
    this.userId,
    this.eventService,
    this.description,
    this.endDate,
    this.startDate,
    this.startTime,
    this.endTime,
    this.eventImage,
    this.location,this.ticketCount,
    this.ticketSaleOption,
  });

  factory CreatedAllEvent.fromJson(Map<String, dynamic> json) {
    return CreatedAllEvent(
      eventId: json['id'],
      eventTitle: json['event_title'],
      userId: json['user_id'],
      eventService: json['event_service_id'],
      description: json['description'],
      endDate: json['end_date'],
      startDate: json['start_date'],
      startTime: json['start_time'],
      endTime: json['end_time'],
      eventImage: json['image'],
      location: json['location'],
      ticketSaleOption: json['ticket_sale_options_id'],
      ticketCount: json['quantity'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = eventId;
    data['event_title'] = eventTitle;
    data['user_id'] = userId;
    data['description'] = description;
    data['end_date'] = endDate;
    data['start_date'] = startDate;
    data['start_time'] = startTime;
    data['end_time'] = endTime;
    data['location'] = location;
    data['ticket_sale_options_id'] = ticketSaleOption;
    data['quantity'] = ticketCount;

    return data;
  }
}

class PopularEventModel {
  bool? status;
  List<Record>? record;

  PopularEventModel({this.status, this.record});

  PopularEventModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['record'] != null) {
      record = <Record>[];
      json['record'].forEach((v) {
        record!.add(Record.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (record != null) {
      data['record'] = record!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Record {
  int? eventId;
  String? eventTitle,
      userId,
      eventService,
      description,
      endDate,
      startDate,
      startTime,
      endTime,
      eventImage,
      location,
      ticketSaleOption;

  Record({
    this.eventId,
    this.eventTitle,
    this.userId,
    this.eventService,
    this.description,
    this.endDate,
    this.startDate,
    this.startTime,
    this.endTime,
    this.eventImage,
    this.location,
    this.ticketSaleOption,
  });

  factory Record.fromJson(Map<String, dynamic> json) {
    return Record(
      eventId: json['id'],
      eventTitle: json['event_title'],
      userId: json['user_id'],
      eventService: json['event_service_id'],
      description: json['description'],
      endDate: json['end_date'],
      startDate: json['start_date'],
      startTime: json['start_time'],
      endTime: json['end_time'],
      eventImage: json['image'],
      location: json['location'],
      ticketSaleOption: json['ticket_sale_options_id'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = eventId;
    data['event_title'] = eventTitle;
    data['user_id'] = userId;
    data['description'] = description;
    data['end_date'] = endDate;
    data['start_date'] = startDate;
    data['start_time'] = startTime;
    data['end_time'] = endTime;
    data['location'] = location;
    data['ticket_sale_options_id'] = ticketSaleOption;

    return data;
  }
}
