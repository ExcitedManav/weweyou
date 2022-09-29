// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'package:weweyou/data/models/onboarding_models/popular_events_model.dart';
// import 'package:weweyou/data/networking/api_end_point.dart';
// import 'package:weweyou/data/networking/api_provider.dart';
// import 'package:http/http.dart' as http;
// import 'package:weweyou/data/networking/shared_pref.dart';
// import 'package:weweyou/ui/utils/constant.dart';
//
// class PaginationTest extends StatefulWidget {
//   const PaginationTest({Key? key}) : super(key: key);
//
//   @override
//   State<PaginationTest> createState() => _PaginationTestState();
// }
//
// class _PaginationTestState extends State<PaginationTest> {
//   int _page = 0;
//
//   final int _limit = 8;
//
//   bool _isFirstLoadingRunning = false;
//   bool _hasNextPage = true;
//   bool _isLoadMoreRunning = false;
//
//   List<CreatedAllEvent> _post = [];
//   List<CreatedAllEvent> _fetchedPost = [];
//
//   void _loadMore() async {
//     if (_hasNextPage == true &&
//         _isFirstLoadingRunning == false &&
//         _isLoadMoreRunning == false) {
//       setState(() {
//         _isLoadMoreRunning = true; // Display loader for loading
//       });
//
//       _page += 1;
//       try {
//         var url = "${baseUrl + ApiEndPoint.CREATEDEVENTLIST}?page=$_page";
//         // "${baseUrl + ApiEndPoint.CREATEDEVENTLIST}?page=$_page&_limit=$_limit";
//         print("url");
//         print(url);
//         var token = await getAuthToken();
//         print('Token check $token');
//         final response = await http.get(Uri.parse(url), headers: {
//           'Authorization': "Bearer $token",
//           "X-localization": "en",
//           // "Content-Type": "application/json"
//         });
//         var data = jsonDecode(response.body);
//         CreatedEventListModel createdEventListModel =
//             CreatedEventListModel.fromJson(data);
//         _fetchedPost = createdEventListModel.record!.allEvent!;
//         if (_fetchedPost.isNotEmpty) {
//           setState(() {
//             _post.addAll(_fetchedPost);
//           });
//         } else {
//           _hasNextPage = false;
//         }
//         print("Check _post Here ${response.statusCode}");
//         print("Check _post Here ${createdEventListModel.record!.allEvent}");
//       } catch (e) {
//         print(e.toString());
//       }
//       setState(() {
//         _isLoadMoreRunning = false;
//       });
//     }
//   }
//
//   void _firstLoad() async {
//     setState(() {
//       _isFirstLoadingRunning = true;
//     });
//     try {
//       var url = "${baseUrl + ApiEndPoint.CREATEDEVENTLIST}?page=$_page";
//       // "${baseUrl + ApiEndPoint.CREATEDEVENTLIST}?page=$_page&_limit=$_limit";
//       print("url");
//       print(url);
//       var token = await getAuthToken();
//       print('Token check $token');
//       final response = await http.get(Uri.parse(url), headers: {
//         'Authorization': "Bearer $token",
//         "X-localization": "en",
//         // "Content-Type": "application/json"
//       });
//       var data = jsonDecode(response.body);
//       CreatedEventListModel createdEventListModel =
//           CreatedEventListModel.fromJson(data);
//       _post = createdEventListModel.record!.allEvent!;
//       print("Check _post Here ${response.statusCode}");
//       print("Check _post Here ${createdEventListModel.record!.allEvent}");
//     } catch (e) {
//       print(e.toString());
//     }
//
//     setState(() {
//       _isFirstLoadingRunning = false;
//     });
//   }
//
//   ScrollController _scrollController = ScrollController();
//
//   @override
//   void initState() {
//     _firstLoad();
//     _scrollController = ScrollController()
//       ..addListener(() {
//         _loadMore();
//       });
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(),
//       body: _isFirstLoadingRunning
//           ? const Center(
//               child: CircularProgressIndicator(),
//             )
//           : Column(
//               children: [
//                 Expanded(
//                   child: ListView.separated(
//                     separatorBuilder: (_, i) => sizedBox(),
//                     itemCount: _post.length,
//                     controller: _scrollController,
//                     itemBuilder: (context, i) {
//                       return ListTile(
//                         title: Text(_post[i].eventTitle ?? ''),
//                         subtitle: Text(_post[i].description ?? ''),
//                       );
//                     },
//                   ),
//                 ),
//                 if (_isLoadMoreRunning == true)
//                   const Padding(
//                     padding: EdgeInsets.only(
//                       top: 10,
//                       bottom: 40,
//                     ),
//                     child: Center(
//                       child: CircularProgressIndicator(),
//                     ),
//                   ),
//               ],
//             ),
//     );
//   }
// }

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:http/http.dart' as http;
import 'package:weweyou/data/networking/networking.dart';

import 'data/models/onboarding_models/popular_events_model.dart';
import 'data/networking/api_end_point.dart';
import 'data/networking/api_provider.dart';
import 'data/networking/shared_pref.dart';

class PaginationTest extends StatefulWidget {
  const PaginationTest({Key? key}) : super(key: key);

  @override
  State<PaginationTest> createState() => _PaginationTestState();
}

class _PaginationTestState extends State<PaginationTest> {
  static const _pageSize = 8;
  static int _page = 0;
  final PagingController<int, CreatedAllEvent> _pagingController =
      PagingController(firstPageKey: _page);

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    super.initState();
  }

  List<CreatedAllEvent> _post = [];

  Future<void> _fetchPage(int pageKey) async {
    try {
      var url = "${baseUrl + ApiEndPoint.CREATEDEVENTLIST}?page=$pageKey";
      debugPrint("Url ----> $url");
      var token = await getAuthToken();
      final response = await http.get(Uri.parse(url), headers: {
        'Authorization': "Bearer $token",
        "X-localization": "en",
      });
      var data = jsonDecode(response.body);
      CreatedEventListModel createdEventListModel =
          CreatedEventListModel.fromJson(data);
      _post = createdEventListModel.record!.allEvent!;
      final isLastPage = _post.length < _pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(_post);
      } else {
        _page += 1;
        final nextPageKey = _page + _post.length;
        _pagingController.appendPage(_post, _page);
        print("Page Count $_page");
      }
      if (mounted) setState(() {});
    } catch (error) {
      _pagingController.error = error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PagedListView<int, CreatedAllEvent>(
        pagingController: _pagingController,
        builderDelegate: PagedChildBuilderDelegate<CreatedAllEvent>(
          itemBuilder: (context, item, index) => ListTile(
            title: Text(item.eventTitle ?? ''),
          ),
        ),
      ),
    );
  }
}
