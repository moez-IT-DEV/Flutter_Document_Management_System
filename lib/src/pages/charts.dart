import 'package:dms/src/api_sevices/services.dart';
import 'package:dms/src/services/folderService.dart';
import 'package:dms/src/model/foldermodel.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:get/get.dart';
class displaypage extends StatefulWidget {
  const displaypage({Key? key}) : super(key: key);

  @override
  State<displaypage> createState() => _displaypageState();
}

class _displaypageState extends State<displaypage> {
List<charts.Series<DocumentCategory, String>> _seriesList = [];

@override
void initState() {
  super.initState();
  _getChartData();
}

Future<void> _getChartData() async {
  List<FolderModel> folders = await FolderCollection().getFoldersList();
  List<charts.Series<DocumentCategory, String>> data = await _createData(folders);

  setState(() {
    _seriesList = data;
  });
}

@override
Widget build(BuildContext context) {
  return Scaffold(
    body: Center(
      child: SimpleChart(_seriesList, animate: true),
    ),
  );
}
}

class DocumentCategory {
  final String category;
  final int count;

  DocumentCategory(this.category, this.count);
}

class SimpleChart extends StatelessWidget {
  final List<charts.Series<DocumentCategory, String>> seriesList;
  final bool animate;

  SimpleChart(this.seriesList, {required this.animate});

  @override
  Widget build(BuildContext context) {
    return charts.BarChart(
      seriesList,
      animate: animate,
    );
  }
}

Future<List<charts.Series<DocumentCategory, String>>> _createData(List<FolderModel> folders) async {
  final data = <DocumentCategory>[];
  final FilesController controller = Get.put<FilesController>(FilesController());
  for (var folder in folders) {
    final fileList = await controller.getFilesCategory(folder.folder);
    final itemCount = fileList.length;
    data.add(DocumentCategory(folder.folder, itemCount));
  }

  return [
    charts.Series<DocumentCategory, String>(
      id: 'Folders',
      domainFn: (DocumentCategory category, _) => category.category,
      measureFn: (DocumentCategory category, _) => category.count,
      data: data,
      labelAccessorFn: (DocumentCategory category, _) => '${category.count}', // Display count as label
    )
  ];
}