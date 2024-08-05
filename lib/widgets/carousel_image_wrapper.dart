import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tbr_test_task/utils/constants.dart';

import '../blocs/launch_bloc.dart';
import '../blocs/rocket_bloc.dart';

class CarouselImageWrapper extends StatefulWidget {
  const CarouselImageWrapper({super.key});

  @override
  CarouselImageWrapperState createState() => CarouselImageWrapperState();
}

class CarouselImageWrapperState extends State<CarouselImageWrapper> {
  final CarouselController _controller = CarouselController();
  final ValueNotifier<int> _currentPageNotifier = ValueNotifier<int>(0);

  @override
  void initState() {
    super.initState();
    context.read<RocketBloc>().add(FetchRocketImages());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RocketBloc, RocketState>(
      builder: (context, state) {
        if (state is RocketLoading) {
          return const Center(
            child: CircularProgressIndicator(
              color: accentColor,
            ),
          );
        } else if (state is RocketLoaded) {
          final imageUrls = state.imageUrls;
          final selectedRocketId = state.selectedRocketId;

          context.read<LaunchBloc>().add(FetchLaunches(selectedRocketId));

          return Column(
            children: [
              CarouselSlider(
                items: imageUrls.map((url) {
                  return ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                    child: CachedNetworkImage(
                      imageUrl: url,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  );
                }).toList(),
                carouselController: _controller,
                options: CarouselOptions(
                  enableInfiniteScroll: false,
                  aspectRatio: 16 / 9,
                  enlargeCenterPage: true,
                  viewportFraction: 0.76,
                  enlargeFactor: 0.2,
                  onPageChanged: (index, reason) {
                    _currentPageNotifier.value = index;
                    final rocketId = imageUrls[
                        index]; // Adjust to fetch the correct rocketId
                    context.read<RocketBloc>().add(ChangeRocket(rocketId));
                  },
                ),
              ),
              ValueListenableBuilder<int>(
                valueListenable: _currentPageNotifier,
                builder: (context, currentPage, _) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: imageUrls.asMap().entries.map((entry) {
                      int index = entry.key;
                      return GestureDetector(
                        onTap: () => _controller.animateToPage(index),
                        child: Container(
                          width: 12.0,
                          height: 12.0,
                          margin: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 4.0),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: currentPage == index
                                ? elements
                                : Colors.transparent,
                            border: Border.all(
                              color: currentPage == index
                                  ? Colors.transparent
                                  : elements,
                              width: 2.0,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ],
          );
        } else if (state is RocketError) {
          return Center(
            child: Text('Error: ${state.message}'),
          );
        } else {
          return const Center(
            child: Text('No data available'),
          );
        }
      },
    );
  }

  @override
  void dispose() {
    _currentPageNotifier.dispose();
    super.dispose();
  }
}
