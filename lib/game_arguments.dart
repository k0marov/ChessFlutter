class GameArguments {
  bool asBlack;
  bool isMultiplayer;
  String difficultyOfAI; 

  GameArguments({
    this.asBlack = false, 
    this.isMultiplayer = false, 
    this.difficultyOfAI = "",
  }); 

  GameArguments.fromJson(Map<String, dynamic> json)
      : asBlack = json['asblck'], 
        isMultiplayer = json['ismp'], 
        difficultyOfAI = json['diff']; 
        

  Map<String, dynamic> toJson() {
    return {
      'asblck': asBlack, 
      'ismp': isMultiplayer, 
      'diff': difficultyOfAI, 
    };
  }
}
