# One To Many
## 1. 연관 관계와 관계형 데이터베이스  
* 관계형 데이터베이스에서는 1:1, 1:N(N:1), M:N의 관계를 이용해서 데이터가 서로 간에 어떤 관계를 가지고 있는지 표현  
    이 때 Primary Key와 Foreign Key를 이용해서 관계를 설정  
* JPA에서는 어노테이션과 방향성을 이용해서 표현하게 되는데, 데이터베이스에서는 방향성의 개념이 없습니다.  

1:1 -> @OneToOne  
1:N -> @OneToMany  
N:1 -> @ManyToOne  
N:M -> @ManyToMany  

* 방향성은 단방향과 양방향이 있습니다.  

### 1) 1:1관계  
* 한쪽 테이블의 하나의 행과 다른 쪽 테이블의 하나의 행이 매칭이 되는 경우  
* 이 경우는 양쪽 테이블의 기본키를 다른 테이블에 외래키로 추가해주어야 합니다.  
* JPA에서는 양쪽의 기본키에 @OneToOne을 설정하면 자동으로 추가해줍니다.  

### 2) 1:N관계  
* 회원과 게시글의 관계  
    한명의 회원은 여러개의 게시글을 작성할 수 있고, 하나읭 게시글은 한명의 회원이 작성해야 합니다.  
    관계형 데이터베이스에서는 회원의 기본키를 게시글의 외래키로 추가해야 합니다.  
    JPA에서는 회원의 기본키에 @OneToMany를 설정해도 되고 게시글 쪽의 외래키에 @ManyToOne을 설정해도 됩니다.  

### 3) M:N 관계  
* 회원과 상품의 관계  
    한 명의 회원은 여러 개의 다른 상품을 구매할 수 있습니다.  동일한 상품을 여러 명의 회원이 구매할 수 있습니다.  
    데이터베이스에서는 별도의 테이블을 만들어서 각 테이블의 기본기를 새로 만든 테이블의 외래키로 추가합니다.  
    JPA에서는 @ManyToMany로 설정은 가능하지만 @OneToMany나 @ManyToOne 2개로 분할해서 설정  

### 4) 회원, 게시글, 댓글의 관계  
    회원과 게시글은 1:N관계  
    게시글과 댓글은 1:N  
    회원과 댓글은 1:N  

## 2. Board 애플리케이션 생성  
### 1) 프로젝트 생성  
* 의존성 : Spring Boot Devtools, Lombok, Spring Web, Thymeleaf, Spring Data JPA, MySQL  
* boot 2.7.0버전  

### 2) build.gradle 파일에 시간 처리 관련 의존성을 추가  
```gradle
// https://mvnrepository.com/artifact/org.thymeleaf.extras/thymeleaf-extras-java8time
implementation group: 'org.thymeleaf.extras', name: 'thymeleaf-extras-java8time'
```  

### 3) application.properties파일에 기본 설정을 추가  
* 이전 프로젝트 것 thymeleaf만 빼고 복붙  
```ini
#server 의 port 설정
server.port = 80

#연결할 데이터베이스 설정 - MySQL
spring.datasource.driver-class-name=com.mysql.cj.jdbc.Driver
spring.datasource.url=jdbc:mysql://localhost:3306/node?useUnicode=yes&characterEncoding=UTF-8&serverTimezon=UTC
spring.datasource.username=root
spring.datasource.password=1234

#연결할 데이터베이스 설정 - Oracle
#spring.datasource.driver-class-name=oracle.jdbc.driver.OracleDriver
#spring.datasource.url=jdbc:oracle:thin:@192.168.10.4:1521:xe
#spring.datasource.username=system
#spring.datasource.password=oracle

spring.jpa.properties.hibernate.show_sql=true
spring.jpa.properties.hibernate.format_sql=true
spring.jpa.hibernate.ddl-auto=update
logging.level.org.hibernate.type.descriptor.sql=trace

spring.devtools.livereload.enabled=true
```  

### 4) EntryPoint클래스에 데이터베이스 감시 설정 추가  
```java
@EnableJpaAuditing
@SpringBootApplication
public class BoardApplication {

	public static void main(String[] args) {
		SpringApplication.run(BoardApplication.class, args);
	}

}
```  

### 5) 기본이 되는 속성들을 갖는 model.BaseEntity 생성  
```java
@EntityListeners(value= {AuditingEntityListener.class})
@MappedSuperclass
@Getter
abstract class BaseEntity {
	@CreatedDate
	@Column(name = "regdate", updatable = false)
	private LocalDateTime regDate;
	
	@LastModifiedDate
	@Column(name = "moddate")
	private LocalDateTime modDate;
}
```  

## 3. Model 생성
### 1) 회원 정보를 저장할 Entity 생성 - model.Member  
* email(기본키), password, name  
```java
@Entity
@Table(name="tbl_member")
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Getter
@ToString
public class Member extends BaseEntity{
	@Id
	private String email;
	private String password;
	private String name;
}
```  

### 2) 게시물 정보를 저장할 Board Entity 생성 - model.Board  
* 게시글 번호(기본키 자동 생성), 제목, 내용  
```java
@Entity
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Getter
@ToString
public class Board extends BaseEntity{
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private Long bno;
	private String title;
	private String content;
}
```

### 3) 댓글 정보를 저장할 Reply Entity를 생성 - model.Reply  
* 댓글 번호, 댓글 내용, 댓글 작성자
```java
@Entity
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Getter
@ToString
public class Reply extends BaseEntity{
	@Id
	@GeneratedValue(strategy = GenerationType.AUTO)
	private Long rno;
	private String content;
	private String replyer;
}
```  
## 4. 관계 어노테이션의 세부 속성  
### 1) mappedBy : 양방향 연관관계를 만들 떄 매핑되는 엔티티의 필드를 연결  

### 2) cascade : Entity의 상태변화를 전파시키는 옵션  
* PERSIST : 부모 Entity가 저장될 때 자식 Entity도 같이 저장  
* MERGE : 부모 Entity가 병합될 때 자식 Entity도 같이 병합  
* REMOVE : 부모 Entity가 삭제될 때 자식 Entity도 같이 삭제  
* REFRESH : 부모 Entity가 refresh될 때 자식 Entity도 같이 refresh  
* DETACH : 부모 Entity가 detach될 때 자식 Entity도 같이 detach  
* ALL : 부모 Entity의 모든 변화가 자식 Entity에 전파  

### 3) orphanRemoval  
* 고아 객체를 삭제해주는 옵션  
* Primary Key 값이 NULL인 데이터가 고아 객체(orphanRemoval) : Entity는 데이터베이스에 있었던 데이터이지만 실제로는 메모리에 존재하는 데이터  

### 4) fetch  
* 관련있는 Entity를 가져오는 시점을 설정하는 것인데 Eagar(바로 가져오기)와 Lazy(지연)가 있음  

## 5. ManyToOne 어노테이션  
* Board테이블과 Member테이블은 Board쪽에서 바라보면 N:1의 관계입니다.  
	객체지향에서 이런 관계를 표현하고자 할 때는 Board쪽에 Member를 참조할 수 있는 속성을 하나 추가하거나 Mebmer쪽에 Board를 포함할 수 있는 List나 배열같은 속성을 추가합니다.  
* 관계형 데이터베이스에서는 Member테이블의 기본키를 Board테이블에 외래키로 설정합니다.  
* Spring JPA에서는 속성 위에 @OneToMany나 @ManyToOne을 이용해서 설정을 합니다.  

### +) Build tool  
소스코드 -> 컴파일 작업(문법적인 오류가 있는지 확인)을 수행하게 되고 이 작업을 하고나면 자바의 경우는 중간 코드인 class 파일이 생성됩니다. -> build를 수행하는데 결과로는 실행 가능한 코드가 만들어집니다. -> Run(실행)  

* gradle(build.gradle에 설정), maven(pom.xml파일에 설정), jenkins(현업과 클라우드 환경에서 가장 많이 사용되는 build tool) : 설정 파일을 수정하면 rebuild를 해주는 것이 좋습니다. 의존성 설정을 수정한 경우에는 반드시 rebuild를 해주는 것이 좋습니다. 외부 라이브러리의 의존성을 설정해서 코드를 작성할 떄는 에러가 없었는데 실행을하면 ClassNotFoundExceptioon이 발생하는 경우가 있는데 이 경우가 대부분 rebuild를 하지 않아서 그렇습니디.  

### 1) Board Entity에 Member Entity를 참조할 수 있는 속성을 추가  
```java
	// Member Entity를 N:1관계로 참조
	@ManyToOne
	private Member member;
```  

### 2) ReplyEntity에 BoardEntity를 참조할 수 있는 속성을 추가  
```java
	@ManyToOne
	private Board board;
```  

### 3) 프로젝트 실행
### 4) 데이터베이스 확인  
```sql
desc tbl_member;
desc board;
desc reply;
```
* board테이블에는 member_기본키 컬럼이 추가되어 있고 reply테이블에는 board_기본키 컬럼이 추가되어 있어야 합니다.  

## 6. Repository 생성  
### 1) Member Entity를 위한 Repository 인터페이스 생성 - persistence.MemberRepository  
```java
public interface MemberRepository extends JpaRepository<Member, String> {
	
}
```  

### 2) Board Entity를 위한 Repository 인터페이스 생성 - persistence.BoardRepository  
```java
public interface BoardRepository extends JpaRepository<Board, Long> {

}
```  

