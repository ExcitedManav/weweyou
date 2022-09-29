//
//
// import 'package:weweyou/data/networking/api_end_point.dart';
// import 'package:weweyou/file_upload.dart';
//
//
// class PetRepo {
//   PetRepo._();
//
//   static Future<List<PetDto>> getPets() async {
//     final response = await httpGetList<PetDto>(ApiEndPoint.ITINERARYDETAILSUPDATE, {});
//     if (response.isSuccessful) {
//       return response.data!.toList();
//     } else {
//       return [];
//     }
//   }
//
//   static Future<ResponseDto<String>> addPet(
//     String petName,
//     String age,
//     String breed,
//     String desc,
//     List<String> images,
//   ) async {
//     final uploadHelper = FileUploadHelper(
//       path: Endpoints.addPet,
//       fields: {
//         'pet_name': petName,
//         'age': age,
//         'breed': breed,
//         'description': desc
//       },
//       multipleFiles: MultipleFiles(fileFieldName: 'files[]', filePaths: images),
//     );
//     return uploadHelper.startUploadParsed<String>();
//   }
//
//   static Future<ResponseDto<String>> deletePet(int petId) {
//     final requestBody = {
//       "id": petId.toString(),
//     };
//     return httpPost<String>(Endpoints.deletePet, requestBody);
//   }
//
//   static Future<ResponseDto<String>> deletePetImage(int petImageId) {
//     final requestBody = {
//       "id": petImageId.toString(),
//     };
//     return httpPost<String>(Endpoints.deletePetImage, requestBody);
//   }
//
//   static Future<ResponseDto<String>> addMoreImages(
//       int petId, String imagePath) {
//     final uploadHelper = FileUploadHelper(
//       path: Endpoints.addMoreImagesPet,
//       fields: {
//         'id': petId.toString(),
//       },
//       multipleFiles: MultipleFiles(
//         fileFieldName: 'files[]',
//         filePaths: [imagePath],
//       ),
//     );
//     return uploadHelper.startUploadParsed<String>();
//   }
//
//   static Future<ResponseDto<BuiltList<PetImageDto>>> getImageList(int petId) {
//     final requestBody = {"pet_id": petId.toString()};
//     return httpPostList<PetImageDto>(Endpoints.getPetImageList, requestBody);
//   }
// }
