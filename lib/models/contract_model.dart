import 'package:image_picker/image_picker.dart';

enum ContractStatus { inProgress, completed }

class ChecklistItem {
  String title;
  bool isChecked;
  List<XFile> attachments;

  ChecklistItem({
    required this.title,
    this.isChecked = false,
    List<XFile>? attachments,
  }) : attachments = attachments ?? [];
}

class Contract {
  final String id;
  String name;
  String type;
  List<ChecklistItem> items;
  DateTime completionDate;
  ContractStatus status;

  Contract({
    required this.name,
    required this.type,
    required this.items,
    this.status = ContractStatus.inProgress,
  })  : id = DateTime.now().millisecondsSinceEpoch.toString(),
        completionDate = DateTime.now();
}