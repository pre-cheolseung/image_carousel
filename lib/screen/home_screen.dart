import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:image_carousel/screen/image_slider_screen.dart';
import 'package:image_carousel/widget/app_name.dart';
import 'package:image_carousel/widget/logo.dart';

import 'package:image_picker/image_picker.dart';

// StatefulWidget 정의
// 이미지를 다중 선택하여 Map에 저장하는 첫 번째 화면
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
  // ImagePicker 객체 초기화
  final ImagePicker _picker = ImagePicker();
  // 선택한 이미지를 저장할 Map 객체 (Key: 파일명, Value: File 객체)
  final Map<String, File> _selectedImagesMap = {};

  // // initState() 함수 등록
  // @override
  // void initState() {
  //   super.initState();   // 부모 initState() 실행

  //   Timer.periodic(   // Timer.periodic() 등록
  //     Duration(seconds: 3),   // 3초마다 콜백 실행
  //     (timer) {
  //       // 현재 페이지
  //       int? nextPage = pageController.page?.toInt();

  //       if (nextPage == null) {   // 페이지 값이 없을 때 예외 처리
  //         return;
  //       }

  //       if (nextPage == 4) {   // 첫 페이지와 마지막 페이지 분기 처리
  //         nextPage = 0;
  //       } else {
  //         nextPage++;
  //       }

  //       pageController.animateToPage(   // 부드럽게 페이지 변경
  //         nextPage,   // 이동할 페이지
  //         duration: Duration(milliseconds: 500),   // 페이지 이동 소요 시간 설정
  //         curve: Curves.ease,   // 페이지 이동 애니메이션 방식 설정
  //       );
  //     }
  //   );
  // }

  // @override
  // Widget build(BuildContext context) {
  //   // 상단 상태바 아이콘 색상 (밝게: light, 어둡게: dark)
  //   // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
  //   SystemChrome.setSystemUIOverlayStyle(
  //     const SystemUiOverlayStyle(
  //       statusBarIconBrightness: Brightness.light,
  //     ),
  //   );

  //   return Scaffold(
  //     body: PageView(   // PageView 추가
  //       controller: pageController,   // PageController 등록
  //       children: [1, 2, 3, 4, 5].map(   // 샘플 리스트 생성 및 위젯으로 매핑
  //         (number) => Image.asset(
  //           'assets/img/image_$number.jpeg',
  //           fit: BoxFit.cover,   // BoxFit.cover 설정
  //         ),
  //       ).toList(),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: entry(),
    );
  }

  BoxDecoration getBoxDecoration() {
    return BoxDecoration(
      // 그라데이션 색상 적용
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFF2A3A7C),
          Color(0xFF000118),
        ],
      ),
    );
  }

  Widget entry() {
    return Container(
      decoration: getBoxDecoration(),
      width: MediaQuery.of(context).size.width,   // 최대 넓이로 설정
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,   // 위젯들 가운데 정렬
        children: [
          Logo(   // 로고 이미지
            onTap: _pickImages,   // 로고를 탭 했을 때 실행할 함수
          ),
          SizedBox(
            height: 30.0,
          ),
          AppName(),   // 앱 이름
        ],
      ),
    );
  }

  // 이미지 다중 선택 함수
  Future<void> _pickImages() async {
    // 기기 내 갤러리에서 이미지 다중 선택
    final List<XFile> images = await _picker.pickMultiImage(limit: 5);
    
    if (images.isNotEmpty) {
      setState(() {
        _selectedImagesMap.clear();
        for (var xFile in images) {
          // 파일명을 Key로, File 객체를 Value로 Map에 저장
          _selectedImagesMap[xFile.name] = File(xFile.path);
        }
      });

      // 이미지가 정상적으로 Map에 담기면 곧바로 다음 화면으로 이동하며 데이터 전달
      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ImageSliderScreen(imagesMap: _selectedImagesMap),
          ),
        );
      }
    }
  }
}