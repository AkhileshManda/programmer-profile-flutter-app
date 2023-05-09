import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime_type/mime_type.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ImageInput extends StatefulWidget {
  //final Function onSelectImage;
  final String? url;
  const ImageInput({required this.url, super.key});

  @override
  ImageInputState createState() => ImageInputState();
}

class ImageInputState extends State<ImageInput> {
  File? _storedImage;

  void _upload(File file, String token) async {
    String fileName = file.path.split('/').last;
    //print(fileName);

    String url =
        "https://graphenous.azurewebsites.net/api/upload/profile-picture";

    String mimeType = mime(fileName)!;
    String mimee = mimeType.split('/')[0];
    String type = mimeType.split('/')[1];
    // print("API Call");
    Dio dio = Dio();
    dio.options.headers["Content-Type"] = "multipart/form-data";
    dio.options.headers["Authorization"] = "Bearer $token";
    FormData formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(file.path,
          filename: fileName, contentType: MediaType(mimee, type))
    });
    dio.post(url, data: formData).then((response) {
      // print("Lol");
      // print(response.toString());
    }).catchError((e) {});
  }

  Future<void> _takePicture() async {
    final imageFile = await ImagePicker()
        .pickImage(source: ImageSource.gallery, maxWidth: 600);
    setState(() {
      // print("am setting state here");
      _storedImage = File(imageFile!.path);
    });

    if (imageFile == null) {
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString("token")!;
    // print(token);
    //Upload to api
    // print("API UPload");
    _upload(File(imageFile.path), token);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Stack(
        alignment: AlignmentDirectional.bottomEnd,
        children: [
          Container(
            width: 100,
            height: 100,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(200))),
            //decoration: BoxDecoration(border: Border.all(width: 1)),
            child: _storedImage != null
                ? Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                          image: FileImage(
                            _storedImage!,
                          ),
                        ),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(200))),
                    // child: Image.file(
                    //   _storedImage!,
                    //   fit: BoxFit.fill,
                    //   width: double.infinity,

                    // ),
                  )
                : (widget.url == null
                    ? const CircleAvatar(
                        backgroundColor: Colors.white,
                        foregroundColor: Color.fromRGBO(0, 10, 56, 1),
                        radius: 50,
                        child: Icon(Icons.person, size: 50))
                    : Container(
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: NetworkImage(widget.url!)),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(200))),
                      )),
          ),
          IconButton(
              onPressed: _takePicture,
              icon: const Icon(Icons.edit, color: Colors.white))
        ],
      ),
    );
  }
}
