import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 상단 상태바 아이콘 색상 (밝게: light, 어둡게: dark)
    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.light,
      ),
    );

    return Scaffold(
      body: PageView(   // 페이지뷰 추가
        children: [1, 2, 3, 4, 5].map(   // 샘플 리스트 생성 및 위젯으로 매핑
          (number) => Image.asset(
            'assets/img/image_$number.jpeg',
            fit: BoxFit.cover,   // BoxFit.cover 설정
          ),
        ).toList(),
      ),
    );
  }
}