### 3) Reply Entity를 위한 Repository 인터페이스 생성 - persistence.ReplyRepository  
```java
public interface ReplyRepository extends JpaRepository<Reply, Long> {
	
}
```  
## 7. Repository Test  
### 1) Repository의 작업을 Test하기 위한 클래스를 src/test/java디렉터리의 패키지에 생성 - RepoTest
```java
@SpringBootTest
public class RepoTest {

}
```  

### 2) Member테이블에 100개의 데이터 삽입  
```java
	@Autowired
	private MemberRepository m;
	
	@Test
	public void insertMember() {
		IntStream.rangeClosed(0, 99).forEach(i -> {
			Member member = Member.builder().email("choc"+i+"@aa.com").password("1234").name("촉촉한초코칩"+i).build();
			m.save(member);
		});
	}
```  

### 3) Board테이블에 100개의 데이터 삽입  
```java
	@Autowired
	private BoardRepository b;
	
	@Test
	public void insertBoards() {
		IntStream.rangeClosed(0,99).forEach(i ->{
			Member member = Member.builder().email("choc0@aa.com").build(); // 없는 이메일 입력시 오류
			Board board = Board.builder().title("제목..."+i).content("내용..."+i).member(member).build();
			b.save(board);
		});
	}
```  
### 4) Reply테이블에 100개의 데이터 삽입  
```java
	@Autowired
	private ReplyRepository r;
	
	@Test
	public void insertReplys() {
		IntStream.rangeClosed(0,99).forEach(i ->{
			// 0부터 99사이의 정수를 랜덤하게 생성해서 Board객체를 생성
			long bno = (long)(Math.random()*100);
			Board board = Board.builder().bno(bno).build();
			Reply reply = Reply.builder().content("댓글..."+i).board(board).build();
			r.save(reply);
		});
	}	
```  
* Identity를 적용하면 차근차근 올라가지만 AUTO는 어떻게 올라갈지 모름
	AUTO할 때 오라클에서는 sequence써서 하고 MySQL에서는 AUTO_increment  

## 7. Eager/Lazy Loading  
### +) Eager / Lazy
* 객체지향 프로그래밍에서 하나의 인스턴스가 다른 인스턴스를 네부에서 사용하고자 할 때 포함된 인스턴스의 생성시점을 생각해볼 이유가 있다.  
```java
class Super {
	public Sub sub;
	public void method(){
		// 사용하기 직전에 생성 : Lazy
		sub = new Sub();
		System.out.println(sub.cnt); // 그냥 하면 생성되지 않은 객체를 불러오기 떄문에 오류남
	}
	// 생성자에서 하위 인스턴스 생성 : Eager
	public Super(){
		sub = new Sub();
	}
}
class Sub {
	public int cnt;
}
Super super = new Super();
super.method();
```
* 생성자에서 생성(Eager) : 이미 생성된 인스턴스를 사용하기 때문에 속도가 빨라질 수 있지만 사용하기 전부터 가지고 있기 떄문에 오히려 메모리에 부담을 줄 수 있음  
* 사용하기 직전 생성(Lazy) : Eager의 장단점이 반대로 적용  

* 이와 동일한 원리가 클라이언트 / 서버에도 적용이 됩니다.  
	클라이언트 프로그램은 **사용가능성**이 중요  
	서버 프로그램은 **속도**나 **효율**이 중요  

### 1) 하나의 Board데이터를 가져오는 메서드 - RepoTest에서 수행  
```java
	// 하나의 board데이터를 조회하는 메서드
	@Test
	public void readBoard() {
		Optional<Board> result = b.findById(50L);
		// 데이터를 출력
		System.out.println(result);
		System.out.println(result.get().getMember());
	}
```  
-> 수행된 쿼리를 확인해보면 Left Outer Join을 이용해서 데이터를 가져오는 것을 알 수 있습니다.  

### 2) 하나의 Reply데이터를 가져오는 메서드 
```java
	// 하나의 reply데이터를 조회하는 메서드
	@Test
	public void readReply() {
		Optional<Reply> result = r.findById(850L);
		// 데이터를 출력
		System.out.println(result);
		System.out.println(result.get().getBoard());
	}
```
-> 수행된 쿼리를 확인해보면 Left Outer Joini을 2번 이용  

### 3) Eager Loading  
* 즉시 로딩이라고 번역을 하는데 데이터를 조회할 떄 관계가 있는 데이터를 바로 찾아오는 Loading을 뜻합니다.  
* 관계를 만들 때 fetch옵션을 생략하거나 직접 지정해서 사용합니다.  
* 연관된 데이터를 자주 사용하는 경우가 아니라면 권장하지 않습니다.  

### 4) Lazy Loading  
* 지연 로딩이라고 번역을 하는데 연관된 데이터를 필요할 때 찾아오는 방식  
* 관계를 설정할 때 fetch옵션에 FetchType.LAZY를 적용하면 됩니다.  

### 5) Board Entity에 Lazy Loading 적용
```java
@Entity
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Getter
@ToString
public class Board extends BaseEntity{
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private Long bno;
	private String title;
	private String content;
	
	// Member Entity를 N:1관계로 참조
	@ManyToOne(fetch = FetchType.LAZY)
	private Member member;
}
```  
* 이전의 하나의 Board를 가져오는 메서드를 다시 테스트  
	Error  
	readBoard를 다시 실행하면 getMember()를 할 수 없어서 에러가 납니다. -> member데이터를 찾아오지 않음  
	=> 데이터를 가져올 때 트랜잭션을 적용하면 이 문제 해결 가능  

* 테스트하는 메서드위에 @Transactional을 추가하고 다시 테스트
```java
	@Test
	@Transactional
	public void readBoard() {
		Optional<Board> result = b.findById(50L);
		// 데이터를 출력
		System.out.println(result);
		System.out.println(result.get().getMember());
	}
```  
-> 이 경우에는 join을 하지 않고 Board의 데이터를 가져온 후 거기서 외래키의 값을 가지고 Member테이블의 데이터를 다시 조회합니다. ~> 서브쿼리의 형태로 동작하는 것을 확인할 수 있습니다.  

### 6) 연관관계에서 @ToString  
* ToString은 자신의 모든 속성을 toString을 호출해서 하나의 문자열로 만들어서 리턴하는 toString메서드를 자동 생성해주는 어노테이션입니다.
* Eager Loading을 사용하는 경우는 모든 데이터가 존재하기 떄문에 별 문제가 안되지만 Lazy Loading의 경우는 처음에 연관된 데이터가 존재하지 않기 때문에 문제가 발생할 가능성이 있음  
* @ToString(exclude="toString 만들 때 제외할 속성")을 이용해서 특정 속성을 제외할 수 있습니다.  

* Board에 적용  
```java
@ToString(exclude="member")
```

## 8. JPQL과 left outer join
* 게시글을 가져올 때 댓글의 수를 같이 가져오고자 하는 경우에는 하나의 entity로는 처리가 불가능  
	댓글의 수는 entity에 존재하지 않기 떄문입니다.  
	이런 경우에는 JPQL을 이용해서 해결 가능  

### 1) BoardRepository인터페이스에 Board데이터를 가져올 때 Member정보도 같이 가져오는 JPQL처리 메서드를 생성  
```java
	// Board테이블에서 데이터를 가져올 때 Member 정보도 같이 가져오는 메서드
	@Query("select b, w from Board b left join b.member w where b.bno = :bno")
	Object getBoardWithMember(Long bno);
```
### 2) RepoTest 클래스에서 앞에서 만든 메서드 테스트  
```java
@Test
	public void testReadWithWriter() {
		// 데이터 조회
		Object result = b.getBoardWithMember(40L);
		// JPQL의 결과가 Object인 경우는 Object[]로 강제 형변환해서 사용
		System.out.println((Object[])result);
	}
```  

### 3) BoardRepository인터페이스에 글 번호에 해당하는 게시글과 그에 해당하는 모든 댓글을 가져오는 메서드를 작성  
* Board테이블과 Reply테이블은 연관관계가 있으면 Reply테이블에 board라는 속성으로 관계가 설정되어 있습니다.  
	Board에서 바라볼 때는 1:N의 관계입니다.  
```java
// 하나의 글 번호를 가지고 게시글과 댓글을 모두 가져오는 메서드
	// 하나의 게시글에 여러 개의 댓글이 있으므로 리턴 타입은 List<Object[]>
	// 결과는 게시글, 댓글 + 게시글, 댓글의 형태로 리턴됩니다.
	@Query("select b,r from Board b left join Reply r on r.board = b where b.bno=:bno")
	List<Object[]> getBoardWithReply(@Param("bno") Long bno);
```  

### 4) RepoTest 클래스에서 앞에서 만든 메서드 테스트  
```java
	//@Test
	public void testGetBoardWithReply() {
		List<Object[]> result = b.getBoardWithReply(40L);
		for(Object[] ar : result) {
			System.out.println(Arrays.toString(ar));
		}
	}
```

### +) JPA MySQL 관련 오류  
계속 board_bno라는 애를 reply에서 참조를 제대로 못하고 있다는 오류가 났는데, 그냥 테이블자체 잘못 올라갔던 것이라 drop하고 다시 올렸더니 고쳐졌다  

## 9. 목록보기에 필요한 Repository 구현  
### 1) 필요한 데이터  
Board : 게시물 번호, 제목, 작성시간  
Member : 회원의 이름, 이메일  
Reply : 댓글의 수  
페이징도 구현  
### 2) BoardRepository 인터페이스에 메서드를 선언
```java
	// 목록보기를 위한 메서드  
	@Query(value="select b, w, count(r) "+
	"from Board b left join b.member w left join Reply r On r.board = b group by b", 
			countQuery="select count(b) from Board b")
	Page<Object[]> getBoardWithReplyCount(Pageable pageable);
```  

