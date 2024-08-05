import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../services/rocket_service.dart';

abstract class RocketEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchRocketImages extends RocketEvent {}

class ChangeRocket extends RocketEvent {
  final String rocketId;

  ChangeRocket(this.rocketId);

  @override
  List<Object> get props => [rocketId];
}

abstract class RocketState extends Equatable {
  @override
  List<Object> get props => [];
}

class RocketInitial extends RocketState {}

class RocketLoading extends RocketState {}

class RocketLoaded extends RocketState {
  final List<String> imageUrls;
  final String selectedRocketId;

  RocketLoaded(this.imageUrls, this.selectedRocketId);

  @override
  List<Object> get props => [imageUrls, selectedRocketId];
}

class RocketError extends RocketState {
  final String message;

  RocketError(this.message);

  @override
  List<Object> get props => [message];
}

class RocketBloc extends Bloc<RocketEvent, RocketState> {
  final RocketService rocketService;

  RocketBloc(this.rocketService) : super(RocketInitial()) {
    on<FetchRocketImages>(_onFetchRocketImages);
    on<ChangeRocket>(_onChangeRocket);
  }

  void _onFetchRocketImages(
      FetchRocketImages event, Emitter<RocketState> emit) async {
    emit(RocketLoading());
    try {
      final List<Map<String, String>> imageUrls =
          await rocketService.fetchRocketImages();
      final List<String> urls =
          imageUrls.map((map) => map['image_url']!).toList();
      final String firstRocketId = imageUrls.first['rocket_id']!;

      emit(RocketLoaded(urls, firstRocketId));
    } catch (e) {
      emit(RocketError(e.toString()));
    }
  }

  void _onChangeRocket(ChangeRocket event, Emitter<RocketState> emit) {
    final state = this.state;
    if (state is RocketLoaded) {
      emit(RocketLoaded(state.imageUrls, event.rocketId));
    }
  }
}
