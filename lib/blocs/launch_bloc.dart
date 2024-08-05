import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tbr_test_task/services/rocket_service.dart';

abstract class LaunchEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchLaunches extends LaunchEvent {
  final String rocketId;

  FetchLaunches(this.rocketId);

  @override
  List<Object> get props => [rocketId];
}

abstract class LaunchState extends Equatable {
  @override
  List<Object> get props => [];
}

class LaunchInitial extends LaunchState {}

class LaunchLoading extends LaunchState {}

class LaunchLoaded extends LaunchState {
  final List<Map<String, dynamic>> launches;

  LaunchLoaded(this.launches);

  @override
  List<Object> get props => [launches];
}

class LaunchError extends LaunchState {
  final String message;

  LaunchError(this.message);

  @override
  List<Object> get props => [message];
}

class LaunchBloc extends Bloc<LaunchEvent, LaunchState> {
  final RocketService rocketService;

  LaunchBloc(this.rocketService) : super(LaunchInitial()) {
    on<FetchLaunches>(_onFetchLaunches);
  }

  void _onFetchLaunches(FetchLaunches event, Emitter<LaunchState> emit) async {
    emit(LaunchLoading());
    try {
      final launches = await rocketService.fetchLaunches(event.rocketId);
      emit(LaunchLoaded(launches));
    } catch (e) {
      emit(LaunchError(e.toString()));
    }
  }
}
