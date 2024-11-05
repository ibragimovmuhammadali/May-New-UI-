import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ngdemo15/pages/upload_page.dart';

import '../models/cat_list_res.dart';
import '../services/http_service.dart';
import '../services/log_service.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading=false;
  List<CatListRes>items=[];

  callUploadPage()async{
    var result =await Navigator.of(context).
    push(MaterialPageRoute(builder: (BuildContext contex){
      return UploadPage();
    }));
    if(result){
      apiCatList();
    }
  }
  apiCatList()async{
    setState(() {
      isLoading=true;
    });
    var response=await HttpService.GET(HttpService.API_CAT_LIST,HttpService.paramsCatList());
    List<CatListRes>catList=HttpService.parseCatList(response!);
    LogService.i(response);
    setState(() {
      items=catList;
      isLoading=false;
    });
  }
  @override
  void initState() {
    super.initState();
    apiCatList();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text("Cat List"),
      ),
      body: Stack(
          children: [
            ListView.builder(
              itemCount: items.length,
              itemBuilder: (context,index){
                return itemOfCat(items[index]);
              },
            ),
            isLoading ? Center(child: CircularProgressIndicator(),):SizedBox.shrink(),
          ]
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue[200],
        onPressed: (){
          callUploadPage();
        },
        child: Icon(Icons.add,color: Colors.white,),
      ),
    );
  }
  Widget itemOfCat(CatListRes cat){
    return CachedNetworkImage(
      height: 300,
      fit: BoxFit.cover,
      imageUrl: cat.url,
      placeholder: (context, url)=>Image(image: AssetImage("assets/images/photo.jpg"),fit: BoxFit.cover,),
      errorWidget: (context, url, error)=>Image(image: AssetImage("assets/images/photo.jpg"),fit: BoxFit.cover,),
    );
  }
}