package com.controller;

import com.dao.BoardDAO;
import com.dao.BoardAttachmentDAO;
import com.model.Board;
import com.model.BoardAttachment;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.File;
import java.io.IOException;
import java.net.URLEncoder;
import java.util.UUID;

@WebServlet("/board/write")
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, // 2MB
        maxFileSize = 1024 * 1024 * 10, // 10MB
        maxRequestSize = 1024 * 1024 * 50 // 50MB
)
public class BoardWriteController extends HttpServlet {

    private BoardDAO boardDAO;
    private BoardAttachmentDAO attachmentDAO;
    private static final String UPLOAD_DIR = "uploads/board";

    @Override
    public void init() throws ServletException {
        super.init();
        this.boardDAO = new BoardDAO();
        this.attachmentDAO = new BoardAttachmentDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login");
            return;
        }

        request.getRequestDispatcher("/WEB-INF/views/board/write.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login");
            return;
        }

        try {
            Integer userId = (Integer) session.getAttribute("userId");
            String title = request.getParameter("title");
            String content = request.getParameter("content");

            if (title == null || title.trim().isEmpty() ||
                    content == null || content.trim().isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/board/write?error=" +
                        URLEncoder.encode("제목과 내용을 입력해주세요.", "UTF-8"));
                return;
            }

            Board board = new Board();
            board.setUserId(userId);
            board.setTitle(title.trim());
            board.setContent(content.trim());

            boolean success = boardDAO.createPost(board);

            if (success) {
                // 첨부파일 처리
                handleFileUploads(request, board.getBoardId());

                response.sendRedirect(request.getContextPath() + "/board/list");
            } else {
                throw new Exception("게시글 작성 실패");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/board/write?error=" +
                    URLEncoder.encode("게시글 작성 중 오류가 발생했습니다.", "UTF-8"));
        }
    }

    /**
     * 파일 업로드 처리
     */
    private void handleFileUploads(HttpServletRequest request, int boardId) throws Exception {
        // 업로드 디렉토리 생성
        String uploadPath = getServletContext().getRealPath("") + File.separator + UPLOAD_DIR;
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }

        // 모든 파트 중 파일만 처리
        for (Part part : request.getParts()) {
            String fileName = getFileName(part);
            if (fileName != null && !fileName.isEmpty()) {
                // 파일 저장
                String storedFileName = UUID.randomUUID().toString() + "_" + fileName;
                String filePath = uploadPath + File.separator + storedFileName;

                part.write(filePath);

                // DB에 저장
                BoardAttachment attachment = new BoardAttachment();
                attachment.setBoardId(boardId);
                attachment.setOriginalFilename(fileName);
                attachment.setStoredFilename(storedFileName);
                attachment.setFilePath(UPLOAD_DIR + "/" + storedFileName);
                attachment.setFileSize(part.getSize());
                attachment.setFileType(part.getContentType());

                attachmentDAO.insertAttachment(attachment);
            }
        }
    }

    /**
     * Part에서 파일명 추출
     */
    private String getFileName(Part part) {
        String contentDisposition = part.getHeader("content-disposition");
        String[] tokens = contentDisposition.split(";");
        for (String token : tokens) {
            if (token.trim().startsWith("filename")) {
                return token.substring(token.indexOf("=") + 2, token.length() - 1);
            }
        }
        return null;
    }
}
