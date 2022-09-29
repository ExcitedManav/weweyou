class CreatedEventDetailModel {
  int? status;
  bool? success;
  CreatedEventDetailRecord? record;

  CreatedEventDetailModel({this.status, this.success, this.record});

  CreatedEventDetailModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    success = json['success'];
    record = json['record'] != null ? CreatedEventDetailRecord.fromJson(json['record']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['success'] = success;
    if (record != null) {
      data['record'] = record!.toJson();
    }
    return data;
  }
}

class CreatedEventDetailRecord {
  int? id;
  String? eventTitle;
  String? eventStep;
  String? userId;
  String? eventServiceId;
  String? coverImgId;
  String? budgetType;
  String? category;
  String? city;
  String? country;
  String? currency;
  String? description;
  String? endDate;
  String? startDate;
  String? startTime;
  String? endTime;
  String? eventGroup;
  String? facebook;
  String? geoLocation;
  String? goLiveDate;
  String? goodDeal;
  String? grossSales;
  String? highestPrice;
  String? image;
  String? instagram;
  String? isConfidential;
  String? isFree;
  String? isOnline;
  String? isPrivate;
  String? itinerary;
  String? joinedParticipantsNumber;
  String? lastSaved;
  String? location;
  String? lowestPrice;
  String? name;
  String? netSales;
  String? notOfficialTickets;
  String? orders;
  String? organizer;
  String? qrCodeUrl;
  String? sameDay;
  String? showAttendeeCount;
  String? status;
  String? subEvents;
  String? summary;
  String? suspendPayments;
  String? tags;
  String? tagsString;
  String? tagsStringFr;
  String? ticketSaleOptionsId;
  String? ticketType;
  String? ticketTypesList;
  String? tickets;
  String? twitter;
  String? type;
  String? video;
  String? website;
  String? whatsapp;
  String? creator;
  String? modifiedDate;
  String? createdDate;
  String? slug;
  String? officialTickets;
  String? title;
  String? price;
  String? quantity;
  String? imageVideoStatus;
  CategoryImg? categoryImg;

  CreatedEventDetailRecord({
    this.id,
    this.eventTitle,
    this.eventStep,
    this.userId,
    this.eventServiceId,
    this.coverImgId,
    this.budgetType,
    this.category,
    this.city,
    this.country,
    this.currency,
    this.description,
    this.endDate,
    this.startDate,
    this.startTime,
    this.endTime,
    this.eventGroup,
    this.facebook,
    this.geoLocation,
    this.goLiveDate,
    this.goodDeal,
    this.grossSales,
    this.highestPrice,
    this.image,
    this.instagram,
    this.isConfidential,
    this.isFree,
    this.isOnline,
    this.isPrivate,
    this.itinerary,
    this.joinedParticipantsNumber,
    this.lastSaved,
    this.location,
    this.lowestPrice,
    this.name,
    this.netSales,
    this.notOfficialTickets,
    this.orders,
    this.organizer,
    this.qrCodeUrl,
    this.sameDay,
    this.showAttendeeCount,
    this.status,
    this.subEvents,
    this.summary,
    this.suspendPayments,
    this.tags,
    this.tagsString,
    this.tagsStringFr,
    this.ticketSaleOptionsId,
    this.ticketType,
    this.ticketTypesList,
    this.tickets,
    this.twitter,
    this.type,
    this.video,
    this.website,
    this.whatsapp,
    this.creator,
    this.modifiedDate,
    this.createdDate,
    this.slug,
    this.officialTickets,
    this.title,
    this.price,
    this.quantity,
    this.imageVideoStatus,
    this.categoryImg,
  });

