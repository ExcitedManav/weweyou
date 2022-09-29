import 'package:weweyou/data/models/onboarding_models/UserModel.dart';

class EmailVerifiedModel {
  bool? status;
  String? message;
  UserData? userData;

  EmailVerifiedModel({this.status, this.message, this.userData});

  EmailVerifiedModel.fromJson(Map<String, dynamic> json) {
    EmailVerifiedModel(
      status: json['status'],
      message: json['message'],
      userData:
          json['record'] != null ? UserData.fromJson(json['record']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (userData != null) {
      data['record'] = userData!.toJson();
    }
    return data;
  }
}

class UserData {
  int? id;
  String? address;
  String? address2;
  String? admin;
  String? applesignin;
  String? approved;
  String? blocked;
  String? city;
  String? company;
  String? country;
  String? createdEvents;
  String? createdGroups;
  String? createdItineraries;
  String? currency;
  String? currentOrder;
  String? dateOfBirth;
  String? emailConfirmed;
  String? favoriteEvents;
  String? favoriteGroups;
  String? favoriteItineraries;
  String? favoriteSubs;
  String? firstName;
  String? following;
  String? group;
  String? groupsJoined;
  String? idApple;
  String? joinedEventGroups;
  String? language;
  String? lastName;
  String? location;
  String? orders;
  String? phone;
  String? placedOrders;
  String? position;
  String? postalCode;
  String? preferredCategories;
  String? profileColor;
  String? profilePhoto;
  String? region;
  String? scroll;
  String? searchDateRange;
  String? stripeSellerId;
  String? tags;
  String? userOrganizer;
  String? website;
  String? email;
  String? modifiedDate;
  String? createdDate;
  String? slug;
  String? fcmToken;
  String? originalPassword;
  String? status;
  String? token;
  String? webMobileType;
  String? authtoken;

  UserData(
      {this.id,
        this.address,
        this.address2,
        this.admin,
        this.applesignin,
        this.approved,
        this.blocked,
        this.city,
        this.company,
        this.country,
        this.createdEvents,
        this.createdGroups,
        this.createdItineraries,
        this.currency,
        this.currentOrder,
        this.dateOfBirth,
        this.emailConfirmed,
        this.favoriteEvents,
        this.favoriteGroups,
        this.favoriteItineraries,
        this.favoriteSubs,
        this.firstName,
        this.following,
        this.group,
        this.groupsJoined,
        this.idApple,
        this.joinedEventGroups,
        this.language,
        this.lastName,
        this.location,
        this.orders,
        this.phone,
        this.placedOrders,
        this.position,
        this.postalCode,
        this.preferredCategories,
        this.profileColor,
        this.profilePhoto,
        this.region,
        this.scroll,
        this.searchDateRange,
        this.stripeSellerId,
        this.tags,
        this.userOrganizer,
        this.website,
        this.email,
        this.modifiedDate,
        this.createdDate,
        this.slug,
        this.fcmToken,
        this.originalPassword,
        this.status,
        this.token,
        this.webMobileType,
        this.authtoken});

  UserData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    address = json['address'];
    address2 = json['address2'];
    admin = json['admin'];
    applesignin = json['applesignin'];
    approved = json['approved'];
    blocked = json['Blocked'];
    city = json['city'];
    company = json['company'];
    country = json['country'];
    createdEvents = json['created_events'];
    createdGroups = json['created_groups'];
    createdItineraries = json['created_itineraries'];
    currency = json['currency'];
    currentOrder = json['current_order'];
    dateOfBirth = json['Date_of_birth'];
    emailConfirmed = json['email_confirmed'];
    favoriteEvents = json['Favorite_events'];
    favoriteGroups = json['Favorite_groups'];
    favoriteItineraries = json['Favorite_itineraries'];
    favoriteSubs = json['Favorite_subs'];
    firstName = json['first_name'];
    following = json['following'];
    group = json['Group'];
    groupsJoined = json['Groups_Joined'];
    idApple = json['id_apple'];
    joinedEventGroups = json['Joined_event_groups'];
    language = json['Language'];
    lastName = json['last_name'];
    location = json['location'];
    orders = json['orders'];
    phone = json['phone'];
    placedOrders = json['placed_orders'];
    position = json['position'];
    postalCode = json['postal_code'];
    preferredCategories = json['preferred_categories'];
    profileColor = json['Profile_color'];
    profilePhoto = json['Profile_photo'];
    region = json['region'];
    scroll = json['scroll'];
    searchDateRange = json['search_date_range'];
    stripeSellerId = json['stripe_seller_id'];
    tags = json['tags'];
    userOrganizer = json['userOrganizer'];
    website = json['website'];
    email = json['email'];
    modifiedDate = json['modified_date'];
    createdDate = json['created_date'];
    slug = json['slug'];
    fcmToken = json['fcm_token'];
    originalPassword = json['original_password'];
    status = json['status'];
    token = json['token'];
    webMobileType = json['web_mobile_type'];
    authtoken = json['authtoken'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['address'] = address;
    data['address2'] = address2;
    data['admin'] = admin;
    data['applesignin'] = applesignin;
    data['approved'] = approved;
    data['Blocked'] = blocked;
    data['city'] = city;
    data['company'] = company;
    data['country'] = country;
    data['created_events'] = createdEvents;
    data['created_groups'] = createdGroups;
    data['created_itineraries'] = createdItineraries;
    data['currency'] = currency;
    data['current_order'] = currentOrder;
    data['Date_of_birth'] = dateOfBirth;
    data['email_confirmed'] = emailConfirmed;
    data['Favorite_events'] = favoriteEvents;
    data['Favorite_groups'] = favoriteGroups;
    data['Favorite_itineraries'] = favoriteItineraries;
    data['Favorite_subs'] = favoriteSubs;
    data['first_name'] = firstName;
    data['following'] = following;
    data['Group'] = group;
    data['Groups_Joined'] = groupsJoined;
    data['id_apple'] = idApple;
    data['Joined_event_groups'] = joinedEventGroups;
    data['Language'] = language;
    data['last_name'] = lastName;
    data['location'] = location;
    data['orders'] = orders;
    data['phone'] = phone;
    data['placed_orders'] = placedOrders;
    data['position'] = position;
    data['postal_code'] = postalCode;
    data['preferred_categories'] = preferredCategories;
    data['Profile_color'] = profileColor;
    data['Profile_photo'] = profilePhoto;
    data['region'] = region;
    data['scroll'] = scroll;
    data['search_date_range'] = searchDateRange;
    data['stripe_seller_id'] = stripeSellerId;
    data['tags'] = tags;
    data['userOrganizer'] = userOrganizer;
    data['website'] = website;
    data['email'] = email;
    data['modified_date'] = modifiedDate;
    data['created_date'] = createdDate;
    data['slug'] = slug;
    data['fcm_token'] = fcmToken;
    data['original_password'] = originalPassword;
    data['status'] = status;
    data['token'] = token;
    data['web_mobile_type'] = webMobileType;
    data['authtoken'] = authtoken;
    return data;
  }
}

