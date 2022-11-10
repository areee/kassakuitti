/// Selected file format: xlsx (XLSX), csv (CSV)
enum SelectedFileFormat {
  /// XLSX = Excel
  xlsx('XLSX'),

  /// CSV
  csv('CSV');

  /// A file format name.
  final String _fileFormatName;

  /// Constructor for [SelectedFileFormat] that sets a file format name.
  const SelectedFileFormat(this._fileFormatName);

  /// Returns a file format name.
  String get fileFormatName => _fileFormatName;
}
