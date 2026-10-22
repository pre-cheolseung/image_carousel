// 전달받은 Map 데이터를 PageController를 사용해 곧바로 보여주는 두 번째 화면
import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ImageSliderScreen extends StatefulWidget {
  final Map<String, File> imagesMap;

  const ImageSliderScreen({super.key, required this.imagesMap});

  @override
  State<ImageSliderScreen> createState() => _ImageSliderScreenState();
}

class _ImageSliderScreenState extends State<ImageSliderScreen> {
  late final PageController _pageController;
  late final List<File> _fileList;

  int _currentPage = 0;   // 현재 가리키고 있는 페이지 인덱스 상태 관리

  // initState() 함수 등록
  @override
  void initState() {
    super.initState();   // 부모 initState() 실행
    _pageController = PageController(initialPage: 0);
    _fileList = widget.imagesMap.values.toList();   // Map의 value(File)들만 추출하여 PageView에 사용할 List로 변환

    // Timer.periodic() 등록
    Timer.periodic(
      Duration(seconds: 3),   // 3초마다 콜백 실행
      (timer) {
        int? nextPage = _pageController.page?.toInt();   // 현재 페이지
        
        // 페이지 값이 없을 때 예외 처리
        if (nextPage == null) {
          return;
        }

        // 첫 페이지와 마지막 페이지 분기 처리
        if (nextPage == 4) {
          nextPage = 0;
        } else {
          nextPage++;
        }

        // 페이지 부드럽게 변경
        _pageController.animateToPage(
          nextPage,   // 이동할 페이지
          duration: Duration(milliseconds: 500),   // 페이지 이동 소요 시간 설정
          curve: Curves.ease,   // 페이지 이동 애니메이션 방식 설정
        );
      }
    );
  }

  // dispose() 함수 등록
  @override
  void dispose() {
    _pageController.dispose();   // 메모리 해제 (누수 방지)
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);   // 상단 상태바 아이콘 색상 (밝게: light, 어둡게: dark)
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.light,   // 상단 상태바 아이콘 색상 (밝게: light, 어둡게: dark)
      ),
    );

    return Scaffold(
      body: _fileList.isEmpty
          ? const Center(child: Text('No image selected'))
          : Stack(
            children: [
              // PageView를 통해 좌우 슬라이드로 이미지 노출
              PageView.builder(
                controller: _pageController,   // _PageController 등록
                itemCount: _fileList.length,
                onPageChanged: (int page) {
                    setState(() {
                      _currentPage = page;   // 페이지 전환 시 인덱스 업데이트
                    });
                  },
                itemBuilder: (context, index) {
                  // 기기 내 로컬 파일이므로 Image.file을 사용하여 출력
                  return Image.file(
                    _fileList[index],   // Map에서 인덱스(Key)에 해당하는 이미지 파일 가져오기
                    fit: BoxFit.cover,   // BoxFit.cover 설정
                    width: double.infinity,
                    height: double.infinity,
                    // 로딩 에러 핸들링
                    errorBuilder: (context, error, stackTrace) {
                      return const Center(child: Icon(Icons.error));
                    },
                  );
                },
              ),
              Positioned(
                bottom: 30,   // 하단 여백 설정
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    _fileList.length,
                    (index) => AnimatedContainer(
                      duration: const Duration(milliseconds: 300),   // 크기 변경 시 부드러운 효과
                      margin: const EdgeInsets.symmetric(horizontal: 4.0),
                      height: 10,
                      width: _currentPage == index ? 24 : 10,   // 활성화된 페이지는 가로로 길게 효과 (웜 인디케이터 스타일)
                      decoration: BoxDecoration(
                        color: _currentPage == index 
                            ? Colors.white   // 활성화된 점 색상
                            : Colors.white.withOpacity(0.4),   // 비활성화된 점 색상
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
    );
  }
}