package com.fis.board.voc.dao;

import ibsheet.BaseMap;

import java.util.List;

import com.vo.BoardVO;
import com.vo.CommentVO;

public interface VocDAO {

	void insertVoc(BoardVO boardVO) throws Exception;

	void updateVoc(BoardVO boardVO) throws Exception;

	void deleteVoc(BoardVO boardVO) throws Exception;

	void deleteCommentsBelongVoc(CommentVO commentVO) throws Exception;

	public List<BaseMap> getOneComment(CommentVO commentVO) throws Exception;

	void deleteComment(CommentVO commentVO) throws Exception;

	void insertComment(CommentVO commentVO) throws Exception;

	public List<BaseMap> getComments(CommentVO commentVO) throws Exception;

	List<BaseMap> showList(BoardVO boardVO) throws Exception;

	List<BaseMap> searchList(BoardVO boardVO) throws Exception;

	public List<BaseMap> showContents(BoardVO boardVO) throws Exception;
}
