import 'package:flutter/material.dart';

class TableConfig<T> extends StatelessWidget {
  final String title;
  final List<T> data;
  final List<String> columns;
  final List<Widget Function(T)> rowBuilder;

  const TableConfig({
    super.key,
    required this.title,
    required this.data,
    required this.columns,
    required this.rowBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
              title,
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.deepPurpleAccent
              ),
          ),
        ),
        Directionality(
          textDirection: TextDirection.rtl,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: DataTable(
                columns: columns.map((col) => DataColumn(label: Text(col))).toList(),
                rows: data.map((item) {
                  return DataRow(cells: rowBuilder.map((builder) => DataCell(builder(item))).toList());
                }).toList(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class DateTimeStyle extends StatelessWidget {
  const DateTimeStyle({
    super.key,
    required this.dateInput
  });

  final String dateInput;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.deepPurpleAccent.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        dateInput,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Colors.deepPurpleAccent.shade700,
        ),
      ),
    );
  }
}

class StatusLabelStyle extends StatelessWidget {
  const StatusLabelStyle({super.key, required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(
        status,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      backgroundColor: status == 'Confirmed'
          ? Colors.green.shade400
          : Colors.orange.shade400,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
    );
  }
}