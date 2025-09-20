import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
        if (isStartDate) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  Map<String, dynamic> _calculateDDayAndProgress() {
    Map<String, dynamic> result = {"dDayText": "D-Day", "percentageValue": 0.0, "percentageText": "0.0%"};
    if (_startDate == null || _endDate == null || _endDate!.isBefore(_startDate!)) return result;
    final today = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    final remainingDays = _endDate!.difference(today).inDays;
    result["dDayText"] = remainingDays >= 0 ? "D-$remainingDays" : "D+${remainingDays.abs()}";
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