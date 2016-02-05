package com.fis.board.notice.controller;

import ibsheet.BaseMap;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;

import com.fis.board.notice.service.NoticeService;
import com.vo.BoardVO;
import com.vo.CommentVO;

/**
 * @Class Name : ChartSimpleController.java
 * @Description :
 * @Modification Information @ @ 수정일 수정자 수정내용 @ --------- ---------
 *               ------------------------------- @ 2016. 01. 06. 허용준 최초생성
 * 
 * @author 허용준
 * @since
 * @version 1.0
 * @see
 */

@Controller
@RequestMapping(value = "/fis/board/notice")
public class NoticeController {

	@Autowired
	private NoticeService noticeService;

	private final int pageSize = 10;
	private final int f_NORMAL = 1, f_SEARCH = 2;// flag

	/**
	 * 메인화면조회
	 * 
	 * @param sheetSimpleVO
	 * @param req
	 * @param res
	 * @param model
	 * @return
	 * @throws Exception
	 */

	public void initBoard(BoardVO boardVO, ModelMap model, int pageNo)
			throws Exception {
		List<BaseMap> list = null;
		int flag = -1;

		if (boardVO.getSearchWord() == null)
			flag = f_NORMAL;
		else
			flag = f_SEARCH;

		switch (flag) {
		case f_NORMAL:
			list = noticeService.showList(boardVO);
			break;
		case f_SEARCH:
			list = noticeService.searchList(boardVO);
			break;
		}

		int size = list.size() / pageSize;
		if (list.size() % 10 != 0)
			size += 1;
		int pStart = (pageNo - 1) * pageSize, pEnd = pageNo * pageSize - 1;

		model.addAttribute("list", list);
		model.addAttribute("listLen", size);
		model.addAttribute("pageNo", pageNo);
		model.addAttribute("pStart", pStart);
		model.addAttribute("pEnd", pEnd);
		model.addAttribute("user_name", boardVO.getUser_name());
		model.addAttribute("searchWord", boardVO.getSearchWord());
	}

	@RequestMapping(value = "/{pageNo}/gotoNotice.moJson")
	public String gotoNotice(@ModelAttribute("boardVO") BoardVO boardVO,
			@PathVariable int pageNo, HttpServletRequest req,
			HttpServletResponse res, ModelMap model) throws Exception {
		String returnJsp = "/fis/board/notice";
		req.setCharacterEncoding("UTF-8");
		System.out.println("goto : " + boardVO);

		initBoard(boardVO, model, pageNo);

		System.out.println("notice controller");

		try {

			// 세션정보 가져오는 것
			// UserVO session = SessionUtil.getInstance().getUser(req);
		} catch (Exception e) {
			System.out.println("session fail");

		}

		return returnJsp;
	}

	@RequestMapping(value = "/gotoNoticeWriter.moJson")
	public String noticeWriter(@ModelAttribute("boardVO") BoardVO boardVO,
			HttpServletRequest req, HttpServletResponse res, ModelMap model)
			throws Exception {
		String returnJsp = "/fis/board/noticeWriter";

		req.setCharacterEncoding("UTF-8");
		model.addAttribute("pageNo", boardVO.getPageNo());
		model.addAttribute("user_name", boardVO.getUser_name());

		System.out.println("Writer" + boardVO.getPageNo());
		try {

			// 세션정보 가져오는 것
			// UserVO session = SessionUtil.getInstance().getUser(req);
		} catch (Exception e) {
			System.out.println("session fail");
		}

		return returnJsp;
	}

	@RequestMapping(value = "/gotoNoticeEditor.moJson")
	public String noticeEditor(@ModelAttribute("boardVO") BoardVO boardVO,
			@ModelAttribute("commentVO") CommentVO commentVO,
			HttpServletRequest req, HttpServletResponse res, ModelMap model)
			throws Exception {
		String returnJsp = "/fis/board/noticeEditor";
		String num = boardVO.getNum();
		String pageNo = boardVO.getPageNo();

		req.setCharacterEncoding("UTF-8");

		initViewer(boardVO, commentVO, num, req, model, pageNo);

		System.out.println("editorB : " + boardVO);
		System.out.println("editorC : " + commentVO);
		try {

			// 세션정보 가져오는 것
			// UserVO session = SessionUtil.getInstance().getUser(req);
		} catch (Exception e) {
			System.out.println("session fail");
		}

		return returnJsp;
	}

	@RequestMapping(value = "/{pageNo}/insert.moJson")
	public String noticeInsert(@ModelAttribute("boardVO") BoardVO boardVO,
			@PathVariable int pageNo, HttpServletRequest req,
			HttpServletResponse res, ModelMap model) throws Exception {
		String returnJsp = "/fis/board/notice";
		req.setCharacterEncoding("UTF-8");

		noticeService.insertNotice(boardVO);

		System.out.println(boardVO);
		initBoard(boardVO, model, 1);

		return returnJsp;
	}

