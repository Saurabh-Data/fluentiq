import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class VideoLectureScreen extends StatefulWidget {
  const VideoLectureScreen({super.key});

  @override
  _VideoLectureScreenState createState() => _VideoLectureScreenState();
}

class _VideoLectureScreenState extends State<VideoLectureScreen> {
  final Map<String, List<dynamic>> _playlistsVideos = {};
  String? _errorMessage;

  final List<Map<String, String>> playlists = [
    {'title': 'Develop your Interest in English', 'playlistId': 'PL4beGJxQXcwBum_Ot9zpcZbb5cR1Aodt4'},
    {'title': 'Boost Your Mindset Thinking in English', 'playlistId': 'PLiSXvPiNzG5L-xuQETbubWE4Ejabr2l3X'},
    {'title': 'Listen and Read the Song', 'playlistId': 'PLeS553ZNGqNR7fJ9eznn1Z5mIuMZwT_bY'},
    {'title': 'Interesting Way to Conversation', 'playlistId': 'PLTyvAtj9OYb1vr-gESA7YyCQ2BjQ9twqP'},
  ];

  @override
  void initState() {
    super.initState();
    _fetchAllPlaylists();
  }

  Future<void> _fetchAllPlaylists() async {
    final String apiKey = 'AIzaSyD-aRzbBSJTSwUSasm4-4E3P15DDQHC7wI'; // Add your API key here

    try {
      for (var playlist in playlists) {
        final String playlistId = playlist['playlistId']!;
        List<dynamic> playlistVideos = [];

        String? nextPageToken;

        do {
          final String url =
              'https://www.googleapis.com/youtube/v3/playlistItems?part=snippet&maxResults=50&playlistId=$playlistId&key=$apiKey${nextPageToken != null ? '&pageToken=$nextPageToken' : ''}';

          final response = await http.get(Uri.parse(url));
          if (response.statusCode == 200) {
            final data = json.decode(response.body);
            playlistVideos.addAll(data['items']);
            nextPageToken = data['nextPageToken'];
          } else {
            setState(() {
              _errorMessage = 'Error: ${response.statusCode} - ${response.reasonPhrase}';
            });
            break;
          }
        } while (nextPageToken != null);

        setState(() {
          _playlistsVideos[playlist['title']!] = playlistVideos;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video Lectures'),
      ),
      body: _errorMessage != null
          ? Center(child: Text(_errorMessage!))
          : _playlistsVideos.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: playlists.length,
        itemBuilder: (context, index) {
          String playlistTitle = playlists[index]['title']!;
          List<dynamic> videos = _playlistsVideos[playlistTitle] ?? [];

          return _buildPlaylistSection(context, playlistTitle, videos);
        },
      ),
    );
  }

  Widget _buildPlaylistSection(BuildContext context, String playlistTitle, List<dynamic> videos) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            playlistTitle,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue),
          ),
          SizedBox(height: 10),
          videos.isEmpty
              ? Center(child: CircularProgressIndicator())
              : SizedBox(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: videos.length,
              itemBuilder: (context, index) {
                String title = videos[index]['snippet']['title'];
                String videoId = videos[index]['snippet']['resourceId']['videoId'];

                return _buildVideoItem(context, title, videoId);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoItem(BuildContext context, String title, String videoId) {
    return Container(
      width: 160,
      margin: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(8),
        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)],
      ),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => YouTubePlayerScreen(videoId: videoId),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: NetworkImage('https://img.youtube.com/vi/$videoId/0.jpg'), // Thumbnail image
                  fit: BoxFit.cover,
                ),
              ),
              child: Center(
                child: Icon(Icons.play_circle_outline, size: 50, color: Colors.white),
              ),
            ),
            SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text(
                title,
                style: TextStyle(fontSize: 14),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class YouTubePlayerScreen extends StatefulWidget {
  final String videoId;

  const YouTubePlayerScreen({super.key, required this.videoId});

  @override
  _YouTubePlayerScreenState createState() => _YouTubePlayerScreenState();
}

class _YouTubePlayerScreenState extends State<YouTubePlayerScreen> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: widget.videoId,
      flags: YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
        isLive: false,
        hideControls: false,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  AspectRatio(
                    aspectRatio: 16 / 9,
                    child: YoutubePlayer(
                      controller: _controller,
                      showVideoProgressIndicator: true,
                      onReady: () {
                        // Video is ready to play
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
