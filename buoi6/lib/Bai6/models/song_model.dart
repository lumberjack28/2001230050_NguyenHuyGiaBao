class Song {
  final int id;
  final String title;
  final String artist;
  final String duration;

  Song({
    required this.id,
    required this.title,
    required this.artist,
    required this.duration,
  });
}

final List<Song> sampleSongs = [
  Song(id: 1, title: 'Shape of You', artist: 'Ed Sheeran', duration: '3:53'),
  Song(id: 2, title: 'Blinding Lights', artist: 'The Weeknd', duration: '3:20'),
  Song(id: 3, title: 'Levitating', artist: 'Dua Lipa', duration: '3:23'),
  Song(
    id: 4,
    title: 'Stay',
    artist: 'The Kid LAROI, Justin Bieber',
    duration: '2:21',
  ),
  Song(id: 5, title: 'Bad Habits', artist: 'Ed Sheeran', duration: '3:51'),
  Song(id: 6, title: 'Save Your Tears', artist: 'The Weeknd', duration: '3:35'),
  Song(id: 7, title: 'Peaches', artist: 'Justin Bieber', duration: '3:18'),
];
