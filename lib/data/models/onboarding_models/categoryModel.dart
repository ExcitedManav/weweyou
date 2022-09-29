class CategoryModel {
  bool? status;
  List<CategoryData> categoryData = [];

  CategoryModel({this.status, required this.categoryData});

  CategoryModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['record'] != null) {
      categoryData = <CategoryData>[];
      categoryData = json["record"]
          .map<CategoryData>((e) => CategoryData.fromJson(e))
          .toList();
    }
  }
}

class CategoryData {
  int? id;
  String? categoryCardNameEN,
      categoryDescriptionEN,
      categoryDescriptionFR,
      imageAdditional,
      nameEN,
      nameES,
      nameFR,
      orderId,
      thumbnail,
      creator,
      slug;

  CategoryData(
      {this.id,
      this.categoryCardNameEN,
      this.categoryDescriptionEN,
      this.categoryDescriptionFR,
      this.imageAdditional,
      this.nameEN,
      this.nameES,
      this.nameFR,
      this.orderId,
      this.thumbnail,
      this.creator,
      this.slug});

  factory CategoryData.fromJson(Map<String, dynamic> json) {
    return CategoryData(
        id: json['id'],
        categoryCardNameEN: json['Category_Card_Name_EN'],
        categoryDescriptionEN: json['Category_Description_En'],
        categoryDescriptionFR: json['Category_Description_Fr'],
        imageAdditional: json['image_aditional'],
        nameEN: json['name_En'],
        nameES: json['name_Es'],
        nameFR: json['name_Fr'],
        orderId: json['order_id'],
        thumbnail: json['thumbnail'],
        creator: json['creator'],
        slug: json['slug']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['Category_Card_Name_EN'] = categoryDescriptionEN;
    _data['Category_Description_En'] = categoryDescriptionEN;
    _data['Category_Description_Fr'] = categoryDescriptionFR;
    _data['image_aditional'] = imageAdditional;
    _data['name_En'] = nameEN;
    _data['name_Es'] = nameES;
    _data['name_Fr'] = nameFR;
    _data['order_id'] = orderId;
    _data['thumbnail'] = thumbnail;
    _data['creator'] = creator;
    _data['slug'] = slug;
    return _data;
  }
}

class SaveCategoryModel {
  String? message;
  bool? status;

  SaveCategoryModel({this.message, this.status});

  factory SaveCategoryModel.fromJson(Map<String, dynamic> json) {
    return SaveCategoryModel(message: json['message'], status: json['status']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['message'] = message;
    _data['status'] = status;
    return _data;
  }
}
