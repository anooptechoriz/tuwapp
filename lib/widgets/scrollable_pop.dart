import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ScrollableDialogBox extends StatefulWidget {
  final List<String> images;
  final int index;

  ScrollableDialogBox({required this.images, required this.index});

  @override
  _ScrollableDialogBoxState createState() => _ScrollableDialogBoxState();
}

class _ScrollableDialogBoxState extends State<ScrollableDialogBox> {
  late PageController pageController;
  int currentIndex = 0;
  @override
  void initState() {
    super.initState();
    // Initialize currentIndex with the provided index
    currentIndex = widget.index;

    // Initialize PageController with the provided index
    pageController = PageController(initialPage: currentIndex);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Preload images to ensure they are cached
    for (int i = 0; i < widget.images.length; i++) {
      precacheImage(CachedNetworkImageProvider(widget.images[i]), context);
    }
  }

  // Function to show the next image
  void showNextImage() {
    // setState(() {
    //   currentIndex = (currentIndex + 1) % widget.images.length;
    // });
    if (currentIndex < widget.images.length - 1) {
      pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
    print(currentIndex);
    print(widget.images.length);
  }

  // Function to show the previous image
  void showPreviousImage() {
    // setState(() {
    //   currentIndex =
    //       (currentIndex - 1 + widget.images.length) % widget.images.length;
    // });

    if (currentIndex > 0) {
      pageController.previousPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Dialog(
      child: Stack(
        children: [
          SizedBox(
            height: size.height * 0.7,
            width: size.width * 0.9,
            child: PageView.builder(
                controller: pageController,
                itemCount: widget.images.length,
                onPageChanged: (index) {
                  setState(() {
                    currentIndex = index;
                  });
                },
                itemBuilder: (context, index) {
                  return CachedNetworkImage(
                    imageUrl: widget.images[index],
                    fit: BoxFit.fitWidth,
                  );
                }),
          ),
          Positioned(
            top: 5,
            right: 5,
            child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.close,
                color: Colors.red,
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 10,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: showPreviousImage,
                  icon: Icon(Icons.arrow_back_ios),
                ),
                IconButton(
                  onPressed: showNextImage,
                  icon: Icon(Icons.arrow_forward_ios),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
