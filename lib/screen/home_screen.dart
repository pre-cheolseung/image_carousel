import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
      body: renderEmpty(),
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

  Widget renderEmpty() {
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

// 로고를 보여줄 위젯
class Logo extends StatelessWidget {
  final GestureTapCallback onTap;   // 탭 했을 때 실행할 함수

  const Logo({
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,   // 상위 위젯으로부터 탭 콜백 수신
      child: Image.asset(
        'assets/img/logo.png',   // 로고 이미지
      ),
    );
  }
}

// 앱 제목을 보여줄 위젯
class AppName extends StatelessWidget {
  const AppName({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
      color: Colors.grey,
      fontSize: 30.0,
      fontWeight: FontWeight.w300,
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,   // 글자 가운데 정렬
      children: [
        Text(
          'IMAGE',
          style: textStyle,
        ),
        Text(
          'CAROUSEL',
          style: textStyle.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w700,   // textStyle에서 두께만 700으로 변경
          ),
        ),
      ],
    );
  }
}

// 전달받은 Map 데이터를 PageController를 사용해 곧바로 보여주는 두 번째 화면
class ImageSliderScreen extends StatefulWidget {
  final Map<String, File> imagesMap;

  const ImageSliderScreen({super.key, required this.imagesMap});

  @override
  State<ImageSliderScreen> createState() => _ImageSliderScreenState();
}

class _ImageSliderScreenState extends State<ImageSliderScreen> {
  late final PageController _pageController;
  late final List<File> _fileList;
  // 현재 가리키고 있는 페이지 인덱스 상태 관리
  int _currentPage = 0;

  // initState() 함수 등록
  @override
  void initState() {
    super.initState();   // 부모 initState() 실행
    _pageController = PageController(initialPage: 0);
    // Map의 value(File)들만 추출하여 PageView에 사용할 List로 변환
    _fileList = widget.imagesMap.values.toList();

    Timer.periodic(   // Timer.periodic() 등록
      Duration(seconds: 3),   // 3초마다 콜백 실행
      (timer) {
        // 현재 페이지
        int? nextPage = _pageController.page?.toInt();
        
        if (nextPage == null) {   // 페이지 값이 없을 때 예외 처리
          return;
        }

        if (nextPage == 4) {   // 첫 페이지와 마지막 페이지 분기 처리
          nextPage = 0;
        } else {
          nextPage++;
        }

        _pageController.animateToPage(   // 부드럽게 페이지 변경
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
    // 상단 상태바 아이콘 색상 (밝게: light, 어둡게: dark)
    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.light,
      ),
    );

    return Scaffold(
      body: _fileList.isEmpty
          ? const Center(child: Text('No image selected'))
          : Stack(
            children: [
              // PageView를 통해 좌우 슬라이드로 이미지 노출
              PageView.builder(   // PageView 추가
                controller: _pageController,   // PageController 등록
                itemCount: _fileList.length,
                onPageChanged: (int page) {
                    setState(() {
                      _currentPage = page; // 페이지 전환 시 인덱스 업데이트
                    });
                  },
                itemBuilder: (context, index) {
                  // 기기 내 로컬 파일이므로 Image.file을 사용하여 출력
                  return Image.file(
                    // Map에서 인덱스(Key)에 해당하는 이미지 파일 가져오기
                    _fileList[index],
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