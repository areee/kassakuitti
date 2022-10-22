enum PreviousRow { notSet, refund }

class RowHelper {
  PreviousRow previousRow;
  int rowAmount;

  RowHelper({this.previousRow = PreviousRow.notSet, this.rowAmount = 0});
}
