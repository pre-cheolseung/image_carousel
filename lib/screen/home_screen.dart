import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:image_carousel/screen/image_slider_screen.dart';
import 'package:image_carousel/widget/app_name.dart';
import 'package:image_carousel/widget/logo.dart';

import 'package:image_picker/image_picker.dart';

// 이미지를 다중 선택하여 Map에 저장하는 첫 번째 화면
// StatefulWidget 정의
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);   // const 생성자 : 최초 선언 후 변경 불가능한 빌드 타임 함수

  @override
  // State<HomeScreen> createState() => _HomeScreenState();
  State<HomeScreen> createState() {
    return _HomeScreenState();
  }
}

// _HomeScreenState 정의
class _HomeScreenState extends State<HomeScreen> {
  final ImagePicker _picker = ImagePicker();   // ImagePicker 객체 초기화
  final Map<String, File> _selectedImagesMap = {};   // 선택한 이미지를 저장할 Map 객체 (Key: 파일명, Value: File 객체)

  // // initState() 함수 등록
  // @override
  // void initState() {
  //   super.initState();   // 부모 initState() 실행

  //   // Timer.periodic() 등록
  //   Timer.periodic(
  //     Duration(seconds: 3),   // 3초마다 콜백 실행
  //     (timer) {
  //       int? nextPage = pageController.page?.toInt();   // 현재 페이지

  //       // 페이지 값이 없을 때 예외 처리
  //       if (nextPage == null) {
  //         return;
  //       }

  //       // 첫 페이지와 마지막 페이지 분기 처리
  //       if (nextPage == 4) {
  //         nextPage = 0;
  //       } else {
  //         nextPage++;
  //       }

  //       // 페이지 부드럽게 변경
  //       pageController.animateToPage(
  //         nextPage,   // 이동할 페이지
  //         duration: Duration(milliseconds: 500),   // 페이지 이동 소요 시간 설정
  //         curve: Curves.ease,   // 페이지 이동 애니메이션 방식 설정
  //       );
  //     }
  //   );
  // }

  // @override
  // Widget build(BuildContext context) {
  //   // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);   // 상단 상태바 아이콘 색상 (밝게: light, 어둡게: dark)
  //   SystemChrome.setSystemUIOverlayStyle(
  //     const SystemUiOverlayStyle(
  //       statusBarIconBrightness: Brightness.light,   // 상단 상태바 아이콘 색상 (밝게: light, 어둡게: dark)
  //     ),
  //   );

  //   return Scaffold(
  //     // PageView를 통해 좌우 슬라이드로 이미지 노출
  //     body: PageView(
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
          // 로고 이미지
          Logo(
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
    final List<XFile> images = await _picker.pickMultiImage(limit: 5);   // 기기 내 갤러리에서 이미지 다중 선택
    
    if (images.isNotEmpty) {
      setState(() {
        _selectedImagesMap.clear();
        for (var xFile in images) {
          _selectedImagesMap[xFile.name] = File(xFile.path);   // 파일명을 Key로, File 객체를 Value로 Map에 저장
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