### 3) RepoTest에서 테스트
```java
	@Test
	public void testWithReplyCount() {
		Pageable pageable = PageRequest.of(0, 10, Sort.by("bno").descending());
		Page<Object[]> result = b.getBoardWithReplyCount(pageable);
		
		result.get().forEach(row ->{
			Object[] ar = (Object[])row;
			System.out.println(Arrays.toString(ar));
		});
	}
```  
-> 결과에서 0번 요소가 Board이고 1번 요소가 Member 2번 요소가 댓글의 개수  

### 4) BoardRepository인터페이스에 게시글 번호를 가지고 동일한 데ㅔ이터를 가져오는 메서드를 선언  
```java
// 게시글 번호를 가지고 데이터를 찾아오는 메서드 
	@Query(value="select b, w, count(r) "+
	"from Board b left join b.member w left join Reply r On r.board = b where b.bno = :bno")
	Object getBoardByBno(@Param("bno") Long bno);
```  

### 5) RepositoryTest 클래스에서 메서드 테스트  
```java
	@Test
	public void testByBno() {
		Object result = b.getBoardByBno(40L);
		Object[] ar = (Object[])result;
		System.out.println(Arrays.toString(ar));
	}
```  

## 10. CRUD작업을 위한 준비
### 1) BoardEntity에 해당하는 Board DTO클래스 생성  
```java
@Data
@ToString
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class BoardDTO {
	private Long bno;
	private String title;
	private String content;
	private LocalDateTime regdate;
	private LocalDateTime moddate;
	
	// 작성자 정보
	private String memberEmail;
	private String memberName;
	
	// 댓굴의 개수
	private int replyCount;
}
```  

### 2) Board Entity의 요청을 처리할 메서드의 원형을 소유할 BoardService인터페이스를 생성하고 DTO와 Entity사이의 변환을 수행해주는 메서드를 생성 - service.BoardService  
```java
public interface BoardService {
	// DTO를 Entity로 변환하는 메서드
	default Board dtoToEntity(BoardDTO dto) {
		Member member = Member.builder().email(dto.getMemberEmail()).build();
		Board board = Board.builder().bno(dto.getBno()).title(dto.getTitle()).content(dto.getContent()).member(member).build();
		
		return board;
	}
	
	// Entity를 DTO로 변환해주는 메서드
	default BoardDTO entitytoDTO(Board board, Member member, Long replyCount) {
		BoardDTO boardDTO = BoardDTO.builder().bno(board.getBno()).title(board.getTitle()).content(board.getContent())
				.regdate(board.getRegDate()).moddate(board.getModDate()).memberEmail(member.getEmail())
				.memberName(member.getName()).replyCount(replyCount.intValue()).build();
		return boardDTO;		
	}
}
```  

### 3) 사용자의 요청을 처리할 메서드를 구현하기위한 BoardServiceImpl 클래스를 생성 - service.BoardServiceImpl  
```java
@Service
@RequiredArgsConstructor
@Log4j2
public class BoardServiceImpl implements BoardService{
	private final BoardRepository boardRepostiory;
}
```
## 11. 게시물 등록
### 1) BoardService 인터페이스에 메서드를 선언
```java
	// 게시물 등록을 위한 메서드
	Long register(BoardDTO dto);
```  

### 2) BoardServiceImpl에 메서드 구현  
```java
	@Override
	public Long register(BoardDTO dto) {
		log.info(dto);
		Board board = dtoToEntity(dto);
		boardRepostiory.save(board);
		return board.getBno();
	}
```  

### 3) Service 계층 테스트를 위한 클래스를 생성하고 작성한 메서드 테스트 - src/test/java의 ServiceTest  
```java
@SpringBootTest
public class ServiceTest {
	@Autowired
	private BoardService b;
	
	@Test
	public void testRegister() {
		BoardDTO dto = BoardDTO.builder().title("test").content("test content").memberEmail("choc1@aa.com").build();
		Long bno = b.register(dto);
		System.out.println("test reg : "+bno);
	}
}
```  
-> 없는 member의 email을 사용하면 오류  

## 12. 게시물 목록 보기  
### 1) 목록보기 요청을 위한 DTO클래스를 생성 - dto.PageRequestDTO  
```java
@Builder
@AllArgsConstructor
@Data
public class PageRequestDTO {
	// 현재페이지 번호
	private int page;
	// 페이지당 출력할 데이터 개수
	private int size;
	// 검색 항목
	private String type;
	// 검색할 데이터
	private String keyword;
	
	// 생성자
	public PageRequestDTO() {
		this.page = 1;
		this.size = 10;
	}
	
	public Pageable getPageable(Sort sort) {
		return PageRequest.of(page-1, size, size);
	}
}
```
### 2) 목록보기 응답을 위한 DTO클래스를 생성 - dto.PageResultDTO  
```java
@Data
public class PageResultDTO<DTO, EN> {
	//DTO리스트
	private List<DTO> dtoList;
	
	// 전체 페이지 개수
	private int totalPage;
	
	// 현재 페이지 번호
	private int page;
	
	// 출력할 페이지 번호 개수
	private int size;
	
	// 시작하는 페이지번호와 끝나는 페이지번호
	private int start, end;
	
	// 이전 페이지와 다음페이지 존재여부
	private boolean prev,next;
	
	// 페이지번호 목록
	private List<Integer> pageList;
	
	// 페이지 번호목록을 만들어주는 메서드
	private void makePageList(Pageable pageable) {
		this.page = pageable.getPageNumber() + 1;
		this.size = pageable.getPageSize();
		
		int tempEnd = (int)(Math.ceil(page/10.0)) * 10;
		start = tempEnd - 9;
		prev = start > 1;
		
		end = totalPage > tempEnd ? tempEnd:totalPage;
		next= totalPage> tempEnd;
		pageList = IntStream.rangeClosed(start, end).boxed().collect(Collectors.toList());
	}
	
	public PageResultDTO(Page <EN> result, Function<EN, DTO> fn) {
		dtoList = result.stream().map(fn).collect(Collectors.toList());
		totalPage = result.getTotalPages();
		makePageList(result.getPageable());		
	}
}
```  

### 3) BoardService 인터페이스에 목록보기 메서드 선언  
```java
	// 목록보기 메서드
	PageResultDTO<BoardDTO, Object[]> <BoardDTO, Object[]> getList(PageRequestDTO pageRequestDTO);
```  

### 4) BoardServiceImpl 클래스에 목록보기 메서드 구현  
```java
	@Override
	public PageResultDTO<BoardDTO, Object[]> getList(PageRequestDTO pageRequestDTO) {
		log.info(pageRequestDTO);
		
		// Entity를 DTO로 변환해주는 함수 생성
		// Repository의 메서드의 결과가 Object[]인데 이 배열의 요소를 가지고 BoardDTO를 생성해서 출력해야 함
		Function<Object[], BoardDTO> fn = (en -> entitytoDTO((Board)en[0], (Member)en[1], (Long)en[2]));
		
		// 데이터를 조회 - bno의 내림차순 적용
		// 상황에 따라서는 regdate나 moddate로 정렬하는 경우도 있음
		Page<Object[]> result = boardRepostiory.getBoardWithReplyCount(pageRequestDTO.getPageable(Sort.by("bno").descending()));
			
		return new PageResultDTO<>(result, fn);
	}
```  

### 5) ServiceTest클래스에 앞에서 만든 메서드를 테스트하는 코드를 추가하고 확인  
```java
	@Test
	public void testList() {
		PageRequestDTO pageRequestDTO = new PageRequestDTO();
		PageResultDTO<BoardDTO, Object[]> result = b.getList(pageRequestDTO);
		
		for(BoardDTO boardDTO : result.getDtoList()) {
			System.out.println(boardDTO);
		}
	}
```

## 13. 게시물 상세보기  
### 1) BoardService 인터페이스에서 상세보기(하나의 데이터를 자세히 확인하는 작업)를 위한 메서드를 선언  
```java
	// 상세보기 메서드
	BoardDTO getBoard(Long bno);
```

### 2) BoardServiceImpl에서 상세보기를 위한 메서드 구현  
```java
	@Override
	public BoardDTO getBoard(Long bno) {
		// bno를 이용해서 하나의 데이터 가져오기
		// Board, Member, Long - 댓글 개수
		Object result = boardRepostiory.getBoardByBno(bno);
		Object[] ar = (Object[]) result;
		
		return entitytoDTO((Board)ar[0], (Member)ar[1], (Long)ar[2]);
	}
```  

### 3) ServiceTest 클래스에 상세보기를 확인하는 메서드를 생성하고 확인  
```java
	@Test
	public void testBoard() {
		BoardDTO dto = b.getBoard(40L);
		System.out.println("test board : " + dto);
	}
```  

## 14. 게시물 삭제  
* 삭제를 할 때는 실제 삭제할 것인지 아니면 삭제되었다는 표시를 할 것인지를 고민해야 합니다.  
* Board테이블에서 게시글을 지울 때 Reply테이블에서 게시글에 해당하는 데이터도 삭제  

### 1) ReplyRepository 인터페이스에 게시글 번호로 삭제하는 메서드를 생성  
```java
public interface ReplyRepository extends JpaRepository<Reply, Long> {
	// 게시글 번호를 이용해서 삭제하는 메서드 
	@Modifying
	@Query("delete from Reply r where r.board.bno = :bno")
	public void deleteByBno(@Param("bno") Long bno);
}
```  

