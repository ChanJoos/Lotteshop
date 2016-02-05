package com.fis.board.notice.service;

import ibsheet.BaseMap;

import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.fis.board.notice.dao.NoticeDAO;
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
@Service("com.fis.borad.notice.service.NoticeService")
public class NoticeService {

	Logger log = LoggerFactory.getLogger(NoticeService.class);

	@Autowired
	private NoticeDAO noticeDAO;

	public void insertNotice(BoardVO boardVO) throws Exception {
		noticeDAO.insertNotice(boardVO);
	}

	public void updateNotice(BoardVO boardVO) throws Exception {
		noticeDAO.updateNotice(boardVO);
	}

	public void deleteNotice(BoardVO boardVO) throws Exception {
		noticeDAO.deleteNotice(boardVO);
	}

	public void deleteCommentsBelongNotice(CommentVO commentVO)
			throws Exception {
		noticeDAO.deleteCommentsBelongNotice(commentVO);
	}

	public void deleteComment(CommentVO commentVO) throws Exception {
		noticeDAO.deleteComment(commentVO);
	}

	public List<BaseMap> getOneComment(CommentVO commentVO) throws Exception {
		List<BaseMap> list = noticeDAO.getOneComment(commentVO);
		return list;
	}

	public void insertComment(CommentVO commentVO) throws Exception {
		noticeDAO.insertComment(commentVO);
	}

	public List<BaseMap> getComments(CommentVO commentVO) throws Exception {
		List<BaseMap> list = noticeDAO.getComments(commentVO);
		return list;
	}

	public List<BaseMap> showList(BoardVO boardVO) throws Exception {
		List<BaseMap> list = noticeDAO.showList(boardVO);
		return list;
	}

	public List<BaseMap> searchList(BoardVO boardVO) throws Exception {
		List<BaseMap> list = noticeDAO.searchList(boardVO);
		return list;
	}

	public List<BaseMap> showContents(BoardVO boardVO) throws Exception {
		List<BaseMap> list = noticeDAO.showContents(boardVO);
		return list;
	}
}
