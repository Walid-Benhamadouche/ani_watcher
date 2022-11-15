import 'keywords.dart';

class Parser {
  String name;
  String _episode = '';
  String _name = '';
  String _season = '';
  int _episodeNumberIndex = -1;
  List<String> _tokens = [];

  Parser({required this.name}){
    name = name.toUpperCase();
    name = name.replaceAll("_", " ");
    name = name.replaceAll("]", "] ");
    name = name.replaceAll("×", "X");
    _tokanize();
    _searchForEpisode();
    _searchSeason();
    _searchAnimeName(false);
  }

  Parser.fromnyaa({required this.name}){
    _tokanize();
    _searchForEpisode();
    _searchSeason();
    _searchAnimeName(true);
  }

  _tokanize(){
    _removeExtraWords();
    name.split(" ");
    _tokens = name.split(" ");
  }

  _searchForEpisode(){
    var temp = '';
    var tempToken = '';
    for (String token in _tokens.reversed){
      tempToken = token;
      if (token.contains(RegExp(r'[0-9]+'))){
        if(token.contains(RegExp(r'^[0-9]+$'))){
          if(int.parse(token) < 1917){
            _episode = token;
            _episodeNumberIndex = _tokens.indexOf(tempToken);
            return;
          }
        }
        else if (token.contains(RegExp(r'^\[[0-9]+\]$'))){
          temp = token.split("[")[1].split("]")[0];
          if(int.parse(temp) < 1917){
            _episode = temp;
            _episodeNumberIndex = _tokens.indexOf(tempToken);
            return;
          }
        }
        else if (token.contains(RegExp(r'^\([0-9]+\)$'))){
          temp = token.split("(")[1].split(")")[0];
          if(int.parse(temp) < 1917){
            _episode = temp;
            _episodeNumberIndex = _tokens.indexOf(tempToken);
            return;
          }
        }
        else if (token.length < 8){
          for (String episodePrefix in Keywords.episodePrefix){
          if (token.contains(episodePrefix)){
            _episode = token.split(episodePrefix)[1].replaceAll(RegExp(r'[A-Z]+'), '');
            _episodeNumberIndex = _tokens.indexOf(tempToken);
            return;
          }
        }
        }
      }
    }
  }

  _searchAnimeName(bool nyaa){
    int beginIndex = 0;
    
    if (_tokens[0].contains("[")){
      beginIndex = 1;
    }
    List<String> tokens;
    if(!nyaa){
      if(_episodeNumberIndex != -1){
        print(_tokens[_episodeNumberIndex]);
      _tokens[_episodeNumberIndex] = _tokens[_episodeNumberIndex].replaceAll(_tokens[_episodeNumberIndex], "");
      }
      tokens = _tokens.sublist(beginIndex);
    }
    else{
      if(_episodeNumberIndex != -1){
        tokens = _tokens.sublist(beginIndex, _episodeNumberIndex);
      }
      tokens = _tokens.sublist(beginIndex);
    }
    
    var temp = "";
    for (String tokent in tokens) {
      if (tokent.contains(RegExp(r'^\[[0-9]+\]$'))){
          temp = tokent.split("[")[1].split("]")[0];
          if(int.parse(temp) > 1917){
            tokens.remove(tokent);
            break;
          }
        }
    else if (tokent.contains(RegExp(r'^\([0-9]+\)$'))){
          temp = tokent.split("(")[1].split(")")[0];
          if(int.parse(temp) > 1917){
            tokens.remove(tokent);
            break;
          }
        }
    }
    for (String token in tokens){
      if (token.contains("[")){
        tokens.remove(token);
        break;
      }
    }
    _name = tokens.join(" ");
    
    for (String season in Keywords.animeSeasonPrefix){
      _name = _name.replaceAll(season, "");
    }
    
    for (String episode in Keywords.episodePrefixR){
      _name = _name.replaceAll(episode, "");
    }
    
    _name = _name.replaceAll(RegExp(r'[():_.&+,-]'), "");
    _name = _name.replaceAll(RegExp(r'\['), "");
    _name = _name.replaceAll(RegExp(r'\]'), "");
  }

  _searchSeason(){
    var toRemove = '';
    for (String token in _tokens) {
      for (String season in Keywords.animeSeasonPrefix){
        if (token.contains(season)) {
          _season = _tokens[_tokens.indexOf(token)+1];
          toRemove =_tokens[_tokens.indexOf(token)+1];
          _tokens.remove(toRemove);
          break;
        }
        else if (token.contains(RegExp(r'^S{1}[0-9]+'))){
          _season = token.split("S")[1].split(RegExp(r'[A-Z]'))[0];
          toRemove = token;
          if (_tokens.indexOf(toRemove) == _episodeNumberIndex){
            _episodeNumberIndex = -1;
          }
          _tokens.remove(toRemove);
          break;
        }
      }
      if (toRemove != ''){
        break;
      }
    }
  }

  _removeExtraWords(){
    for (String extention in Keywords.fileExtension){
      name = name.replaceAll("."+extention, "");
    }
    
    for (String audio in Keywords.audioTerm){
      name = name.replaceAll(audio, "");
    }
    
    for (String language in Keywords.language){
      name = name.replaceAll(language, "");
    }

    for(String other in Keywords.other){
      name = name.replaceAll(other, "");
    }

    for(String information in Keywords.releaseInformation){
      name = name.replaceAll(information, "");
    }

    for(String version in Keywords.releaseVersion){
      name = name.replaceAll(version, "");
    }

    for(String source in Keywords.source){
      name = name.replaceAll(source, "");
    }

    for(String subtitle in Keywords.subtitles){
      name = name.replaceAll(subtitle, "");
    }

    for(String videoTerm in Keywords.videoTerm){
      name = name.replaceAll(videoTerm, "");
    }

    for(String volumePrefix in Keywords.volumePrefix){
      name = name.replaceAll(volumePrefix, "");
    }
  }

  
  get episode => _episode;
  get animeName => _name;
  get animeSeason => _season;
}