import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/http_service.dart';
import '../services/log_service.dart';

class UploadPage extends StatefulWidget {
  const UploadPage({super.key});

  @override
  State<UploadPage> createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  bool isLoading=false;
  XFile? pickedImage;
  final ImagePicker _picker =ImagePicker();

  getImageFromGallery()async{
    final XFile? image= await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 100,
    );
    setState(() {
      pickedImage=image;
    });
  }
  apiUploadCat()async{
    setState(() {
      isLoading=true;
    });
    var imageFile= File(pickedImage!.path);
    var response =await HttpService.MUL(
        HttpService.API_CAT_UPLOAD,imageFile,HttpService.paramsEmpty()
    );
    LogService.i(response!);



    setState(() {
      isLoading=false;
    });
    Navigator.of(context).pop(true);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text("Upload Page"),
      ),
      body: Stack(
        children: [
          Center(
            child: Container(
              padding: EdgeInsets.all(15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    height: 300,
                    width: 300,
                    child: pickedImage == null
                        ? Center(
                              child: Image(image: AssetImage("assets/images/photo.jpg"),fit: BoxFit.cover,),
                    ):Image.file(File(pickedImage!.path),fit: BoxFit.cover,),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      MaterialButton(
                        color: Colors.green[200],
                        onPressed: (){
                          getImageFromGallery();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text("Get Image",style: TextStyle(color: Colors.white),),
                        ),
                      ),
                      SizedBox(width: 20,),
                      MaterialButton(
                        color: Colors.red[200],
                        onPressed: (){
                          apiUploadCat();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text("Upload Image",style: TextStyle(color: Colors.white),),
                        ),
                      ),
                    ],
                  ),
                  isLoading ? Center(child: CircularProgressIndicator(),):SizedBox.shrink(),
                ],
              ),
            ),
          ),

        ],
      ),
    );
  }
}