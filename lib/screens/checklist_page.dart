import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zari/data/database.dart';
import 'package:zari/models/contract_model.dart';

class ChecklistPage extends StatefulWidget {
  final Contract? existingContract;
  const ChecklistPage({super.key, this.existingContract});

  @override
  State<ChecklistPage> createState() => _ChecklistPageState();
}

class _ChecklistPageState extends State<ChecklistPage> {
  late TextEditingController _contractNameController;
  String? _contractType;
  List<ChecklistItem> _items = [];
  final ImagePicker _picker = ImagePicker();
  Contract? _currentContract;

  final Map<String, List<String>> _checklistTemplates = {
    '월세': ['등기부등본 확인 (근저당, 압류)','건축물대장 확인 (불법 건축물 여부)','집주인 신분증과 등기부등본 소유자 일치 확인','대리인 계약 시 위임장, 인감증명서 확인','보증금/월세 금액, 지급일 확인','관리비 포함 내역 확인 (수도, 전기, 가스)','입주 전 하자(벽지, 누수 등) 사진 촬영','특약사항 꼼꼼히 확인 (반려동물, 전대차 등)','입주 즉시 전입신고 및 확정일자 받기',],
    '전세': ['등기부등본 확인 (선순위 채권 금액 확인)','건축물대장 확인 (불법 건축물 여부)','집주인 신분증과 등기부등본 소유자 일치 확인','대리인 계약 시 위임장, 인감증명서 확인','전세보증금 반환보증보험 가입 가능 여부 확인','전세금액, 지급일, 계약기간 확인','근저당 설정 시 전세금+근저당액이 시세의 70% 이하인지 확인','특약사항 꼼꼼히 확인 (수리비 부담 등)','입주 즉시 전입신고 및 확정일자 받기',],
  };

  @override
  void initState() {
    super.initState();
    _contractNameController = TextEditingController();
    if (widget.existingContract != null) {
      _currentContract = widget.existingContract;
      _contractNameController.text = _currentContract!.name;
      _contractType = _currentContract!.type;
      _items = _currentContract!.items;
    }
  }

  void _selectContractType(String type) {
    if (_contractNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("계약 이름을 먼저 입력해주세요.")));
      return;
    }
    setState(() {
      _contractType = type;
      _items = _checklistTemplates[type]!.map((title) => ChecklistItem(title: title)).toList();
    });
  }

  void _addNewItem() {
    final newItemController = TextEditingController();
    showDialog(context: context, builder: (context) => AlertDialog(title: const Text("새 항목 추가"), content: TextField(controller: newItemController, decoration: const InputDecoration(hintText: "항목 이름")), actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text("취소")), TextButton(onPressed: () { if (newItemController.text.isNotEmpty) { setState(() => _items.add(ChecklistItem(title: newItemController.text))); Navigator.pop(context); } }, child: const Text("추가"))]));
  }

  void _attachFile(int index) async {
    final List<XFile> pickedFiles = await _picker.pickMultipleMedia();
    setState(() => _items[index].attachments.addAll(pickedFiles));
  }

  void _resetChecklist() {
    showDialog(context: context, builder: (context) => AlertDialog(title: const Text("초기화"), content: const Text("모든 체크 항목이 초기화됩니다. 계속하시겠습니까?"), actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text("취소")), TextButton(onPressed: () { setState(() { for (var item in _items) { item.isChecked = false; } }); Navigator.pop(context); ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("체크리스트가 초기화되었습니다."))); }, child: const Text("확인"))]));
  }

  void _saveContract() {
    setState(() {
      if (_currentContract == null) {
        final newContract = Contract(name: _contractNameController.text, type: _contractType!, items: _items, status: ContractStatus.inProgress);
        _currentContract = newContract;
        savedContracts.add(newContract);
      } else {
        _currentContract!.name = _contractNameController.text;
        _currentContract!.type = _contractType!;
        _currentContract!.items = _items;
        _currentContract!.status = ContractStatus.inProgress;
        _currentContract!.completionDate = DateTime.now();
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("계약이 '진행 중' 상태로 저장되었습니다.")));
  }

  void _completeContract() {
    _saveContract();
    setState(() {
      _currentContract!.status = ContractStatus.completed;
    });
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("계약이 완료되어 증거보관함에 최종 저장되었습니다.")));
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _contractNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: false, title: const Text('단계별 계약 체크리스트'), actions: [if (_contractType != null) IconButton(icon: const Icon(Icons.add), onPressed: _addNewItem)]),
      body: _contractType == null ? _buildTypeSelection() : _buildChecklist(),
      bottomNavigationBar: _contractType == null ? null : Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(onPressed: _saveContract, child: const Text("저장하기")),
            ElevatedButton(onPressed: _resetChecklist, style: ElevatedButton.styleFrom(backgroundColor: Colors.red), child: const Text("초기화")),
            ElevatedButton(onPressed: _completeContract, style: ElevatedButton.styleFrom(backgroundColor: Colors.green), child: const Text("계약 완료")),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeSelection() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("계약 이름", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          TextField(controller: _contractNameController, decoration: const InputDecoration(border: OutlineInputBorder(), hintText: "예: 신림동 원룸")),
          const SizedBox(height: 24),
          const Text("계약 유형을 선택해주세요.", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          _buildTypeSelectionCard(icon: Icons.home_work_outlined, title: '월세 계약', subtitle: '매월 정해진 금액을 지불하는 방식입니다.', onTap: () => _selectContractType('월세')),
          const SizedBox(height: 12),
          _buildTypeSelectionCard(icon: Icons.real_estate_agent_outlined, title: '전세 계약', subtitle: '목돈을 맡기고 계약 종료 후 돌려받는 방식입니다.', onTap: () => _selectContractType('전세')),
        ],
      ),
    );
  }

  Widget _buildTypeSelectionCard({required IconData icon, required String title, required String subtitle, required VoidCallback onTap}) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap, borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              Icon(icon, size: 40, color: Colors.deepPurple),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(subtitle, style: const TextStyle(color: Colors.grey)),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChecklist() {
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 80),
      itemCount: _items.length,
      itemBuilder: (context, index) {
        final item = _items[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Column(
            children: [
              CheckboxListTile(title: Text(item.title), value: item.isChecked, onChanged: (bool? value) => setState(() => item.isChecked = value!)),
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 8, bottom: 8),
                child: Row(
                  children: [
                    Text("첨부파일: ${item.attachments.length}개", style: const TextStyle(color: Colors.grey)),
                    const Spacer(),
                    IconButton(icon: const Icon(Icons.attach_file, color: Colors.grey), onPressed: () => _attachFile(index)),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}