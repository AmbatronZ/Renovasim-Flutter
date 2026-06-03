import 'package:flutter/material.dart';
import '../../data/models/project_model.dart';
import '../../data/repositories/project_repository.dart';

class ProjectProvider extends ChangeNotifier {
  List<ProjectModel> _projects = [];
  ProjectModel? _selectedProject;
  bool _isLoading = false;
  String? _error;

  List<ProjectModel> get projects => _projects;
  ProjectModel? get selectedProject => _selectedProject;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadProjects(int userId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _projects = await ProjectRepository.getProjectsByUserId(userId);
      _error = null;
    } catch (e) {
      _error = e.toString();
      _projects = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadProjectById(int projectId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _selectedProject = await ProjectRepository.getProjectById(projectId);
      _error = null;
    } catch (e) {
      _error = e.toString();
      _selectedProject = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<ProjectModel> createProject({
    required int userId,
    required String name,
    required String roomType,
    required double areaSize,
    double totalCost = 0,
    String status = 'draft',
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final project = await ProjectRepository.createProject(
        userId: userId,
        name: name,
        roomType: roomType,
        areaSize: areaSize,
        totalCost: totalCost,
        status: status,
      );
      _projects.insert(0, project);
      _selectedProject = project;
      _error = null;
      return project;
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateProject(int projectId, Map<String, dynamic> data) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final updatedProject = await ProjectRepository.updateProject(projectId, data);
      final index = _projects.indexWhere((p) => p.id == projectId);
      if (index != -1) {
        _projects[index] = updatedProject;
      }
      if (_selectedProject?.id == projectId) {
        _selectedProject = updatedProject;
      }
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteProject(int projectId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await ProjectRepository.deleteProject(projectId);
      _projects.removeWhere((p) => p.id == projectId);
      if (_selectedProject?.id == projectId) {
        _selectedProject = null;
      }
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void selectProject(ProjectModel project) {
    _selectedProject = project;
    notifyListeners();
  }

  void clearSelection() {
    _selectedProject = null;
    notifyListeners();
  }
}
