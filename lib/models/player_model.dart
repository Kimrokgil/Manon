class Player {
  final String id;
  final String name;
  final String position;
  final int speed;
  final int shot;
  final int pass;
  final int dribble;
  final int defense;
  final int stamina;

  Player({
    required this.id,
    required this.name,
    required this.position,
    required this.speed,
    required this.shot,
    required this.pass,
    required this.dribble,
    required this.defense,
    required this.stamina,
  });

  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      id: json['id'],
      name: json['name'],
      position: json['position'],
      speed: json['speed'],
      shot: json['shot'],
      pass: json['pass'],
      dribble: json['dribble'],
      defense: json['defense'],
      stamina: json['stamina'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'position': position,
      'speed': speed,
      'shot': shot,
      'pass': pass,
      'dribble': dribble,
      'defense': defense,
      'stamina': stamina,
    };
  }
}