  CreatedEventDetailRecord.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    eventTitle = json['event_title'];
    eventStep = json['event_step'];
    userId = json['user_id'];
    eventServiceId = json['event_service_id'];
    coverImgId = json['cover_img_id'];
    budgetType = json['budget_type'];
    category = json['category'];
    city = json['city'];
    country = json['country'];
    currency = json['currency'];
    description = json['description'];
    endDate = json['end_date'];
    startDate = json['start_date'];
    startTime = json['start_time'];
    endTime = json['end_time'];
    eventGroup = json['event_group'];
    facebook = json['facebook'];
    geoLocation = json['geo_location'];
    goLiveDate = json['go_live_date'];
    goodDeal = json['good_deal'];
    grossSales = json['gross_sales'];
    highestPrice = json['highest_price'];
    image = json['image'];
    instagram = json['instagram'];
    isConfidential = json['is_confidential'];
    isFree = json['is_free'];
    isOnline = json['is_online'];
    isPrivate = json['is_private'];
    itinerary = json['itinerary'];
    joinedParticipantsNumber = json['joined_participants_number'];
    lastSaved = json['last_saved'];
    location = json['location'];
    lowestPrice = json['lowest_price'];
    name = json['name'];
    netSales = json['net_sales'];
    notOfficialTickets = json['not_Official_tickets'];
    orders = json['orders'];
    organizer = json['organizer'];
    qrCodeUrl = json['qr_code_url'];
    sameDay = json['same_day'];
    showAttendeeCount = json['show_attendee_count'];
    status = json['status'];
    subEvents = json['Sub_events'];
    summary = json['summary'];
    suspendPayments = json['suspend_payments'];
    tags = json['tags'];
    tagsString = json['tags_string'];
    tagsStringFr = json['tags_string_fr'];
    ticketSaleOptionsId = json['ticket_sale_options_id'];
    ticketType = json['ticket_type'];
    ticketTypesList = json['Ticket_types-list'];
    tickets = json['tickets'];
    twitter = json['twitter'];
    type = json['type'];
    video = json['video'];
    website = json['website'];
    whatsapp = json['whatsapp'];
    creator = json['creator'];
    modifiedDate = json['modified_date'];
    createdDate = json['created_date'];
    slug = json['slug'];
    officialTickets = json['official_tickets'];
    title = json['title'];
    price = json['price'];
    quantity = json['quantity'];
    imageVideoStatus = json['image_video_status'];
    categoryImg = json['category_img'] != null
        ? CategoryImg.fromJson(json['category_img'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['event_title'] = eventTitle;
    data['event_step'] = eventStep;
    data['user_id'] = userId;
    data['event_service_id'] = eventServiceId;
    data['cover_img_id'] = coverImgId;
    data['budget_type'] = budgetType;
    data['category'] = category;
    data['city'] = city;
    data['country'] = country;
    data['currency'] = currency;
    data['description'] = description;
    data['end_date'] = endDate;
    data['start_date'] = startDate;
    data['start_time'] = startTime;
    data['end_time'] = endTime;
    data['event_group'] = eventGroup;
    data['facebook'] = facebook;
    data['geo_location'] = geoLocation;
    data['go_live_date'] = goLiveDate;
    data['good_deal'] = goodDeal;
    data['gross_sales'] = grossSales;
    data['highest_price'] = highestPrice;
    data['image'] = image;
    data['instagram'] = instagram;
    data['is_confidential'] = isConfidential;
    data['is_free'] = isFree;
    data['is_online'] = isOnline;
    data['is_private'] = isPrivate;
    data['itinerary'] = itinerary;
    data['joined_participants_number'] = joinedParticipantsNumber;
    data['last_saved'] = lastSaved;
    data['location'] = location;
    data['lowest_price'] = lowestPrice;
    data['name'] = name;
    data['net_sales'] = netSales;
    data['not_Official_tickets'] = notOfficialTickets;
    data['orders'] = orders;
    data['organizer'] = organizer;
    data['qr_code_url'] = qrCodeUrl;
    data['same_day'] = sameDay;
    data['show_attendee_count'] = showAttendeeCount;
    data['status'] = status;
    data['Sub_events'] = subEvents;
    data['summary'] = summary;
    data['suspend_payments'] = suspendPayments;
    data['tags'] = tags;
    data['tags_string'] = tagsString;
    data['tags_string_fr'] = tagsStringFr;
    data['ticket_sale_options_id'] = ticketSaleOptionsId;
    data['ticket_type'] = ticketType;
    data['Ticket_types-list'] = ticketTypesList;
    data['tickets'] = tickets;
    data['twitter'] = twitter;
    data['type'] = type;
    data['video'] = video;
    data['website'] = website;
    data['whatsapp'] = whatsapp;
    data['creator'] = creator;
    data['modified_date'] = modifiedDate;
    data['created_date'] = createdDate;
    data['slug'] = slug;
    data['official_tickets'] = officialTickets;
    data['title'] = title;
    data['price'] = price;
    data['quantity'] = quantity;
    data['image_video_status'] = imageVideoStatus;
    if (categoryImg != null) {
      data['category_img'] = categoryImg!.toJson();
    }
    return data;
  }
}

class CategoryImg {
  int? id;
  String? image;
  String? creator;
  String? slug;
  String? createdAt;
  String? updatedAt;

  CategoryImg(
      {this.id,
      this.image,
      this.creator,
      this.slug,
      this.createdAt,
      this.updatedAt});

  CategoryImg.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'];
    creator = json['creator'];
    slug = json['slug'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['image'] = image;
    data['creator'] = creator;
    data['slug'] = slug;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
