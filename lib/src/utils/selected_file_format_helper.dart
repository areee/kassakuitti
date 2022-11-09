/// Selected file format: excel or csv
enum SelectedFileFormat {
  xlsx('XLSX'), // Excel
  csv('CSV');

  final String term;
  const SelectedFileFormat(this.term);

  String get value => term;
}