### 2) BoardService에 게시글을 삭제하는 메서드를 선언  
```java
	// 게시글 삭제 메서드
	void removeWithReplies(Long bno);
```

### 3) BoardServiceImpl클래스에 게시글을 삭제하는 메서드를 구현  
```java
	private final ReplyRepository replyRepo;

	// 이 메서드 안의 작업은 하나의 트랜젝션으로 처리해달라고 요청
	@Transactional
	@Override
	public void removeWithReplies(Long bno) {
		// 댓글 삭제
		replyRepo.deleteByBno(bno);
		// 게시글 삭제
		boardRepostiory.deleteById(bno);
	}
```  
-> @Transactional 생략시 오류나므로 조심할 것  

### 4) ServiceTest 클래스에 테스트 코드를 작성하고 테스트  
```java
	@Test
	public void testDelete() {
		Long bno = 2L;
		b.removeWithReplies(bno);
	}
```  
### +) 
```java
Scanner sc = new Scanner(System.in);
while(true){
	try{
		String x = sc.nextLine();
		int n = sc.nextInt();
	}catch(Exception e){
		continue;
	}	
}
```  

## 15. 데이터 수정  
* Board Entity에 getter는 있으나 Setter는 없으므로 수정이 안됨  
### 1) Board Entity에 title과 content를 수정할 수 있는 메서드를 추가  
```java
// title을 수정하는 메서드
	public void changeTitle(String title) {
		this.title = title;
	}
	
	// content을 수정하는 메서드
	public void changeContent(String content) {
		this.content = content;
	}
```

### 2) BoardService인터페이스에 게시글 수정을 위한 메서드를 선언  
```java
	// 게시글 수정 메서드
	void modifyBoard(BoardDTO boardDTO);
```  

### 3) BoardServiceImpl클래스에 게시글 수정을 위한 메서드 생성  
```java
	@Transactional
	@Override
	public void modifyBoard(BoardDTO boardDTO) {
		// 데이터의 존재 여부를 확인
		Optional<Board> board = boardRepostiory.findById(boardDTO.getBno());
		if(board.isPresent()) {
			board.get().changeTitle(boardDTO.getTitle());
			board.get().changeContent(boardDTO.getContent());
			
			boardRepostiory.save(board.get());
		}
	}
```

### 4) ServiceTest 클래스에 테스트 코드를 작성하고 테스트  
```java
	@Test
	public void testModifyBoard() {
		BoardDTO boardDTO = BoardDTO.builder().bno(3L).title("제목을 수정").content("내용을 수정").build();
		b.modifyBoard(boardDTO);
	}
```  



## 16. Controller와 Veiw 계층  
### 1) 공통된 디자인 적용을위한 설정 - bootstrap의 simple sidebar 디자인 적용  
* 공통된 디자인을 적용하기 위한 css 파일이나 js파일은 static 디렉터리에 위치시켜야합니다.  
* 이전에 사용했던 assets, css, js 디렉터리를 src/main/resources디렉터리 안의 static 디렉터리에 복사  
* 이전에 공통된 메뉴를 위해 만들었던 basic.html파일을 src/main/resources디렉터리안의 template 디렉터리에 layout 디렉터리를 만들고 복사  

### 2) Controller역할을 수행할 BoardController 클래스를 생성 
```java
@Controller
@Log4j2
@RequiredArgsConstructor
public class BoardController {
	private final BoardService boardService;
	
	
}
```  

### 3) 목록보기 처리  
* 목록보기 요청을 처리할 메서드를 BoardController 클래스에 생성  
```java
	// 목록보기 요청을 처리할 메서드
	@GetMapping({"/","/board/list"})
	public String list(PageRequestDTO pageRequestDTO, Model model) {
		log.info("목록보기 요청"+pageRequestDTO);
		model.addAttribute("result",boardService.getList(pageRequestDTO));
		
		return "/board/list";
	}
```

* templates/board디렉터리에 board디렉터리를 생성하고 list.html파일을 생성하고 작성  
```html
<!DOCTYPE html>
<html lang="en" xmlns:th="http://www.thymeleaf.org">
<th:block th:replace="~{/layout/basic :: setContent(~{this::content} )}">
   <th:block th:fragment="content">
      <h1 class="mt-4">
         Board List Page 
         <span><a th:href="@{/board/register}">
         	<button type="button" class="btn btn-outline-primary">REGISTER</button>
         </a></span>
      </h1>
      <form action="/board/list" method="get" id="searchForm">
         <div class="input-group">
            <input type="hidden" name="page" value="1">
            <div class="input-group-prepend">
               <select class="custom-select" name="type">
                  <option th:selected="${pageRequestDTO.type == null}">-------</option>
                  <option value="t" th:selected="${pageRequestDTO.type =='t'}">제목</option>
                  <option value="c" th:selected="${pageRequestDTO.type =='c'}">내용</option>
                  <option value="w" th:selected="${pageRequestDTO.type =='w'}">작성자</option>
                  <option value="tc" th:selected="${pageRequestDTO.type =='tc'}">제목+내용</option>
                  <option value="tcw" th:selected="${pageRequestDTO.type =='tcw'}">ALL</option>
               </select>
            </div>
            <input class="form-control" name="keyword"
               th:value="${pageRequestDTO.keyword}">
            <div class="input-group-append" id="button-addon4">
               <button class="btn btn-outline-secondary btn-search" type="button">Search</button>
               <button class="btn btn-outline-secondary btn-clear" type="button">Clear</button>
            </div>
         </div>
      </form>
      <table class="table table-striped">
         <thead>
            <tr>
               <th scope="col">#</th>
               <th scope="col">Title</th>
               <th scope="col">Writer</th>
               <th scope="col">Regdate</th>
            </tr>
         </thead>
         <tbody>
            <tr th:each="dto : ${result.dtoList}">
               <th scope="row">[[${dto.bno}]]</th>
               <td><a th:href="@{/board/read(bno = ${dto.bno},
                    page= ${result.page},
                    type=${pageRequestDTO.type} ,
                    keyword = ${pageRequestDTO.keyword})}">[[${dto.title}]]--------[<b th:text="${dto.replyCount}"></b>]
               </a></td>
               <td>[[${dto.memberName}]] <small>[[${dto.memberEmail}]]</small>
               </td>
               <td>[[${#temporals.format(dto.regdate, 'yyyy/MM/dd')}]]</td>
            </tr>
         </tbody>
      </table>
      <ul class="pagination h-100 justify-content-center align-items-center">
         <li class="page-item " th:if="${result.prev}"><a
            class="page-link"
            th:href="@{/board/list(page= ${result.start-1},
                    type=${pageRequestDTO.type} ,
                    keyword = ${pageRequestDTO.keyword} ) }"
            tabindex="-1">Previous</a></li>
         <li th:class=" 'page-item ' + ${result.page == page?'active':''} "
            th:each="page: ${result.pageList}"><a class="page-link"
            th:href="@{/board/list(page = ${page} ,
                   type=${pageRequestDTO.type} ,
                   keyword = ${pageRequestDTO.keyword}  )}">
               [[${page}]] </a></li>
         <li class="page-item" th:if="${result.next}"><a
            class="page-link"
            th:href="@{/board/list(page= ${result.end + 1} ,
                    type=${pageRequestDTO.type} ,
                    keyword = ${pageRequestDTO.keyword} )}">Next</a>
         </li>
      </ul>
      <div class="modal" tabindex="-1" role="dialog">
         <div class="modal-dialog" role="document">
            <div class="modal-content">
               <div class="modal-header">
                  <h5 class="modal-title">Modal title</h5>
                  <button type="button" class="close" data-dismiss="modal"
                     aria-label="Close">
                     <span aria-hidden="true">&times;</span>
                  </button>
               </div>
               <div class="modal-body">
                  <p>[[${msg}]]</p>
               </div>
               <div class="modal-footer">
                  <button type="button" class="btn btn-secondary"
                     data-dismiss="modal">Close</button>
               </div>
            </div>
         </div>
      </div>
<script th:inline="javascript">
    var msg = [[${msg}]];
    console.log(msg);

    if(msg){
      $(".modal").modal();
    }
    var searchForm = $("#searchForm");
    $('.btn-search').click(function(e){
      searchForm.submit();
    });

    $('.btn-clear').click(function(e){
      searchForm.empty().submit();
    });
</script>
```

### 4) 게시물 작성
* BoardController 클래스에 게시물 등록을 위한 메서드를 생성  
```java
	// 게시물 작성을 처리할 메서드
	@GetMapping("/board/register")
	public void register() {
		log.info("게시물 등록으로 이동");
	}
	
	@PostMapping("/board/register")
	public String register(BoardDTO dto, RedirectAttributes rAttr) {
		log.info("게시물 처리중"+dto);
		// 게시물 등록
		Long bno = boardService.register(dto);
		// View에 데이터 전달
		rAttr.addFlashAttribute("msg",bno+" insert");
		return "redirect:/board/list";
	}
```
* templates 디렉터리에 register.html파일을 생성하고 작성  
```html
<!DOCTYPE html>
<html lang="en" xmlns:th="http://www.thymeleaf.org">

<th:block th:replace="~{/layout/basic :: setContent(~{this::content} )}">
  <th:block th:fragment="content">
    <h1 class="mt-4">게시물 작성</h1>

    <form th:action="@{/board/register}" th:method="post">
      <div class="form-group">
        <label>제목</label>
        <input type="text" class="form-control" name="title" placeholder="Enter Title">
      </div>
      <div class="form-group">
        <label>내용</label>
        <textarea class="form-control" rows="5" name="content"></textarea>
      </div>
      <div class="form-group">
        <label>작성자 이메일</label>
        <input type="email" class="form-control" name="memberEmail" placeholder="작성자 이메일">
      </div>
      <button type="submit" class="btn btn-primary">Submit</button>
    </form>
  </th:block>
</th:block>
```  

