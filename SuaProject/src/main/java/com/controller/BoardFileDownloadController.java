package com.controller;

import com.dao.BoardAttachmentDAO;
import com.model.BoardAttachment;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.net.URLEncoder;

@WebServlet("/board/download")
public class BoardFileDownloadController extends HttpServlet {

    private BoardAttachmentDAO attachmentDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        this.attachmentDAO = new BoardAttachmentDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            String attachmentIdParam = request.getParameter("id");
            if (attachmentIdParam == null || attachmentIdParam.isEmpty()) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "첨부파일 ID가 필요합니다.");
                return;
            }

            int attachmentId = Integer.parseInt(attachmentIdParam);
            BoardAttachment attachment = attachmentDAO.getAttachmentById(attachmentId);

            if (attachment == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "첨부파일을 찾을 수 없습니다.");
                return;
            }

            // 파일 경로
            String filePath = getServletContext().getRealPath("") + File.separator + attachment.getFilePath();
            File file = new File(filePath);

            if (!file.exists()) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "파일이 존재하지 않습니다.");
                return;
            }

            // 다운로드 횟수 증가
            attachmentDAO.incrementDownloadCount(attachmentId);

            // 파일 다운로드 응답 설정
            response.setContentType("application/octet-stream");
            response.setContentLength((int) file.length());

            // 파일명 인코딩 (한글 파일명 지원)
            String encodedFileName = URLEncoder.encode(attachment.getOriginalFilename(), "UTF-8")
                    .replaceAll("\\+", "%20");
            response.setHeader("Content-Disposition",
                    "attachment; filename=\"" + encodedFileName + "\"; filename*=UTF-8''" + encodedFileName);

            // 파일 전송
            try (FileInputStream fis = new FileInputStream(file);
                    OutputStream os = response.getOutputStream()) {

                byte[] buffer = new byte[4096];
                int bytesRead;
                while ((bytesRead = fis.read(buffer)) != -1) {
                    os.write(buffer, 0, bytesRead);
                }
                os.flush();
            }

        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "잘못된 첨부파일 ID입니다.");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "파일 다운로드 중 오류가 발생했습니다.");
        }
    }
}
