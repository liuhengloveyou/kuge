import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

import 'package:kuge_app/provider/account_provider.dart';

typedef OnPickImageCallback = void Function(double maxWidth, double maxHeight, int quality);
   
class SimpleImageEditor extends StatefulWidget {
  @override
  _SimpleImageEditorState createState() => _SimpleImageEditorState();
}

class _SimpleImageEditorState extends State<SimpleImageEditor> {
  final ImagePicker _picker = ImagePicker();
  // final GlobalKey<ExtendedImageEditorState> editorKey =GlobalKey<ExtendedImageEditorState>();
  bool _cropping = false;

   PickedFile? _imageFile;
   dynamic? _pickImageError;
   UserAccount? userInfo;

  @override
  void initState() {
    super.initState();

    userInfo = context.read<UserAccount>();
  }

  _buildBody() {
    if (_imageFile != null) {
      // return ExtendedImage.file(
      //   File(_imageFile.path),
      //   fit: BoxFit.contain,
      //   mode: ExtendedImageMode.editor,
      //   enableLoadState: true,
      //   extendedImageEditorKey: editorKey,
      //   initEditorConfigHandler: (ExtendedImageState state) {
      //     return EditorConfig(
      //       maxScale: 8.0,
      //       cropRectPadding: const EdgeInsets.all(20.0),
      //       hitTestSize: 20.0,
      //       initCropRectType: InitCropRectType.imageRect,
      //       cropAspectRatio: CropAspectRatios.ratio1_1,
      //     );
      //   },
      // );
    } else if (userInfo!.avatarUrl != "") {
      // return ExtendedImage.network(
      //   "${Api.IMG_HOST}/useravatar/${userInfo.avatarUrl}",
      //   fit: BoxFit.contain,
      //   mode: ExtendedImageMode.editor,
      //   enableLoadState: true,
      //   extendedImageEditorKey: editorKey,
      //   initEditorConfigHandler: (ExtendedImageState state) {
      //     return EditorConfig(
      //       maxScale: 8.0,
      //       cropRectPadding: const EdgeInsets.all(20.0),
      //       hitTestSize: 20.0,
      //       initCropRectType: InitCropRectType.imageRect,
      //       cropAspectRatio: CropAspectRatios.ratio1_1,
      //     );
      //   },
      // );
    } else {
      return Container();
    }
  }

   //上传图片到服务器
  submit() async {    
    // if ((_imageFile == null && userInfo.avatarUrl == "") || (editorKey.currentState.rawImageData.length <= 0))  {
    //   showToast("请选择头像图片", position: StyledToastPosition.center);
    //   return;
    // }

    // if (_cropping) {
    //   return;
    // }

    // final Uint8List imgData = Uint8List.fromList(await cropImageDataWithNativeLibrary(state: editorKey.currentState));
    // var resp = await userInfo.updateAvatar(imgData);
    // if (resp.data['code'] != 0) {
    //   showToast(resp.data["errmsg"], position: StyledToastPosition.center);
    // } else {
    //   showToast("更新成功", position: StyledToastPosition.center);
    //   userInfo.fetchUserInfo();
    //   Navigator.pop(context);
    // }
    
    _cropping = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        elevation: 0,
        titleSpacing: 0,
        centerTitle: false,
        title: const Text('头像'),
        actions: [
          IconButton(icon: const Icon(Icons.replay), onPressed: (){
            // editorKey.currentState.reset();
          }),
          IconButton(icon: const Icon(Icons.done_all), onPressed: (){
            submit();
          }),
          PopupMenuButton(
            onSelected: (String value){
              var source = ImageSource.camera;
              if (value == "2") {
                source = ImageSource.gallery;
              }
              _onImagePickerPressed(source, context: context);
            },
            itemBuilder: (BuildContext context) =><PopupMenuItem<String>>[
              const PopupMenuItem(
                value: "1",
                child: Text("拍照")
              ),
              const PopupMenuItem(
                value: "2",
                child: Text("从像册中选择")
              )]
          )
        ],
      ),
      body: _buildBody(),
    );
  }
  
  void _onImagePickerPressed(ImageSource source, {required BuildContext context}) async {
    try {
      final pickedFile = await _picker.getImage(source: source);
          setState(() {
            _imageFile = pickedFile!;
          });
      } catch (e) {
          print("imagepicker ERR: $e");
          setState(() {
            _pickImageError = e;
          });
    }
  }
}