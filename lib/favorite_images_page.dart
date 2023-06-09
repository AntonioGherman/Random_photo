import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritePhotosPage extends StatefulWidget {
  const FavoritePhotosPage({super.key});

  @override
  State<FavoritePhotosPage> createState() => _FavoritePhotosPageState();
}

class _FavoritePhotosPageState extends State<FavoritePhotosPage> {
  List<String> _favoriteImages = <String>[];

  Future<void> _getImages() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _favoriteImages = prefs.getStringList('links') ?? <String>[];
    });
  }

  Future<void> setFavoriteImages(List<String> favoriteImage) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setStringList('links', favoriteImage);
    });
  }

  @override
  void initState() {
    _getImages();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
          itemCount: _favoriteImages.length,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onLongPress: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(30, 30, 30, 155),
                        child: Card(
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height - MediaQuery.of(context).size.height / 2,
                            child: Column(
                              children: <Widget>[
                                _imageWidget(context, index),
                                Padding(padding: const EdgeInsets.all(20), child: _option(context, index))
                              ],
                            ),
                          ),
                        ),
                      );
                    });
              },
              child: Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: SizedBox(
                  child: _imageWidget(context, index),
                ),
              ),
            );
          }),
    );
  }

  SizedBox _imageWidget(BuildContext context, int index) {
    return SizedBox(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Image.network(_favoriteImages[index], fit: BoxFit.fitHeight, loadingBuilder: _loadingImage),
        ),
      ),
    );
  }

  Widget _loadingImage(BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
    if (loadingProgress == null) {
      return child;
    }
    return Container(
      decoration: const BoxDecoration(color: Color(0xFFF4F4F4)),
    );
  }

  Row _option(BuildContext context, int index) {
    return Row(
      children: <Widget>[
        GestureDetector(
          onTap: () {
            setState(() {
              _favoriteImages.removeAt(index);
              setFavoriteImages(_favoriteImages);
              Navigator.pop(context);
            });
          },
          child: const Icon(
            Icons.delete,
            size: 39,
          ),
        ),
        const Text(' Delete', style: TextStyle(fontSize: 17)),
        const Spacer(),
        ElevatedButton(
            onPressed: () {
              setState(() {
                Navigator.pop(context);
              });
            },
            child: const Text('Go back'))
      ],
    );
  }
}
