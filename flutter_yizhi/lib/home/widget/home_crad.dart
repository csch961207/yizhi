import 'package:flutter/material.dart';
import 'package:flutter_yizhi/home/home_router.dart';
import 'package:flutter_yizhi/routers/fluro_navigator.dart';

import '../../my/my_router.dart';

class HomeCard extends StatelessWidget {
  const HomeCard(this.id, this.title, this.author, this.tags, this.isDeleted,
      {super.key, this.isEdit = false});

  final int id;
  final String title;
  final String author;
  final List<String> tags;
  final bool? isDeleted;
  final bool? isEdit;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (isDeleted == true) {
          return;
        }
        if (isEdit == false) {
          NavigatorUtils.push(context, '${HomeRouter.detailsPage}?id=$id');
        } else {
          NavigatorUtils.push(context, '${MyRouter.createOrEditPage}?id=$id');
        }
      },
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: const Color(0xffe4e4e7),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(4)),
        child: Padding(
          padding: const EdgeInsets.all(7),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(3),
                child: Text(
                  title,
                  maxLines: 11,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: isDeleted == true
                          ? const Color(0xff717179)
                          : const Color(0xff09090B),
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(3),
                child: Text(
                  author,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style:
                      const TextStyle(color: Color(0xff717179), fontSize: 14),
                ),
              ),
              Wrap(
                  children: List.generate(
                      tags.length,
                      (index) => GestureDetector(
                            onTap: () {
                              NavigatorUtils.push(context,
                                  '${HomeRouter.labelPage}?tag=${Uri.encodeComponent(tags[index])}');
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 3),
                              child: Text(
                                '#${tags[index]}',
                                style: const TextStyle(
                                    color: Color(0xff3A48D1), fontSize: 12),
                              ),
                            ),
                          )))
            ],
          ),
        ),
      ),
    );
  }
}
