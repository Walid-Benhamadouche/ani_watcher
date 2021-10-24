class Anime {
  String? _animeName;
  String? _imageLink;
  String? _seasonFormat;
  String? _season;
  int? _seasonYear;
  int? _episode;
  int? _episodes;
  int? _behind;
  int? _timeToNextEpisode;

  Anime({required item}) {
    final _media = item['media'];
    _animeName = _media['title']['english'].toString();
    _imageLink = _media['coverImage']['extraLarge'].toString();
    _seasonFormat = _media['format'];
    _season = _media['season'];
    _seasonYear = _media['seasonYear'];
    _episode = _media['mediaListEntry']['progress'];

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

    if (_media['nextAiringEpisode'] != null) {
      _behind = _media['nextAiringEpisode']['episode'] - _episode - 1;
    } else if (_episodes != null) {
      _behind = _media['episodes'] - _episode;
    }
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

  get timeToNextEpisode {
    return _timeToNextEpisode;
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
}
