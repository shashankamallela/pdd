import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../services/api_service.dart';
import 'kids_dental_videos.dart';

class VideosWatchedScreen extends StatefulWidget {
  const VideosWatchedScreen({super.key});

  @override
  State<VideosWatchedScreen> createState() => _VideosWatchedScreenState();
}

class _VideosWatchedScreenState extends State<VideosWatchedScreen> {
  late Future<List<Map<String, dynamic>>> videosFuture;

  @override
  void initState() {
    super.initState();
    videosFuture = ApiService.fetchVideos();
  }

  void retry() {
    setState(() {
      videosFuture = ApiService.fetchVideos();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.only(
                top: 60,
                left: 24,
                right: 24,
                bottom: 40,
              ),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF3B82F6),
                    Color(0xFF06B6D4),
                  ],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      context.pop();
                    },
                    child: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    "Kids Dental Videos",
                    style: TextStyle(
                      fontSize: 38,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(24),
            sliver: FutureBuilder<List<Map<String, dynamic>>>(
              future: videosFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SliverToBoxAdapter(
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.all(40),
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  );
                }

                if (snapshot.hasError) {
                  return SliverToBoxAdapter(
                    child: _ErrorState(
                      message: snapshot.error
                          .toString()
                          .replaceFirst('Exception: ', ''),
                      onRetry: retry,
                    ),
                  );
                }

                final videos = snapshot.data ?? [];

                if (videos.isEmpty) {
                  return const SliverToBoxAdapter(
                    child: Center(
                      child: Text(
                        'No videos available',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  );
                }

                return SliverList.separated(
                  itemBuilder: (context, index) {
                    final video = _normalizeVideo(videos[index], index);

                    return GestureDetector(
                      onTap: () {
                        context.push('/video-player', extra: video);
                      },
                      child: _buildVideoTile(video),
                    );
                  },
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 16),
                  itemCount: videos.length,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  static Map<String, dynamic> _normalizeVideo(
    Map<String, dynamic> video,
    int index,
  ) {
    final fallback = kidsDentalVideos[index % kidsDentalVideos.length];

    return {
      ...fallback,
      ...video,
      'duration': video['duration'] ?? fallback['duration'],
      'category': video['category'] ?? fallback['category'],
      'tip': video['tip'] ?? fallback['tip'],
      'icon': fallback['icon'],
      'color': fallback['color'],
    };
  }

  static Widget _buildVideoTile(Map<String, dynamic> video) {
    final Color color = video['color'];

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 18,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            height: 72,
            width: 72,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Icon(
              video['icon'],
              color: color,
              size: 34,
            ),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  video['title'] ?? 'Untitled video',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "${video['category']} - ${video['duration']}",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          CircleAvatar(
            backgroundColor: color,
            child: const Icon(
              Icons.play_arrow,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorState({
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.cloud_off_outlined,
            color: Colors.blueGrey,
            size: 44,
          ),
          const SizedBox(height: 14),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.blueGrey,
              fontSize: 16,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 18),
          ElevatedButton(
            onPressed: onRetry,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}
