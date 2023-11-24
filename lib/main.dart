import 'package:flutter/material.dart';
import 'package:extended_image/extended_image.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

void main() {
  runApp(MyApp());
}

mixin CacheManager {
  static const key = "customCache";

  Future<String> getFilePath() async {
    var directory = await getTemporaryDirectory();
    return p.join(directory.path, key);
  }
}

class Post {
  final String imageUrl;
  final String description;

  Post({required this.imageUrl, required this.description});
}

class MyApp extends StatelessWidget with CacheManager {
  final List<Post> posts = List.generate(
    50,
    (index) => Post(
      imageUrl: "https://placekitten.com/200/200?image=$index", // Example URL
      description: "Description for post $index",
    ),
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Extended Image Caching'),
        ),
        body: ListView.builder(
          itemCount: posts.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Post $index',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  ExtendedImage.network(
                    posts[index].imageUrl,
                    width: 200,
                    height: 200,
                    cache: true,
                    loadStateChanged: (ExtendedImageState state) {
                      switch (state.extendedImageLoadState) {
                        case LoadState.loading:
                          return CircularProgressIndicator();
                        case LoadState.completed:
                          return ExtendedRawImage(
                            image: state.extendedImageInfo?.image,
                          );
                        case LoadState.failed:
                          return Icon(Icons.error);
                      }
                    },
                  ),
                  SizedBox(height: 8),
                  Text(posts[index].description),
                  Divider(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}