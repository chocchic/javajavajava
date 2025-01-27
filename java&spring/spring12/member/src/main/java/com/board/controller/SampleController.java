package com.board.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;
import java.util.stream.IntStream;

import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import lombok.extern.log4j.Log4j;
/*
 	@RestController : 요청에 해당하는 순수 데이터만 반환해주는 컨트롤러임을 명시
 	produces	: 해당 메서드가 생산하는 데이터 MIME타입
 	consumes	: 클라이언트가 요청시 보내준 데이터의 타입 제약걸기
 				  클라이언트가 데이터 보낼 때 Content-Type : "application/json" 명시해서 보내면 
 				  서버에서 consumses 속성에 "applicatio/json" 작성해줘야 함.
 * 
 * 
 * */
@RestController
@RequestMapping("/sample")
@Log4j
public class SampleController {
	@GetMapping(value="/getText", produces ="text/plain;charset=UTF-8")
	public String getText() {
		log.info("getText called");
		log.info(MediaType.TEXT_PLAIN_VALUE);
		return "hellohihola"; 
	}
	
	// 객체 데이터 응답
	@GetMapping(value="/getPerson", produces= {MediaType.APPLICATION_JSON_UTF8_VALUE,
			MediaType.APPLICATION_XML_VALUE})
	public Person getPerson() {
		return new Person("피카츄", 10);
	}
	
	//  List 데이터 응답
	@GetMapping(value="/getList")
	public List<Person> getList(){
		return IntStream.range(1, 10).mapToObj(i->new Person("name"+i,i+1)).collect(Collectors.toList());
	}
	
	//Map 데이터 응닫ㅂ
	@GetMapping(value="/getMap")
	public Map<String, Person> getMap(){
		Map<String, Person> map = new HashMap<String, Person>();
		map.put("one", new Person("ononno",1444));
		map.put("two", new Person("숯불닭갈비",44));
		return map;
	}
	
	//ResponseEntity : 데이터 + HTTP 헤더 상태메시지 등
	@GetMapping(value="/hello", params= {"name","age"})
	public ResponseEntity<Person> hello(String name, Integer age){
		Person person = new Person(name, age);
		ResponseEntity<Person> result =null;
		if(age < 18) {
			result=ResponseEntity.status(HttpStatus.BAD_GATEWAY).body(person);
		}else {
			result = ResponseEntity.status(HttpStatus.OK).body(person);
		}
		
		return result;
	}
	//http://localhost:8080/sample/shop/shoes/1000001
	@GetMapping("/shop/{cat}/{pid}")
	public String[] getSource(@PathVariable("cat")String cat, @PathVariable("pid") Integer pid) {
		return new String[] {"category : "+cat,"product id : "+pid};
	}
	// json으로 요청시 데이터가 넘어왔을 때
	@PostMapping("/test")
	public Person test(@RequestBody Person person) {
		
		// 처리
		
		return person;
	}
}
