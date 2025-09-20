import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';

// --- 데이터 모델 ---
// 각 체크리스트 항목을 나타내는 클래스
class ChecklistItem {
  String title;
  bool isChecked;
  List<XFile> attachments; // 첨부 파일 (사진, 동영상 등)

  ChecklistItem({
    required this.title,
    this.isChecked = false,
    List<XFile>? attachments,
  }) : this.attachments = attachments ?? [];
}

// 하나의 완성된 계약을 나타내는 클래스
class Contract {
  final String id;
  final String name;
  final String type;
  final List<ChecklistItem> items;
  final DateTime completionDate;

  Contract({
    required this.name,
    required this.type,
    required this.items,
  })  : id = DateTime.now().millisecondsSinceEpoch.toString(),
        completionDate = DateTime.now();
}

// --- 전역 데이터 저장소 (서버 대신 임시 사용) ---
List<Contract> savedContracts = [];

void main() {
  runApp(const ZariApp());
}

class ZariApp extends StatelessWidget {
  const ZariApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '자리 (ZARI)',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        scaffoldBackgroundColor: const Color(0xFFF2F2F7),
        fontFamily: 'Pretendard',
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFF2F2F7),
          foregroundColor: Colors.black,
          elevation: 0,
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      home: const MainScreen(),
    );
  }
}

// --- 메인 스크린 ---
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _widgetOptions = [
    const ListingsPage(),
    const ContractPage(),
    const CompassAiPage(),
    const InfoPage(),
    const MyPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _widgetOptions,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.location_on_outlined), label: '매물'),
          BottomNavigationBarItem(icon: Icon(Icons.shield_outlined), label: '계약'),
          BottomNavigationBarItem(icon: Icon(Icons.compass_calibration_rounded), label: '나침반'),
          BottomNavigationBarItem(icon: Icon(Icons.lightbulb_outline), label: '정보'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: '마이페이지'),
        ],
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
      ),
    );
  }
}

// --- 탭 페이지들 ---

// 1. 매물 탭
class ListingsPage extends StatelessWidget {
  const ListingsPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: false, title: const Text('내 주변 매물')),
      body: Container(
        height: double.infinity,
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Stack(
          children: [
            const Center(child: Text("지도 영역", style: TextStyle(color: Colors.grey, fontSize: 20))),
            _buildListingPin(top: 50, left: 60),
            _buildListingPin(top: 120, left: 200),
            _buildListingPin(bottom: 80, right: 80),
          ],
        ),
      ),
    );
  }
  Widget _buildListingPin({double? top, double? bottom, double? left, double? right}) {
    return Positioned(
      top: top, bottom: bottom, left: left, right: right,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(color: Colors.deepPurple, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2))]),
        child: const Text("500/55", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }
}

// 2. 계약 탭
class ContractPage extends StatelessWidget {
  const ContractPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: false, title: const Text('계약 안심 동행')),
      body: ListView(
        padding: const EdgeInsets.only(top: 20.0),
        children: [_buildFeatureCard(children: [
          _buildListTile(
            icon: Icons.checklist_rtl_rounded, color: Colors.orange, title: '단계별 계약 체크리스트',
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ChecklistPage())),
          ),
          _buildListTile(icon: Icons.document_scanner_rounded, color: Colors.red, title: 'AI 계약서 분석', onTap: () {}),
          // 증거보관함 페이지로 이동
          _buildListTile(
            icon: Icons.camera_alt_rounded, color: Colors.teal, title: '증거보관함',
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const EvidenceLockerPage())),
          ),
        ])],
      ),
    );
  }
}

