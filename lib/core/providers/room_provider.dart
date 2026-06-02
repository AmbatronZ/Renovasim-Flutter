import 'package:flutter/material.dart';
import '../../data/models/room_model.dart';
import '../../data/models/room_object_model.dart';
import '../../data/repositories/room_repository.dart';
import '../../data/repositories/room_object_repository.dart';

class RoomProvider extends ChangeNotifier {
  List<RoomModel> _rooms = [];
  RoomModel? _selectedRoom;
  List<RoomObjectModel> _roomObjects = [];
  bool _isLoading = false;
  String? _error;

  List<RoomModel> get rooms => _rooms;
  RoomModel? get selectedRoom => _selectedRoom;
  List<RoomObjectModel> get roomObjects => _roomObjects;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadRooms(int userId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _rooms = await RoomRepository.getRoomsByUserId(userId);
      _error = null;
    } catch (e) {
      _error = e.toString();
      _rooms = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadRoomById(int roomId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _selectedRoom = await RoomRepository.getRoomById(roomId);
      await loadRoomObjects(roomId);
      _error = null;
    } catch (e) {
      _error = e.toString();
      _selectedRoom = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadRoomObjects(int roomId) async {
    try {
      _roomObjects = await RoomObjectRepository.getObjectsByRoomId(roomId);
      _error = null;
    } catch (e) {
      _error = e.toString();
      _roomObjects = [];
    }
    notifyListeners();
  }

  Future<void> createRoom({
    required int userId,
    String? name,
    String? description,
    double width = 4,
    double length = 5,
    double height = 3,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final room = await RoomRepository.createRoom(
        userId: userId,
        name: name,
        description: description,
        width: width,
        length: length,
        height: height,
      );
      _rooms.insert(0, room);
      _selectedRoom = room;
      _roomObjects = [];
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateRoom(int roomId, Map<String, dynamic> data) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final updatedRoom = await RoomRepository.updateRoom(roomId, data);
      final index = _rooms.indexWhere((r) => r.id == roomId);
      if (index != -1) {
        _rooms[index] = updatedRoom;
      }
      if (_selectedRoom?.id == roomId) {
        _selectedRoom = updatedRoom;
      }
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteRoom(int roomId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await RoomRepository.deleteRoom(roomId);
      _rooms.removeWhere((r) => r.id == roomId);
      if (_selectedRoom?.id == roomId) {
        _selectedRoom = null;
        _roomObjects = [];
      }
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addObject({
    required String type,
    required List<double> position,
    required List<double> rotation,
    required List<double> scale,
    double? confidence,
    Map<String, dynamic>? metadata,
  }) async {
    if (_selectedRoom == null) {
      _error = 'Ruangan tidak terpilih';
      notifyListeners();
      return;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final object = await RoomObjectRepository.createObject(
        roomId: _selectedRoom!.id,
        type: type,
        position: position,
        rotation: rotation,
        scale: scale,
        confidence: confidence,
        metadata: metadata,
      );
      _roomObjects.insert(0, object);
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateObject(int objectId, Map<String, dynamic> data) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final updatedObject = await RoomObjectRepository.updateObject(objectId, data);
      final index = _roomObjects.indexWhere((o) => o.id == objectId);
      if (index != -1) {
        _roomObjects[index] = updatedObject;
      }
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteObject(int objectId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await RoomObjectRepository.deleteObject(objectId);
      _roomObjects.removeWhere((o) => o.id == objectId);
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void selectRoom(RoomModel room) {
    _selectedRoom = room;
    notifyListeners();
  }

  void clearSelection() {
    _selectedRoom = null;
    _roomObjects = [];
    notifyListeners();
  }
}