### 5) 게시물 상세보기  
* 1) BoardController 클래스에 게시물 상세보기를 위한 메서드를 생성  
```java
	// 상세보기 처리를 위한 메서드
	@GetMapping("/board/read")
	// @ModelAttribute("이름")는 파라미터를 받아서이름으로 다음 요청에게 넘겨주는 역항르 수행
	public void read(@ModelAttribute("requestDTO")PageRequestDTO pageRequestDTO, Model model, Long bno) {
		log.info("상세보기 처리중.." + bno);
		BoardDTO boardDTO = boardService.getBoard(bno);
		model.addAttribute("dto",boardDTO);
	}
```  

* 2) templates/board디렉터리에 read.html파일을 생성하고 작성  
```html

```  

### 6) 게시물 수정 및 삭제  
### 1) BoardController에서 게시물 상세보기 요청을 처리하는 부분의 URL을 수정  
```java
	// 상세보기와 수정보기 처리를 위한 메서드
	@GetMapping({"/board/read", "/board/modify"})
	// @ModelAttribute("이름")는 파라미터를 받아서이름으로 다음 요청에게 넘겨주는 역항르 수행
	public void read(@ModelAttribute("requestDTO")PageRequestDTO pageRequestDTO, Model model, Long bno) {
		log.info("상세보기 처리중.." + bno);
		BoardDTO boardDTO = boardService.getBoard(bno);
		model.addAttribute("dto",boardDTO);
	}
```
-> 상세보기와 수정을 위한 화면으로 이동하는 것은 하나의 데이터를 찾아오는 것은 동일하고 출력할 때 읽기전용으로 만들 것이냐 아니면 편집이 가능하도록 할 것이냐의 차이입니다.  

### 2) BoardController에서 수정과 삭제를 처리할 메서드
```java
	// 수정을 처리할 메서드
	@PostMapping("/board/modify")
	// 수정은 이전에 보고있던 목록보기로 돌아갈 수있어야하기 때문에 목록 보기에 필요한 데이터가 필요합니다.
	public String modify(BoardDTO dto, @ModelAttribute("requestDTO")PageRequestDTO pageRequestDTO, RedirectAttributes rAttr) {
		boardService.modifyBoard(dto);
		
		rAttr.addAttribute("page", pageRequestDTO.getPage());
		rAttr.addAttribute("type", pageRequestDTO.getType());
		rAttr.addAttribute("keyword", pageRequestDTO.getKeyword());
		rAttr.addAttribute("bno", dto.getBno());
		
		return "redirect:/board/read";
	}

		// 수정을 처리할 메서드
	@PostMapping("/board/modify")
	// 수정은 이전에 보고있던 목록보기로 돌아갈 수있어야하기 때문에 목록 보기에 필요한 데이터가 필요합니다.
	public String modify(BoardDTO dto, @ModelAttribute("requestDTO")PageRequestDTO pageRequestDTO, RedirectAttributes rAttr) {
		boardService.modifyBoard(dto);
		
		rAttr.addAttribute("page", pageRequestDTO.getPage());
		rAttr.addAttribute("type", pageRequestDTO.getType());
		rAttr.addAttribute("keyword", pageRequestDTO.getKeyword());
		rAttr.addAttribute("bno", dto.getBno());
		
		return "redirect:/board/read";
	}
```  

### 3) templates/board디렉터리에 modify.html 작성  
```html
<!DOCTYPE html>
<html lang="en" xmlns:th="http://www.thymeleaf.org">
<th:block th:replace="~{/layout/basic :: setContent(~{this::content} )}">
   <th:block th:fragment="content">
      <h1 class="mt-4">Board Modify Page</h1>
      <form action="/board/modify" method="post">

         <!--페이지 번호  -->
         <input type="hidden" name="page" th:value="${requestDTO.page}">
         <input type="hidden" name="type" th:value="${requestDTO.type}">
         <input type="hidden" name="keyword" th:value="${requestDTO.keyword}">

         <div class="form-group">
            <label>Bno</label> <input type="text" class="form-control"
               name="bno" th:value="${dto.bno}" readonly>
         </div>

         <div class="form-group">
            <label>Title</label> <input type="text" class="form-control"
               name="title" th:value="${dto.title}">
         </div>
         <div class="form-group">
            <label>Content</label>
            <textarea class="form-control" rows="5" name="content">[[${dto.content}]]</textarea>
         </div>
         <div class="form-group">
            <label>Writer</label> <input type="text" class="form-control"
               name="member" th:value="${dto.memberEmail}" readonly>
         </div>
         <div class="form-group">
            <label>RegDate</label> <input type="text" class="form-control"
               th:value="${#temporals.format(dto.regdate, 'yyyy/MM/dd HH:mm:ss')}"
               readonly>
         </div>
         <div class="form-group">
            <label>ModDate</label> <input type="text" class="form-control"
               th:value="${#temporals.format(dto.moddate, 'yyyy/MM/dd HH:mm:ss')}"
               readonly>
         </div>
      </form>

      <button type="button" class="btn btn-primary modifyBtn">수정</button>
      <button type="button" class="btn btn-info listBtn">목록</button>
      <button type="button" class="btn btn-danger removeBtn">삭제</button>

      <script th:inline="javascript">
      var actionForm = $("form"); //form 태그 객체

      $(".removeBtn").click(function(){
             if(!confirm("삭제하시겠습니까?")){
          return ;
        }        
           actionForm
                .attr("action", "/board/remove")
                .attr("method","post");

        actionForm.submit();
      });

      $(".modifyBtn").click(function() {
        if(!confirm("수정하시겠습니까?")){
          return ;
        }
        actionForm
                .attr("action", "/board/modify")
                .attr("method","post")
                .submit();
      });
      
      $(".listBtn").click(function() {
        //var pageInfo = $("input[name='page']");
        var page = $("input[name='page']");
        var type = $("input[name='type']");
        var keyword = $("input[name='keyword']");

        actionForm.empty(); //form 태그의 모든 내용을 지우고

        actionForm.append(page);
        actionForm.append(type);
        actionForm.append(keyword);
        
        actionForm
                .attr("action", "/board/list")
                .attr("method","get");

        actionForm.submit();
      })
    </script>

   </th:block>
</th:block>
```  

## 17. 동적인 쿼리 작업  
* 검색항목이 고정이 아니고 변하는 쿼리 - Spring JPA에서는 querydsl을 이용해서 처리 가능  

### 1) querydsl사용 설정
* querydsl을 사용하기 위해서 build.gradle을 수정 : group, version, sourceCompatibility, tasks.named("test")는 그대로, implements에는 jpa  
```gradle
buildscript {
	ext {
		queryDslVersion = "5.0.0"
	}
}
plugins {
	id 'org.springframework.boot' version '2.7.0'
	id 'io.spring.dependency-management' version '1.0.11.RELEASE'
	id 'java'
	
	id "com.ewerk.gradle.plugins.querydsl" version "1.0.10"
}

group = 'com.chocchic.board'
version = '0.0.1-SNAPSHOT'
sourceCompatibility = '11'

configurations {
	compileOnly {
		extendsFrom annotationProcessor
	}
}

repositories {
	mavenCentral()
}

dependencies {
	implementation 'org.springframework.boot:spring-boot-starter-data-jpa'
	implementation 'org.springframework.boot:spring-boot-starter-thymeleaf'
	implementation 'org.springframework.boot:spring-boot-starter-web'
	compileOnly 'org.projectlombok:lombok'
	developmentOnly 'org.springframework.boot:spring-boot-devtools'
	runtimeOnly 'mysql:mysql-connector-java'
	annotationProcessor 'org.projectlombok:lombok'
	testImplementation 'org.springframework.boot:spring-boot-starter-test'
	
	// https://mvnrepository.com/artifact/org.thymeleaf.extras/thymeleaf-extras-java8time
	implementation group: 'org.thymeleaf.extras', name: 'thymeleaf-extras-java8time'
	
	//querydsl 추가
	implementation "com.querydsl:querydsl-jpa:${queryDslVersion}"
	implementation "com.querydsl:querydsl-apt:${queryDslVersion}"
}

tasks.named('test') {
	useJUnitPlatform()
}

def querydslDir = "$buildDir/generated/querydsl"
querydsl {
	jpa = true
	querydslSourcesDir = querydslDir
}
sourceSets {
	main.java.srcDir querydslDir
}
configurations {
	compileOnly {
		extendsFrom annotationProcessor
	}
	querydsl.extendsFrom compileClasspath
}
compileQuerydsl {
	options.annotationProcessorPath = configurations.querydsl
}

```  

* build.gradle을 수정 후 프로젝트를 선택하고 마우스 오른쪽을 누른후 gradle - refresh gradle project를 수행  

* build tasks 윈도우를 열어서 build에서 build와 jar를 클릭  

* 제대로 빌드되었다면 프로젝트에 build/generated/querydsl 디렉터리가 생성됩니다.  

### 2) persistence패키지에 검색을 위한 SearchBoardRepostiory인터페이스를 생성 - BoardRepository의 기능을 확장하기 위해서 만든 인터페이스  
```java
public interface SearchBoardRepository {
	
}
```
### 3) persistence패키지에 검색을 위한 SearchBoardRepostiory인터페이스를 implements하고 Querydsl을 사용할 수 있는 클래스를 생성  - SearchBoardRepositoryImpl
```java
public class SearchBoardRepositoryImpl extends QuerydslRepositorySupport implements SearchBoardRepository {

	public SearchBoardRepositoryImpl() {
		super(Board.class);
	}

}
```  