// 3. 나침반 탭
class CompassAiPage extends StatefulWidget {
  const CompassAiPage({super.key});
  @override
  State<CompassAiPage> createState() => _CompassAiPageState();
}
class _CompassAiPageState extends State<CompassAiPage> {
  bool _isDiagnosed = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: false, title: const Text('나침반 AI')),
      body: ListView(
        padding: const EdgeInsets.only(top: 20.0),
        children: [
          const DDayCard(),
          const SizedBox(height: 20),
          _buildAiResultsCard(),
          const SizedBox(height: 8),
          _buildFeatureCard(children: [
            _buildListTile(icon: Icons.compass_calibration_rounded, color: Colors.purple, title: 'AI 주거 상황 진단', onTap: () => setState(() => _isDiagnosed = true)),
            _buildListTile(icon: Icons.real_estate_agent_rounded, color: Colors.blue, title: '최적 주거 형태/지역 추천', onTap: () {}),
            _buildListTile(icon: Icons.savings_rounded, color: Colors.green, title: '맞춤형 금융 상품 매칭', onTap: () {}),
          ]),
        ],
      ),
    );
  }
  Widget _buildAiResultsCard() {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("AI 상황 판단 결과", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: _isDiagnosed ? _buildDiagnosisResult() : _buildDiagnosisPrompt(),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildDiagnosisResult() {
    return Column(
      key: const ValueKey('result'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text("• 추천 보증금: 1000만원 ~ 3000만원"),
        SizedBox(height: 4),
        Text("• 추천 월세: 45만원 ~ 60만원"),
        SizedBox(height: 4),
        Text("• 추천 지역: 서울시 관악구, 동작구"),
      ],
    );
  }
  Widget _buildDiagnosisPrompt() {
    return const Text(
      key: ValueKey('prompt'), "AI를 통해 여러분들의 상황을 진단 받고\n최적의 월세/전세 비용을 추천 받으세요!",
      textAlign: TextAlign.center, style: TextStyle(color: Colors.grey, height: 1.5),
    );
  }
}

// 4. 정보 탭
class InfoPage extends StatelessWidget {
  const InfoPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: false, title: const Text('유용한 정보')),
      body: ListView(
        padding: const EdgeInsets.only(top: 20.0),
        children: [_buildFeatureCard(children: [
          _buildListTile(icon: Icons.notifications_active_rounded, color: Colors.indigo, title: '맞춤형 주거 공고 알림', onTap: () {}),
          _buildListTile(icon: Icons.school_rounded, color: Colors.brown, title: '틈새 장학금 정보', onTap: () {}),
          _buildListTile(icon: Icons.wallet_giftcard_rounded, color: Colors.pink, title: '생활비 절약 꿀팁', onTap: () {}),
        ])],
      ),
    );
  }
}

// 5. 마이페이지 탭
class MyPage extends StatelessWidget {
  const MyPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: false, title: const Text('마이페이지')),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        children: [
          Column(
            children: const [
              CircleAvatar(radius: 40, backgroundColor: Colors.deepPurple, child: Icon(Icons.person, size: 50, color: Colors.white)),
              SizedBox(height: 12),
              Text("User_Nickname", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: 4),
              Text("User@email.com", style: TextStyle(fontSize: 14, color: Colors.grey)),
            ],
          ),
          const SizedBox(height: 30),
          _buildFeatureCard(children: [
            _buildListTile(icon: Icons.settings, color: Colors.grey, title: '계정 설정', onTap: () {}),
            _buildListTile(icon: Icons.notifications, color: Colors.blue, title: '알림 설정', onTap: () {}),
            _buildListTile(icon: Icons.headset_mic, color: Colors.green, title: '고객센터', onTap: () {}),
          ]),
          const SizedBox(height: 20),
          _buildFeatureCard(children: [_buildListTile(icon: Icons.logout, color: Colors.red, title: '로그아웃', onTap: () {})])
        ],
      ),
    );
  }
}

// --- 계약 체크리스트 페이지 ---
class ChecklistPage extends StatefulWidget {
  const ChecklistPage({super.key});
  @override
  State<ChecklistPage> createState() => _ChecklistPageState();
}

class _ChecklistPageState extends State<ChecklistPage> {
  final _contractNameController = TextEditingController();
  String? _contractType;
  List<ChecklistItem> _items = [];
  final ImagePicker _picker = ImagePicker();

