import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../api_sevices/services.dart';
import '../widgets/buttons.dart';
import '../widgets/nav_bar.dart';
import '../widgets/text.dart';

class Auditspage extends StatefulWidget {
  const Auditspage({Key? key}) : super(key: key);

  @override
  State<Auditspage> createState() => _AuditspageState();
}

class _AuditspageState extends State<Auditspage> {
  final FilesController controller =
      Get.put<FilesController>(FilesController());
  @override
  void initState() {
    super.initState();
    controller.getFiles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: 60,
          ),
          top_nav(tittle: "AUDITS"),
          SizedBox(
            height: 20,
          ),
          SizedBox(
            height: 30,
          ),
          /*Expanded(
            child: Obx(() {
              if (controller.files != null) {
                return ListView.builder(
                  itemCount: controller.files!.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: Row(
                        children: [
                          Column(
                            children: [
                              Text("File Tittle"),
                              Expanded(child: Text(controller.files![index].tittle)),
                            ],
                          ),
                          Column(
                            children: [
                              Text("File Description"),
                              Expanded(child: Text(controller.files![index].description)),
                            ],
                          ),
                          Column(
                            children: [
                              Text("Created by"),
                              Expanded(child: Text("Created by: ${controller.files![index].user}")),
                            ],
                          ),
                        ],
                      )
                    );
                  },
                );
              } else {
                return Text("Please be patient"
                );
              }
            }),
          )*/
          Expanded(
            child: Obx(() {
              if (controller.files != null && controller.files!.isNotEmpty) {
                return ListView.builder(
                  itemCount: controller.files!.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: ListTile(
                          title: Text(
                              "File Title: ${controller.files![index].tittle}"),
                          subtitle: Text(
                              /*
                          DateTime.parse('2023-05-20 20:18:04Z');
print(moonLanding.hour); // 20


                          */
                              "Date Uploaded: ${controller.files![index].date}"),
                          trailing: Text(
                              "Uploaded by:${controller.files![index].user}")),
                    );
                  },
                );
              } else {
                return Text("Please wait");
              }
            }),
          )
        ],
      ),
    );
  }
}
