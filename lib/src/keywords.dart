class Keywords {
  static List<String> get animeSeasonPrefix => ["SAISON", "SEASON"];

  static List<String> get animeTypeUnidentifiable => ["GEKIJOUBAN", "MOVIE", "OAD", "OAV", "ONA", "OVA", 
  "SPECIAL", "SPECIALS", "TV"];
                        
  static List<String> get animeTypeUnidentifiableInvalid => ["ED", "ENDING", "NCED", "NCOP", "OP", "OPENING", 
  "PREVIEW", "PV"];

  static List<String> get audioTerm => [
        // Audio channels
        "2.0CH", "2CH", "5.1", "5.1CH", "DTS", "DTS-ES",
         "DTS5.1",
        "TRUEHD5.1",
        // Audio codec
        "AAC", "AACX2", "AACX3", "AACX4", "AC3", "EAC3", "E-AC-3",
        "FLAC", "FLACX2", "FLACX3", "FLACX4", "LOSSLESS", "MP3", "OGG",
        "VORBIS",
        // Audio language
        "DUALAUDIO", "DUAL AUDIO"];

  static List<String> get deviceCompatibility => ["IPAD3", "IPHONE5", "IPOD", "PS3", "XBOX", "XBOX360"];

  static List<String> get deviceCompatibilityUnidentifiable => ["ANDROID"];

  static List<String> get episodePrefix => ["EPISODE", "EPISODE.", "EPISODES",
  "CAPITULO", "EPISODIO", "FOLGE", "#", "E", "EP", "EP.", "SP", "EPS", "EPS."];

  static List<String> get episodePrefixR => ["EPISODE", "EPISODE.", "EPISODES",
  "CAPITULO", "EPISODIO", "FOLGE"];

  static List<String> get episodePrefixInvalid => ["E", "\x7B2C"];  // single-letter episode keywords are not valid tokens

  static List<String> get fileExtension => ["3GP", "AVI", "DIVX", "FLV", "M2TS", "MKV", "MOV", "MP4", "MPG",
        "OGM", "RM", "RMVB", "TS", "WEBM", "WMV"];
  static List<String> get fileExtensioninvalid => ["AAC", "AIFF", "FLAC", "M4A", "MP3", "MKA", "OGG", "WAV",
       "WMA",
        "7Z", "RAR", "ZIP",
        "ASS", "SRT"];

  static List<String> get language => ["ENG", "ENGLISH", "ESPANOL", "JAP", "PT-BR", "SPANISH", "VOSTFR"];

  static List<String> get languageUnidentifiable => ["ESP", "ITA"];  // e.g. "Tokyo ESP", "Bokura ga Ita"

  static List<String> get other => ["REMASTER", "REMASTERED", "UNCENSORED", "UNCUT",
        "VFR", "WIDESCREEN"];

  static List<String> get releaseInformation => ["BATCH", "COMPLETE", "PATCH", "REMUX"];
        
  static List<String> get releaseInformationUnidentifiable => ["END",  "FINAL"];  // e.g. "The End of Evangelion",  FINAL Approach"

  static List<String> get releaseVersion => ["V0", "V1", "V2", "V3", "V4"];

  static List<String> get source => [
        "BD", "BDRIP", "BLURAY", "BLU-RAY",
        "DVD", "DVD5", "DVD9", "DVD-R2J", "DVDRIP", "DVD-RIP",
        "R2DVD", "R2J", "R2JDVD", "R2JDVDRIP",
        "HDTV", "HDTVRIP", "TVRIP", "TV-RIP",
        "WEBCAST", "WEBRIP"];

  static List<String> get subtitles => [
        "BIG5", "DUB", "DUBBED", "HARDSUB", "HARDSUBS", "RAW",
        "SOFTSUB", "SOFTSUBS", "SUB", "SUBBED", "SUBTITLED"];

  static List<String> get videoTerm => [
        // Frame rate
        "23.976FPS", "24FPS", "29.97FPS", "30FPS", "60FPS", "120FPS",
        // Video codec
        "8BIT", "8-BIT", "10BIT", "10BITS", "10-BIT", "10-BITS",
        "HI10", "HI10P", "HI444", "HI444P", "HI444PP",
        "H264", "H265", "H.264", "H.265", "X264", "X265", "X.264",
        "AVC", "HEVC", "HEVC2", "DIVX", "DIVX5", "DIVX6", "XVID",
        // Video format
        "AVI", "RMVB", "WMV", "WMV3", "WMV9",
        // Video quality
        "HQ", "LQ",
        // Video resolution
        "HD", "SD"];

  static List<String> get volumePrefix => ["VOL", "VOL.", "VOLUME"];
}