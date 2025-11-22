<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    String contextPath = request.getContextPath();
    boolean isEdit = request.getAttribute("product") != null;
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= isEdit ? "상품 수정" : "상품 추가" %> - Admin</title>
    <link rel="stylesheet" href="<%= contextPath %>/assets/css/common.css" />
    <link rel="stylesheet" href="<%= contextPath %>/assets/css/admin.css" />
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #F1F1F1;
            color: #2c2c2c;
        }

        .admin-container {
            max-width: 1000px;
            margin: 0 auto;
            padding: 20px;
        }

        .admin-header {
            background: white;
            padding: 24px 32px;
            border-radius: 20px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.12);
            margin-bottom: 32px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            border: 1px solid rgba(0,0,0,0.1);
        }

        .admin-header h1 {
            font-size: 2rem;
            font-weight: 900;
            background: linear-gradient(135deg, #000000 0%, #444444 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }

        .back-link {
            color: #2c2c2c;
            text-decoration: none;
            font-size: 14px;
            padding: 8px 16px;
            border: 1px solid #d0d0d0;
            border-radius: 8px;
            transition: all 0.3s ease;
            display: inline-block;
            background: linear-gradient(135deg, #ffffff 0%, #f8f8f8 100%);
            font-weight: 600;
        }

        .back-link:hover {
            background: linear-gradient(135deg, #2c2c2c 0%, #1a1a1a 100%);
            color: white;
            border-color: #2c2c2c;
        }

        .form-section {
            background: white;
            padding: 32px;
            border-radius: 20px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.12);
            border: 1px solid rgba(0,0,0,0.1);
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 700;
            color: #2c2c2c;
        }

        .form-group input,
        .form-group textarea,
        .form-group select {
            width: 100%;
            padding: 12px;
            border: 1px solid #d0d0d0;
            border-radius: 12px;
            font-size: 14px;
            transition: all 0.3s ease;
        }

        .form-group input:focus,
        .form-group textarea:focus,
        .form-group select:focus {
            outline: none;
            border-color: #2c2c2c;
            box-shadow: 0 0 0 3px rgba(44,44,44,0.1);
        }

        .form-group textarea {
            resize: vertical;
            min-height: 100px;
        }

        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
        }

        .form-actions {
            display: flex;
            gap: 10px;
            margin-top: 30px;
        }

        .btn {
            padding: 14px 28px;
            border: none;
            border-radius: 12px;
            font-size: 14px;
            font-weight: 700;
            cursor: pointer;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-block;
            text-align: center;
            letter-spacing: 0.3px;
        }

        .btn-primary {
            background: linear-gradient(135deg, #000000 0%, #333333 100%);
            color: white;
            box-shadow: 0 4px 12px rgba(0,0,0,0.3);
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(0,0,0,0.4);
        }

        .btn-secondary {
            background: linear-gradient(135deg, #6B6B6B 0%, #4A4A4A 100%);
            color: white;
            box-shadow: 0 4px 12px rgba(60,60,60,0.3);
        }

        .btn-secondary:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(60,60,60,0.4);
        }

        .required {
            color: #e74c3c;
            margin-left: 4px;
        }

        .help-text {
            font-size: 12px;
            color: #7f8c8d;
            margin-top: 5px;
        }

        .image-preview {
            width: 150px;
            height: 150px;
            border: 2px dashed #ddd;
            border-radius: 5px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-top: 10px;
            overflow: hidden;
        }

        .image-preview img {
            max-width: 100%;
            max-height: 100%;
            object-fit: cover;
        }

        .image-preview.empty {
            color: #95a5a6;
            font-size: 14px;
        }
    </style>
</head>
<body>
<div class="admin-container">
    <!-- Header -->
    <div class="admin-header">
        <h1><%= isEdit ? "상품 수정" : "상품 추가" %></h1>
        <a href="<%= contextPath %>/admin/products" class="back-link">← 목록으로</a>
    </div>

    <!-- Form -->
    <div class="form-section">
        <form action="<%= contextPath %>/admin/products" method="post" enctype="multipart/form-data">
            <input type="hidden" name="action" value="<%= isEdit ? "update" : "create" %>">
            <c:if test="${not empty product}">
                <input type="hidden" name="productId" value="${product.productId}">
            </c:if>

            <div class="form-group">
                <label for="productName">상품명<span class="required">*</span></label>
                <input type="text" id="productName" name="productName" 
                       value="${product.productName}" required>
            </div>

            <div class="form-group">
                <label for="description">상품 설명<span class="required">*</span></label>
                <textarea id="description" name="description" required>${product.description}</textarea>
                <div class="help-text">상품에 대한 자세한 설명을 입력하세요.</div>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label for="price">가격 (원)<span class="required">*</span></label>
                    <input type="number" id="price" name="price" 
                           value="${product.price}" min="0" required>
                </div>

                <div class="form-group">
                    <label for="stock">재고<span class="required">*</span></label>
                    <input type="number" id="stock" name="stock" 
                           value="${product.stock}" min="0" required>
                </div>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label for="category">카테고리<span class="required">*</span></label>
                    <select id="category" name="category" required>
                        <option value="">선택하세요</option>
                        <option value="전자제품" ${product.category == '전자제품' ? 'selected' : ''}>전자제품</option>
                        <option value="의류" ${product.category == '의류' ? 'selected' : ''}>의류</option>
                        <option value="식품" ${product.category == '식품' ? 'selected' : ''}>식품</option>
                        <option value="도서" ${product.category == '도서' ? 'selected' : ''}>도서</option>
                        <option value="생활용품" ${product.category == '생활용품' ? 'selected' : ''}>생활용품</option>
                        <option value="스포츠" ${product.category == '스포츠' ? 'selected' : ''}>스포츠</option>
                        <option value="뷰티" ${product.category == '뷰티' ? 'selected' : ''}>뷰티</option>
                        <option value="기타" ${product.category == '기타' ? 'selected' : ''}>기타</option>
                    </select>
                </div>

                <div class="form-group">
                    <label for="status">상태<span class="required">*</span></label>
                    <select id="status" name="status" required>
                        <option value="활성" ${product.status == '활성' ? 'selected' : ''}>활성</option>
                        <option value="비활성" ${product.status == '비활성' ? 'selected' : ''}>비활성</option>
                    </select>
                </div>
            </div>

            <div class="form-group">
                <label for="productImage">상품 이미지 업로드</label>
                <input type="file" id="productImage" name="productImage" 
                       accept="image/*" onchange="previewImage(this)">
                <div class="help-text">JPG, PNG, GIF 형식의 이미지 파일을 선택하세요. (최대 10MB, 선택사항)</div>
                
                <c:if test="${not empty product.filePath}">
                    <div class="image-preview" id="imagePreview">
                        <img src="${product.filePath}" alt="상품 이미지">
                    </div>
                </c:if>
                <c:if test="${empty product.filePath}">
                    <div class="image-preview empty" id="imagePreview">
                        이미지 미리보기
                    </div>
                </c:if>
            </div>
            
            <div class="form-group">
                <label for="filePath">또는 이미지 URL 입력</label>
                <input type="text" id="filePath" name="filePath" 
                       value="${product.filePath}" 
                       placeholder="http://example.com/image.jpg"
                       onchange="updateImagePreview(this.value)">
                <div class="help-text">외부 이미지 URL을 입력하거나 위에서 파일을 업로드하세요.</div>
            </div>

            <div class="form-actions">
                <button type="submit" class="btn btn-primary">
                    <%= isEdit ? "수정하기" : "등록하기" %>
                </button>
                <a href="<%= contextPath %>/admin/products" class="btn btn-secondary">취소</a>
            </div>
        </form>
    </div>
</div>

<script>
    // 파일 선택 시 미리보기
    function previewImage(input) {
        const preview = document.getElementById('imagePreview');
        
        if (input.files && input.files[0]) {
            const reader = new FileReader();
            
            reader.onload = function(e) {
                preview.classList.remove('empty');
                preview.innerHTML = '<img src="' + e.target.result + '" alt="상품 이미지">';
            };
            
            reader.readAsDataURL(input.files[0]);
        } else {
            preview.classList.add('empty');
            preview.innerHTML = '이미지 미리보기';
        }
    }
    
    // 이미지 URL 입력 시 미리보기 업데이트
    function updateImagePreview(imageUrl) {
        const preview = document.getElementById('imagePreview');
        
        if (imageUrl.trim()) {
            preview.classList.remove('empty');
            preview.innerHTML = '<img src="' + imageUrl + '" alt="상품 이미지" onerror="this.parentElement.classList.add(\'empty\'); this.parentElement.innerHTML=\'이미지를 불러올 수 없습니다\';">';
        } else {
            preview.classList.add('empty');
            preview.innerHTML = '이미지 미리보기';
        }
    }

    // 폼 제출 전 유효성 검사
    document.querySelector('form').addEventListener('submit', function(e) {
        const price = parseInt(document.getElementById('price').value);
        const stock = parseInt(document.getElementById('stock').value);

        if (price < 0) {
            alert('가격은 0원 이상이어야 합니다.');
            e.preventDefault();
            return false;
        }

        if (stock < 0) {
            alert('재고는 0개 이상이어야 합니다.');
            e.preventDefault();
            return false;
        }
    });
</script>
</body>
</html>
