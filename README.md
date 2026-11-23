# Digital Photo Frame

Digital photo frame that automatically displays images in sequence.

- Flutter 3.47.7
- Dart 3.13.5

## Preparation

- Widget lifecycle

## Key Components

- StatefulWidget
- Image
- PageView
    - Controller
- Timer
- SystemChrome
    - Top status bar and bottom navigation bar settings.

## Additional Components

- ImagePicker
    - Load images stored on the device.

## Features

- Change settings such as status bar color
- Access to images stored in the system
- Other file formats besides JPG are supported
- Swipe left or right to change images
- Automatically roll over after the set time passes
- Image filling the screen

## 기능

- 상태바 색상 등 설정 변경
- 시스템에 저장된 이미지 접근
- JPG 외 다른 파일 형식 활용 가능
- 좌우로 스와이프해서 이미지 변경 가능
- 설정한 시간이 지나면 자동으로 롤링
- 화면에 꽉 찬 이미지