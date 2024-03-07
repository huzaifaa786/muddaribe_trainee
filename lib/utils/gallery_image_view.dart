import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class GalleryView extends StatefulWidget {
  final List<String> imageUrls;
  final int initialIndex;

  const GalleryView(
      {Key? key, required this.imageUrls, required this.initialIndex})
      : super(key: key);

  @override
  _GalleryViewState createState() => _GalleryViewState();
}

class _GalleryViewState extends State<GalleryView> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: const Text('Full photo'),
        centerTitle: true,
      ),
      body: PhotoViewGallery.builder(
        itemCount: widget.imageUrls.length,
        pageController: _pageController,
        builder: (context, index) {
          return PhotoViewGalleryPageOptions(
            imageProvider: NetworkImage(widget.imageUrls[index]),
            minScale: PhotoViewComputedScale.contained,
            maxScale: PhotoViewComputedScale.covered * 2,
          );
        },
        scrollPhysics: BouncingScrollPhysics(),
        backgroundDecoration: BoxDecoration(
          color: Colors.black,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
