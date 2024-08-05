import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../services/rocket_service.dart';

abstract class RocketEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchRocketImages extends RocketEvent {}

class ChangeRocket extends RocketEvent {
  final String imageUrl;

  ChangeRocket(this.imageUrl);

  @override
  List<Object> get props => [imageUrl];
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
      final List<Map<String, String>> rocketImages =
          await rocketService.fetchRocketImages();
      final List<String> urls =
          rocketImages.map((map) => map['image_url']!).toList();
      final String firstRocketId =
          rocketImages.isNotEmpty ? rocketImages.first['rocket_id']! : '';

      emit(RocketLoaded(urls, firstRocketId));
    } catch (e) {
      emit(RocketError(e.toString()));
    }
  }

  void _onChangeRocket(ChangeRocket event, Emitter<RocketState> emit) async {
    final state = this.state;
    if (state is RocketLoaded) {
      final rocketId = state.imageUrls.indexOf(event.imageUrl);
      final newRocketId = rocketId != -1 ? state.imageUrls[rocketId] : '';
      final rocketImages = await rocketService.fetchRocketImages();
      final matchingRocket = rocketImages.firstWhere(
        (rocket) => rocket['image_url'] == event.imageUrl,
        orElse: () => {'rocket_id': ''},
      );
      final rocketIdFromImage = matchingRocket['rocket_id'] ?? '';

      emit(RocketLoaded(state.imageUrls, rocketIdFromImage));
    }
  }
}
