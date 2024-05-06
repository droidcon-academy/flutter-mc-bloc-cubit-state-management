import 'package:blocify/blocs/load_image_bloc/load_image_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../utils/image_data.dart';
import '../../data/models/my_image.dart';

class LoadImageCubit extends Cubit<LoadImageState> {
  LoadImageCubit() : super(ImageNotLoadedState());
  Future<void> loadImage() async {
    emit(ImageLoadingState());
    // Delay the function execution for 1 second to simulate network call
    List<Map<String, dynamic>> fetchImages =
        await Future.delayed(const Duration(seconds: 1), () {
      return imageData;
    });
    // Convert the image json data into MyImage object
    List<MyImage> resultImages =
        fetchImages.map((image) => MyImage.fromJson(image)).toList();
    emit(ImageLoadedState(allImages: resultImages));
  }

  void removeImage() {
    emit(ImageNotLoadedState());
  }
}
