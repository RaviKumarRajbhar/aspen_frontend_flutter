import 'dart:typed_data';

import 'package:crop_your_image/crop_your_image.dart';
import 'package:flutter/material.dart';

class CropImageScreen extends StatefulWidget {

  final Uint8List imageBytes;

  const CropImageScreen({
    super.key,
    required this.imageBytes,
  });

  @override
  State<CropImageScreen> createState() =>
      _CropImageScreenState();
}

class _CropImageScreenState
    extends State<CropImageScreen> {

  CropController controller = CropController();

  bool isLandscape = false;

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(

        title: const Text(
          "Crop Image",
        ),
      ),

      body: Column(

        children: [


          const SizedBox(height: 12),

          Expanded(

            child: Crop(

              key: ValueKey( isLandscape ),

              controller: controller,

              image: widget.imageBytes,

              aspectRatio:isLandscape? 16 / 9 : 4 / 5,

              onCropped:(result) {

                if (result
                is CropSuccess) {
                  Navigator.pop(context,(
                    croppedImage: result.croppedImage,
                    isLandscape: isLandscape ),
                  );
                }
              },
            ),
          ),

          const SizedBox( height: 12 ),

          Row(

            mainAxisAlignment: MainAxisAlignment.center,

            children: [

              ChoiceChip( label: const Text( "Portrait" ),

                selected: !isLandscape,

                onSelected: (_) {

                  setState(() {
                    isLandscape = false;
                    controller = CropController();
                  });
                },
              ),

              const SizedBox(width: 12),

              ChoiceChip( label: const Text( "Landscape" ),

                selected: isLandscape,

                onSelected: (_) {

                  setState(() {

                    isLandscape = true;
                    controller = CropController();

                  });
                },
              ),
            ],
          ),

          Padding(

            padding:
            const EdgeInsets.all(16),

            child: SizedBox(
              width:
              double.infinity,

              child:
              ElevatedButton( onPressed: () { controller.crop();},

                child:
                const Text("Done"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}