import 'package:flutter/material.dart';

class ChapterCard extends StatelessWidget {
  final int index;
  final String title;
  final String description;
  final String stats;
  final VoidCallback onTap;

  const ChapterCard({
    super.key,
    required this.index,
    required this.title,
    required this.description,
    required this.stats,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4), // Subtle rounded corners
        ),
        shadowColor: Colors.grey[200], // Color of the shadow
        elevation: 4, // Increased elevation for more visible shadow
        margin: const EdgeInsets.only(
            right: 8,
            bottom: 0), // Margin to create space for shadow on the right
        child: Padding(
          padding: const EdgeInsets.all(8), // Padding inside the card
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 0,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 4), // Space between title and description
              Text(
                description,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 8), // Space before stats
              Text(
                stats,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
