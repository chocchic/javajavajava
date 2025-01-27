1. 입력문
	1) System.in 
	
		키보드 장치를 직접 제어, 키 입력을 받는 표준 입력 스트림 객체  
		키보드 입력 > System.in 입력스트림 > 바이트데이터 > Scanner > 형변환된 데이터 > 자바 응용프로그램
	
	2) Scanner
	
		자바 패키지에서 제공하는 클래스, 원하는 타입으로 변환해줌  		
		1. import 문 : Scanner 클래스가 있는 자바 제공 패키지를 여기서 사용하겠다  
			```java
			import java.util.Scanner;
			```
			+ 클래스밖 패키지 밑에 선언
		2. Scanner 객체 생성  
			```java
			Scanner sc = new Scanner(System.in);
			```
		3. 입력받기  
			```java
			sc.nextLine(); // 문자열 String 타입으로 return. 입력 받고 싶은 만큼 계속 사용 가능.
			String 변수명 = sc.nextLine();
			```
		4. Scanner 객체 닫기  
			```java
			sc.close();
			```
	3) String 값 형변환  
		String -> int : Integer.parseInt(String 값);  
		String -> double : Double.parseDouble((String 값);  
		String -> float : float.parsefloat(String 값);  
		
2. 연산자 operator
	1) 종류  
		단항연산자		: +(양수) -(음수) ++ -- !  
		이항연산자  
			산술연산자 	: + - * / %  
			비교연산자	: < <= > >= == !=  
			논리연산자	:  && ||   
		삼항연산자		: ? :  
		대입연산자		: =  
		복합대입연산자 	: 산술 + 대입 : += -= *= /= %=  
		(쉬프트/비트 연산자)  
	2) 연산자 우선순위 (높은 순)  
		단항연산자 :  
			++ == (전위형)  
			+ - (양수음수)  
			++ -- (후위형)  
			!
			
		```java
			int a = 10;
			a++ +10; //11
			++a;
		```

		형변환 : (타입)  
		산술연산자(쉬프트연산자) : * / %  
			    		 + - (덧셈 뺄셈)  		
		비교연산자(비트연산자) : < <= > >= == != instanceof  
		논리연산자 : && (||보다 우선순위 높음)  
			    ||  
		삼항연산자 : ? :  
		(복합)대입연산자 : = += -= *= /= %=
3. 제어문
	- 조건문		: if, switch  
	- 반복문		: while, do-while, for  
	- 보조제어문	: break(강제종료), continue(반복하다 건너띄기)  

	1) if 조건문  
		조건이 참이면 영역안의 코드를 실행시킨다.  
		* [구조1]
			```java
			if(condition){
				//조건식이 참일때 실행할 코드 작성
			}
			```
		
 			조건식 :boolean타입의 변수 혹은 비교연산이나 논리연산이  혼합된 식으로 구성  
				반드시 결과가 True/False 둘 중 하나여야 성립
			영역 안의 코드가 1개의 명령일 경우 중괄호 생략가능
		* [구조2] : 둘 중 하나의 블럭은 반드시 실행. else는 옵션(반드시 작성 X)  
			```java
			if(condition) {
				//조건식이 참일 때 실행할 코드 작성
			}else{ 
				//조건식이 참이 아닐때 실행할 코드 작성
			}
			```
		* [구조 3]  
			```java
			if(condition) {
				//조건식이 참일 때 실행할 코드 작성
			}else if(condition2){
				//조건식2가 참일때 실행할 코드 작성
			}else if(condition3){
				//조건식3가 참일때 실행할 코드 작성
			}else{
				//위 조건들이 모두 성립되지 않을 때 뭔가 실행해야하면 else를 붙여서 코드 작성
			}
			```
	2) switch 조건문  
		다중 선택문 : 하나의 변수값을 평가하여, 각 값에 대해 개별적으로 처리하는  문장.  
		
		[구조]
		```java
		case 값1:
			// 값1과 변수의 값이 동일한 경우 실행할 코드들...
			break;
		case 값2:
			// 값2와 변수의 값이 동일한 경우 실행할 코드들...
			break;
		case 값3:
			// 값3와 변수의 값이 동일한 경우 실행할 코드들...
			break;
		...
		default:
			// 위 값들과 일치하지 않을 경우 수행할 명령이 있으면 default에 작성
			break; // 마지막에 위치한 break는 생략가능
		}
		```
		
		특징 :  
			- if문으로 대체 가능, 비교해볼 값이 많다면 가독성 면에서는 switch가 더 좋을 수도  
			- 가능 변수 타입 : int, char, String  
			- default 생략 가능  
			- case 다음에는 반드시 값이 하나 와야한다  
			* 예외 : 아래는 가능하다  
		```java
		case 값1 : case 값2 : 
			...
			break;
		```  
