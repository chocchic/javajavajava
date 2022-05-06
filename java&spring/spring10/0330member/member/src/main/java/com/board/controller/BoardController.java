package com.board.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.board.domain.BoardVO;
import com.board.mapper.BoardMapper;
//import com.board.service.BoardService;
import com.board.service.BoardService;

import lombok.extern.log4j.Log4j;

@Controller
@RequestMapping("/board/*")
@Log4j
public class BoardController {
	@Autowired
	private BoardService boardService;
	
	@GetMapping("write")
	public void write() {
		System.out.println("write requested");
		// service를 연결 했다면
//		boardService.getList()
		
		// 바로 mapper로 db 연결 확인
//		List<BoardVO> list = boardMapper.getList();
//		list.forEach(l -> System.out.println(l));
		
		BoardVO board = new BoardVO();
		
//		board.setTitle("새로 작성 글");
//		board.setContent("새 글 내용");
//		board.setWriter("java02");
//		boardMapper.insert(board);  // bno는 null, db에만 알아서 들어감
//		System.out.println(board);
//		
//		board.setTitle("새로 작성 글2");
//		board.setContent("새 글 내용2");
//		board.setWriter("java02");
//		boardMapper.insertSelectKey(board);
//		System.out.println(board); // bno가 필요할 때 사용 가능
		
		//read
		/*
		BoardVO vo = boardMapper.read(3L);
		System.out.println(vo);
		*/
		//delete
		/*
		 * System.out.println(boardMapper.delete(3L));		
		 */

		/*
		BoardVO vo = new BoardVO();
		vo.setBno(6L);
		vo.setTitle("수정제목");
		vo.setContent("내용 수정");
		vo.setWriter("user");
		
		System.out.println(boardMapper.update(vo));
		*/
		
		// Service까지 거치는 write
		/*
		BoardVO vo = new BoardVO();
		vo.setTitle("service Test");
		vo.setContent("concontent");
		vo.setWriter("java03");
		boardService.register(vo);
		*/
	}
	
	@PostMapping("write")
	public String writePro(BoardVO board, RedirectAttributes rttr){
		System.out.println("C write post : " + board);
		log.info(board);
		//라다이렉트할 때 데이터 전송하는 방법 중 하나로, 데이터를 이로히성으로만 전달하고 싶을 때 이 클래스의 ...Flash메서드 사용
		rttr.addFlashAttribute("result",board.getBno());
		boardService.register(board);
		return "redirect:/board/list";
	}
	
	@GetMapping("list")
	public void list(Model model) {
		model.addAttribute("list",boardService.getList());
	}
	
	@GetMapping("content")
	public void content(@RequestParam("bno")Long bno, Model model) {
		model.addAttribute("board",boardService.get(bno));
	}
	
	@PostMapping("modify")
	public String modify(BoardVO board) {
		
		boolean res = boardService.modify(board);
		if(res) System.out.println("수정 잘됨");
		else System.out.println("수정 안됨");
		
		return "redirect:/board/list"; 
	}
	@PostMapping("delete")
	public String delete(@RequestParam("bno") Long bno, RedirectAttributes rttr) {
		
		if(boardService.remove(bno)) {
			rttr.addFlashAttribute("result", "success"); 
		}
		
		return "redirect:/board/list";
	}
	
	
}