  final Map<String, List<String>> _checklistTemplates = {
    '월세': ['등기부등본 확인 (근저당, 압류)','건축물대장 확인 (불법 건축물 여부)','집주인 신분증과 등기부등본 소유자 일치 확인','대리인 계약 시 위임장, 인감증명서 확인','보증금/월세 금액, 지급일 확인','관리비 포함 내역 확인 (수도, 전기, 가스)','입주 전 하자(벽지, 누수 등) 사진 촬영','특약사항 꼼꼼히 확인 (반려동물, 전대차 등)','입주 즉시 전입신고 및 확정일자 받기',],
    '전세': ['등기부등본 확인 (선순위 채권 금액 확인)','건축물대장 확인 (불법 건축물 여부)','집주인 신분증과 등기부등본 소유자 일치 확인','대리인 계약 시 위임장, 인감증명서 확인','전세보증금 반환보증보험 가입 가능 여부 확인','전세금액, 지급일, 계약기간 확인','근저당 설정 시 전세금+근저당액이 시세의 70% 이하인지 확인','특약사항 꼼꼼히 확인 (수리비 부담 등)','입주 즉시 전입신고 및 확정일자 받기',],
  };

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
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("새 항목 추가"),
        content: TextField(controller: newItemController, decoration: const InputDecoration(hintText: "항목 이름")),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("취소")),
          TextButton(
            onPressed: () {
              if (newItemController.text.isNotEmpty) {
                setState(() {
                  _items.add(ChecklistItem(title: newItemController.text));
                });
                Navigator.pop(context);
              }
            },
            child: const Text("추가"),
          ),
        ],
      ),
    );
  }

  void _attachFile(int index) async {
    final List<XFile> pickedFiles = await _picker.pickMultipleMedia();
    setState(() {
      _items[index].attachments.addAll(pickedFiles);
    });
  }

  void _resetChecklist() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("초기화"),
        content: const Text("모든 체크 항목과 첨부파일이 초기화됩니다. 계속하시겠습니까?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("취소")),
          TextButton(
            onPressed: () {
              setState(() {
                for (var item in _items) {
                  item.isChecked = false;
                }
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("체크리스트가 초기화되었습니다.")));
            },
            child: const Text("확인"),
          ),
        ],
      ),
    );
  }

  void _completeContract() {
    final newContract = Contract(
      name: _contractNameController.text,
      type: _contractType!,
      items: _items,
    );
    setState(() {
      savedContracts.add(newContract);
    });
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("계약이 완료되어 증거보관함에 저장되었습니다.")));
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _contractNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text('단계별 계약 체크리스트'),
        actions: [
          if (_contractType != null)
            IconButton(icon: const Icon(Icons.add), onPressed: _addNewItem),
        ],
      ),
      body: _contractType == null ? _buildTypeSelection() : _buildChecklist(),
      bottomNavigationBar: _contractType == null
          ? null
          : Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("현재 상태가 저장되었습니다."))), child: const Text("저장하기")),
            ElevatedButton(onPressed: _resetChecklist, style: ElevatedButton.styleFrom(backgroundColor: Colors.grey), child: const Text("초기화")),
            ElevatedButton(onPressed: _completeContract, style: ElevatedButton.styleFrom(backgroundColor: Colors.green), child: const Text("계약 완료")),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeSelection() {
    return Padding(
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
          _buildTypeSelectionCard(
            icon: Icons.home_work_outlined, title: '월세 계약', subtitle: '매월 정해진 금액을 지불하는 방식입니다.',
            onTap: () => _selectContractType('월세'),
          ),
          const SizedBox(height: 12),
          _buildTypeSelectionCard(
            icon: Icons.real_estate_agent_outlined, title: '전세 계약', subtitle: '목돈을 맡기고 계약 종료 후 돌려받는 방식입니다.',
            onTap: () => _selectContractType('전세'),
          ),
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
      itemCount: _items.length,
      itemBuilder: (context, index) {
        final item = _items[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Column(
            children: [
              CheckboxListTile(
                title: Text(item.title),
                value: item.isChecked,
                onChanged: (bool? value) => setState(() => item.isChecked = value!),
              ),
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

// --- 증거 보관함 페이지 ---
class EvidenceLockerPage extends StatefulWidget {
  const EvidenceLockerPage({super.key});
  @override
  State<EvidenceLockerPage> createState() => _EvidenceLockerPageState();
}
class _EvidenceLockerPageState extends State<EvidenceLockerPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("증거보관함")),
      body: savedContracts.isEmpty
          ? const Center(child: Text("완료된 계약이 없습니다."))
          : ListView.builder(
        itemCount: savedContracts.length,
        itemBuilder: (context, index) {
          final contract = savedContracts[index];
          return ListTile(
            title: Text(contract.name),
            subtitle: Text("${contract.type} 계약 - ${DateFormat('yyyy.MM.dd').format(contract.completionDate)} 완료"),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ContractDetailsPage(contract: contract))),
          );
        },
      ),
    );
  }
}

// --- 계약 상세 페이지 ---
class ContractDetailsPage extends StatelessWidget {
  final Contract contract;
  const ContractDetailsPage({super.key, required this.contract});

