import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mentor_me/config/paths.dart';
import 'package:mentor_me/models/event_model.dart';
import 'package:mentor_me/repositories/event/base_event_repository.dart';
import 'package:mentor_me/utils/session_helper.dart';

class EventRepository extends BaseEventRepository {
  final FirebaseFirestore _firebaseFirestore;

  EventRepository({FirebaseFirestore? firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  Future<Event> getEvent({required String eventId}) async {
    final event =
        await _firebaseFirestore.collection(Paths.events).doc(eventId).get();
    return Event.fromMap(event.data()!, eventId);
  }

  Future<void> myEvents({required Event event, required refId}) async {
    await _firebaseFirestore
        .collection(Paths.usersEvents)
        .doc(event.creatorId)
        .collection(Paths.userEvent)
        .doc(refId.id)
        .set({});
  }

  Future<void> createEvent({required Event event}) async {
    final refId =
        await _firebaseFirestore.collection(Paths.events).add(event.toMap());
    await myEvents(event: event, refId: refId).then((value) async {
      await joinEvent(roomCode: event.roomCode, userId: SessionHelper.uid!);
    });
  }

  Future<List<Event>> getUserEvents({required String userId}) async {
    List<String> eventIds = [];
    List<Event> events = [];
    final snap = await _firebaseFirestore
        .collection(Paths.usersEvents)
        .doc(userId)
        .collection(Paths.userEvent)
        .get();
    for (var element in snap.docs) {
      eventIds.add(element.id);
    }
    eventIds.forEach((element) async {
      final event = await getEvent(eventId: element);
      events.add(event);
    });
    return events;
  }

  Future<Event?> joinEvent(
      {required String roomCode, required String userId}) async {
    final collection = _firebaseFirestore.collection(Paths.events);
    final snap = await collection.get();
    for (var element in snap.docs) {
      if (element.data()["roomCode"] == roomCode) {
        collection.doc(element.id).update({
          "memberIds": FieldValue.arrayUnion([userId])
        });
        await _firebaseFirestore
            .collection(Paths.usersEvents)
            .doc(userId)
            .collection(Paths.userEvent)
            .doc(element.id)
            .set({});
        return Event.fromMap(element.data(), element.id);
      }
    }
    return null;
  }
}
