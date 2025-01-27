package com.choc;

import java.util.List;
import java.util.Optional;

import org.junit.jupiter.api.Test;
import org.mindrot.jbcrypt.BCrypt;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;

import com.choc.model.Item;
import com.choc.model.Member;
import com.choc.persistence.ItemRepository;
import com.choc.persistence.MemberRepository;

@SpringBootTest
public class RepositoryTest {
	@Autowired
	private MemberRepository m;
	
	// Member에 데이터 삽입
	//@Test
	public void testRegisterMember() {
		/*
		Member member = Member.builder().email("dntksemfdj473@gmail.com")
				.password("159753").name("촉촉한초코칩").imageurl("chocochip.png").build();
		m.save(member);
		*/
		
		// BCrypt 사용해보기
		/*
		String password = BCrypt.hashpw("159753", BCrypt.gensalt()); 
		// 같은 데이터를 가지고 암호화해도 매번 다른 값이 나옴
		System.out.println(password);
		System.out.println(BCrypt.checkpw("159753", password)); // 평문이 같으면 true
		*/
		// password에 String 형태로 hash된 값이 들어간 것이 확인됨
		String password = BCrypt.hashpw("159753", BCrypt.gensalt());
		Member member = Member.builder().email("dntksemfdj473@gmail.com")
				.password(password).name("촉촉한초코칩").imageurl("chocochip.png").build();
		m.save(member);
	}
	
	// 회원 정보 가져오기 - 수정이나 로그인에서 사용  
	//@Test
	public void testGetMember() {
		Optional<Member> optional = m.findById("dntksemfdj473@gmail.com");
		if(optional.isPresent()) {
			Member member = optional.get();
			System.out.println(member); // 로그인은 데이터를 가져와서 비교하면 됨!
		}else {
			System.out.println("존재하지 않는 데이터입니다.");
		}
	}
	
	// 데이터 수정
	//@Test
	public void testUpdateMember() {
		String password = BCrypt.hashpw("111111", BCrypt.gensalt());
		Member member = Member.builder().email("dntksemfdj473@gmail.com")
				.password(password).name("칙촉").imageurl("user.png").build();
		
		m.save(member);
	}
	
	// 데이터 삭제
	//@Test
	public void testDeleteMember() {
		// 2가지 방법 존재
		Member member = Member.builder().email("dntksemfdj473@gmail.com").build();
		m.delete(member);
		

		//m.deleteById("dntksemfdj473@gmail.com");
	}
	
	//이름으로 데이터 조회
	//@Test
	public void testFindName() {
		String name="칙촉";
		List<Member> list = m.findMemberByName(name);
		System.out.println(list);
		
		name = "촉촉한초코칩";
		list = m.findMemberByName(name);
		System.out.println(list);
		
	}
	
	@Autowired
	private ItemRepository i;
	
	// Item 삽입을 테스트
	//@Test
	void testRegisterItem() {
		// 외래키를 생성
		Member member = Member.builder().email("dntksemfdj473@gmail.com").build();
		for(int j = 0; j< 100; j++) {
			Item item = Item.builder().itemname("사과").price(2500).description("비타민 C가 풍부합니다.")
				.pictureurl("apple.png").member(member).build();
			i.save(item);
		}
	}
	
	// 데이터 전체 보기 테스트
	//@Test
	public void getAll() {
		List<Item> list = i.findAll();
		System.out.println(list);
	}
	
	// 페이징과 정렬
	//@Test
	public void getPaging() {
		Sort sort = Sort.by("itemid").descending();
		Pageable pageable = PageRequest.of(0, 10);
		Page<Item> list = i.findAll(pageable);
		list.get().forEach(item-> {System.out.println(item);});
	}
	
	// 외래키를 이용한 조회
	//@Test
	public void getFindMember() {
		Member member = Member.builder().email("dntksemfdj473@gmail.com").build();
		List<Item> list = i.findItemByMember(member);
		System.out.println(list);
	}
	
	// 데이터 1개 가져오기
	//@Test
	public void getItem() {
		Optional<Item> item = i.findById(10L);
		if(item.isPresent()) {
			System.out.println(item.get());
		}else {
			System.out.println("데이터가 없습니다.");
		}
	}
	
	// 데이터 수정
	//@Test
	public void updateItem() {
		Member member = Member.builder().email("dntksemfdj473@gmail.com").build();
		Item item = Item.builder().itemid(10L).itemname("아오리사과").description("달고 아삭아삭해요~")
				.price(3450).pictureurl("greenapple.png").member(member).build();
		i.save(item);
	}
	
	// 데이터 삭제
	@Test
	public void deleteItem(){
		Item item = Item.builder().itemid(100L).build();
		i.delete(item);
	}
	
	
}
