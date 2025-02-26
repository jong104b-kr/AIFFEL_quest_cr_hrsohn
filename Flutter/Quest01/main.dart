import 'dart:async'; // 비동기 작업을 위한 Timer 라이브러리 추가
                     // async : await을 사용한 비동기 함수를
                     // 정의하는 키워드. 이 함수의 반환타입은 항상 Future이다.
                     // https://genius-duck-coding-story.tistory.com/290

class PomodoroTimer {
  int workDuration = 25; // 작업 시간 : (25초) * 60 =  (25분) → (25초)
  int shortBreak = 5;   // 짧은 휴식 시간 : (5초) * 60 = (5분) → (5초)
  int longBreak = 15;   // 긴 휴식 시간 (15초) * 60 =  (15분) → (15초)
  int cycle = 4; // 4회차마다 긴 휴식 적용
  int currentCycle = 0; // 현재 진행 중인 사이클 횟수
  bool isWorking = true; // 현재 작업 중인지 여부
  Timer? timer; // Timer 객체 선언, 교재 p.85 참고, 널 허용(?)

  // 타이머 시작 함수(메소드)
  void startTimer() {
    // 현재 모드(작업/휴식)에 따라 시간 설정
    // 삼항연산자 중첩 사용, https://blog.naver.com/kyg1022/223154013342 참고
    int duration =
        isWorking
        ? workDuration 
        : (currentCycle == cycle - 1 ? longBreak : shortBreak);

    // 1초마다 실행되는 타이머 설정, Timer 클래스 사용, 인스턴수 변수 timer 호출
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (duration <= 0) { // 시간이 종료되면
        timer.cancel(); // 타이머 정지
        switchMode(); // 모드 변경 (작업 <-> 휴식)
      } else {
        duration--; // 남은 시간 1초 감소
        printTime(duration); // 현재 시간 출력
      }
    }); // 괄호 위치 수정해야 함, 들여쓰기 맞추기
  }

  // 작업 <-> 휴식 모드 변경 함수(메소드)
  void switchMode() {
    isWorking = !isWorking; // 작업 <-> 휴식 상태 전환, 불리언 자료형

    // 작업이 끝나고 휴식으로 전환될 때 사이클 증가
    if (!isWorking) {
      currentCycle = (currentCycle + 1) % cycle;
    }

    startTimer(); // 새로운 모드로 타이머 시작, 메소드 호출 
  }

  // 남은 시간을 mm:ss 형식으로 출력하는 함수
  void printTime(int seconds) {
    // 분 계산,몫을 구하는 연산자(~/) 이용,https://brunch.co.kr/@mystoryg/120 참고
    int minutes = seconds ~/ 60;
    // 초 계산, 나머지 연산자(%) 이용
    int secs = seconds % 60;
    // 두 자리 수 형식 출력, https://code-lab.tistory.com/1334 참고
    print('$minutes:${secs.toString().padLeft(2, '0')}'); 
  }
} // 클래스 종료

void main() {
  PomodoroTimer pomodoro = PomodoroTimer(); // PomodoroTimer 객체 생성
  pomodoro.startTimer(); // 타이머 시작
}