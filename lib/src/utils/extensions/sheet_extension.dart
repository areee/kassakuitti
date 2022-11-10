import 'package:excel/excel.dart';

/// Extension for [Sheet].
extension SheetExtension on Sheet {
  /// Updates the style for a selected row.
  void updateSelectedRowStyle(int rowIndex, CellStyle cellStyle) {
    var rowDatas = row(rowIndex);

    for (var rowData in rowDatas) {
      updateCell(rowData!.cellIndex, rowData.value, cellStyle: cellStyle);
    }
  }
}
