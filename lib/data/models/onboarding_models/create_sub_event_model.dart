class CreateSubEventModel {
  bool? status;
  int? statusCode;
  String? message;
  SubEventRecord? subEventRecord;

  CreateSubEventModel({this.status, this.statusCode, this.subEventRecord});

  CreateSubEventModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    statusCode = json['success'];
    message = json['message'];
    subEventRecord =
        json['record'] != null ? SubEventRecord.fromJson(json['record']) : null;
  }
}

class SubEventRecord {
  int? userId, categoryId, ticketTypeId, subEventId;
  String? eventTitle,
      slug,
      eventId,
      location,
      startDate,
      startTime,
      endDate,
      endTime,
      description,
      quantity,
      isPrivate;

  SubEventRecord({
    this.userId,
    this.categoryId,
    this.ticketTypeId,
    this.subEventId,
    this.eventTitle,
    this.slug,
    this.eventId,
    this.location,
    this.startDate,
    this.startTime,
    this.endDate,
    this.endTime,
    this.description,
    this.quantity,
    this.isPrivate,
  });

  SubEventRecord.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    eventTitle = json['event_title'];
    slug = json['slug'];
    categoryId = json['category_id'];
    eventId = json['event_id'];
    location = json['location'];
    startDate = json['start_data'];
    startTime = json['start_time'];
    endDate = json['end_data'];
    endTime = json['end_time'];
    description = json['description'];
    ticketTypeId = json['ticket_type_id'];
    quantity = json['qty'];
    isPrivate = json['is_private'];
    subEventId = json['id'];
  }
}
