import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_cab/utils/assets.dart';
import 'package:flutter_cab/utils/color.dart';

class MultiImageSlider extends StatefulWidget {
  final List<String> images;

  const MultiImageSlider({super.key, required this.images});

  @override
  _MultiImageSliderState createState() => _MultiImageSliderState();
}

class _MultiImageSliderState extends State<MultiImageSlider> {
  final PageController _pageController = PageController();
  Timer? _timer;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    if (widget.images.length > 1) {
      _timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
        if (_currentPage < widget.images.length - 1) {
          _currentPage++;
        } else {
          _currentPage = 0;
        }

        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeIn,
        );
      });
    }
  }

  // Function to navigate to the previous page
  void _previousPage() {
    if (_currentPage > 0) {
      setState(() {
        _currentPage--;
      });
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    }
  }

  // Function to navigate to the next page
  void _nextPage() {
    if (_currentPage < widget.images.length - 1) {
      setState(() {
        _currentPage++;
      });
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.images.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(2.0),
        child: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: SizedBox(
                width: double.infinity,
                child: Image.asset(tour, fit: BoxFit.cover))),
      );
    } else if (widget.images.length == 1) {
      return Padding(
        padding: const EdgeInsets.all(5.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: Image.network(
            widget.images[0],
            // fit: BoxFit.cover,
          ),
        ),
      );
    } else {
      return Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: widget.images.length,
            onPageChanged: (int index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(5.0),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: Image.network(
                      widget.images[index],
                      // fit: BoxFit.cover,
                    )),
              );
            },
          ),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                    onPressed: _previousPage,
                    icon: Container(
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle, color: btnColor),
                      child: const Padding(
                        padding: EdgeInsets.all(5.0),
                        child: Icon(
                          size: 20,
                          Icons.arrow_back_ios_new_outlined,
                          color: background,
                        ),
                      ),
                    )),
                IconButton(
                    onPressed: _nextPage,
                    icon: Container(
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle, color: btnColor),
                      child: const Padding(
                        padding: EdgeInsets.all(5.0),
                        child: Icon(
                          size: 20,
                          Icons.arrow_forward_ios_outlined,
                          color: background,
                        ),
                      ),
                    ))
              ],
            ),
          ),
          Positioned(
            bottom: 10,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                widget.images.length,
                (index) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 350),
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    height: 14,
                    width: 14,
                    decoration: BoxDecoration(
                      color:
                          _currentPage == index ? btnColor : bglightGreyColor,
                      border: Border.all(color: Colors.black87),
                      shape: BoxShape.circle,
                    ),
                  );
                },
              ),
            ),
          )
        ],
      );
    }
  }
}