	@RequestMapping(value = "/doUpdateContents.moJson")
	public String noticeUpdate(@ModelAttribute("boardVO") BoardVO boardVO,
			HttpServletRequest req, HttpServletResponse res, ModelMap model)
			throws Exception {
		String returnJsp = "/fis/board/noticeViewer";
		String num = boardVO.getNum();
		String pageNo = boardVO.getPageNo();
		CommentVO commentVO = new CommentVO();

		req.setCharacterEncoding("UTF-8");
		commentVO.setContents_num(num);
		noticeService.updateNotice(boardVO);

		System.out.println("updater : " + boardVO);
		initViewer(boardVO, commentVO, num, req, model, pageNo);
		// initBoard(boardVO, model, pageNo, f_NORMAL);

		return returnJsp;
	}

	@RequestMapping(value = "/doDeleteContents.moJson")
	public String noticeDelete(@ModelAttribute("boardVO") BoardVO boardVO,
			HttpServletRequest req, HttpServletResponse res, ModelMap model)
			throws Exception {
		String returnJsp = "/fis/board/notice";
		String num = boardVO.getNum();
		int pageNo = Integer.parseInt(boardVO.getPageNo());
		CommentVO commentVO = new CommentVO();
		req.setCharacterEncoding("UTF-8");

		commentVO.setContents_num(num);
		noticeService.deleteCommentsBelongNotice(commentVO);
		noticeService.deleteNotice(boardVO);

		System.out.println("editor : " + boardVO);
		initBoard(boardVO, model, pageNo);

		return returnJsp;
	}

	@RequestMapping(value = "/doDeleteComment.moJson")
	public String noticeCommentDelete(
			@ModelAttribute("commentVO") CommentVO commentVO,
			@ModelAttribute("boardVO") BoardVO boardVO, HttpServletRequest req,
			HttpServletResponse res, ModelMap model) throws Exception {
		String returnJsp = null;
		boardVO.setNum(commentVO.getContents_num());
		System.out.println("dodle  1" + boardVO);
		List<BaseMap> list = noticeService.getOneComment(commentVO);
		System.out.println("dodle  2" + list);
		
		if (list.get(0).getValue(1).toString().equals(boardVO.getUser_name())) {
			returnJsp = "/fis/board/noticeViewer";
			noticeService.deleteComment(commentVO);
			initViewer(boardVO, commentVO, boardVO.getNum(), req, model,
					boardVO.getPageNo());

		} else {
			model.addAttribute("board_type",commentVO.getBoard_type());
			model.addAttribute("pageNo", boardVO.getPageNo());
			model.addAttribute("num", boardVO.getNum());
			model.addAttribute("user_name", boardVO.getUser_name());
			returnJsp = "/fis/board/commentDeleteWarning";
		}
		System.out.println("dodle 3");
		return returnJsp;
	}

	public void initViewer(BoardVO boardVO, CommentVO commentVO, String num,
			HttpServletRequest req, ModelMap model, String pageNo)
			throws Exception {
		boardVO.setNum(num);
		commentVO.setContents_num(num);
		System.out.println("contents viewer");
		List<BaseMap> list = noticeService.showContents(boardVO);
		List<BaseMap> commentList = noticeService.getComments(commentVO);
		System.out.println("list : " + list);
		System.out.println("CommentList : " + commentList);
		req.setCharacterEncoding("UTF-8");

		initBoard(boardVO, model, Integer.parseInt(pageNo));

		model.addAttribute("title", list.get(0).getValue(0));
		model.addAttribute("contents", list.get(0).getValue(1));
		req.setAttribute("contents", list.get(0).getValue(1));
		model.addAttribute("creator", list.get(0).getValue(2));
		model.addAttribute("date", list.get(0).getValue(3));
		model.addAttribute("pageNo", pageNo);
		model.addAttribute("num", num);
		model.addAttribute("commentList", commentList);
		model.addAttribute("commentSize", commentList.size());
		model.addAttribute("user_name", boardVO.getUser_name());

		System.out.println("initViewer : " + model);
	}

	@RequestMapping(value = "/noticeCommentWriter.moJson")
	public String noticeCommentWriter(
			@ModelAttribute("boardVO") BoardVO boardVO,
			@ModelAttribute("commentVO") CommentVO commentVO,
			HttpServletRequest req, HttpServletResponse res, ModelMap model)
			throws Exception {
		String returnJsp = "/fis/board/noticeViewer";
		String num = boardVO.getNum();
		String pageNo = boardVO.getPageNo();

		req.setCharacterEncoding("UTF-8");

		System.out.println("contents writer");
		commentVO.setContents_num(num);
		commentVO.setCreator(boardVO.getUser_name());
		noticeService.insertComment(commentVO);
		System.out.println(commentVO);

		initViewer(boardVO, commentVO, num, req, model, pageNo);

		return returnJsp;
	}

	@RequestMapping("/showNoticeContents.moJson")
	public String showNoticeContents(
			@ModelAttribute("boardVO") BoardVO boardVO,
			@ModelAttribute("commentVO") CommentVO commentVO,
			HttpServletRequest req, HttpServletResponse res, ModelMap model)
			throws Exception {
		String returnJsp = "/fis/board/noticeViewer";
		String num = boardVO.getNum();
		String pageNo = boardVO.getPageNo();

		System.out.println("viewer : " + boardVO);
		initViewer(boardVO, commentVO, num, req, model, pageNo);

		return returnJsp;
	}

}
