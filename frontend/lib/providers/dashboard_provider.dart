import 'package:frontend/modals/board.dart';
import 'package:frontend/modals/column.dart';
import 'package:frontend/services/board_service.dart';
import 'package:frontend/services/column_services.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';


part 'dashboard_provider.g.dart'; 

@riverpod
class Dashboard extends _$Dashboard {

  // creating local instance that handle the http request
  final _service = BoardService();           
  final _columnService = ColumnService();

  @override
  Future<DashboardState> build() async {
    String userFetch = await _service.getUser();   //fetch user email from back end
    String userName=userFetch.split('@').first;
    String user = userName[0].toUpperCase() + userName.substring(1).toLowerCase();
    final boards = await fetchBoards();       //fetch all boarad and their nested data

    return DashboardState(        //return a custom object with these details
      user: user,
      boards: boards,
    );
  }

  Future<List<Board>> fetchBoards() async {      //get the board and list th ecol that they have
    final boards = await _service.getBoards();
    List<Board> boardsWithDetails = [];

    for (var board in boards) {
      final columnsData = await _columnService.getColumns(board.id);
      final cols = columnsData
          .map((c) => KanbanColumn.fromJson(c))
          .toList();

      boardsWithDetails.add(board.copyWith(columnNames: cols));  //create a new board object that includes these column using this method
    }
    return boardsWithDetails;
  }
 
  Future<void> createBoard(String name) async {     //create boards
    state = await AsyncValue.guard(() async {        //asyncvalue.gaurd handles try / catch logic automaicaly for Riverpod
      await _service.addBoard(name);
      ref.invalidateSelf();
      return future;
    });
  }

  Future<void> deleteBoard(String boardId) async {  //delete board
    state = await AsyncValue.guard(() async {
      await _service.deleteBoard(boardId);
      ref.invalidateSelf();
      return future;
    });
  }
}





