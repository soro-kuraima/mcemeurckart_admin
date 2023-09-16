import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mcemeurckart_admin/common_widgets/index.dart';
import 'package:mcemeurckart_admin/constants/index.dart';
import 'package:mcemeurckart_admin/util/user_manager.dart';

class RequestedUsers extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final rxUsers = [].obs;
    setUsers() async {
      try {
        final users = await UserManager.getAuthRequests();
        rxUsers.value = [...users];
      } catch (e) {
        Get.snackbar("Error", e.toString(),
            snackPosition: SnackPosition.TOP,
            backgroundColor: AppColors.red400,
            colorText: AppColors.white);
      }
    }

    setUsers();

    return Scaffold(
      appBar: AppBar(
        title: Text('Requested Users'),
      ),
      body: (Obx(
        () => rxUsers.isEmpty
            ? const Center(child: Text('No Authentication requests'))
            : ListView.builder(
                itemCount: rxUsers.length,
                itemBuilder: (BuildContext context, int index) {
                  final user = rxUsers[index];

                  return ExpansionTile(
                    childrenPadding: const EdgeInsets.all(Sizes.p16),
                    title: Text(user['groceryCardNo']),
                    children: [
                      ListTile(
                        title: Text('Rank: ${user['rank']}'),
                      ),
                      ListTile(
                        title: Text('Name: ${user['name']}'),
                      ),
                      ListTile(
                        title: Text('Email: ${user['email']}'),
                      ),
                      ListTile(
                        title: Text('Address: ${user['address']}'),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          PrimaryButton(
                            buttonLabel: 'Approve',
                            buttonWidth: Sizes.deviceWidth * 0.4,
                            buttonColor: AppColors.green700,
                            onPressed: () async {
                              try {
                                await UserManager.approveUser(user['id']);
                                Get.snackbar("Success", "User Approved",
                                    snackPosition: SnackPosition.TOP,
                                    backgroundColor: AppColors.green700,
                                    colorText: AppColors.white);

                                setUsers();
                              } catch (e) {
                                Get.snackbar("Error", e.toString(),
                                    snackPosition: SnackPosition.TOP,
                                    backgroundColor: AppColors.red400,
                                    colorText: AppColors.white);
                              }
                            },
                          ),
                          PrimaryButton(
                            buttonLabel: 'Reject',
                            buttonWidth: Sizes.deviceWidth * 0.4,
                            buttonColor: AppColors.red400,
                            onPressed: () async {
                              try {
                                await UserManager.rejectUser(user['id']);
                                Get.snackbar("Success", "User Rejected",
                                    snackPosition: SnackPosition.TOP,
                                    backgroundColor: AppColors.green700,
                                    colorText: AppColors.white);
                                setUsers();
                              } catch (e) {
                                Get.snackbar("Error", e.toString(),
                                    snackPosition: SnackPosition.TOP,
                                    backgroundColor: AppColors.red400,
                                    colorText: AppColors.white);
                              }
                            },
                          ),
                        ],
                      )
                    ],
                  );
                },
              ),
      )),
    );
  }
}
