class Location {
  int bangkok;
  int chonburi;

  Location(
      {this.bangkok,
      this.chonburi,
 });
  factory Location.fromJson(Map<String, dynamic> json) {
    return new Location(
      bangkok: json['Bangkok'] as int,
      chonburi: json['Chonburi'] as int,
    );
  }
}
