import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../../core/services/camera_service.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  late CameraService _cameraService;
  final ImagePicker _picker = ImagePicker();
  List<XFile> _selectedImages = [];
  bool _isCameraReady = false;
  String? _lastPhotoPath;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    _cameraService = CameraService();
    final granted = await _cameraService.ensurePermissions();
    if (!granted) {
      debugPrint('Kamera izni verilmedi.');
      if (mounted) {
        setState(() {
          _currentIndex = 1;
        });
      }
      return;
    }

    try {
      await _cameraService.initialize();
      if (_cameraService.hasCameras && _cameraService.isInitialized) {
        if (mounted) {
          setState(() {
            _isCameraReady = true;
          });
        }
      } else {
        debugPrint('Hiç kamera bulunamadı.');
        if (mounted) {
          setState(() {
            _currentIndex = 1;
          });
        }
      }
    } catch (e) {
      debugPrint('Kamera başlatma hatası: $e');
      if (mounted) {
        setState(() {
          _currentIndex = 1;
        });
      }
    }
  }
  @override
  void dispose() {
    _cameraService.dispose();
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
          if (_currentIndex == 0)
            Positioned(
                  bottom: 400.h,
                  left: 0,
                  right: 0,
                  child: Center(
                child: GestureDetector(
                  onTap: () async {
              try {
                final path = await _cameraService.takePictureAndSave();
                setState(() {
                  _lastPhotoPath = path;
                  _currentIndex = 1; // optionally switch to gallery view to show saved image
                  _selectedImages = [XFile(path)]; // show the taken photo in gallery preview
                });
              } catch (e) {
                debugPrint('Fotoğraf çekme hatası: $e');
              }
            },
            child: Container(
              width: 72.w,
              height: 72.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 4),
                color: Colors.white.withValues(alpha: 0.1),
              ),
              child: const Icon(Icons.camera_alt, color: Colors.white),
            ),
          ),
        ),
      ),
          Positioned(
            left: 20.w,
            right: 20.w,
            bottom: 50.h,
            child: _buildCustomNavBar(),
          ),
          Positioned(
            top: MediaQuery.paddingOf(context).bottom + 20.h,
            left: 20.w,
            right: 20.w,
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
        child: CameraPreview(_cameraService.controller!),
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
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 1,
          ),
          itemCount: _selectedImages.length,
          itemBuilder: (context, index) {
            final img = _selectedImages[index];
            return GestureDetector(
              onTap: () {
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

//_headeraction buildheaderın içine alınacak!!!
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children:<Widget>[
          _headerAction(LucideIcons.settings),
          _headerAction(LucideIcons.history),
        ],
      ),


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
            color: Colors.black.withValues(alpha:0.3),
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
