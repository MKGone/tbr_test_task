import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tbr_test_task/theme/theme.dart';
import 'package:tbr_test_task/blocs/launch_bloc.dart';
import 'package:tbr_test_task/services/rocket_service.dart';
import 'package:tbr_test_task/widgets/carousel_image_wrapper.dart';
import 'package:intl/intl.dart';
import '../generated/l10n.dart';
import '../utils/constants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).app_bar_title),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BlocProvider(
                create: (context) => LaunchBloc(RocketService()),
                child: Column(
                  children: [
                    const CarouselImageWrapper(),
                    const SizedBox(height: 24.0),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            S.of(context).missions,
                            style: darkTheme.textTheme.titleLarge,
                            textAlign: TextAlign.start,
                          ),
                          const SizedBox(height: 16.0),
                          BlocBuilder<LaunchBloc, LaunchState>(
                            builder: (context, state) {
                              if (state is LaunchLoading) {
                                return const Center(
                                  child: CircularProgressIndicator(
                                    color: accentColor,
                                  ),
                                );
                              } else if (state is LaunchLoaded) {
                                return SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.8,
                                  child: ListView.builder(
                                    itemCount: state.launches.length,
                                    itemBuilder: (context, index) {
                                      final launch = state.launches[index];
                                      final localDateTime =
                                          DateTime.parse(launch['date']);
                                      String formattedDate =
                                          DateFormat('dd/MM/yyyy')
                                              .format(localDateTime);
                                      String formattedTime =
                                          DateFormat('h:mm a')
                                              .format(localDateTime);
                                      return Container(
                                        margin:
                                            const EdgeInsets.only(bottom: 8.0),
                                        decoration: BoxDecoration(
                                          color: fill,
                                          borderRadius:
                                              BorderRadius.circular(16.0),
                                        ),
                                        child: ListTile(
                                          title: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.3,
                                                child: Text(
                                                  formattedDate,
                                                  style: darkTheme
                                                      .textTheme.bodyMedium,
                                                ),
                                              ),
                                              Expanded(
                                                child: Text(
                                                  launch['name'],
                                                  style: darkTheme
                                                      .textTheme.titleMedium,
                                                ),
                                              ),
                                            ],
                                          ),
                                          subtitle: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.3,
                                                child: Text(
                                                  formattedTime,
                                                  style: darkTheme
                                                      .textTheme.labelMedium,
                                                ),
                                              ),
                                              Expanded(
                                                child: Text(
                                                  launch['site'],
                                                  style: darkTheme
                                                      .textTheme.labelMedium,
                                                  maxLines: 3,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              )
                                            ],
                                          ),
                                          onTap: () {
                                            if (kDebugMode) {
                                              print(launch['wiki']);
                                            }
                                          },
                                        ),
                                      );
                                    },
                                  ),
                                );
                              } else if (state is LaunchError) {
                                return Center(
                                  child: Text(
                                      '${S.of(context).error}: ${state.message}'),
                                );
                              } else {
                                return Center(
                                  child: Text(S.of(context).no_data),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