### 4) SearchBoardRepository인터페이스에 메서드 선언  
```java
	Board search();
```  

### 5) SearchBoardRepositoryImpl클래스에 메서드 구현  
```java
@Override
	public Board search() {
		log.info("search...");
		
		QBoard board = QBoard.board;
		
		JPQLQuery<Board> jpqlQuery = from(board);
		// bno가 40인 데이터 조회를 위한 메서드 호출
		jpqlQuery.select(board).where(board.bno.eq(40L));
		
		// 실행
		List<Board> result = jpqlQuery.fetch();
		
		log.info("result : " + result);
		return result.get(0);
	}
```  

### 6) BoardRepository 인터페이스에 SearchBoardRepository를 extends  
```java
public interface BoardRepository extends JpaRepository<Board, Long>, SearchBoardRepository {
```  

### 7) RepositoryTest 클래스에 테스트 메서드를 생성하고 확인  
```java
	@Test
	public void testSearch() {
		System.out.println("testSearch :"+b.search());
	}
```  

### 8) SearchBoardRepositoryImpl클래스의 search메서드를 수정하고 테스트  
```java
	@Override
	public Board search() {
		log.info("search...");

		// 데이터 하나만 뽑아오는 경우
		QBoard board = QBoard.board;
		
		JPQLQuery<Board> jpqlQuery = from(board);
		// bno가 40인 데이터 조회를 위한 메서드 호출
		jpqlQuery.select(board).where(board.bno.eq(40L));
		
		// 실행
		List<Board> result = jpqlQuery.fetch();
		
		log.info("result : " + result);
		return result.get(0);
	}
```  

### +) Java에서 Database 사용  
* 순수 JDBC Code 이용
	Connection  
	Statement, PreparedStatement, CallableStatement  
	ResultSet  
	클래스들을 이용해서 작성  
	중복된 코드를 만들 가능성이 높아지고 자바 코드 안에 SQL을 문자열의 형태로 작성하기 때문에 에러 가능성이 높아지고가독성이 떨어지고 유지보수가 힘듬.  

* Framework 이용  
	중복된 작업을 자동화해주고 SQL과 자바코드를 분리시키는 구조를 만들어서 데이터베이스 작업의 효율성을 높여줍니다.  

	SQL Mapper Framework : SQL과 자바코드를 분리하고 파라미터 매핑이나 결과 매핑을 자동으로 해주는 프레임워크로 MyBatis가 대표적  
		데이터베이스가 변경되면 SQL을 수정해야합니다.  
		데이터베이스의 변경이 자바 코드의 변경을 가져오는 경우가 발생할 수 있습니다.  
	
	ORM : 프로그래밍언어의 객체와 데이터베이스의 행을 매핑시켜서 SQL없이도 데이터베이스 작업이 가능하도록 해주는 프레임워크
		원리는 데이터베이스에 연결할 떄 데이터베이스의 내용을 메모리로 가져와서 가져온 복사본을 사용합니다. 이 복사본을 가져오는 작업은 자바코드를 이용하지 않고 설정을 이용합니다. 복사본을 작업하면 프레임워크가 적절한 순간에 데이터베이스와 동기화를 해줍니다.  
		ORM의 대표적인 방식이 Java에서는 JPA인터페이스를 이용하는 Hibernate입니다.  

	- JPA를 이용하는 방식
		+ Entity의 Repository인터페이스만 이용하는 방법 : 전체 또는 페이지 단위로 조회하거나 기본키를 가지고 수행하는 CRUD작업만 가능  
		+ 이름으로 메서드를 만들어서 이용하는 방법 : 간단한 조건을 이름으로 설정해서 작업을 수행할 수 있습니다 
			ex) findByEmail(String email)  
========= 위의 두가지는 하나의 Entity로만 결과를 만들 수 잇습니다. =========   

		+ JPQL로 쿼리를 생성해서 이용하는 방법 : JPQL 문법으로 쿼리를 작성해서 작업을 수행  
			@Query("쿼리")로 작성해서 사용하는 방식  
	여기까지 모든 방법들은 정적인 쿼리를 만드는 것입니다. 정적인 쿼리는 조건에 해당하는 값은 바꿀 수 있지만, 테이블 이름이나 컬럼 이름등은 실행 중에 변경이 불가능합니다.  
	select ? from ? where ? = ? ; 

	- 실행중에 쿼리를 변경하고자 하는 경우에 사용할 수 있는 Querydsl을 제공합니다.  
		검색항목을 여러 개 두고 그 중에서 하나의 항목을 선택해서 조회를 하고자 합니다.  

### +) 어떤 클래스를 상속받았을 떄 에러가 발생하는 경우  
	* 이 클래스가 private이나 default class인지 확인 : 다른 패키지에서 사용이 안되기 때문  
	* 이 클래스가 추상 클래스인지 확인 : 추상 메서드를 재정의하지 않아서 에러  
	* final class 인지 확인 : final클래스는 상속이 안됩니다.  
	* default constructor가 없는 경우  

### 9) SearchBoardRepositoryImpl클래스의 search메서드를 수정하고 테스트  
```java
@Override
	public Board search() {
		log.info("search...");
		/*
		// 데이터 하나만 뽑아오는 경우
		QBoard board = QBoard.board;
		
		JPQLQuery<Board> jpqlQuery = from(board);
		// bno가 40인 데이터 조회를 위한 메서드 호출
		jpqlQuery.select(board).where(board.bno.eq(40L));
		
		// 실행
		List<Board> result = jpqlQuery.fetch();
		
		log.info("result : " + result);
		return result.get(0);
		*/
		
		/*
		// 쿼리를 수행할 수 있는 Querydsl객체 중 join하고자 하는 Entity를 가져옵니다.
		QBoard board = QBoard.board;
		QReply reply = QReply.reply;
		QMember member = QMember.member;
		
		// 관계에서 부모에 해당하는 Entity를 기준으로 쿼리 객체 JPQLQuery를 생성
		JPQLQuery <Board> jpqlQuery = from(board);
		
		// 관계설정에 사용한 속성을 가지고 조인
		// SQL로 보면 : select * from board b, member m where b.email = m.email; 
		jpqlQuery.leftJoin(member).on(board.member.eq(member)); // member와 join
		jpqlQuery.leftJoin(reply).on(reply.board.eq(board)); // reply와 join
		
		// 필요한 데이터를 조회하는 구문을 추가
		// 조인한 데이터를 board별로 묶어서 board와 회원의 email 그리고 댓글의 개수 조회
		jpqlQuery.select(board, member.email, reply.count()).groupBy(board);
		
		// 결과 가져오기
		List<Board> result = jpqlQuery.fetch();
		
		System.out.println(result);
		*/
		
		// 결과를 Tuple로 받기
		QBoard board = QBoard.board;
		QReply reply = QReply.reply;
		QMember member = QMember.member;
		
		// Tuple은 관계형 데이터베이스에서는 하나의 행을 지칭하는 용어
		// 프로그래밍에서는 일반적으로 여러 종류의 데이터가 묶여서 하나의 데이터를 나타내는 것
		// Map과 다른 점은 Map은 key로 세부 데이터를 접근하지만 Tuple은 인덱스로 접근이 가능하고, 대부분의 경우 Tuple은 수정이 불가능
		JPQLQuery<Board> jpqlquery = from(board);
		jpqlquery.leftJoin(member).on(board.member.eq(member)); // member와 join
		jpqlquery.leftJoin(reply).on(reply.board.eq(board)); // reply와 join
		
		JPQLQuery<Tuple> tuple = jpqlquery.select(board, member.email, reply.count());
		tuple.groupBy(board);
		
		// 결과 가져오기
		List<Tuple> result = tuple.fetch();
		
		System.out.println(result);
		
		return null;
	}
```  

### 10) SearchBoardRepository인터페이스에 검색기능을 위한 메서드를 선언
```java
	// 검색을 위한 메서드
	// 3개의 항목을 묶어서 하나의 클래스로 표현해도 됩니다.
	Page<Object[]> searchPage(String type, String keyword, Pageable pageable);
```  

