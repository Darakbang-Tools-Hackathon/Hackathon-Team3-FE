import 'package:flutter/material.dart';

class TimePickerWidget extends StatefulWidget {
  final int initialHour;
  final int initialMinute;
  final String initialPeriod;
  final Function(int, int, String) onChanged;

  const TimePickerWidget({
    super.key,
    required this.initialHour,
    required this.initialMinute,
    required this.initialPeriod,
    required this.onChanged,
  });

  @override
  State<TimePickerWidget> createState() => _TimePickerWidgetState();
}

class _TimePickerWidgetState extends State<TimePickerWidget> {
  late int hour;
  late int minute;
  late String period;

  @override
  void initState() {
    super.initState();
    hour = widget.initialHour;
    minute = widget.initialMinute;
    period = widget.initialPeriod;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3))
        ],
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          DropdownButton<int>(
            value: hour,
            items: List.generate(12, (i) => i + 1)
                .map((h) => DropdownMenuItem(value: h, child: Text('$h')))
                .toList(),
            onChanged: (v) {
              setState(() => hour = v!);
              widget.onChanged(hour, minute, period);
            },
          ),
          const Text(" : ", style: TextStyle(fontSize: 18)),
          DropdownButton<int>(
            value: minute,
            items: List.generate(60, (i) => i)
                .map((m) => DropdownMenuItem(value: m, child: Text(m.toString().padLeft(2, '0'))))
                .toList(),
            onChanged: (v) {
              setState(() => minute = v!);
              widget.onChanged(hour, minute, period);
            },
          ),
          const SizedBox(width: 10),
          DropdownButton<String>(
            value: period,
            items: ['AM', 'PM']
                .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                .toList(),
            onChanged: (v) {
              setState(() => period = v!);
              widget.onChanged(hour, minute, period);
            },
          ),
        ],
      ),
    );
  }
}
