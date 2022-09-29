import 'package:flutter/material.dart';
import 'package:weweyou/ui/home_screens/drawer_screens/groups/create_group_screen.dart';
import 'package:weweyou/ui/home_screens/drawer_screens/groups/group_detail_screen.dart';
import 'package:weweyou/ui/home_screens/widgets/image_network_function.dart';
import 'package:weweyou/ui/utils/common_text_style.dart';
import 'package:weweyou/ui/utils/constant.dart';

class GroupListScreen extends StatefulWidget {
  const GroupListScreen({Key? key}) : super(key: key);

  @override
  State<GroupListScreen> createState() => _GroupListScreenState();
}

class _GroupListScreenState extends State<GroupListScreen> {
  String imagePath =
      'https://media.istockphoto.com/photos/group-multiracial-people-having-fun-outdoor-happy-mixed-race-friends-picture-id1211345565?k=20&m=1211345565&s=612x612&w=0&h=Gg65DvzedP7YDo6XFbB-8-f7U7m5zHm1OPO3uIiVFgo=';

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: WeweyouColors.blackBackground,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Groups',
              style: poppinsBold(
                fontSize: 18,
              ),
            ),
            sizedBox(),
            Expanded(
              child: ListView.separated(
                itemBuilder: (ctx, i) {
                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 15),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              const GroupDetailScreen(imagePath: 'https://media.istockphoto.com/photos/group-multiracial-people-having-fun-outdoor-happy-mixed-race-friends-picture-id1211345565?k=20&m=1211345565&s=612x612&w=0&h=Gg65DvzedP7YDo6XFbB-8-f7U7m5zHm1OPO3uIiVFgo='),
                        ),
                      );
                    },
                    tileColor: WeweyouColors.blackPrimary,
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(25),
                      child: const ImageNetworkFunction(
                        height: 38,
                        width: 38,
                        imagePath: NetworkImage(
                          'https://media.istockphoto.com/photos/group-multiracial-people-having-fun-outdoor-happy-mixed-race-friends-picture-id1211345565?k=20&m=1211345565&s=612x612&w=0&h=Gg65DvzedP7YDo6XFbB-8-f7U7m5zHm1OPO3uIiVFgo=',
                        ),
                      ),
                    ),
                    title: Text(
                      'Groups Name',
                      style: poppinsBold(
                        fontSize: 18,
                      ),
                    ),
                    subtitle: commonText(
                      text: '50 members',
                      fontSize: 14,
                    ),
                    trailing: IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.person_add_alt_outlined,
                        color: WeweyouColors.primaryDarkRed,
                        size: 26,
                      ),
                    ),
                  );
                },
                separatorBuilder: (_, i) => sizedBox(),
                itemCount: 8,
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const CreateGroupScreen(),
            ),
          );
        },
        backgroundColor: WeweyouColors.primaryDarkRed,
        child: const Icon(
          Icons.add,
          size: 48,
          color: WeweyouColors.blackBackground,
        ),
      ),
    );
  }
}