### 11) SearchBoardRepositoryImpl클래스에 검색기능을 위한 메서드를 구현  
```java
@Override
	public Page<Object[]> searchPage(String type, String keyword, Pageable pageable) {
		QBoard board = QBoard.board;
		QReply reply = QReply.reply;
		QMember member = QMember.member;
		
		JPQLQuery<Board> jpqlquery = from(board);
		jpqlquery.leftJoin(member).on(board.member.eq(member)); 
		jpqlquery.leftJoin(reply).on(reply.board.eq(board));
		
		JPQLQuery<Tuple> tuple = jpqlquery.select(board, member, reply.count());

		// 동적인ㅇ 쿼리 수행을 위한 객체 생성
		BooleanBuilder booleanBuilder = new BooleanBuilder();
		// bno가 0보다 큰 데이터를 추출
		BooleanExpression expression = board.bno.gt(0L);
		
		// type이 검색 항목
		if(type !=null) {
			String[] typeArr = type.split("");
			BooleanBuilder conditionBuilder = new BooleanBuilder();
			for(String t : typeArr) {
				switch(t) {
					case "t":
						conditionBuilder.or(board.title.contains(keyword));
						break;
					case "c":
						conditionBuilder.or(board.content.contains(keyword));
						break;
					case "w":
						conditionBuilder.or(board.member.name.contains(keyword));
						break;
				}
			}
			booleanBuilder.and(conditionBuilder);
		}
		// 조건 적용
		tuple.where(booleanBuilder);
		
		// 데이터 정렬 - 하나의 조건으로만 정렬
		// tuple.orderBy(board.bno.desc());
		// 정렬 조건 가져오기
		Sort sort = pageable.getSort();
		sort.stream().forEach(order ->{
			Order direction = order.isAscending()?Order.ASC:Order.DESC;
			String prop = order.getProperty();
			
			PathBuilder orderByExpression = new PathBuilder(Board.class, "board");
			tuple.orderBy(new OrderSpecifier(direction, orderByExpression.get(prop)));
		});
		
		// 그룹화
		tuple.groupBy(board);
		
		// 페이징 처리
		tuple.offset(pageable.getOffset());
		tuple.limit(pageable.getPageSize());
		
		// 결과를 가져오기
		List<Tuple> result = tuple.fetch();
		
		// 결과를 리턴
		return new PageImpl<Object[]>(result.stream().map(t->t.toArray()).collect(Collectors.toList()), pageable, tuple.fetchCount());
	}
```  

### 12) RepositoryTest클래스에서 만든 메서드 테스트  
```java
	@Test
	public void testSearchPage() {
		Pageable p = PageRequest.of(0,10,Sort.by("bno").descending().and(Sort.by("title").ascending()));
		Page<Object[]> result = b.searchPage("tcw", "9", p);
		System.out.println("result : " + result);
	}	
```  

### 13) BoardServiceImpl클래스의 getList메서드 수정  
```java
	@Override
	public PageResultDTO<BoardDTO, Object[]> getList(PageRequestDTO pageRequestDTO) {
		log.info(pageRequestDTO);
		
		// Entity를 DTO로 변환해주는 함수 생성
		// Repository의 메서드의 결과가 Object[]인데 이 배열의 요소를 가지고 BoardDTO를 생성해서 출력해야 함
		Function<Object[], BoardDTO> fn = (en -> entitytoDTO((Board)en[0], (Member)en[1], (Long)en[2]));
		
		// 데이터를 조회 - bno의 내림차순 적용
		// 상황에 따라서는 regdate나 moddate로 정렬하는 경우도 있음
		/*
		Page<Object[]> result = boardRepostiory.getBoardWithReplyCount(pageRequestDTO.getPageable(Sort.by("bno").descending()));
		*/
		Page<Object[]> result = boardRepostiory.searchPage(pageRequestDTO.getType(),pageRequestDTO.getKeyword(), pageRequestDTO.getPageable(Sort.by("bno").descending()));
		return new PageResultDTO<>(result, fn);
	}
```  

### +) 검색 타입 지정
	우리는 갯수가 적어서 영어 알파벳으로 해도 괜찮지만 쿠팡같은 거대한 쇼핑몰의 경우 알파벳으로만 하는 것이 힘들다
	그래서 숫자로 하는데,  shift연산자로 한다.
  	1 << 0
	1 << 1  

	1, 2, 3, 4, 5 ...
	1, 2, 4, 8, 16 ... 

	int i = 1; 이라고 지정하면 컴퓨터 입장에서는 2진수로 변환한다. -> 00000000 00000000 00000000 00000001  
	1 << 1 : 1을 왼쪽으로 한번 밀기 -> 0000000 0000000 00000000 00000010 : 2 (맨 앞에 0은 부호이므로 밀리지 않음)
	1 << 2 : 1을 왼쪽으로 두번 밀기 -> 0000000 0000000 00000000 00000100 : 4  

	같이 쓸 수 있는 옵션인지 못 쓰는 애들인지 사람이 기억해야 한다.  

	shift만 누르면 0000000 0000000 00000000 00000100 -> 4  
	control만 누르면 0000000 0000000 00000000 00001000 -> 8  
	shift와 control을 같이 0000000 0000000 00000000 00001100 -> 12  
	alt만 누르면  0000000 0000000 00000000 00100000 -> 16  

	shift 누른 것 확인 : 오른쪽으로 2번 밀기 % 2 == 1  	

## 18. 댓글 작업  
### 1) 개요  
* 댓글을 처리하는 Controller는 Rest Controller를 이용해서 생성  
* 웹 클라이언트에서 ajax를 이용해서 댓글을 처리  
* URL과 전송 방식  
  댓글 가져오기 - /replies/board/{bno - 게시글 번호} - GET 방식  
  댓글 작성 - /replies - Post방식  
  댓글 삭제 - /replies/{rno - 댓글번호} - DELETE 방식, 삭제 결과 문자열  
  댓글 주정 - /repiles/{rno - 댓글번호} - PUT 방식, 수정 결과 문자열  

### 2) Reply.java를 수정  
```java
@Entity
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Getter
@ToString
public class Reply extends BaseEntity{
	@Id
	@GeneratedValue(strategy = GenerationType.AUTO)
	private Long rno;
	private String content;
	private String replyer;
	
	// 다대일 관계 이고 데이터는 처음부터 가져오지 않고 나중에 가져오는 것으로 설정
	@ManyToOne(fetch = FetchType.LAZY)
	private Board board;
}
```  

### 3) ReplyRepository클래스에 게시글 번호를 이용해서 댓글 목록을 가져오는 메서드 추가  
```java
	// 게시글 번호를 이용해서 댓글 목록을 가져오는 메서드
	public List<Reply> getRepliesByBoardOrderByRno (Board Board);
```  

### 4) Test클래스에서 테스트  
* 데이터베이스에서 댓글이 있는 게시물 번호를 먼저 찾기.
```sql
-- reply 테이블에서 board)bno로 그룹화 해서 board_bno와 데이터 개수를 조회
-- 데이터 개수의 내림차순으로 정렬
select board_bno, count(*) from reply group by board_bno order by 2 desc;
```  

* 테스트 클래스에서 작성하고 실행  
```java
	@Test
	public void testListByBoard() {
		List<Reply> replyList = r.getRepliesByBoardOrderByRno(Board.builder().bno(41L).build());
		System.out.println(replyList);
	}
```  

### 5) Reply Entity를 화면에 출력하기 위한 ReplyDTO클래스를 생성  
```java
@Builder
@Data
@AllArgsConstructor
@NoArgsConstructor
public class ReplyDTO {
	private Long rno;
	private String text;
	private String replyer;
	
	private Long bno;
	
	private LocalDateTime regdate;
	private LocalDateTime moddate;
}
```  

### 6) Reply 관련 Service 인터페이스를 생성  
* 댓글을 삽입하는 기능, 댓글의 리스트를 가져오는 기능, 댓글을 수정하는 기능, 댓글을 삭제한느 기능을 구현  
* Entity 클래스와 DTO 클래스 간의 변환을 위한 메서드 - 개발자들에 따라서 다르기는 한데 인터페이스에 default method로 만들기도 하고, DTO클래스에 생성자와 static 메서드를 이용해서 만들기도 합니다.  

```java
public interface ReplyService {
	// 댓글 등록
	public Long register(ReplyDTO replyDTO);
	
	// 게시글 번호를 이용해서 댓글의 목록을 가져오는 메서드
	public List<ReplyDTO> getList(Long bno);
	
	// 댓글로 수정하는 메서드
	public void modify(ReplyDTO replyDTO);
	
	// 댓글을 삭제하는 메서드
	public void remove(Long rno);
	
	// ReplyDTO 객체를 Reply 객체로 변환하는 메서드
	default Reply dtoToEntity(ReplyDTO replyDTO) {
		Board board = Board.builder().bno(replyDTO.getBno()).build();
		Reply reply = Reply.builder().rno(replyDTO.getRno()).text(replyDTO.getText()).replyer(replyDTO.getReplyer()).board(board).build();
		return reply;
	}
	
	// Reply Entity를 ReplyDTO 객체로 변환하는 메서드
	default ReplyDTO entityToDTO(Reply reply) {
		ReplyDTO dto = ReplyDTO.builder().rno(reply.getRno()).replyer(reply.getReplyer()).text(reply.getContent()).regdate(reply.getRegdate()).moddate(reply.getModdate()).build();
		return dto;
	}
}
```  

### 7) ReplyService 인터페이스의 메서드를 구현할 ReplyServiceImpl클래스를 만들고 구현  
```java
@Service
@RequiredArgsConstructor
public class ReplyServiceImpl implements ReplyService {
	private final ReplyRepository replyRepository;
	
	@Override
	public Long register(ReplyDTO replyDTO) {
		Reply reply = dtoToEntity(replyDTO);
		replyRepository.save(reply);
		return reply.getRno();
	}

	@Override
	public List<ReplyDTO> getList(Long bno) {
		// 게시글 번호에 해당하느 Reply를 전부 찾아옴
		List<Reply> result = replyRepository.getRepliesByBoardOrderByRno(Board.builder().bno(bno).build());
		result.sort(new Comparator<Reply>() {
			@Override
			public int compare(Reply o1, Reply o2) {
				// 수정 시간의 내림차순
				// 오름차순의 경우는 o1과 o2의 순서를 바꾸면 됨 -> o1.getModDate().compareTo(o2.getModDate())
				// 숫자의 경우는 뺄셈으 이용하면 됩니다.
				// 양수가 리턴되면 앞의 데이터가 크다고 판단하고 음수가 리턴되면 뒤의 데이터가 크다고 판단해서 음수가 리턴될때 순서를 면경
				// 자바스크립트에서 데이터를 정렬할 때 주의해야합ㄴ디ㅏ.
				// 자바스크립트는 숫자도 문자열로 판단해서 정렬합니다. 숫자 데이터의 경우 정렬하고자 할 때 직접 구현해야합니다.
				return o2.getModDate().compareTo(o1.getModDate());
			}
		});
		return result.stream().map(reply-> entityToDTO(reply)).collect(Collectors.toList());
	}

	@Override
	public void modify(ReplyDTO replyDTO) {
		Reply reply = dtoToEntity(replyDTO);
		replyRepository.save(reply);
	}

	@Override
	public void remove(Long rno) {
		replyRepository.deleteById(rno);		
	}
}
```

