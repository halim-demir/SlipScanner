import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../../core/services/camera_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  CameraController? _controller;
  final ImagePicker _picker = ImagePicker();
  List<XFile> _selectedImages= [];
  bool _isCameraReady = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final cameraService = CameraService();
    if (!cameraService.hasCameras) return;

    final status = await Permission.camera.request();
    if (status.isGranted) {
      _controller = CameraController(
        cameraService.cameras[0],
        ResolutionPreset.high,
        enableAudio: false,
      );

      try {
        await _controller!.initialize();
        if (mounted) {
          setState(() {
            _isCameraReady = true;
          });
        }
      } catch (e) {
        debugPrint('Camera initialization error: $e');
      }
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _pickImages() async {

    try {
     final List<XFile>? images = await _picker.pickMultiImage();
      if (images != null) {
        setState(() {
          _selectedImages = images;
          _currentIndex = 1; // Switch to gallery view if image picked
        });
      }
    } catch (e) {
      debugPrint('Error picking images: $e');
    }
  }

  void _onTabTapped(int index) {
    if (index == 1) {
      _pickImages();
    } else {
      setState(() {
        _currentIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildBody(),
          Positioned(
            left: 20,
            right: 20,
            bottom: 30,
            child: _buildCustomNavBar(),
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: 20,
            right: 20,
            child: _buildHeader(),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (_currentIndex == 0) {
      if (!_isCameraReady) {
        return const Center(
          child: CircularProgressIndicator(color: Color(0xFF6366F1)),
        );
      }
      return SizedBox.expand(
        child: CameraPreview(_controller!),
      );
    } else {
      return Container(
        color: Theme.of(context).colorScheme.surface,
        child: Center(
          child: _selectedImages.isEmpty
              ? _buildEmptyGallery()
              : _buildImagePreview(),
        ),
      );
    }
  }

  Widget _buildEmptyGallery() {
    return Column(

      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(LucideIcons.image, size: 64, color: Colors.white24),
        const SizedBox(height: 16),
        Text(
          'No image selected',
          style: GoogleFonts.inter(
            color: Colors.white70,
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  Widget _buildImagePreview() {
    return Padding(
      padding: const EdgeInsets.all(28.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 1,

          ),
          itemCount: _selectedImages.length,
          itemBuilder: (context, index)
          {
            final img = _selectedImages[index];
            return GestureDetector(
              onTap: (){
                //Tam Ekran Önizleme
                Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                  return Scaffold(
                    appBar: AppBar(backgroundColor: Colors.black),
                    backgroundColor: Colors.black,
                    body: Center(
                      child: Image.file(File(img.path)),
                    ),
                  );
                }));
              },
              child: Hero(
                tag: img.path,
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(16.0),

                  child: Image.file(
                    File(img.path),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _headerAction(LucideIcons.settings),
        Text(
          'SLIP SCANNER',
          style: GoogleFonts.montserrat(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
            color: Colors.white,
          ),
        ),
        _headerAction(LucideIcons.history),
      ],
    );
  }

  Widget _headerAction(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.black26,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, color: Colors.white),
    );
  }

  Widget _buildCustomNavBar() {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B).withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _navItem(0, LucideIcons.camera, "Scan"),
          _navItem(1, LucideIcons.image, "Gallery"),
        ],
      ),
    );
  }

  Widget _navItem(int index, IconData icon, String label) {
    bool isActive = _currentIndex == index;
    return GestureDetector(
      onTap: () => _onTabTapped(index),
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isActive ? const Color(0xFF6366F1) : Colors.white54,
              size: 26,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                color: isActive ? const Color(0xFF6366F1) : Colors.white54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
