import 'dart:async'; // 비동기 작업을 위한 Timer 라이브러리 추가
                     // async : await을 사용한 비동기 함수를
                     // 정의하는 키워드. 이 함수의 반환타입은 항상 Future이다.
                     // https://genius-duck-coding-story.tistory.com/290

class PomodoroTimer {
  int workDuration = 25; // 작업 시간 : (25초) * 60 =  (25분) → (25초) 시연시간 단축을 위해 변경. *60을 해주면 25분으로 변경가능
  int shortBreak = 5;   // 짧은 휴식 시간 : (5초) * 60 = (5분) → (5초)  상동 *60을 해주면 5분으로 변경가능
  int longBreak = 15;   // 긴 휴식 시간 (15초) * 60 =  (15분) → (15초)  상동*60을 해주면 15분으로 변경가능
  int cycle = 4; // 4회차마다 긴 휴식(15초) 적용
  int currentCycle = 0; // 현재 진행 중인 사이클 횟수
  bool isWorking = true; // 현재 작업 중인지 여부
  Timer? timer; // Timer 객체 선언, 교재 p.85 참고, 
                //(물음표)는 nullable 타입을 의미하며, timer 변수에 null을 저장할 수 있음을 나타냄. 
                //초기에는 null 상태이며, startTimer() 함수가 실행될 때 Timer.periodic()을 통해 timer가 생성. 
                //타이머가 실행되지 않는 초기 상태에서 timer는 존재하지 않으므로 null로 초기화.

  // 타이머 시작 함수(메소드)
  void startTimer() {
    // 현재 모드(작업/휴식)에 따라 시간 설정
    // 삼항연산자 중첩 사용, https://blog.naver.com/kyg1022/223154013342 참고
    int duration =
        isWorking
        ? workDuration 
        : (currentCycle == cycle - 1 ? longBreak : shortBreak);
        //isWorking이 true(작업 중) 이면 workDuration(25초) 할당
        //isWorking이 false(휴식 시간) 이면 두 번째 조건문 실행

        //currentCycle == cycle - 1이면 긴 휴식 (longBreak, 15초) 적용
        //그렇지 않으면 짧은 휴식 (shortBreak, 5초) 적용

    // 1초마다 실행되는 타이머 설정, Timer 클래스 사용, 인스턴수 변수 timer 호출
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (duration <= 0) { // 시간이 종료되면
        timer.cancel(); // 타이머 정지
        switchMode(); // 모드 변경 (작업 <-> 휴식)
      } else {
        duration--; // 남은 시간 1초 감소
        printTime(duration); // 현재 시간 출력
      }
    }); 
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

//전체해석
//현재 isWorking == true (작업 중) 이라면?
//duration = workDuration (25초)


//현재 isWorking == false (휴식 중) 이라면?
//currentCycle == cycle - 1 (예: 4번째 작업이 끝난 후) → longBreak (15초) 적용
//그렇지 않으면 shortBreak (5초) 적용