import 'package:flutter/material.dart';
import 'package:memochat/components/chapter_card.dart';
import 'package:memochat/data/constants.dart';

class ChaptersScreen extends StatelessWidget {
  final Function(int) onChapterSelected;

  const ChaptersScreen({
    super.key,
    required this.onChapterSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chapters'),
      ),
      body: Container(
        color: Colors.grey[100], // Very light grey background color
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount:
                (MediaQuery.of(context).size.width <= widthForMobile) ? 1 : 2,
            crossAxisSpacing: 16.0,
            mainAxisSpacing: 16.0,
            childAspectRatio: MediaQuery.of(context).size.width /
                (MediaQuery.of(context).size.height / 5),
          ),
          itemCount: chaptersList.length,
          itemBuilder: (context, index) {
            var chapter = chaptersList[index];
            return ChapterCard(
              index: index,
              title: chapter.name,
              description: chapter.description,
              stats: chapter.stats,
              onTap: () => onChapterSelected(index + 1),
            );
          },
        ),
      ),
    );
  }
}
