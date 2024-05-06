import 'package:blocify/blocs/load_image_bloc/load_image_event.dart';
import 'package:blocify/blocs/load_image_bloc/load_image_state.dart';
import 'package:blocify/utils/image_data.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/my_image.dart';

class LoadImageBloc extends Bloc<LoadImageEvent, LoadImageState> {
  LoadImageBloc() : super(ImageNotLoadedState()) {
    on<LoadButtonPressedEvent>((event, emit) async {
      //emit(ImageLoadingState());
      // Delay the function execution for 1 second to simulate network call
      List<Map<String, dynamic>> fetchImages =
          await Future.delayed(const Duration(seconds: 1), () {
        return imageData;
      });
      // Convert the image json data into MyImage object
      List<MyImage> resultImages =
          fetchImages.map((image) => MyImage.fromJson(image)).toList();
      emit(ImageLoadedState(allImages: resultImages));
    });
    on<RemoveButtonPressedEvent>((event, emit) async {
      emit(ImageNotLoadedState());
    });
  }

  @override
  void onChange(Change<LoadImageState> change) {
    super.onChange(change);
    print("onChange Observer :");
    print(change.currentState.toString());
    print(change.nextState.toString());
  }

  @override
  void onTransition(Transition<LoadImageEvent, LoadImageState> transition) {
    super.onTransition(transition);
    print("onTransition Observer :");
    print(transition.toString());
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    super.onError(error, stackTrace);
    print("OnError Observer :");
    print(error.toString());
  }

  @override
  void onEvent(LoadImageEvent event) {
    super.onEvent(event);
    print("onEvent Observer :");
    print(event.toString());
  }
}
