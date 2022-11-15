import 'package:flutter/foundation.dart';

class Anime {
  String? _animeName;
  String? _englishName;
  String? _romajiName;
  String? _nativeName;
  String? _imageLink;
  String? _coverLink;
  String? _seasonFormat;
  String? _season;
  String? _userStatus;
  String? _synopsis;
  String? _status;
  List<String>? _synonyms;
  List<dynamic>? _genres;
  List<dynamic>? _studios;
  int? _entryId;
  int? _mediaId;
  int? _score;
  int? _seasonYear;
  int? _episode;
  int? _episodes;
  int? _behind;
  int? _timeToNextEpisode;
  double? _uScore;

  Anime({required item, boolV}) {
    final _media;
    if (!boolV){
      _uScore = item['score'].toDouble();
      _media = item['media'];
    }
    else{
      _media = item;
    }
    _entryId = item['id'];
    _mediaId = _media['id'];
    _englishName = _media['title']['english'].toString();
    _romajiName = _media['title']['romaji'].toString();
    _nativeName = _media['title']['native'].toString();
    _animeName = _media['title']['userPreferred'].toString();
    _imageLink = _media['coverImage']['large'].toString();
    _seasonFormat = _media['format'];
    _season = _media['season'];
    _seasonYear = _media['seasonYear'];
    _episode = _media['mediaListEntry']?['progress'];
    _userStatus = _media['mediaListEntry']?['status'];
    _coverLink = _media['bannerImage'];
    _genres = _media['genres'];
    _score = _media['meanScore'];
    _studios = _media['studios']['nodes'];
    _synopsis = _media['description'];
    _status = _media['status'];

    if (_media['synonyms'] != null){
      _synonyms = [];
      for (var syn in _media['synonyms']){
        _synonyms!.add(syn.toString());
      }
    }

    if (_media['episodes'] != null) {
      _episodes = _media['episodes'];
    } else {
      _episodes = null;
    }

    if (_media['nextAiringEpisode'] != null) {
      _timeToNextEpisode = _media['nextAiringEpisode']['timeUntilAiring'];
    } else {
      _timeToNextEpisode = null;
    }

    if (_media['nextAiringEpisode'] != null && _episode != null) {
      _behind = _media['nextAiringEpisode']['episode'] - _episode - 1;
    } else if (_episodes != null && _episode != null) {
      _behind = _media['episodes'] - _episode;
    }
  }

  get entryId {
    return _entryId;
  }

  get mediaId {
    return _mediaId;
  }

  get englishName {
    return _englishName;
  }

  get romajiName {
    return _romajiName;
  }

  get nativeName {
    return _nativeName;
  }

  get userStatus {
    return _userStatus;
  }

  get synopsis {
    return _synopsis;
  }

  get status {
    return _status;
  }

  get genres {
    return _genres;
  }

  get studios {
    List<dynamic> temp = [];
    for (var studio in _studios!) {
      temp.add(studio['name']);
    }
    return temp;
  }

  get score {
    return _score;
  }

  get animeName {
    return _animeName;
  }

  get imageLink {
    return _imageLink;
  }

  get seasonFormat {
    return _seasonFormat;
  }

  get coverLink {
    return _coverLink;
  }

  get season {
    return _season;
  }

  get seasonYear {
    return _seasonYear;
  }

  get episode {
    return _episode;
  }

  get episodes {
    if (_episodes != null) {
      return _episodes;
    } else {
      return '?';
    }
  }

  get behind {
    if (_behind != 0) {
      return '(+$_behind)';
    } else {
      return '';
    }
  }

  get behindInt {
    if (_behind == null){
      return 0;
    }
    return _behind;
  }

  get timeToNextEpisode {
    return _timeToNextEpisode;
  }

  get synonyms {
    _synonyms!.insert(0, _englishName!);
    _synonyms!.insert(0, _romajiName!);
    return _synonyms;
  }

  get timeToNextEpisodeString {
    if (_timeToNextEpisode != null) {
      var _timeInString = '';
      var _day = _timeToNextEpisode! ~/ (24 * 3600);
      var temp = _timeToNextEpisode! % (24 * 3600);
      var _hour = temp ~/ 3600;
      temp = temp % 3600;
      var _minute = temp ~/ 60;
      if (_day != 0) {
        _timeInString = _timeInString + '${_day}d ';
      }
      if (_hour != 0) {
        _timeInString = _timeInString + '${_hour}h ';
      }
      if (_minute != 0) {
        _timeInString = _timeInString + '${_minute}m';
      }
      return _timeInString;
    } else {
      return '';
    }
  }

get uScore {
  return _uScore;
}
}


class AnimeList extends ChangeNotifier {
  List<List<Anime>> animes = [[], [], [], [], [], [], []];
  void clearList(type) {
    animes[type].clear();
  }

  void addAnime(type, anime) {
    animes[type].add(anime);
  }

  void addAnimeN(type, anime) {
    animes[type].add(anime);
    notifyListeners();
  }

  void updateAnime(type, anime, index) {
    animes[type][index] = anime;
    notifyListeners();
  }

  void updateStatus(type, index, status) {
    animes[type][index]._userStatus = status;
    notifyListeners();
  }

  void updateScore(type, index, score) {
    animes[type][index]._uScore = score;
    notifyListeners();
  }

  void updateEpisode(type, index, episode) {
    int? temp = animes[type][index]._episode;
    animes[type][index]._episode = episode;
    if (animes[type][index]._behind != null)
    {
      animes[type][index]._behind = animes[type][index]._behind! + (temp! - animes[type][index]._episode!);
      if (animes[type][index]._behind! < 0 ){
        animes[type][index]._behind = 0;
      }
    }
    notifyListeners();
  }
}
