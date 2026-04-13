// lib/screens/room_3d_webview_screen.dart
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class Room3DWebViewScreen extends StatefulWidget {
  final String? initialSceneId;
  final String serverUrl;

  const Room3DWebViewScreen({
    super.key,
    this.initialSceneId,
    required this.serverUrl,
  });

  @override
  State<Room3DWebViewScreen> createState() => _Room3DWebViewScreenState();
}

class _Room3DWebViewScreenState extends State<Room3DWebViewScreen> {
  late final WebViewController _controller;
  bool _isLoading = false;
  String? _currentSceneId;

  @override
  void initState() {
    super.initState();
    _currentSceneId = widget.initialSceneId;
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {},
          onPageStarted: (String url) {
            setState(() => _isLoading = true);
          },
          onPageFinished: (String url) {
            setState(() => _isLoading = false);
          },
          onWebResourceError: (WebResourceError error) {
            debugPrint('WebView error: ${error.description}');
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Error loading page: ${error.description}'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
        ),
      )
      ..addJavaScriptChannel(
        'Flutter',
        onMessageReceived: (JavaScriptMessage message) {
          debugPrint('Message from Web: ${message.message}');
        },
      );

    _loadEditor();
  }

  void _loadEditor() {
    String url = '${widget.serverUrl}/editor';
    if (_currentSceneId != null) {
      url += '?scene_id=$_currentSceneId';
    }
    _controller.loadRequest(Uri.parse(url));
  }

  Future<void> _pickAndProcessImage(ImageSource source) async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: source);
    if (image == null) return;

    setState(() => _isLoading = true);

    try {
      final uri = Uri.parse('${widget.serverUrl}/api/process-for-flutter');
      final request = http.MultipartRequest('POST', uri);
      request.files.add(await http.MultipartFile.fromPath('files', image.path));
      request.fields['rendering_mode'] = 'stylized';

      final response = await request.send();
      final responseData = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        final data = json.decode(responseData);
        final editorUrl = data['editor_url'];
        final sceneId = data['scene_id'];

        setState(() {
          _currentSceneId = sceneId;
        });

        _controller.loadRequest(Uri.parse('${widget.serverUrl}$editorUrl'));

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Room processed! ${data['preview']['object_count']} objects detected.'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        throw Exception('Server error: ${response.statusCode}\n$responseData');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _showImageSourceDialog() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Image Source'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Gallery'),
              onTap: () {
                Navigator.pop(context);
                _pickAndProcessImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Camera'),
              onTap: () {
                Navigator.pop(context);
                _pickAndProcessImage(ImageSource.camera);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('3D Room Editor'),
        backgroundColor: const Color(0xFF16213E),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadEditor,
          ),
          IconButton(
            icon: const Icon(Icons.cloud_upload),
            onPressed: _showImageSourceDialog,
            tooltip: 'Upload Room Image',
          ),
        ],
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading)
            Container(
              color: Colors.black54,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}