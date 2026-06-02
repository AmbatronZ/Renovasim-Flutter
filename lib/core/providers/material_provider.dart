import 'package:flutter/material.dart';
import '../../data/models/material_model.dart';
import '../../data/models/project_material_model.dart';
import '../../data/repositories/material_repository.dart';
import '../../data/repositories/project_material_repository.dart';

class MaterialProvider extends ChangeNotifier {
  List<MaterialModel> _allMaterials = [];
  List<MaterialModel> _materialsByCategory = [];
  List<ProjectMaterialModel> _projectMaterials = [];
  bool _isLoading = false;
  String? _error;

  List<MaterialModel> get allMaterials => _allMaterials;
  List<MaterialModel> get materialsByCategory => _materialsByCategory;
  List<ProjectMaterialModel> get projectMaterials => _projectMaterials;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadAllMaterials() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _allMaterials = await MaterialRepository.getAllMaterials();
      _error = null;
    } catch (e) {
      _error = e.toString();
      _allMaterials = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadMaterialsByCategory(String category) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _materialsByCategory = await MaterialRepository.getMaterialsByCategory(category);
      _error = null;
    } catch (e) {
      _error = e.toString();
      _materialsByCategory = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadProjectMaterials(int projectId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _projectMaterials = await ProjectMaterialRepository.getMaterialsByProjectId(projectId);
      _error = null;
    } catch (e) {
      _error = e.toString();
      _projectMaterials = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addMaterialToProject({
    required int projectId,
    required int materialId,
    required double quantity,
    required double subtotal,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final projectMaterial = await ProjectMaterialRepository.addMaterialToProject(
        projectId: projectId,
        materialId: materialId,
        quantity: quantity,
        subtotal: subtotal,
      );
      _projectMaterials.insert(0, projectMaterial);
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateProjectMaterial(
    int projectMaterialId,
    Map<String, dynamic> data,
  ) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final updatedMaterial = await ProjectMaterialRepository.updateProjectMaterial(
        projectMaterialId,
        data,
      );
      final index = _projectMaterials.indexWhere((m) => m.id == projectMaterialId);
      if (index != -1) {
        _projectMaterials[index] = updatedMaterial;
      }
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> removeMaterialFromProject(int projectMaterialId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await ProjectMaterialRepository.removeMaterialFromProject(projectMaterialId);
      _projectMaterials.removeWhere((m) => m.id == projectMaterialId);
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
