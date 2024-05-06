import 'package:blocify/blocs/load_image_bloc/load_image_state.dart';
import 'package:blocify/cubits/load_image_cubit/load_image_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/my_image.dart';

class LoadImageScreen extends StatefulWidget {
  const LoadImageScreen({super.key});

  @override
  State<LoadImageScreen> createState() => _LoadImageScreenState();
}

class _LoadImageScreenState extends State<LoadImageScreen> {
  String imageUrl = "";

  @override
  Widget build(BuildContext context) {
    print("Complete UI Rebuild");

    return Scaffold(
      appBar: AppBar(
        // title: const Text("Load Image with setState"),
        // title: const Text("Load Image with Bloc"),
        title: const Text("Load Image with Cubit"),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColorLight,
      ),
      // body: Center(
      //   child: Column(
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     children: [
      //       imageUrl.isEmpty ? const Text("No Image") : Image.network(imageUrl,height: 250.0,width: 250.0,),
      //       const SizedBox(
      //         height: 100,
      //       ),
      //       ElevatedButton(onPressed: () {
      //         if(imageUrl.isEmpty){
      //           setState(() {
      //             imageUrl = "https://lwfiles.mycourse.app/droidcon-public/f11ed54687792408d5dfc847bf926bae.png";
      //           });
      //         }else {
      //           setState(() {
      //             imageUrl = "";
      //           });
      //         }
      //       }, child:  imageUrl.isEmpty ? const Text("Load Image") : const Text("Remove Image"))
      //     ],
      //   ),
      // ),
      body: //BlocConsumer<LoadImageBloc, LoadImageState>(
          BlocConsumer<LoadImageCubit, LoadImageState>(
              listener: (context, state) {
        if (state is ImageLoadedState) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Image Loaded Successfully !")));
        }
      }, builder: (context, state) {
        print("Bloc Rebuilding");
        if (state is ImageLoadingState) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is ImageLoadedState) {
          return Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 60, vertical: 30),
                    itemCount: state.allImages.length,
                    itemBuilder: (context, index) {
                      MyImage myImage = state.allImages[index];
                      return Card(
                          child: Image.asset(
                        myImage.url,
                        height: myImage.size,
                        width: myImage.size,
                        fit: BoxFit.fill,
                      ));
                    },
                  ),
                  const SizedBox(height: 100),
                  ElevatedButton(
                      onPressed: () {
                        // context
                        //     .read<LoadImageBloc>()
                        //     .add(RemoveButtonPressedEvent());
                        context.read<LoadImageCubit>().removeImage();
                      },
                      child: const Text("Remove Image")),
                ],
              ),
            ),
          );
        } else {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("No Image"),
                const SizedBox(height: 100),
                ElevatedButton(
                    onPressed: () {
                      // context
                      //     .read<LoadImageBloc>()
                      //     .add(LoadButtonPressedEvent());
                      context.read<LoadImageCubit>().loadImage();
                    },
                    child: const Text("Load Image"))
              ],
            ),
          );
        }
      }),
    );
  }
}
