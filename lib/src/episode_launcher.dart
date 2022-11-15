import 'keywords.dart';
import 'parser.dart';

class EpisodeLauncher {

  static bool launchEpisode(List<String> names, file,int episode, String format){
  Parser episodeFound = Parser(name: file);
  bool found = false;
  bool toReturn = false;
  if (episodeFound.episode == "") {
    return false;
  }
  if (format == "MOVIE"){
  }
  else if(int.parse(episodeFound.episode) != episode){
    return false;
  }
  if (episodeFound.animeSeason != ""){
    for (String name in names){
      if (name.contains(int.parse(episodeFound.animeSeason).toString())){
        found = true;
        break;
      }
  }
  }
  if (found){
    for (String name in names){
      String animeToWatch = name.toUpperCase();
      for (String season in Keywords.animeSeasonPrefix){
        animeToWatch = animeToWatch.replaceAll(season, "");
        animeToWatch = animeToWatch.replaceAll(RegExp(r'[:_.&+,-]'), "");
      }
      if (_isAnime(episodeFound.animeName, animeToWatch, found)){
        toReturn = true;
        break;
      }
    } 
  }
  else {
    for (String name in names){
      String animeToWatch = name.toUpperCase();
      for (String season in Keywords.animeSeasonPrefix){
        animeToWatch = animeToWatch.replaceAll(season, "");
        animeToWatch = animeToWatch.replaceAll(RegExp(r'[:_.&+,-]'), "");
      }
      if (format == "MOVIE"){  
        String temp = episodeFound.animeName+episodeFound.episode;
        if (_isAnime(animeToWatch, temp, found)){
          toReturn = true;
          break;
        }
      }
      if (_isAnime(animeToWatch, episodeFound.animeName, found)){
        toReturn = true;
        break;
      }
    }
  }
  return toReturn;
}

static bool _isAnime(String first,String second, bool found) {
  if (found){
    var lena = second.split(" ");
    lena.remove("");
    var len = lena.length;
    var temp = first.split(" ");
    List<String> temp1 = [];
    String prev = "";
    for (String token in temp){
      
      if(token == "" && prev ==""){
        temp1.clear();
      }
      else if(second.contains(token)){
          temp1.add(token);
          if (temp1.length == len){
            return true;
          }
      }
      prev = token;
    }
  }
  else{
    var temp = second.split(" ");
    List<String> temp1 = [];
    int len = 0;
    var prev;
    for (String token in temp){
      if(token == ""){
        continue;
      }
      else {
        if (prev ==""){
          if (temp1.length == len){
             return true;
          }
          else {
            temp1.clear();
          }
        }
        len++;
        if(first.contains(token)){
          temp1.add(token);
        }
      }
      prev = token;
    }
    if (temp1.length == len){
       return true;
    }
    else {
      return false;
    }
  }
  return false;
}
}