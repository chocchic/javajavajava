1. 제어문
	- 조건문		: if, switch  
	- 반복문		: while, do-while, for  
	- 보조제어문	: break(강제종료), continue(반복하다 건너띄기)  
	
	1) while 반복문
		- 조건식을 먼저 검사한 후, 실행하는 반복문 (루프)
		- 조건식이 true이면 계속 반복
		- 실행문 영역{}안에서 루프를 종료할 수 있게 만들어 줘야한다.
	
		* [ 구조1 ] : 반복의 횟수를 알 때  
			```java
			변수 = 초기값;
			while(조건식){
				실행문들...;
				증감식; //증감식으로 조건식을 조절->loop에서 빠져나옴
			}
			```  
    
		* [ 구조2 ] : 반복의 횟수를 알지 못할 떄  
			```java
			while(true) {
				실행문들...;
				if(조건문) break; // 종료 시점이 반드시 필요하다.
			}
			```
    
	2) do-while  
		선처리 후비교 :  실행 먼저한 후 조건을 검사하는 형태  
		(1번은 무조건 실행된다)
	
		* [ 구조 ]  
			```java
			do{
				// 반복할 코드 작성
			}while(조건식);
			```
	3) for 반복문
		지정된 수만큼 반복해서 실행
		
		* [ 구조 ]
			```java  
			    (1)    (2)    (4)  
			for(초기식; 조건식; 증감식){
				// 반복할 코드 작성 ... (3) 
			}
			```  
		실행 순서 : (1) -> (2) -> (3) -> (4) -> (2) -> (3) => (4) -> (2) -> ... -> (2)  
		(2)단계에서 조건식이 거짓(False)이 되면 for문을 종료한다.
2. 배열 array  
	- 같은 타입의 여러 변수를 합쳐놓은 형태와 비슷  
	- 데이터 공간 수정 / 변경이 어렵다  
	- 변수 == 단독주택, 배열 == 아파트  
	1) 선언  
		```java
		타입[] 변수명;
		타입 변수명[];
		ex)
		int[] arr; //배열
		int arr[]; //위와 같은 의미
		String[] str;
		int a; //변수

		int[] arr;
		```  
		
		int : 배열의 타입, 배열에ㅔ 저장할 수 있는 데이터들의 타입
		[] : 배열 만든다 선언
		arr : 배열의 이름, 배열에 대한 레퍼런스(주소) 변수 (레퍼런스 == 참조)

		선언만으로는 배열의 공간이 할당되지 않으며, arr이라는 레퍼런스 변수만 선언된 것이다.  
		레퍼런스 변수는 실제 값이 저장되는 배열 공간의 주소값(레퍼런스 값)을 저장하며 그 자체가 변수는 아니다.  
		배열 공간이 생성되지 않았기 때문에 선언만 할 시, 레퍼런스 변수의 초기값은 null이다.  
		-> 레퍼런스 = 배열의 주소 겂, 레퍼런스 변수 = 주소값을 저장하는 변수  
	
	2) 생성
		```java
		arr = new int[5]; // 새로운 메모리 공간 5개 만듬.
		```
		
		new : 메모리 점유/할당/생성 키워드  
		[5] : 방의 개수 지정  

		```java
		ex)
		new Scanner[5]; // 배열 만든 것. 선언된 Scanner가 들어가야 함.
		new Scanner[System.in);
		```
	
	3) 인덱스  
		배열의 방은 0부터 시작하는 방 번호가 매겨지며 이를 인덱스라 한다.  
		배열에서는 각 방에 접근하려면 인덱스를 이용해야한다.  
		
		```java
		arr[인덱스 번호]
		```  
		
	4) length
		배열의 길이(방의 개수)를 알려주는 명령어  
		
		```java
		arr.length ===>5
		```
	5) 초기화  
		생성시 처음 들어가는 값을 초기값이라 한다.  
		
		```java
		int[] math = {100,90,80,70,60}; // new 생략됨.
		```
		* 다음은 불가능  
		```java
		int[] math;
		math = {100,90,80,70,60};
		```
