import 'package:flutter/material.dart';
import 'package:flutter_yizhi/res/colors.dart';
import 'package:flutter_yizhi/util/image_utils.dart';

class EmptyWidget extends StatelessWidget {
  const EmptyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height - 200,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
              image: ImageUtils.getAssetImage('empty'),
              width: 120.0,
              height: 120.0,
              color: Colours.app_main,
            ),
            const Text(
              '空空如也',
              style: TextStyle(
                fontSize: 16,
              ),
            )
          ],
        ),
      ),
    );
  }
}
