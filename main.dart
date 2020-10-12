import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:swipedetector/swipedetector.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  
  VideoPlayerController _controller;
  Future<void> _initializeVideoPlayerFuture;

  List videoList = [
    "assets/videos/1.mp4",
    "assets/videos/test1.mp4",
    "assets/videos/test2.mp4",
    "assets/videos/test3.mp4",
    "assets/videos/test4.mp4",
    "assets/videos/test6.mp4",
    "assets/videos/test7.mp4",
    "assets/videos/test8.mp4",
  ];

  int videoCount = 0;

  //Play Next video by swipe Up 
  setNextVideo(){
    if(_controller != null){
      _controller = null;
    }

    if(videoCount+1 < videoList.length){
      setState(() {
        videoCount = videoCount + 1;
        _controller = VideoPlayerController.asset(videoList[videoCount]);
        _initializeVideoPlayerFuture = _controller.initialize();
        _controller.setLooping(true);
        _controller.setVolume(1.0);
        _controller.play();        
      });
    }
    else{
      setState(() {
        videoCount = videoList.length-1;
        _controller = VideoPlayerController.asset(videoList[videoCount]);
        _initializeVideoPlayerFuture = _controller.initialize();
        _controller.setLooping(true);
        _controller.setVolume(1.0);
        _controller.play();        
      });
    }
  }

  //Play previous video by swipe down 
  setPrevVideo(){
    if(_controller != null){
      _controller = null;
    }

    if((videoCount-1) > -1){
      setState(() {
        videoCount = videoCount - 1;
        _controller = VideoPlayerController.asset(videoList[videoCount]);
        _initializeVideoPlayerFuture = _controller.initialize();
        _controller.setLooping(true);
        _controller.setVolume(1.0);
        _controller.play();        
      });
    }
    else{
      setState(() {
        videoCount = 0;
        _controller = VideoPlayerController.asset(videoList[videoCount]);
        _initializeVideoPlayerFuture = _controller.initialize();
        _controller.setLooping(true);
        _controller.setVolume(1.0);
        _controller.play();        
      });
    }
  }

  //Playing back to back videos 
  isFinishedVideo(){
    if(! _controller.value.isPlaying){
      print("-------------- end--------------");

      if((videoCount+1) < videoList.length){
        setState(() {
          videoCount = videoCount + 1;
          _controller = VideoPlayerController.asset(videoList[videoCount]);

          _initializeVideoPlayerFuture = _controller.initialize();
          _controller.setLooping(false);
          _controller.setVolume(1.0);
          _controller.play();    
          _controller.addListener(isFinishedVideo);
        });
      }
      else{
        _controller.pause();
        _controller.dispose();
      }
    }
  }

  @override
  void initState() {
    // _controller = VideoPlayerController.network(
    //     "https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4");

    _controller = VideoPlayerController.asset(videoList[videoCount]);
    _initializeVideoPlayerFuture = _controller.initialize();
    _controller.setLooping(true);
    _controller.setVolume(1.0);
    _controller.play();
    // _controller.addListener(isFinishedVideo);
      
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SwipeDetector(
        child: GestureDetector(
          onTap: () {
            setState(() {
              if (_controller.value.isPlaying) {
                _controller.pause();
              } else {
                _controller.play();
              }
            });
          },
          child:Container(
            padding: EdgeInsets.only(top: 15),
            height: MediaQuery.of(context).size.height-10,
            width: MediaQuery.of(context).size.width,
            child:   Stack(
              children: <Widget>[
                FutureBuilder(
                  future: _initializeVideoPlayerFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return Center(
                        child: VideoPlayer(_controller),
                      );
                    } 
                    else {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),

              ],
            ),
          ),
        ),
        // onSwipeUp: setNextVideo,
        // onSwipeDown: setPrevVideo,
        onSwipeRight: setPrevVideo,
        onSwipeLeft: setNextVideo,
      )
    );
  }
}
