import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart'; // 1번 오류 해결: 패키지 import
import 'package:pdf_render/pdf_render.dart';

class MlService {
  Future<String> getTextFromImage(File imageFile) async {
    try {
      final textRecognizer = TextRecognizer(script: TextRecognitionScript.korean);
      final inputImage = InputImage.fromFilePath(imageFile.path);
      final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);
      String resultText = recognizedText.text;
      textRecognizer.close();

      if (resultText.isEmpty) {
        return "이미지에서 텍스트를 인식하지 못했습니다. 더 선명한 사진을 사용해보세요.";
      }
      return resultText;
    } catch (e) {
      print("텍스트 인식 중 오류 발생: $e");
      return "텍스트를 인식하는 중 오류가 발생했습니다.";
    }
  }
}

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

  Future<void> _pickImageFromCamera() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _selectedFile = File(pickedFile.path);
        _analysisResult = null;
      });
    }
  }

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

  String _analyzeTextForKeywords(String text) {
    final keywords = ['독소조항', '불공정', '일방적 해지', '위약금 과다'];
    List<String> foundKeywords = [];
    for (var keyword in keywords) {
      if (text.contains(keyword)) {
        foundKeywords.add(keyword);
      }
    }

    if (foundKeywords.isEmpty) {
      return "특별한 위험 조항이 발견되지 않았습니다.";
    } else {
      return "다음과 같은 잠재적 위험 조항이 포함되어 있을 수 있습니다: ${foundKeywords.join(', ')}";
    }
  }

  Future<void> _startAnalysis() async {
    if (_selectedFile == null) return;

    setState(() => _isLoading = true);

    try {
      File imageToProcess = _selectedFile!;

      if (_selectedFile!.path.toLowerCase().endsWith('.pdf')) {
        setState(() => _analysisResult = "PDF 파일을 이미지로 변환 중...");
        final doc = await PdfDocument.openFile(_selectedFile!.path);
        final page = await doc.getPage(1);

        // 2번 오류 해결: .round() 추가
        final pageImage = await page.render(
          width: (page.width * 2).round(),
          height: (page.height * 2).round(),
        );

        // 1번 오류 해결: getTemporaryDirectory 함수 사용 가능
        final tempDir = await getTemporaryDirectory();
        final imageFile = File('${tempDir.path}/pdf_page.png');

        // 3번 오류 해결: .bytes를 .pixels로 변경
        await imageFile.writeAsBytes(pageImage.pixels);
        imageToProcess = imageFile;
      }

      final extractedText = await _mlService.getTextFromImage(imageToProcess);
      final analysis = _analyzeTextForKeywords(extractedText);

      setState(() => _analysisResult = "--- [인식된 전체 텍스트] ---\n$extractedText\n\n--- [위험 조항 분석] ---\n$analysis");
    } catch (e) {
      setState(() => _analysisResult = '분석 중 오류가 발생했습니다: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI 계약서 분석'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: _pickImageFromCamera,
                  icon: const Icon(Icons.camera_alt),
                  label: const Text('카메라'),
                ),
                ElevatedButton.icon(
                  onPressed: _pickFile,
                  icon: const Icon(Icons.attach_file),
                  label: const Text('파일 선택'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            if (_selectedFile != null)
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    Text(
                      '선택된 파일: ${_selectedFile!.path.split('/').last}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    if (!_selectedFile!.path.toLowerCase().endsWith('.pdf'))
                      Image.file(
                        _selectedFile!,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                  ],
                ),
              ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: (_selectedFile == null || _isLoading) ? null : _startAnalysis,
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('분석 시작'),
            ),
            const SizedBox(height: 20),
            if (_analysisResult != null)
              Container(
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _analysisResult!,
                  style: const TextStyle(fontSize: 15),
                ),
              ),
          ],
        ),
      ),
    );
  }
}