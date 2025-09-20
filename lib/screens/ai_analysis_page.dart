import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:zari/services/ml_service.dart';

class AiAnalysisPage extends StatefulWidget {
  const AiAnalysisPage({super.key});

  @override
  State<AiAnalysisPage> createState() => _AiAnalysisPageState();
}

class _AiAnalysisPageState extends State<AiAnalysisPage> {
  File? _selectedFile;
  String? _analysisResult;
  bool _isLoading = false;
  final MlService _mlService = MlService();

  // 카메라로 사진 찍기
  Future<void> _pickImageFromCamera() async {
    try {
      final pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);
      if (pickedFile != null) {
        setState(() {
          _selectedFile = File(pickedFile.path);
          _analysisResult = null; // 새 파일 선택 시 이전 결과 초기화
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("카메라를 열 수 없습니다: ${e.toString()}"))
      );
    }
  }

  // 갤러리에서 사진 또는 PDF 선택
  Future<void> _pickFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
      );
      if (result != null && result.files.single.path != null) {
        setState(() {
          _selectedFile = File(result.files.single.path!);
          _analysisResult = null;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("파일을 가져올 수 없습니다: ${e.toString()}"))
      );
    }
  }

  // AI 분석 시작
  Future<void> _startAnalysis() async {
    if (_selectedFile == null) return;

    setState(() => _isLoading = true);
    try {
      // 1. 온디바이스 ML Service를 통해 이미지에서 텍스트 추출
      final extractedText = await _mlService.getTextFromImage(_selectedFile!);

      // 2. (간단한 버전) 추출된 텍스트에서 위험 키워드 분석
      final analysis = _analyzeTextForKeywords(extractedText);

      setState(() => _analysisResult = "--- [인식된 전체 텍스트] ---\n$extractedText\n\n--- [위험 조항 분석] ---\n$analysis");

    } catch (e) {
      setState(() => _analysisResult = '분석 중 오류가 발생했습니다: $e');
    } finally {
      if(mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  // 간단한 키워드 기반 텍스트 분석 함수
  String _analyzeTextForKeywords(String text) {
    List<String> findings = [];

    if (text.contains("모든 수선") || text.contains("모든 비용")) {
      findings.add("- '모든 수선/비용' 조항: 임대인의 기본 수선 의무를 임차인에게 과도하게 전가할 수 있는 위험한 조항입니다.");
    }
    if (text.contains("임의로 해지")) {
      findings.add("- '임의 해지' 조항: 임대인이 일방적으로 계약을 해지할 수 있다는 조항은 불공정할 수 있습니다.");
    }
    if (text.contains("권리금")) {
      findings.add("- '권리금' 관련 조항: 주택 임대차에서는 일반적이지 않은 조항입니다. 상가 계약이 아닌지 확인이 필요합니다.");
    }

    if (findings.isEmpty) {
      return "특별히 위험해 보이는 키워드가 발견되지 않았습니다. 하지만 전체 내용을 꼼꼼히 확인하세요.";
    }

    return findings.join("\n");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AI 계약서 분석')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. 파일 선택 UI
            if (_selectedFile == null && !_isLoading) ...[
              const Icon(Icons.cloud_upload_outlined, size: 80, color: Colors.grey),
              const SizedBox(height: 16),
              const Text('계약서 파일을 업로드하거나 촬영하여 AI 분석을 받아보세요.', textAlign: TextAlign.center, style: TextStyle(fontSize: 16, color: Colors.black54)),
              const SizedBox(height: 32),
              _buildOptionButton(
                icon: Icons.camera_alt_outlined,
                label: '카메라로 촬영',
                onPressed: _pickImageFromCamera,
              ),
              const SizedBox(height: 16),
              _buildOptionButton(
                icon: Icons.attach_file_rounded,
                label: '사진/PDF 파일 업로드',
                onPressed: _pickFile,
              ),
            ],

            // 2. 파일 선택 후 UI
            if (_selectedFile != null && !_isLoading) ...[
              _buildFileInfoCard(),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _startAnalysis,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                child: const Text('AI 분석 시작하기', style: TextStyle(fontSize: 18)),
              ),
            ],

            const SizedBox(height: 40),

            // 3. 분석 중 또는 결과 표시 UI
            if (_isLoading)
              const Center(child: Column(
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 20),
                  Text('이미지를 분석 중입니다...', style: TextStyle(fontSize: 16)),
                ],
              )),
            if (_analysisResult != null)
              _buildResultCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionButton({required IconData icon, required String label, required VoidCallback onPressed}) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(double.infinity, 50),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        foregroundColor: Colors.black54,
        side: BorderSide(color: Colors.grey.shade300),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _buildFileInfoCard() {
    final fileName = _selectedFile!.path.split('/').last;
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: const Icon(Icons.file_present_rounded, color: Colors.red),
        title: Text(fileName, overflow: TextOverflow.ellipsis),
        subtitle: const Text('분석할 파일이 선택되었습니다.'),
        trailing: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => setState(() {
            _selectedFile = null;
            _analysisResult = null;
          }),
        ),
      ),
    );
  }

  Widget _buildResultCard() {
    return Card(
      elevation: 4,
      color: Colors.grey[50],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('AI 분석 결과', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black)),
            const Divider(height: 24),
            Text(_analysisResult!, style: const TextStyle(fontSize: 16, height: 1.5, color: Colors.black87)),
          ],
        ),
      ),
    );
  }
}