### 8) ServiceTest클래스를 이용해서 ReplyServiceImpl클래스의 메서드 테스트  
```java
	@Autowired
	private ReplyService r;
	
	// 댓글 목록 가져오기 테스트
	@Test
	public void testGetList() {
		Long bno = 7L;
		List<ReplyDTO> replyDTOList= r.getList(bno);
		replyDTOList.forEach(replyDTO -> System.out.println(replyDTO));
	}
```  

### 9) 댓글 처리를 위한 RestController를 생성하고 게시글 번호를 가지고 게시글을 찾아오는 요청 처리 메서드를 생성  
```java
@RestController
@RequestMapping("/replies/")
@Log4j2
@RequiredArgsConstructor
public class ReplyController {
	private final ReplyService replyService;
	
	// 댓글 가져오기
	@GetMapping(value="/board/{bno}", produces = MediaType.APPLICATION_JSON_VALUE)
	public ResponseEntity<List<ReplyDTO>> getListByBoard(@PathVariable("bno")Long bno){
		List<ReplyDTO> list = replyService.getList(bno);
		return new ResponseEntity(list, HttpStatus.OK);
	}
}
```  

### 10) 브라우저에 localhost:포트번호/replies/board/게시글 번호를 입력해서 댓글이 나오는지 확인  

### 11) read.html파일에 댓글을 출력  
* 댓글 출력영역을 만들기  
```html
		<div>
			<div class="mt-4">
				<h5><span class="badge badge-secondary replyCount"> 댓글	[[${dto.replyCount}]]</span> </h5>
			</div>
			<div class="list-group replyList">
			</div>
		</div>
```  

* read.html 파일에 스크립트를 추가  
```html
<!--위의 코드 생략-->
<script th:inline="javascript">
      $(document).ready(function() {
       //게시글 번호를 bno에 저장
        var bno = [[${dto.bno}]];
      
        //댓글의 개수를 클릭했을 때 처리
        $(".replyCount").click(function () {
          loadJSONData();
        });

        //댓글이 추가될 영역
        var listGroup = $(".replyList");
        
        //날짜 처리를 위한 함수
        function formatTime(str){
          var date = new Date(str);
          return date.getFullYear() + '/' + (date.getMonth() + 1) + '/' + date.getDate() + ' ' + date.getHours() + ':' + date.getMinutes();
        }
        
        //특정한 게시글의 댓글을 처리하는 함수
        function loadJSONData() {
           //ajax의 get 방식으로 요청을 전송
          $.getJSON('/replies/board/'+bno, function(arr){
            console.log(arr);
            var str = "";
            //댓글 수 출력
            $('.replyCount').html("댓글 수 " + arr.length);
            //댓글을 순회하면서 댓글 출력 내용을 생성
            $.each(arr, function(idx, reply) {
              console.log(reply);
              str += '<div class="card-body" data-rno="' + reply.rno + '"><b>' + reply.rno + '</b>';
              str += '<h5 class="card-title">' + reply.text + '</h5>';
              str += '<h6 class="card-subtitle mb-2 text-muted">' + reply.replyer + '</h6>';
              str += '<p class="card-text">' + formatTime(reply.regDate) + '</p>';
              str += '</div>';
            })
            //댓글 출력
            listGroup.html(str);
          });
        }
      });
    </script>
   </th:block>
</th:block>
```

### 12) read.html파일에 댓글 삽입, 수정 및 삭제에 이용할 모달 창영역을 생성 - script 위에 작성  
```html
	<div class="modal" tabindex="-1" role="dialog">
		<div class="modal-dialog" role="document">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title">Modal title</h5>
					<button type="button" class="close" data-dismiss="modal" aria-label="Close">
					<span aria-hidden="true">&times;</span> </button>
				</div>
				<div class="modal-body">
					<div class="form-group">
					<input class="form-control" type="text" name="replyText" placeholder="댓글 작성...">
					</div>
					<div class="form-group">
						<input class="form-control" type="text" name="replyer" placeholder="작성자..." >
						<input type="hidden" name="rno"/>
					</div>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-danger replyRemove">삭제</button>
					<button type="button" class="btn btn-warning replyModify">수정</button>
					<button type="button" class="btn btn-primary replySave">추가</button>
					<button type="button" class="btn btn-outline-secondary replyClose" data-dismiss="modal">닫기</button>
				</div>
			</div>
		</div>
	</div>
```  

### 13) 데이터 삽입 요청  
* ReplyController에 데이터 삽입 요청을 처리하는 메서드를 작성  
```java
	// 댓글 삽입
	@PostMapping("")
	// 클라이언트에서 JSON 형태로 보낸 문자열을 ReplyDTO로 변경해서 저장합니다.
	public ResponseEntity<Long> register(@RequestBody ReplyDTO replyDTO){
		log.info("replyDOT : " + replyDTO);
		Long rno = replyService.register(replyDTO);
		return new ResponseEntity<>(rno, HttpStatus.OK);
	}
```  

* read.html파일에 댓글 삽입 요청을 생성  
```html
<h5><span class="badge badge-secondary addReply">댓글 작성 </span></h5>
```  

* read.html파일에 댓글 삽입 요청을 처리하기 위한 스크립트 추가  
```javascript
$(".replySave").click(function() {
	var reply = { 
		bno: bno,
		text: $('input[name="replyText"]').val(),
		replyer: $('input[name="replyer"]').val()
	};
	console.log(reply);
	$.ajax({
		url: '/replies/',
		method: 'post',
		data: JSON.stringify(reply),
		contentType: 'application/json; charset=utf-8', dataType: 'json',
		success: function(data){
			console.log(data);
			var newRno = parseInt(data);
			alert(newRno +"번 댓글이 등록되었습니다.");
			modal.modal('hide');
			loadJSONData();
		}
	})
});
```  

### 14) 댓글 삭제  
* ReplyController클래스에 댓글 삭제 요청을 처리해주는 메서드를 작성  
```java
	// 댓글 삭제
	@DeleteMapping("/{rno}")
	// 클라이언트에서 JSON형태로 보낸 문자열을 ReplyDTO로 변경해서 저장합니다.
	public ResponseEntity<String> remove(@PathVariable("rno")Long rno){
		replyService.remove(rno);
		return new ResponseEntity<>("Success",HttpStatus.OK);
	}
```  

* read.html파일에 댓글 삭제 요청을 위한 스크립트 코드를 추가  
```javascript
//댓글을 클릭했을 때 댓글을 출력하기 위한 코드
$('.replyList').on("click", ".card-body", function(){
	var rno = $(this).data("rno");
	$("input[name='replyText']").val( $(this).find('.card-title').html());
	$("input[name='replyer']").val( $(this).find('.card-subtitle').html());
	$("input[name='rno']").val(rno);
	$(".modal-footer .btn").hide();
	$(".replyRemove, .replyModify, .replyClose").show();
	modal.modal('show');
});

//삭제 버튼을 눌렀을 때 처리
$(".replyRemove").on("click", function(){
	var rno = $("input[name='rno']").val(); //모달창에 보이는 댓글 번호로 hidden처리되어 있음
	$.ajax({
		url: '/replies/' + rno,
		method: 'delete',
		success: function(result){
		//console.log("result: " + result);
			if(result ==='success'){
			alert("댓글이 삭제되었습니다.");
			modal.modal('hide');
			loadJSONData();
			}
		}
	})
});
```  
-> JQuery UI에서 modal이라고 검색하면 다른 방식도 있고, Bootstrap에서 examples나 docs의 예제를 사용해도 됨  
	우리는 JQueryUI것을 사용한 코드  

### 15) 댓글 수정  
* ReplyController클래스에 댓글 수정 요청을 처리해주는 메서드를 작성  
```java
	// 댓글 수정
	@PutMapping("/{rno}")
	// 클라이언트에서 JSON형태로 보낸 문자열을 ReplyDTO로 변경해서 저장합니다.
	public ResponseEntity<String> modify(@RequestBody ReplyDTO replyDTO){
		replyService.modify(replyDTO);
		return new ResponseEntity<>("success",HttpStatus.OK);
	}
```  

* read.html파일에 댓글 수정 요청을 위한 스크립트 코드를 추가  
```javascript
// 수정 버튼을 눌렀을 때 처리
$(".replyModify").click(function() {
	var rno = $("input[name='rno']").val();
	var reply = { 
		rno: rno, 
		bno: bno,
		text: $('input[name="replyText"]').val(),
		replyer: $('input[name="replyer"]').val() 
	}
	//console.log(reply); 
	$.ajax({
		url: '/replies/' + rno, 
		method: 'put',
		data: JSON.stringify(reply),
		contentType: 'application/json; charset=utf-8',
		success: function(result){
			console.log("RESULT: " + result);
			if(result ==='success'){ 
				alert("댓글이 수정되었습니다"); 
				modal.modal('hide'); 
				loadJSONData();
			} 
		}
	});
});
```  