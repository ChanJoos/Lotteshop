package com.fis.board.voc.service;

import ibsheet.BaseMap;

import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.fis.board.voc.dao.VocDAO;
import com.vo.BoardVO;
import com.vo.CommentVO;

/**
 * @Class Name : BusiOppService.java
 * @Description :
 * @Modification Information @ @ 수정일 수정자 수정내용 @ --------- ---------
 *               ------------------------------- @ 2013. 8. 14. ms.kang 최초생성
 * 
 * @author ms.kang
 * @since
 * @version 1.0
 * @see
 */
@Service("com.fis.borad.notice.service.VocService")
public class VocService {

	Logger log = LoggerFactory.getLogger(VocService.class);

	@Autowired
	private VocDAO vocDAO;

	public void insertVoc(BoardVO boardVO) throws Exception {
		vocDAO.insertVoc(boardVO);
	}

	public void updateVoc(BoardVO boardVO) throws Exception {
		vocDAO.updateVoc(boardVO);
	}

	public void deleteVoc(BoardVO boardVO) throws Exception {
		vocDAO.deleteVoc(boardVO);
	}

	public void deleteCommentsBelongVoc(CommentVO commentVO) throws Exception {
		vocDAO.deleteCommentsBelongVoc(commentVO);
	}

	public List<BaseMap> getOneComment(CommentVO commentVO) throws Exception {
		List<BaseMap> list = vocDAO.getOneComment(commentVO);
		return list;
	}

	public void deleteComment(CommentVO commentVO) throws Exception {
		vocDAO.deleteComment(commentVO);
	}

	public void insertComment(CommentVO commentVO) throws Exception {
		vocDAO.insertComment(commentVO);
	}

	public List<BaseMap> getComments(CommentVO commentVO) throws Exception {
		List<BaseMap> list = vocDAO.getComments(commentVO);
		return list;
	}

	public List<BaseMap> showList(BoardVO boardVO) throws Exception {
		List<BaseMap> list = vocDAO.showList(boardVO);
		return list;
	}

	public List<BaseMap> searchList(BoardVO boardVO) throws Exception {
		List<BaseMap> list = vocDAO.searchList(boardVO);
		return list;
	}

	public List<BaseMap> showContents(BoardVO boardVO) throws Exception {
		List<BaseMap> list = vocDAO.showContents(boardVO);
		return list;
	}
}
