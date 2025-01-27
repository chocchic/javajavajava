package io.github.chocchic.service;

import java.util.Optional;
import java.util.function.Function;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;

import com.querydsl.core.BooleanBuilder;
import com.querydsl.core.types.dsl.BooleanExpression;

import io.github.chocchic.dto.MemoDTO;
import io.github.chocchic.dto.PageRequestDTO;
import io.github.chocchic.dto.PageResponseDTO;
import io.github.chocchic.model.Memo;
import io.github.chocchic.model.QMemo;
import io.github.chocchic.persistence.MemoRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;

@Log4j2 // 로그 기록을 위한 어노테이션 - log.레벨(메세지)를 이용해서 로그를 출력하는 것이 가능
@Service
// 생성자를 이용해서 주입받기 위한 어노테이션 
@RequiredArgsConstructor
// @Autowired로 이용해서 주입받으면 주입받는 시점을 예측하기 어렵기 때문에 비추천
public class MemoServiceImpl implements MemoService {
	// 주입받기 위한 Repository - 생성자에서 주입받기 위해서는 final로 만들어져야 합니다.
	private final MemoRepository m;

	@Override
	public Long insertMemo(MemoDTO dto) {
		log.info("==데이터 삽입==");
		log.info(dto);
		
		// DTO를 Entity로 변환
		Memo memo = dtoToEntity(dto);
		
		// 데이터 저장하고 저장한 내용을 memo에 닫시 기록
		m.save(memo);
		
		return memo.getGno();
	}
	
	// 검색 조건을 만들어주는 메서드
	private BooleanBuilder getSearch(PageRequestDTO requestDTO) {
		// querydsl에서 사용할 검색 조건을 만드는 객체 생성
		BooleanBuilder booleanBuilder = new BooleanBuilder();
		
		// 검색 항목을 읽음
		String type = requestDTO.getType();
		// querydsl이 Entity에 적용할 검색 Entity를 제공하는데 그 객체를 가져옴
		QMemo qmemo = QMemo.memo;
		
		// 검색에 사용할 값
		String keyword = requestDTO.getKeyword();
		
		// gno 값이 0보다 큰 데이터만 조회
		BooleanExpression expression = qmemo.gno.gt(0L);
		booleanBuilder.and(expression);
		
		// 검색 조건이 없을 때
		if(type == null || type.trim().length() == 0) {
			return booleanBuilder;
		}
		//검색 조건이 있는 경우
		BooleanBuilder conditionBuilder = new BooleanBuilder();
		if(type.contains("t")) {
			conditionBuilder.or(qmemo.title.contains(keyword));
		}
		if(type.contains("c")) {
			conditionBuilder.or(qmemo.content.contains(keyword));
		}
		if(type.contains("w")) {
			conditionBuilder.or(qmemo.writer.contains(keyword));
		}
		// 모든 조건 통합
		booleanBuilder.and(conditionBuilder);
		
		return booleanBuilder;		
	}
	@Override
	public PageResponseDTO<MemoDTO, Memo> getList(PageRequestDTO requestDTO) {
		// 정렬조건을 적용해서 페이징 객체를 생성
		Pageable pageable = requestDTO.getPageable(Sort.by("gno").descending());
		// 검색조건을 생성
		BooleanBuilder booleanBuilder = getSearch(requestDTO);
		// 검색조건을 적용해서 조회
		Page<Memo> result = m.findAll(booleanBuilder, pageable);
		
		// Entity를 DTO로 변환해주는 함수 설정
		Function<Memo, MemoDTO> fn = (entity -> entityToDTO(entity));
		// 결과 리턴
		return new PageResponseDTO<MemoDTO, Memo>(result, fn);
	}

	@Override
	public MemoDTO read(Long gno) {
		// 기본키를 이용해서 데이터 찾아오기
		Optional<Memo> memo = m.findById(gno);
		return memo.isPresent()?entityToDTO(memo.get()):null;
	}

	@Override
	public void modify(MemoDTO dto) {
		// 데이터 찾아오기(그동안 지워졌을까봐)
		Optional<Memo> result = m.findById(dto.getGno());
		if(result.isPresent()){
			//업데이트 하는 항목은 '제목', '내용'
			Memo entity = result.get();
			entity.changeTitle(dto.getTitle());
			entity.changeContent(dto.getContent());
			m.save(entity);
		}
	}

	@Override
	public void remove(Long gno) {
		// 데이터 찾아오기(그동안 지워졌을까봐)
		Optional<Memo> result = m.findById(gno);
		if(result.isPresent()){
			m.deleteById(gno);
		}
	}
}
