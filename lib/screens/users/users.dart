import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mcemeurckart_admin/constants/index.dart';
import 'package:mcemeurckart_admin/controller/users_controller_getx.dart';
import 'package:mcemeurckart_admin/routes/app_routes.dart';

class Users extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Users'),
      ),
      body: GetBuilder<UsersController>(builder: (usersController) {
        final users = List<Map<String, dynamic>>.from(usersController.users);
        return ListView.builder(
          padding: EdgeInsets.all(Sizes.p16),
          itemCount: users.length,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () async {
                await usersController.setCurrentUser(users[index]['email']);
                Get.toNamed(AppRoutes.user);
              },
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      usersController.users[index]['displayPicture'] != null
                          ? CachedNetworkImage(
                              imageUrl: users[index]['displayPicture'],
                              height: 100,
                              width: 100,
                            )
                          : Icon(Icons.person,
                              size: 100, color: AppColors.neutral400),
                      gapW16,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(users[index]['rank'] ?? ''),
                            Text(users[index]['displayName'] ?? ''),
                            Text(users[index]['email'] ?? ''),
                            Text(users[index]['groceryCardNo'] ?? ''),
                            Text(users[index]['address'] ?? ''),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
