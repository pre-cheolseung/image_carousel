import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:image_carousel/screen/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // 화면 전체(Edge-to-Edge) 영역까지 앱이 그려지도록 설정
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  // 상단 상태바 및 하단 내비게이션바 설정
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,   // 상단 상태바 투명
      // statusBarIconBrightness: Brightness.light,   // 상단 상태바 아이콘 색상 (밝게: light, 어둡게: dark)
      systemNavigationBarColor: Colors.transparent,   // 하단 내비게이션바 투명
      systemNavigationBarDividerColor: Colors.transparent,   // 하단 구분선 제거
      // systemNavigationBarIconBrightness: Brightness.light,   // 하단 내비게이션바 아이콘 색상 (밝게: light, 어둡게: dark)
    ),
  );
  // 상단 상태바 및 하단 내비게이션바 숨김
  // SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,   // 우측 상단 DEBUG 빨간색 배너 삭제
      home: HomeScreen(),
    ),
  );
}