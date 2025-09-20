import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:zari/services/api_service.dart'; // ApiService import

class AiAnalysisPage extends StatefulWidget {
  const AiAnalysisPage({super.key});

  @override
  State<AiAnalysisPage> createState() => _AiAnalysisPageState();
}

class _AiAnalysisPageState extends State<AiAnalysisPage> {
  File? _selectedFile;
  String? _analysisResult;
  bool _isLoading = false;

  // 카메라로 사진 찍기
  Future<void> _pickImageFromCamera() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _selectedFile = File(pickedFile.path);
        _analysisResult = null; // 새 파일 선택 시 이전 결과 초기화
      });
    }
  }

  // 갤러리에서 사진 또는 PDF 선택
  Future<void> _pickFile() async {
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
  }

  // AI 분석 시작
  Future<void> _startAnalysis() async {
    if (_selectedFile == null) return;

    setState(() => _isLoading = true);
    try {
      // ApiService를 통해 백엔드로 파일 전송 및 분석 요청
      final result = await ApiService().analyzeContractFile(_selectedFile!);
      setState(() => _analysisResult = result);
    } catch (e) {
      setState(() => _analysisResult = '분석 중 오류가 발생했습니다: $e');
    } finally {
      setState(() => _isLoading = false);
    }
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
            if (_selectedFile == null) ...[
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
            if (_selectedFile != null) ...[
              _buildFileInfoCard(),
              const SizedBox(height: 32),
              if (!_isLoading)
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
              const Center(child: CircularProgressIndicator()),
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
        textStyle: const TextStyle(fontSize: 16),
      ),
    );
  }

  Widget _buildFileInfoCard() {
    final fileName = _selectedFile!.path.split('/').last;
    return Card(
      elevation: 2,
      child: ListTile(
        leading: const Icon(Icons.file_present_rounded, color: Colors.red),
        title: Text(fileName, overflow: TextOverflow.ellipsis),
        subtitle: const Text('분석할 파일이 선택되었습니다.'),
        trailing: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => setState(() => _selectedFile = null),
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