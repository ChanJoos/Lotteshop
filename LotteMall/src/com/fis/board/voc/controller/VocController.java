package com.fis.board.voc.controller;

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

import com.fis.board.voc.service.VocService;
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
@RequestMapping(value = "/fis/board/voc")
public class VocController {

	@Autowired
	private VocService vocService;

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
			list = vocService.showList(boardVO);
			break;
		case f_SEARCH:
			list = vocService.searchList(boardVO);
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

	@RequestMapping(value = "/{pageNo}/gotoVoc.moJson")
	public String gotoVoc(@ModelAttribute("boardVO") BoardVO boardVO,
			@PathVariable int pageNo, HttpServletRequest req,
			HttpServletResponse res, ModelMap model) throws Exception {
		String returnJsp = "/fis/board/voc";
		req.setCharacterEncoding("UTF-8");

		initBoard(boardVO, model, pageNo);
		System.out.println("voc controller");
		try {

			// 세션정보 가져오는 것
			// UserVO session = SessionUtil.getInstance().getUser(req);
		} catch (Exception e) {
			System.out.println("session fail");

		}

		return returnJsp;
	}

	@RequestMapping(value = "/gotoVocWriter.moJson")
	public String vocWriter(@ModelAttribute("boardVO") BoardVO boardVO,
			HttpServletRequest req, HttpServletResponse res, ModelMap model)
			throws Exception {
		String returnJsp = "/fis/board/vocWriter";

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

	@RequestMapping(value = "/gotoVocEditor.moJson")
	public String vocEditor(@ModelAttribute("boardVO") BoardVO boardVO,
			@ModelAttribute("commentVO") CommentVO commentVO,
			HttpServletRequest req, HttpServletResponse res, ModelMap model)
			throws Exception {
		String returnJsp = "/fis/board/vocEditor";
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
	public String vocInsert(@ModelAttribute("boardVO") BoardVO boardVO,
			@PathVariable int pageNo, HttpServletRequest req,
			HttpServletResponse res, ModelMap model) throws Exception {
		String returnJsp = "/fis/board/voc";
		req.setCharacterEncoding("UTF-8");

		vocService.insertVoc(boardVO);

		System.out.println(boardVO);
		initBoard(boardVO, model, 1);

		return returnJsp;
	}

	@RequestMapping(value = "/doUpdateContents.moJson")
	public String vocUpdate(@ModelAttribute("boardVO") BoardVO boardVO,
			HttpServletRequest req, HttpServletResponse res, ModelMap model)
			throws Exception {
		String returnJsp = "/fis/board/vocViewer";
		String num = boardVO.getNum();
		String pageNo = boardVO.getPageNo();
		CommentVO commentVO = new CommentVO();

		req.setCharacterEncoding("UTF-8");
		commentVO.setContents_num(num);
		vocService.updateVoc(boardVO);

		System.out.println("updater : " + boardVO);
		initViewer(boardVO, commentVO, num, req, model, pageNo);
		// initBoard(boardVO, model, pageNo, f_NORMAL);

		return returnJsp;
	}

	@RequestMapping(value = "/doDeleteContents.moJson")
	public String vocDelete(@ModelAttribute("boardVO") BoardVO boardVO,
			HttpServletRequest req, HttpServletResponse res, ModelMap model)
			throws Exception {
		String returnJsp = "/fis/board/voc";
		String num = boardVO.getNum();
		int pageNo = Integer.parseInt(boardVO.getPageNo());
		CommentVO commentVO = new CommentVO();
		req.setCharacterEncoding("UTF-8");

		commentVO.setContents_num(num);
		vocService.deleteCommentsBelongVoc(commentVO);
		vocService.deleteVoc(boardVO);

		System.out.println("editor : " + boardVO);
		initBoard(boardVO, model, pageNo);

		return returnJsp;
	}

	@RequestMapping(value = "/doDeleteComment.moJson")
	public String vocCommentDelete(
			@ModelAttribute("commentVO") CommentVO commentVO,
			@ModelAttribute("boardVO") BoardVO boardVO, HttpServletRequest req,
			HttpServletResponse res, ModelMap model) throws Exception {
		String returnJsp = null;

		boardVO.setNum(commentVO.getContents_num());
		List<BaseMap> list = vocService.getOneComment(commentVO);
		
		if (list.get(0).getValue(1).toString().equals(boardVO.getUser_name())) {
			returnJsp = "/fis/board/vocViewer";
			vocService.deleteComment(commentVO);
			initViewer(boardVO, commentVO, boardVO.getNum(), req, model,
					boardVO.getPageNo());

		} else {
			model.addAttribute("board_type",commentVO.getBoard_type());
			model.addAttribute("pageNo", boardVO.getPageNo());
			model.addAttribute("num", boardVO.getNum());
			model.addAttribute("user_name", boardVO.getUser_name());
			returnJsp = "/fis/board/commentDeleteWarning";
		}

		return returnJsp;
	}

	public void initViewer(BoardVO boardVO, CommentVO commentVO, String num,
			HttpServletRequest req, ModelMap model, String pageNo)
			throws Exception {
		boardVO.setNum(num);
		commentVO.setContents_num(num);
		System.out.println("contents viewer");
		List<BaseMap> list = vocService.showContents(boardVO);
		List<BaseMap> commentList = vocService.getComments(commentVO);
		System.out.println("list : " + list);
		System.out.println("CommentList : " + commentList);
		req.setCharacterEncoding("UTF-8");

		initBoard(boardVO, model, Integer.parseInt(pageNo));

		model.addAttribute("title", list.get(0).getValue(0));
		model.addAttribute("contents", list.get(0).getValue(1));
		req.setAttribute("contents", list.get(0).getValue(1));
		model.addAttribute("creator", list.get(0).getValue(2));
		if (list.get(0).getValue(3).toString().length() == 3) {
			model.addAttribute("secret_flag", list.get(0).getValue(3));
			model.addAttribute("date", list.get(0).getValue(4));
			boardVO.setSecret_flag(list.get(0).getValue(3).toString());
		} else
			model.addAttribute("date", list.get(0).getValue(3));
		model.addAttribute("pageNo", pageNo);
		model.addAttribute("num", num);
		model.addAttribute("commentList", commentList);
		model.addAttribute("commentSize", commentList.size());
		model.addAttribute("user_name", boardVO.getUser_name());

		boardVO.setCreator(list.get(0).getValue(2).toString());

		System.out.println("initViewer : " + model);
	}

	@RequestMapping(value = "/vocCommentWriter.moJson")
	public String vocCommentWriter(@ModelAttribute("boardVO") BoardVO boardVO,
			@ModelAttribute("commentVO") CommentVO commentVO,
			HttpServletRequest req, HttpServletResponse res, ModelMap model)
			throws Exception {
		String returnJsp = "/fis/board/vocViewer";
		String num = boardVO.getNum();
		String pageNo = boardVO.getPageNo();

		req.setCharacterEncoding("UTF-8");

		System.out.println("contents writer");
		commentVO.setContents_num(num);
		commentVO.setCreator(boardVO.getUser_name());
		vocService.insertComment(commentVO);
		System.out.println(commentVO);

		initViewer(boardVO, commentVO, num, req, model, pageNo);

		return returnJsp;
	}

	@RequestMapping("/showVocContents.moJson")
	public String showVocContents(@ModelAttribute("boardVO") BoardVO boardVO,
			@ModelAttribute("commentVO") CommentVO commentVO,
			HttpServletRequest req, HttpServletResponse res, ModelMap model)
			throws Exception {
		String returnJsp = null;
		String num = boardVO.getNum();
		String pageNo = boardVO.getPageNo();
		String user = boardVO.getUser_name();

		System.out.println("viewer : " + boardVO);
		System.out.println("viewer : " + commentVO);
		initViewer(boardVO, commentVO, num, req, model, pageNo);

		System.out.println("user : " + user);
		System.out.println("creator : " + boardVO.getCreator());
		System.out.println("flag : " + !(boardVO.getSecret_flag() == null));
		System.out.println("compare : " + !(user.equals(boardVO.getCreator())));

		if ((!(boardVO.getSecret_flag() == null))
				&& (!(user.equals(boardVO.getCreator()))))
			returnJsp = "/fis/board/vocSecretWarning";
		else
			returnJsp = "/fis/board/vocViewer";

		return returnJsp;
	}

}
