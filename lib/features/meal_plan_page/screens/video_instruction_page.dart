import 'package:another_transformer_page_view/another_transformer_page_view.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:webview_flutter/webview_flutter.dart';

class VideoInstructionPage extends StatefulWidget {
  const VideoInstructionPage({super.key});

  @override
  State<VideoInstructionPage> createState() => _VideoInstructionPageState();
}

class _VideoInstructionPageState extends State<VideoInstructionPage> {
  List<String> gifs = [
    "https://i.giphy.com/media/fehD3PyBLF8KeSOgSP/200.gif",
    "https://i.giphy.com/media/3o85xwjHtUOKOYHXig/200.gif",
    "https://i.giphy.com/media/sdQ3nOAboMc0M/200.gif",
    "https://i.giphy.com/media/POuFzfyFWMDe0/200.gif",
    "https://i.giphy.com/media/oFy0DysfL2nGG0W6Gr/200.gif",
    "https://i.giphy.com/media/1bJBePq1OUsEmZSxg5/200.gif",
    "https://i.giphy.com/media/S9oQJ0eOz7y6CHgHBG/200.gif"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Video Instructions"),
        ),
        body: SafeArea(
          child: TransformerPageView(
              loop: false,
              scrollDirection: Axis.vertical,
              itemBuilder: (BuildContext context, int index) {
                return InteractiveViewer(
                  panEnabled: false,
                  boundaryMargin: const EdgeInsets.all(100),
                  minScale: 0.5,
                  maxScale: 4,
                  child: Center(
                    child: Image.network(
                      gifs[index],
                      fit: (index == gifs.length - 2)
                          ? BoxFit.fitWidth
                          : BoxFit.cover,
                      height: double.infinity,
                      width: double.infinity,
                    ),
                  ),
                );
              },
              itemCount: 7),
        ));
  }
}
