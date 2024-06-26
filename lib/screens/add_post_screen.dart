import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/resources/firebase_services/firestore.dart';
import 'package:instagram_clone/resources/model/user.dart';
import 'package:instagram_clone/resources/providers/user_provider.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/pick_image.dart';
import 'package:instagram_clone/utils/snack_bar.dart';
import 'package:provider/provider.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  Uint8List? _file;
  final TextEditingController _captionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  bool _isLoading = false;

  selectImage(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: const Text('Create a Post'),
          children: [
            SimpleDialogOption(
              padding: const EdgeInsets.all(20.0),
              child: const Text('Take a Photo'),
              onPressed: () async {
                Navigator.of(context).pop();
                Uint8List file = await pickImage(ImageSource.camera);
                setState(
                  () {
                    _file = file;
                  },
                );
              },
            ),
            SimpleDialogOption(
              padding: const EdgeInsets.all(20.0),
              child: const Text('Choose from gallery'),
              onPressed: () async {
                Navigator.of(context).pop();
                Uint8List file = await pickImage(ImageSource.gallery);
                setState(
                  () {
                    _file = file;
                  },
                );
              },
            ),
            SimpleDialogOption(
              padding: const EdgeInsets.all(20.0),
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _captionController.dispose();
    _locationController.dispose();
  }

  void postImage(String uid, String username, String profImage) async {
    setState(() {
      _isLoading = true;
    });
    try {
      String res = await FireStoreMethods().uploadPost(
          _captionController.text,
          _locationController.text.isEmpty ? null : _locationController.text,
          _file!,
          uid,
          username,
          profImage);

      if (res == 'success') {
        setState(() {
          _isLoading = false;
        });

        showSnackBar(context, 'Posted');
        clearImage();
        _captionController.clear();
        _locationController.clear();
      } else {
        setState(() {
          _isLoading = false;
        });
        showSnackBar(context, res);
      }
    } catch (err) {
      showSnackBar(context, err.toString());
    }
  }

  void clearImage() {
    setState(() {
      _file = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0.0,
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.arrow_back,
          ),
        ),
        titleSpacing: 0.0,
        title: const Text(
          'Add Post',
        ),
        centerTitle: false,
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10.0,
              ),
              child: GestureDetector(
                  onTap: () =>
                      postImage(user.uid, user.username, user.profileUrl),
                  child: const Icon(
                    Icons.send,
                    color: blueAccentColor,
                  )),
            ),
          )
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              if (_isLoading)
                const LinearProgressIndicator(
                  color: blueAccentColor,
                ),
              const SizedBox(height: 10.0),
              GestureDetector(
                onTap: () => selectImage(context),
                child: Container(
                  height: screenSize.height * 0.5,
                  width: double.infinity,
                  color: profileBgColor,
                  child: _file == null
                      ? const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Select an Image'),
                            SizedBox(
                              height: 5.0,
                            ),
                            Icon(
                              Icons.upload,
                            ),
                          ],
                        )
                      : Image.memory(_file!, fit: BoxFit.cover),
                ),
              ),
              const SizedBox(
                height: 5.0,
              ),
              Container(
                width: screenSize.width * 0.95,
                padding: const EdgeInsets.all(15.0),
                decoration: BoxDecoration(
                  color: primaryColor,
                  boxShadow: const [
                    BoxShadow(
                      color: blackColor,
                      offset: Offset(2, 2),
                      blurRadius: 6.0,
                    ),
                  ],
                  borderRadius: BorderRadius.circular(10.0),
                ),
                margin: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage(
                            user.profileUrl,
                          ),
                        ),
                        const SizedBox(width: 10.0),
                        Expanded(
                          child: Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  border: Border.all(
                                    width: 2.0,
                                    color: secondaryColor,
                                  ),
                                ),
                                child: TextField(
                                  decoration: InputDecoration(
                                    fillColor: profileBgColor,
                                    hintText: 'Write a Caption...',
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        borderSide: BorderSide.none),
                                    contentPadding: const EdgeInsets.all(10.0),
                                  ),
                                  controller: _captionController,
                                  maxLines: 3,
                                ),
                              ),
                              const SizedBox(height: 10.0),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  border: Border.all(
                                    width: 2.0,
                                    color: secondaryColor,
                                  ),
                                ),
                                child: TextField(
                                  decoration: InputDecoration(
                                    fillColor: profileBgColor,
                                    hintText: 'Add Location...',
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        borderSide: BorderSide.none),
                                    contentPadding: const EdgeInsets.all(10.0),
                                  ),
                                  controller: _locationController,
                                  maxLines: 1,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
