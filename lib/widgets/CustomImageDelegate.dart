// Copyright (c) 2018, the Zefyr project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:fullmarks/utility/AppAssets.dart';
import 'package:fullmarks/utility/Utiity.dart';
import 'package:image_picker/image_picker.dart';

import 'package:fullmarks/zefyr/zefyr.dart';

/// Custom image delegate used by this example to load image from application
/// assets.
class CustomImageDelegate implements ZefyrImageDelegate<ImageSource> {
  @override
  ImageSource get cameraSource => ImageSource.camera;

  @override
  ImageSource get gallerySource => ImageSource.gallery;

  @override
  Future<String> pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final file = await picker.getImage(source: source);
    if (file == null) return null;
    return file.path;
  }

  @override
  Widget buildImage(BuildContext context, String key) {
    // We use custom "asset" scheme to distinguish asset images from other files.
    if (key.startsWith('asset://')) {
      final asset = AssetImage(key.replaceFirst('asset://', ''));
      return Image(image: asset);
    } else if (key.startsWith("http")) {
      return Utility.imageLoader(
        baseUrl: "",
        url: key,
        placeholder: AppAssets.imagePlaceholder,
      );
    } else {
      // Otherwise assume this is a file stored locally on user's device.
      final file = File.fromUri(Uri.parse(key));
      final image = FileImage(file);
      return Image(image: image);
    }
  }
}

// [{
// 	"insert": "​",
// 	"attributes": {
// 		"embed": {
// 			"type": "image",
// 			"source": "https://user-images.githubusercontent.com/122956/72955931-ccc07900-3d52-11ea-89b1-d468a6e2aa2b.png"
// 		}
// 	}
// }, {
// 	"insert": "\n\n"
// }]

// [{
// 	"insert": "​",
// 	"attributes": {
// 		"embed": {
// 			"type": "image",
// 			"source": "/storage/emulated/0/Android/data/app.fullmarks.com/files/Pictures/6a8892cb-0c07-4506-bc3c-f18fed1047245675940290134861771.jpg"
// 		}
// 	}
// }]
