# 앞으로 일정
 - 서버 프로그래밍  
Node : 이번주에 마무리  
Spring Boot : 다음주 일주일  
Go : 일주일 정도  


- 데이터베이스  
MySQL : 오늘(5/9) 마무리  
MongoDB  
 
Oracle  

- 스마트 디바이스 프로그래밍  
react-native : 2주 정도  

- 세미 프로젝트 1주일 : 서버를 2개 구성하고, 스마트 디바이스와 통신  
주제는 자유롭게 선정하고 서버 2개를 구성할 때 DB나 서버 프레임워크는 편한걸 선택  

- 블럭 체인 기본 프로그래밍  
  solidity  
  이더리움  

- 블럭 체인 프로젝트  
  Spring boot project로 서버를 구축한 후 go로 만든 서버와 통신을 하고 스마트폰과 연결  
  데이터베이스는 mysql 사용  

# node에서 구성
Client Application <-> Socker Server | Web Server <->Application Server <-> Repository(database)  
클라이언트쪽에서 데이터 정렬을 위해 버튼 하나 클릭했을 때 오래 걸리면 직접 데이터 저장소까지 가서 다시 결과를 퍼오는 것  
오래 안걸리면 가져온 데이터 저장하고 있다가 다시 정렬하는 것  

# 빅데이터  
빅데이터 - Hadoop - Map Reduce  
이전의 처리 시스템의 한계 : 중앙 집중 시스템은 너무 무겁다  
  처리하는 머신 - 데이터 1  
                - 데이터 2  
                - 데이터 3  
-> 작업을 수행하고자 하면 데이터를 전부 처리하는 머신으로 보내서 데이터를 하나로 만들고 그 다음에 작업을 처리하는 방식  
   데이터를 모으는데 시간이 너무 많이 걸림!

=> 각각에서 처리한후 결과만 전송한 후 결과만 합산을 하는 형태로 진화 - **분산처리 시스템**  
결과를 처리하는 머신 - 처리할 수 있는 머신과 데이터 1  
                     - 처리할 수 있는 머신과 데이터 2  
                      - 처리할 수 있는 머신과 데이터 3  

이런 처리를 하는 프로그래밍 방식을 **Map-Reduce Programming**이라고 합니다.  
가장 대표적인 함수 3개가 map(변환), filter(데이터 추출), reduce(집계)입니다.  

# Transaction+
DB 원본 ----------------> DB 사본  
  RPG 게임 끌 때 딜레이 생기거나 할 때 이런 과정 때문.