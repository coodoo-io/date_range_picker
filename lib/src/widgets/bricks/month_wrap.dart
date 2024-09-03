import 'package:flutter/material.dart';
import 'package:flutter_date_range_picker/src/models.dart';

/// A widget that displays a wrap of a month's worth of day tiles.
class MonthWrapWidget extends StatelessWidget {
  /// Constructs a [MonthWrapWidget] widget.
  const MonthWrapWidget({
    Key? key,
    required this.days,
    required this.delta,
    required this.dayTileBuilder,
    required this.placeholderBuilder,
  }) : super(key: key);

  /// The list of [DayModel]s to display.
  final List<DayModel> days;

  /// The offset of the first day to display.
  final int delta;

  /// A builder that builds a day tile given a [DayModel].
  final Widget Function(DayModel dayModel) dayTileBuilder;

  /// A builder that builds a placeholder widget given a delta index.
  final Widget Function(int deltaIndex) placeholderBuilder;

  @override
  Widget build(BuildContext context) {
    int column = 7;
    int row = (days.length / column).ceil() + 1;

    return Column(
      children: List.generate(row, (rowIndex) {
        return Row(
          children: List.generate(column, (columnIndex) {
            //Special case when the delta is negative we need to place some empty spaces
            if (delta < 0 && rowIndex == 0) {
              if (columnIndex < (column + delta)) {
                return placeholderBuilder(columnIndex);
              } else {
                var dayModel = days[0];
                return dayTileBuilder(dayModel);
              }
            }
            int localRowIndex = 0;
            if (delta < 0 && rowIndex > 0) {
              localRowIndex = rowIndex - 1;
            } else {
              localRowIndex = rowIndex;
            }

            //placeholder before first day in month
            if (localRowIndex * column + columnIndex < delta) {
              return placeholderBuilder(columnIndex);
            }
            //Placeholder behind the last day in month
            if (localRowIndex * column + columnIndex - delta >= days.length) {
              return placeholderBuilder(columnIndex);
            }

            var dayModel = days[localRowIndex * column + columnIndex - delta];

            return dayTileBuilder(dayModel);
          }),
        );
      }),
    );
  }
}
