import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// StatefulWidget 정의
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  // @override
  // State<HomeScreen> createState() => _HomeScreenState();
  @override
  State<HomeScreen> createState() {
    return _HomeScreenState();
  }
}

// _HomeScreenState 정의
class _HomeScreenState extends State<HomeScreen> {
  // 페이지컨트롤러 생성
  final PageController pageController = PageController();

  // initState() 함수 등록
  @override
  void initState() {
    super.initState();   // 부모 initState() 실행

    Timer.periodic(   // Timer.periodic() 등록
      Duration(seconds: 3),   // 3초마다 콜백 실행
      (timer) {
        // 현재 페이지
        int? nextPage = pageController.page?.toInt();

        if (nextPage == null) {   // 페이지 값이 없을 때 예외 처리
          return;
        }

        if (nextPage == 4) {   // 첫 페이지와 마지막 페이지 분기 처리
          nextPage = 0;
        } else {
          nextPage++;
        }

        pageController.animateToPage(   // 부드럽게 페이지 변경
          nextPage,   // 이동할 페이지
          duration: Duration(milliseconds: 500),   // 페이지 이동 소요 시간 설정
          curve: Curves.ease,   // 페이지 이동 애니메이션 방식 설정
        );
      }
    );
  }

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
        controller: pageController,   // 페이지컨트롤러 등록
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