  @override
  Widget build(BuildContext context) {
    // 모든 아이템의 첨부파일을 하나의 리스트로 합침
    final allAttachments = contract.items.expand((item) => item.attachments).toList();

    return Scaffold(
      appBar: AppBar(title: Text(contract.name)),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text("${contract.type} 계약 상세내용", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          ...contract.items.map((item) => ListTile(
            leading: Icon(item.isChecked ? Icons.check_box : Icons.check_box_outline_blank, color: item.isChecked ? Colors.green : Colors.grey),
            title: Text(item.title),
            subtitle: Text("첨부파일: ${item.attachments.length}개"),
          )),
          const Divider(),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text("전체 첨부파일 목록", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          allAttachments.isEmpty
              ? const Center(child: Padding(padding: EdgeInsets.all(16.0), child: Text("첨부된 파일이 없습니다.")))
              : GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.all(8),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 8, mainAxisSpacing: 8),
            itemCount: allAttachments.length,
            itemBuilder: (context, index) {
              final file = allAttachments[index];
              return Image.file(File(file.path), fit: BoxFit.cover);
            },
          ),
        ],
      ),
    );
  }
}

// --- D-Day 및 공용 위젯들 ---
class DDayCard extends StatefulWidget {
  const DDayCard({super.key});
  @override
  State<DDayCard> createState() => _DDayCardState();
}
class _DDayCardState extends State<DDayCard> {
  DateTime? _startDate;
  DateTime? _endDate;
  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(2010), lastDate: DateTime(2040));
    if (picked != null) {
      setState(() {
        if (isStartDate) _startDate = picked; else _endDate = picked;
      });
    }
  }
  Map<String, dynamic> _calculateDDayAndProgress() {
    Map<String, dynamic> result = {"dDayText": "D-Day", "percentageValue": 0.0, "percentageText": "0.0%"};
    if (_startDate == null || _endDate == null || _endDate!.isBefore(_startDate!)) return result;
    final today = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    final remainingDays = _endDate!.difference(today).inDays;
    result["dDayText"] = remainingDays >= 0 ? "D-${remainingDays}" : "D+${remainingDays.abs()}";
    final totalDuration = _endDate!.difference(_startDate!).inDays;
    if (totalDuration > 0) {
      final passedDuration = today.difference(_startDate!).inDays;
      double percentage = passedDuration >= totalDuration ? 100.0 : (passedDuration > 0 ? (passedDuration / totalDuration) * 100 : 0.0);
      result["percentageValue"] = percentage;
      result["percentageText"] = "${percentage.toStringAsFixed(1)}%";
    } else {
      if (!today.isBefore(_startDate!)) {
        result["percentageValue"] = 100.0;
        result["percentageText"] = "100.0%";
      }
    }
    return result;
  }
  @override
  Widget build(BuildContext context) {
    final dDayData = _calculateDDayAndProgress();
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildDateSelector("계약 시작일", _startDate, () => _selectDate(context, true)),
                const Text("~", style: TextStyle(fontSize: 16)),
                _buildDateSelector("계약 종료일", _endDate, () => _selectDate(context, false)),
              ],
            ),
            const SizedBox(height: 16),
            Text(dDayData["dDayText"], style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.deepPurple)),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(child: ClipRRect(borderRadius: BorderRadius.circular(8), child: LinearProgressIndicator(value: dDayData["percentageValue"] / 100, minHeight: 12, backgroundColor: Colors.grey[300], valueColor: const AlwaysStoppedAnimation<Color>(Colors.deepPurple)))),
                const SizedBox(width: 8),
                Text(dDayData["percentageText"], style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            )
          ],
        ),
      ),
    );
  }
  Widget _buildDateSelector(String label, DateTime? date, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
          const SizedBox(height: 4),
          Text(date != null ? DateFormat('yyyy.MM.dd').format(date) : "날짜 선택", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
Widget _buildFeatureCard({required List<Widget> children}) {
  final List<Widget> itemsWithDividers = [];
  for (int i = 0; i < children.length; i++) {
    itemsWithDividers.add(children[i]);
    if (i < children.length - 1) {
      itemsWithDividers.add(const Divider(height: 1, thickness: 0.5, indent: 56, color: Color(0xFFE0E0E0)));
    }
  }
  return Card(
    margin: const EdgeInsets.symmetric(horizontal: 16),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
    child: Column(children: itemsWithDividers),
  );
}
Widget _buildListTile({required IconData icon, required Color color, required String title, required VoidCallback onTap}) {
  return ListTile(
    leading: Container(
      width: 32, height: 32,
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(8)),
      child: Icon(icon, color: Colors.white, size: 20),
    ),
    title: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.normal)),
    trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
    onTap: onTap,
  );
}