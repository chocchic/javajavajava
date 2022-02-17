0. static  
	static 메서드는 객체 생성 없이 바로 사용 가능.  
	-> static 메서드는 static 멤버만 접근 가능(인스턴스 X)  
	-> static 메서드에서 this 키워드 사용할 수 없음  

1. final  
	1)final 클래스  
		클래스 앞에 붙으면, 상속할 수 없음을 지정함.  
		-> 부모가 될 수 없다.  
	```java
	final class FinalClass {   }
	```
	2)final 메서드   
		메서드 앞에 붙으면, 오버라이딩을 할 수 없음을 선언함  
	```java
	final int FinalMethod { ... }
	```
	3)final 메서드  
		변수 앞에 붙으면, 상수가 된다.  
		상수는 한번 초기화 되면 값을 변경할 수 없다.  
	```java
	final int row = 10; // 상수선언
	row = 20;
	public static final double PI = 3.14...;
	```

2. 상속 inheritance  
	1) 클래스와 클래스 사이(1:1)의 부모자식 관계를 만드는 것  
	2) 자바 다중상속 X  
	3) 상속은 부모의 변수, 메서드를 물려받는 것  
	4) 상속시, 생성자와 초기화 블럭은 제외  
	5) 상속 키워드 : extends  
	6) 상속을 받으면 부모의 멤버들을 자식이 담게된다.  
		-> 자식은 부모의 것과 함께 자식만의 변수와 메서드를 갖게 된다.  
	7) 필요한 이유 : 코드 중복을 제거, 유지보수 편리성, 소프트웨어 생산성 향상  
	
	부모클래스 = super = parent = base  
	자식클래스 = sub = child = derived  
	```java
	class Object {}			// 조상님  
	class Parent {}			// 할미할비 : X  
	class Child extends Parent {}		// 엄마아빠 : X, Y  
	class Child2 extends Parent {}	// 이모나 삼촌(남) : X,W  
	class GrandChild extends Child {}	// 아들, 딸 : X,Y,Z  
	```
	8) Object 클래스  : 모든 클래스의 조상  
	9) package : 프로그램에서 폴더/디렉토리를 말함.  
		보통 패키지는 3수준까지 내려가는 폴더 이름을 작성  
		ex) java.awt.color.클래스  
	10) java.lang : 가장 기본적인 package  

3. 상속과 접근제어자  
	1) super클래스와 private 맴버  
		서브클래스 포함 다른 클래스에 접근 X  
	2) super클래스의 default 멤버  
		서브 클래스라도 다른 패키지면 접근 X  
	3) super클래스의 의 public 멤버  
		모두 접근 가능  
	4) super클래스의 protected 멤버  
		같은 패키지의 모든 클래스 접근 가능  
		패키지 상관 없이 서브 클래스 접근 가능  

4. 상속과 생성자  
	1) 서브와 super클래스의 생성자 호출 및 실행  
		서브 클래스와 super 클래스 두개 생성자 모두 실행  
 		super -> 서브  
	2) 서브클래스에서 super클래스 생성자 선택  
		super클래스의 생성자가 여러 개 있는 경우, 개발자가 자식생성자에서 특부모생성자를 명시적으로 지정하지 않는경우, 부모의 기본생성자를 자동으로 실행시킨다.  
		1. super클래스의 기본생성자가 자동으로 선택되는 경우  
			-> 문제 : 부모가 기본생성자는 없고, 매개변수가 있는 생성자만 있다면, **에러발생!!!**   
		2. 부모의 생성자를 개발자가 명시해서 실행하고 싶을 경우  
			super();를 이용하여 선택해줄 수 있다.  
			super() : 부모클래스의 생성자를 호출해주는 메서드. 자식 생성자 안에서 사용가능. 첫번째 명령문이어야한다.  

5. 오버라이딩 overriding  
	1) 상속관계에서 성립  
	2) 재작성, 덮어씌우기, 재정의한다  
		부모 클래스의 메서드가 마음에 안들어 내용을 변경해서 사용하는 것  
	3) 메서드 선언부는 똑같이, 영역{} 안 내용만 바꾸는 것.  
	4) 오버로드와 완전히 다름  
		오버라이딩은 내용을 변경해서 덮어씌우는 형태, 오버로딩은 새로운 메서드 만드는 것
	5) 동적바인딩 : 서브에 오버라이딩 메서드가 있으면, super클래스읭 메서드를 무시하고, 서브클래스에서 오버라이딩된 메서드가 무조건 실행되도록 하는 것.
	6) super : super클래스에 대한 레퍼런스
		super.메서드명()  
		서브클래스에 메서드 오버라이딩시, 동적바인딩으로 오버라이딩된 메서드가 자동으로 호출되는데, 수퍼클래스의 멤버를 호출하고자 할때 사용되는 키워드  