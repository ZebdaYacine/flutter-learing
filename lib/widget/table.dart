import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:table/model/user.dart';

class PlutoGridExamplePage extends StatefulWidget {
  final List<User> usersDB;

  const PlutoGridExamplePage({super.key, required this.usersDB});

  @override
  State<PlutoGridExamplePage> createState() => _PlutoGridExamplePageState();
}

class _PlutoGridExamplePageState extends State<PlutoGridExamplePage> {
  final List<PlutoColumn> columns = <PlutoColumn>[
    PlutoColumn(
      title: 'Id',
      field: 'id',
      type: PlutoColumnType.text(),
    ),
    PlutoColumn(
      title: 'Name',
      field: 'name',
      type: PlutoColumnType.text(),
    ),
    PlutoColumn(
      title: 'Age',
      field: 'age',
      type: PlutoColumnType.number(),
    ),
    PlutoColumn(
      title: 'Role',
      field: 'role',
      type: PlutoColumnType.select(<String>[
        'Programmer',
        'Designer',
        'Owner',
      ]),
    ),
    PlutoColumn(
      title: 'Joined',
      field: 'joined',
      type: PlutoColumnType.date(),
    ),
    PlutoColumn(
      title: 'Working time',
      field: 'working_time',
      type: PlutoColumnType.time(),
    ),
    PlutoColumn(
      title: 'salary',
      field: 'salary',
      type: PlutoColumnType.currency(),
    ),
  ];

  List<PlutoRow> buildRouws(List<User> usersDB) {
    return usersDB.map((user) => PlutoRow(cells: user.toPlutoCells())).toList();
  }

  List<PlutoRow> rows = [];
  List<PlutoRow> fetchingRows = [];

  @override
  initState() {
    super.initState();
    setState(() {
      rows = buildRouws(widget.usersDB);
      fetchingRows = buildRouws(widget.usersDB);
    });
  }

  void _showAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Alert'),
          content: const Text('This is an alert dialog.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Perform some action
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  late final PlutoGridStateManager stateManager;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(15),
        child: PlutoGrid(
          columns: columns,
          rows: fetchingRows,
          onLoaded: (PlutoGridOnLoadedEvent event) {
            stateManager = event.stateManager;
            stateManager.setShowColumnFilter(true);
          },
          onChanged: (PlutoGridOnChangedEvent event) {
            var d = event.row.cells;
            print(User.fromPlutoCells(d).toJson());
          },
          onRowDoubleTap: (event) {
            _showAlertDialog(context);
          },
          configuration: const PlutoGridConfiguration(),
          createFooter: (stateManager) {
            return PlutoLazyPagination(
              initialPage: 1,
              initialFetch: true,
              fetchWithSorting: true,
              fetchWithFiltering: true,
              pageSizeToMove: null,
              fetch: fetch,
              stateManager: stateManager,
            );
          },
        ),
      ),
    );
  }

  Future<PlutoLazyPaginationResponse> fetch(
    PlutoLazyPaginationRequest request,
  ) async {
    var tempList = fetchingRows;
    if (request.filterRows.isNotEmpty) {
      final filter = FilterHelper.convertRowsToFilter(
        request.filterRows,
        stateManager.refColumns,
      );
      tempList = fetchingRows.where(filter!).toList();
    } else {
      fetchingRows = rows;
    }

    if (request.sortColumn != null && !request.sortColumn!.sort.isNone) {
      tempList = [...tempList];

      tempList.sort((a, b) {
        final sortA = request.sortColumn!.sort.isAscending ? a : b;
        final sortB = request.sortColumn!.sort.isAscending ? b : a;
        return request.sortColumn!.type.compare(
          sortA.cells[request.sortColumn!.field]!.valueForSorting,
          sortB.cells[request.sortColumn!.field]!.valueForSorting,
        );
      });
    }

    final page = request.page;
    const pageSize = 20;
    final totalPage = (tempList.length / pageSize).ceil();
    final start = (page - 1) * pageSize;
    final end = start + pageSize;

    Iterable<PlutoRow> pageRows = tempList.getRange(
      max(0, start),
      min(tempList.length, end),
    );

    return PlutoLazyPaginationResponse(
      totalPage: totalPage,
      rows: pageRows.toList(),
    );
  }
}
