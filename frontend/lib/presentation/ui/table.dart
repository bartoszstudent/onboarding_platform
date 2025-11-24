import 'package:flutter/material.dart';

class AppTable extends StatelessWidget {
  final List<String> columns;
  final List<List<Widget>> rows;

  const AppTable({super.key, required this.columns, required this.rows});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: columns
            .map((c) => DataColumn(
                label: Text(c,
                    style: const TextStyle(fontWeight: FontWeight.w600))))
            .toList(),
        rows: rows
            .map((r) => DataRow(
                cells: r
                    .map((c) => DataCell(Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: c)))
                    .toList()))
            .toList(),
      ),
    );
  }
}
