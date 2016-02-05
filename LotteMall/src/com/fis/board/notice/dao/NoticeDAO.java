package com.fis.board.notice.dao;

import ibsheet.BaseMap;

import java.util.List;

import com.vo.BoardVO;
import com.vo.CommentVO;

public interface NoticeDAO {

	void insertNotice(BoardVO boardVO) throws Exception;

	void updateNotice(BoardVO boardVO) throws Exception;

	void deleteNotice(BoardVO boardVO) throws Exception;

	void deleteCommentsBelongNotice(CommentVO commentVO) throws Exception;

	void deleteComment(CommentVO commentVO) throws Exception;

	public List<BaseMap> getOneComment(CommentVO commentVO) throws Exception;

	void insertComment(CommentVO commentVO) throws Exception;

	public List<BaseMap> getComments(CommentVO commentVO) throws Exception;

	List<BaseMap> showList(BoardVO boardVO) throws Exception;

	List<BaseMap> searchList(BoardVO boardVO) throws Exception;

	public List<BaseMap> showContents(BoardVO boardVO) throws Exception;
}
