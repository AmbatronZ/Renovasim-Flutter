# Flutter Database Integration Guide

## ✅ Complete Implementation Status

Semua models, repositories, dan state management telah diintegrasikan dengan database Supabase.

### Struktur Folder

```
lib/
├── core/
│   ├── auth_service.dart
│   ├── supabase_config.dart
│   ├── theme_provider.dart
│   └── providers/
│       ├── user_session_provider.dart
│       ├── project_provider.dart
│       ├── room_provider.dart
│       └── material_provider.dart
├── data/
│   ├── models/
│   │   ├── user_model.dart
│   │   ├── project_model.dart
│   │   ├── room_model.dart
│   │   ├── room_object_model.dart
│   │   ├── material_model.dart
│   │   └── project_material_model.dart
│   └── repositories/
│       ├── user_repository.dart
│       ├── project_repository.dart
│       ├── room_repository.dart
│       ├── room_object_repository.dart
│       ├── material_repository.dart
│       └── project_material_repository.dart
└── screens/
```

## Database Models

### 1. **UserModel**
- id, name, email, phone, avatar_path
- first_name, last_name, role, account_status
- timezone, language, job_title
- timestamps

### 2. **ProjectModel**
- id, user_id, name, room_type, area_size
- total_cost, status (draft/estimated/completed)
- timestamps

### 3. **RoomModel**
- id, user_id, name, description
- width, length, height
- layout_data (JSON)
- timestamps

### 4. **RoomObjectModel**
- id, room_id, type (bed/chair/table/etc)
- position [x, y, z], rotation [x, y, z], scale [x, y, z]
- confidence, metadata (JSON)
- timestamps

### 5. **MaterialModel**
- id, name, category, price_per_unit, unit
- is_active
- timestamps

### 6. **ProjectMaterialModel**
- id, project_id, material_id
- quantity, subtotal
- timestamps

## Usage Examples

### User Session Management

```dart
// Load user by ID
final userSession = context.read<UserSessionProvider>();
await userSession.loadUser(userId);

// Access current user
final user = userSession.currentUser;
print(user?.name);
print(user?.email);

// Update profile
await userSession.updateProfile(
  firstName: 'John',
  lastName: 'Doe',
  phone: '+62812345678',
  timezone: 'Asia/Jakarta',
);

// Check authentication status
if (userSession.isAuthenticated) {
  // User is logged in
}
```

### Projects Management

```dart
final projectProvider = context.read<ProjectProvider>();

// Load all user projects
await projectProvider.loadProjects(userId);

// Access projects list
final projects = projectProvider.projects;

// Create new project
await projectProvider.createProject(
  userId: userId,
  name: 'Renovasi Ruang Tamu',
  roomType: 'living_room',
  areaSize: 25.5,
);

// Select project
final project = projectProvider.projects.first;
projectProvider.selectProject(project);

// Update project
await projectProvider.updateProject(projectId, {
  'status': 'estimated',
  'total_cost': 5000000,
});

// Delete project
await projectProvider.deleteProject(projectId);
```

### Rooms & 3D Objects

```dart
final roomProvider = context.read<RoomProvider>();

// Load all user rooms
await roomProvider.loadRooms(userId);

// Load specific room with objects
await roomProvider.loadRoomById(roomId);

// Access room data
final room = roomProvider.selectedRoom;
print('Room: ${room?.name}');
print('Dimensions: ${room?.width}x${room?.length}x${room?.height}');

// Access room objects
final objects = roomProvider.roomObjects;

// Create room
await roomProvider.createRoom(
  userId: userId,
  name: 'Master Bedroom',
  description: 'Kamar tidur utama',
  width: 4.5,
  length: 5.0,
  height: 3.0,
);

// Add object to room
await roomProvider.addObject(
  type: 'bed',
  position: [2.0, 2.5, 0.0],
  rotation: [0.0, 0.0, 0.0],
  scale: [1.5, 2.0, 0.8],
  metadata: {'color': 'brown', 'material': 'wood'},
);

// Update object position
await roomProvider.updateObject(objectId, {
  'position': [2.5, 3.0, 0.0],
  'rotation': [0.0, 45.0, 0.0],
});

// Delete object
await roomProvider.deleteObject(objectId);
```

### Materials Management

