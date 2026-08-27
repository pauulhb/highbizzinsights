import 'package:uuid/uuid.dart';

import '../models/domain_models.dart';
import '../services/local_database.dart';

class CommercialRepository {
  CommercialRepository({LocalDatabase? db}) : _db = db ?? LocalDatabase.instance;

  final LocalDatabase _db;
  final _uuid = const Uuid();

  Future<CommercialAction> record({
    required String visitId,
    required CommercialActionType type,
    required Map<String, String> fields,
  }) async {
    final action = CommercialAction(
      id: _uuid.v4(),
      visitId: visitId,
      type: type,
      fields: fields,
      createdAt: DateTime.now(),
    );
    await _db.insertCommercialAction(action);
    await _db.enqueueSync('commercial_action', action.id);
    return action;
  }

  Future<List<CommercialAction>> forVisit(String visitId) => _db.actionsForVisit(visitId);
}
