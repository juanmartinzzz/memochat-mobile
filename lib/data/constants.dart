import 'package:flutter/material.dart';

const int widthForMobile = 600;

class Chapter {
  final String id;
  final String name;
  final String description;
  final String stats;
  final IconData iconData;
  Chapter(this.id, this.name, this.description, this.stats, this.iconData);
}


var chaptersList = [
  Chapter("1", "The Roots of Me", "The Roots of Me", "100%", Icons.nature),
  Chapter("2", "Chalkboards and Daydreams", "Chalkboards and Daydreams", "100%", Icons.edit),
  Chapter("3", "Finding My Footing", "Finding My Footing", "100%", Icons.directions_walk),
  Chapter("4", "Love Stories and Heartbeats", "Love Stories and Heartbeats", "100%", Icons.favorite),
  Chapter("5", "Building the Dream", "Building the Dream", "100%", Icons.build),
  Chapter("6", "Words to Live By", "Words to Live By", "100%", Icons.book),
  Chapter("7", "Home Is Where the Heart Is", "Home Is Where the Heart Is", "100%", Icons.home),
  Chapter("8", "Strength in the Storm", "Strength in the Storm", "100%", Icons.storm),
  Chapter("9", "Footsteps Around the World", "Footsteps Around the World", "100%", Icons.public),
  Chapter("10", "Joyful Pursuits", "Joyful Pursuits", "100%", Icons.sentiment_satisfied),
  Chapter("11", "Living Through History", "Living Through History", "100%", Icons.history),
  Chapter("12", "The Golden Lens", "The Golden Lens", "100%", Icons.camera),
];