```dart
final materialProvider = context.read<MaterialProvider>();

// Load all materials
await materialProvider.loadAllMaterials();

// Load materials by category
await materialProvider.loadMaterialsByCategory('ceramic');

// Access materials
final materials = materialProvider.allMaterials;
for (final mat in materials) {
  print('${mat.name}: Rp${mat.pricePerUnit}/${mat.unit}');
}

// Load project materials
await materialProvider.loadProjectMaterials(projectId);

// Add material to project
await materialProvider.addMaterialToProject(
  projectId: projectId,
  materialId: materialId,
  quantity: 50.0,
  subtotal: 2500000.0,
);

// Update material quantity
await materialProvider.updateProjectMaterial(projectMaterialId, {
  'quantity': 75.0,
  'subtotal': 3750000.0,
});

// Remove material from project
await materialProvider.removeMaterialFromProject(projectMaterialId);
```

### In Widgets - Using Consumer

```dart
class ProjectListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ProjectProvider>(
      builder: (context, projectProvider, _) {
        if (projectProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (projectProvider.error != null) {
          return Center(child: Text('Error: ${projectProvider.error}'));
        }

        final projects = projectProvider.projects;
        return ListView.builder(
          itemCount: projects.length,
          itemBuilder: (context, index) {
            final project = projects[index];
            return ListTile(
              title: Text(project.name),
              subtitle: Text('${project.roomType} - ${project.areaSize}m²'),
              trailing: Chip(label: Text(project.status)),
              onTap: () {
                projectProvider.selectProject(project);
                // Navigate to project detail
              },
            );
          },
        );
      },
    );
  }
}
```

### Load Initial User Data (in splash or home screen)

```dart
class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      // Load user from auth/storage
      final userSession = context.read<UserSessionProvider>();
      // Assuming you store userId after login
      final userId = 1; // Get from SharedPreferences or auth state
      
      await userSession.loadUser(userId);
      
      // Load initial data
      final projectProvider = context.read<ProjectProvider>();
      final roomProvider = context.read<RoomProvider>();
      final materialProvider = context.read<MaterialProvider>();
      
      await Future.wait([
        projectProvider.loadProjects(userId),
        roomProvider.loadRooms(userId),
        materialProvider.loadAllMaterials(),
      ]);

      // Navigate to home
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/home');
      }
    } catch (e) {
      // Handle error
      print('Error initializing app: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
```

## Error Handling

Setiap provider memiliki `error` state:

```dart
Consumer<ProjectProvider>(
  builder: (context, provider, _) {
    if (provider.error != null) {
      return Center(
        child: Column(
          children: [
            Text('Error: ${provider.error}'),
            ElevatedButton(
              onPressed: () => provider.loadProjects(userId),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }
    return YourContent();
  },
)
```

## API Endpoints Used

- `GET /rest/v1/users` - Get user data
- `PATCH /rest/v1/users` - Update user profile
- `GET /rest/v1/projects` - Get projects list
- `POST /rest/v1/projects` - Create project
- `PATCH /rest/v1/projects` - Update project
- `DELETE /rest/v1/projects` - Delete project
- `GET /rest/v1/rooms` - Get rooms list
- `POST /rest/v1/rooms` - Create room
- `GET /rest/v1/room_objects` - Get room objects
- `POST /rest/v1/room_objects` - Add object
- `GET /rest/v1/materials` - Get materials
- `GET /rest/v1/project_materials` - Get project materials
- `POST /rest/v1/project_materials` - Add material to project

## Authentication

Semua requests menggunakan Supabase REST API dengan headers:

```dart
{
  'Content-Type': 'application/json',
  'apikey': SupabaseConfig.anonKey,
  'Authorization': 'Bearer ${SupabaseConfig.anonKey}',
}
```

Supabase URL dan key sudah dikonfigurasi di `core/supabase_config.dart`

## Next Steps

1. ✅ Integrate providers di semua screens yang membutuhkan data
2. ✅ Update login screen untuk menyimpan userId setelah autentikasi
3. ✅ Test semua operasi CRUD
4. ✅ Add error handling dan retry logic
5. ✅ Add loading indicators UI
6. ✅ Integrate 3D editor dengan room data

Semua sudah siap digunakan! 🚀
