<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%> <% String
username = (String) session.getAttribute("username"); %>
<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>글쓰기 - Security Crawling</title>
    <link
      rel="stylesheet"
      href="${pageContext.request.contextPath}/assets/css/common.css"
    />
    <link
      rel="stylesheet"
      href="${pageContext.request.contextPath}/assets/css/board.css"
    />
  </head>
  <body>
    <div class="container">
      <div class="nav-links">
        <a href="<%= request.getContextPath() %>/index"> 홈</a>
        <a href="<%= request.getContextPath() %>/board/list"> 게시판</a>
      </div>

      <div class="header">
        <h1>글쓰기</h1>
      </div>

      <div class="info">작성자: <strong><%= username %></strong></div>

      <form
        action="<%= request.getContextPath() %>/board/write"
        method="post"
        enctype="multipart/form-data"
        onsubmit="return validateForm()"
      >
        <div class="form-group">
          <label>제목 <span style="color: red">*</span></label>
          <input
            type="text"
            name="title"
            id="title"
            placeholder="제목을 입력하세요"
            required
          />
        </div>

        <div class="form-group">
          <label>내용 <span style="color: red">*</span></label>
          <textarea
            name="content"
            id="content"
            placeholder="내용을 입력하세요"
            required
          ></textarea>
        </div>

        <div class="form-group">
          <label>첨부파일</label>
          <input
            type="file"
            name="attachments"
            id="attachments"
            multiple
            accept="*/*"
            onchange="updateFileList()"
          />
          <small style="color: #666; display: block; margin-top: 8px">
            최대 10MB, 여러 파일 선택 가능
          </small>
          <div id="file-list" style="margin-top: 12px"></div>
        </div>

        <div class="button-group">
          <button type="submit" class="btn btn-primary">작성완료</button>
          <a
            href="<%= request.getContextPath() %>/board/list"
            class="btn btn-secondary"
            >취소</a
          >
        </div>
      </form>
    </div>

    <script>
      function validateForm() {
        const title = document.getElementById("title").value.trim();
        const content = document.getElementById("content").value.trim();

        if (title.length < 2) {
          alert("제목은 2자 이상 입력해주세요.");
          return false;
        }

        if (content.length < 5) {
          alert("내용은 5자 이상 입력해주세요.");
          return false;
        }

        // 파일 크기 체크 (10MB)
        const fileInput = document.getElementById("attachments");
        if (fileInput.files.length > 0) {
          for (let i = 0; i < fileInput.files.length; i++) {
            if (fileInput.files[i].size > 10 * 1024 * 1024) {
              alert(
                "파일 크기는 10MB를 초과할 수 없습니다: " +
                  fileInput.files[i].name
              );
              return false;
            }
          }
        }

        return true;
      }

      function updateFileList() {
        const fileInput = document.getElementById("attachments");
        const fileList = document.getElementById("file-list");
        fileList.innerHTML = "";

        if (fileInput.files.length > 0) {
          const list = document.createElement("ul");
          list.style.cssText =
            "margin: 0; padding-left: 20px; list-style: disc;";

          for (let i = 0; i < fileInput.files.length; i++) {
            const file = fileInput.files[i];
            const li = document.createElement("li");
            li.style.cssText = "margin: 4px 0; color: #333;";

            const size =
              file.size < 1024
                ? file.size + " B"
                : file.size < 1024 * 1024
                ? (file.size / 1024).toFixed(1) + " KB"
                : (file.size / (1024 * 1024)).toFixed(1) + " MB";

            li.textContent = file.name + " (" + size + ")";
            list.appendChild(li);
          }

          fileList.appendChild(list);
        }
      }
    </script>
  </body>
</html>
