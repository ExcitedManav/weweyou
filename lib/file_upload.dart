// import 'dart:convert';
// import 'dart:developer';
// import 'package:weweyou/data/networking/response.dart';
// import 'package:zumi_app/data/local/shared_pref_helper.dart';
// import 'package:zumi_app/data/remote/endpoints.dart';
// import 'package:zumi_app/data/remote/model/response_dto.dart';
// import 'package:zumi_app/ui/utils/log_tags.dart';
// import 'package:http/http.dart' as http;
//
// ///Helper class for uploading single and multiple multipart files.
// ///@param path The path of the api endpoint.
// ///@param fields Map of fields to be added along with files.
// ///@param multipleFiles List of file paths to be uploaded.
// ///@author simarjot singh kalsi.
// class FileUploadHelper {
//   FileUploadHelper(
//       {required String path,
//       required Map<String, String> fields,
//       MultipleFiles? multipleFiles,
//       Map<String, String>? headers})
//       : _path = path,
//         _fields = fields,
//         _multipleFiles = multipleFiles,
//         _headers =
//             headers ?? {'Authorization': 'Bearer ${Prefs.authToken.get()}'};
//
//   final String _path;
//   final Map<String, String> _fields;
//   final MultipleFiles? _multipleFiles;
//   final Map<String, String> _headers;
//   late http.MultipartRequest request;
//
//   Future<http.Response> startUpload() async {
//     final endpoint = Uri.parse("${Endpoints.baseUrl}/$_path");
//     request = http.MultipartRequest(
//       "POST",
//       endpoint,
//     );
//
//     await _addMultipleFiles();
//     _addHeaders();
//     _addFields();
//
//     log('Starting File upload at /$endpoint', name: LogTags.apiCall);
//     final streamedResponse = await request.send();
//     final response = await http.Response.fromStream(streamedResponse);
//     log('File Upload Completed', name: LogTags.apiCall);
//     log(response.body.toString(), name: LogTags.apiCall);
//
//     return response;
//   }
//
//   Future<ResponseC> startUploadParsed<T>() async {
//     final response = await startUpload();
//     return ResponseDto<T>(
//       (updates) => updates
//         ..isSuccessful = jsonDecode(response.body)['success']
//         ..message = "Uploaded successfully"
//         ..status = 200
//         ..data = null,
//     );
//   }
//
//   Future<void> _addMultipleFiles() async {
//     //adding multiple files if present
//     if (_multipleFiles == null) return;
//     final multipleFiles = _multipleFiles!;
//     final Iterable<Future<http.MultipartFile>> fileFutures =
//         multipleFiles.filePaths.map((path) {
//       return http.MultipartFile.fromPath(
//         multipleFiles.fileFieldName,
//         path,
//       );
//     });
//     final List<http.MultipartFile> files = await Future.wait(fileFutures);
//     request.files.addAll(files);
//   }
//
//   void _addHeaders() {
//     request.headers.addAll(_headers);
//   }
//
//   void _addFields() {
//     request.fields.addAll(_fields);
//   }
// }
//
// class MultipleFiles {
//   List<String> filePaths;
//   String fileFieldName;
//
//   MultipleFiles({required this.fileFieldName, required this.filePaths});
// }
