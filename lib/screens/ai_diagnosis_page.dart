// lib/screens/ai_diagnosis_page.dart

import 'package:flutter/material.dart';
import 'package:zari/models/ai_diagnosis_model.dart';
import 'package:zari/services/api_service.dart';

class AiDiagnosisPage extends StatefulWidget {
  const AiDiagnosisPage({super.key});
  @override
  State<AiDiagnosisPage> createState() => _AiDiagnosisPageState();
}

class _AiDiagnosisPageState extends State<AiDiagnosisPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  int? _incomeQuintile;
  bool? _isMarried;
  final _incomeController = TextEditingController();
  final _familyMembersController = TextEditingController();
  final _childrenController = TextEditingController();
  final _ageController = TextEditingController();
  final _budgetController = TextEditingController();
  final _locationController = TextEditingController();

  @override
  void dispose() {
    _incomeController.dispose();
    _familyMembersController.dispose();
    _childrenController.dispose();
    _ageController.dispose();
    _budgetController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!(_formKey.currentState?.validate() ?? false) || _isMarried == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("모든 항목을 입력해주세요.")));
      return;
    }

    setState(() => _isLoading = true);

    final requestData = AiDiagnosisRequest(
      incomeQuintile: _incomeQuintile!,
      currentIncome: int.parse(_incomeController.text),
      familyMembers: int.parse(_familyMembersController.text),
      childrenCount: int.parse(_childrenController.text),
      isMarried: _isMarried!,
      age: int.parse(_ageController.text),
      availableBudget: int.parse(_budgetController.text),
      location: _locationController.text,
    );

    try {
      final apiService = ApiService();
      final result = await apiService.getAiDiagnosis(requestData);

      // 이전 화면으로 진단 결과를 반환하며 돌아갑니다.
      if (mounted) {
        Navigator.pop(context, result);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('오류: ${e.toString()}')));
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("AI 주거 상황 진단")),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            DropdownButtonFormField<int>(
              decoration: const InputDecoration(labelText: "소득 분위", border: OutlineInputBorder()),
              value: _incomeQuintile,
              hint: const Text("소득 분위 선택"),
              items: List.generate(10, (index) => index + 1)
                  .map((e) => DropdownMenuItem(value: e, child: Text("$e분위")))
                  .toList(),
              onChanged: (value) => setState(() => _incomeQuintile = value),
              validator: (value) => value == null ? '필수 항목입니다.' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _incomeController,
              decoration: const InputDecoration(labelText: '현재 소득 (단위: 만원)', border: OutlineInputBorder()),
              keyboardType: TextInputType.number,
              validator: (value) => value!.isEmpty ? '필수 항목입니다.' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _familyMembersController,
              decoration: const InputDecoration(labelText: '가족 인원 수', border: OutlineInputBorder()),
              keyboardType: TextInputType.number,
              validator: (value) => value!.isEmpty ? '필수 항목입니다.' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _childrenController,
              decoration: const InputDecoration(labelText: '자녀 수', border: OutlineInputBorder()),
              keyboardType: TextInputType.number,
              validator: (value) => value!.isEmpty ? '필수 항목입니다.' : null,
            ),
            const SizedBox(height: 16),
            const Text("기혼 여부", style: TextStyle(fontSize: 16)),
            Row(children: [
              Expanded(child: RadioListTile<bool>(title: const Text('기혼'), value: true, groupValue: _isMarried, onChanged: (value) => setState(() => _isMarried = value))),
              Expanded(child: RadioListTile<bool>(title: const Text('미혼'), value: false, groupValue: _isMarried, onChanged: (value) => setState(() => _isMarried = value)))
            ]),
            const SizedBox(height: 16),
            TextFormField(
              controller: _ageController,
              decoration: const InputDecoration(labelText: '현재 나이', border: OutlineInputBorder()),
              keyboardType: TextInputType.number,
              validator: (value) => value!.isEmpty ? '필수 항목입니다.' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _budgetController,
              decoration: const InputDecoration(labelText: '사용가능한 예산 (단위: 만원)', border: OutlineInputBorder()),
              keyboardType: TextInputType.number,
              validator: (value) => value!.isEmpty ? '필수 항목입니다.' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _locationController,
              decoration: const InputDecoration(labelText: '학교/직장 위치', border: OutlineInputBorder()),
              validator: (value) => value!.isEmpty ? '필수 항목입니다.' : null,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _isLoading ? null : _submitForm,
              style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
              child: _isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text('진단 결과 보기', style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}