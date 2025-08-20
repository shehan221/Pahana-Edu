
function validateForm() {
    clearErrors();
    let isValid = true;
    
    // Item Code validation
    const itemCode = document.getElementById('item_code').value.trim();
    if (!itemCode) {
        showError('item_code_error', 'Item Code is required');
        document.getElementById('item_code').classList.add('invalid-field');
        isValid = false;
    } else if (itemCode.length > 20) {
        showError('item_code_error', 'Item Code must be 20 characters or less');
        document.getElementById('item_code').classList.add('invalid-field');
        isValid = false;
    }
    
    // Title validation
    const title = document.getElementById('title').value.trim();
    if (!title) {
        showError('title_error', 'Title is required');
        document.getElementById('title').classList.add('invalid-field');
        isValid = false;
    } else if (title.length > 255) {
        showError('title_error', 'Title must be 255 characters or less');
        document.getElementById('title').classList.add('invalid-field');
        isValid = false;
    }
    
    // Price validation
    const price = document.getElementById('price').value;
    if (!price || isNaN(price) || parseFloat(price) < 0) {
        showError('price_error', 'Price must be a valid positive number');
        document.getElementById('price').classList.add('invalid-field');
        isValid = false;
    }
    
    // Quantity validation
    const quantity = document.getElementById('quantity').value;
    if (quantity && (isNaN(quantity) || parseInt(quantity) < 0)) {
        showError('quantity_error', 'Quantity must be a non-negative integer');
        document.getElementById('quantity').classList.add('invalid-field');
        isValid = false;
    }
    
    // Image URL validation
    const imageUrl = document.getElementById('image_url').value.trim();
    if (imageUrl && !isValidImageUrl(imageUrl)) {
        showError('image_url_error', 'Please enter a valid image URL (jpg, jpeg, png, gif, webp, bmp)');
        document.getElementById('image_url').classList.add('invalid-field');
        isValid = false;
    }
    
    return isValid;
}

function validateEditForm() {
    clearEditErrors();
    let isValid = true;
    
    // Item Code validation
    const itemCode = document.getElementById('edit_item_code').value.trim();
    if (!itemCode) {
        showError('edit_item_code_error', 'Item Code is required');
        document.getElementById('edit_item_code').classList.add('invalid-field');
        isValid = false;
    } else if (itemCode.length > 20) {
        showError('edit_item_code_error', 'Item Code must be 20 characters or less');
        document.getElementById('edit_item_code').classList.add('invalid-field');
        isValid = false;
    }
    
    // Title validation
    const title = document.getElementById('edit_title').value.trim();
    if (!title) {
        showError('edit_title_error', 'Title is required');
        document.getElementById('edit_title').classList.add('invalid-field');
        isValid = false;
    } else if (title.length > 255) {
        showError('edit_title_error', 'Title must be 255 characters or less');
        document.getElementById('edit_title').classList.add('invalid-field');
        isValid = false;
    }
    
    // Price validation
    const price = document.getElementById('edit_price').value;
    if (!price || isNaN(price) || parseFloat(price) < 0) {
        showError('edit_price_error', 'Price must be a valid positive number');
        document.getElementById('edit_price').classList.add('invalid-field');
        isValid = false;
    }
    
    // Quantity validation
    const quantity = document.getElementById('edit_quantity').value;
    if (quantity && (isNaN(quantity) || parseInt(quantity) < 0)) {
        showError('edit_quantity_error', 'Quantity must be a non-negative integer');
        document.getElementById('edit_quantity').classList.add('invalid-field');
        isValid = false;
    }
    
    // Image URL validation for edit form
    const imageUrl = document.getElementById('edit_image_url').value.trim();
    if (imageUrl && !isValidImageUrl(imageUrl)) {
        showError('edit_image_url_error', 'Please enter a valid image URL (jpg, jpeg, png, gif, webp, bmp)');
        document.getElementById('edit_image_url').classList.add('invalid-field');
        isValid = false;
    }
    
    return isValid;
}

function showError(elementId, message) {
    document.getElementById(elementId).textContent = message;
}

function isValidImageUrl(url) {
    const imageExtensions = /\.(jpg|jpeg|png|gif|webp|bmp)(\?.*)?$/i;
    const httpPattern = /^https?:\/\//i;
    const pathPattern = /^\/[^\/]/;
    
    if (httpPattern.test(url)) {
        return imageExtensions.test(url);
    } else if (pathPattern.test(url)) {
        return imageExtensions.test(url);
    }
    return false;
}

function clearErrors() {
    const fields = ['item_code', 'title', 'author', 'category', 'price', 'quantity', 'publisher', 'image_url', 'description'];
    fields.forEach(field => {
        document.getElementById(field).classList.remove('invalid-field');
        document.getElementById(field + '_error').textContent = '';
    });
}

function clearEditErrors() {
    const fields = ['edit_item_code', 'edit_title', 'edit_author', 'edit_category', 'edit_price', 'edit_quantity', 'edit_publisher', 'edit_image_url', 'edit_description'];
    fields.forEach(field => {
        document.getElementById(field).classList.remove('invalid-field');
        document.getElementById(field + '_error').textContent = '';
    });
}

function openEditModal(id, code, title, author, category, price, quantity, publisher, image_url, description) {
    clearEditErrors();
    document.getElementById('edit_id').value = id;
    document.getElementById('edit_item_code').value = code;
    document.getElementById('edit_title').value = title;
    document.getElementById('edit_author').value = author;
    document.getElementById('edit_category').value = category;
    document.getElementById('edit_price').value = price;
    document.getElementById('edit_quantity').value = quantity;
    document.getElementById('edit_publisher').value = publisher;
    document.getElementById('edit_image_url').value = image_url;
    document.getElementById('edit_description').value = description;
    document.getElementById('editModal').style.display = 'block';
}

function closeEditModal() {
    clearEditErrors();
    document.getElementById('editModal').style.display = 'none';
}

window.onclick = function(event) {
    var modal = document.getElementById('editModal');
    if (event.target == modal) {
        closeEditModal();
    }
}

// Real-time validation for better user experience
document.addEventListener('DOMContentLoaded', function() {
    // Add form real-time validation
    document.getElementById('item_code').addEventListener('input', function() {
        this.classList.remove('invalid-field');
        document.getElementById('item_code_error').textContent = '';
    });
    
    document.getElementById('title').addEventListener('input', function() {
        this.classList.remove('invalid-field');
        document.getElementById('title_error').textContent = '';
    });
    
    document.getElementById('price').addEventListener('input', function() {
        this.classList.remove('invalid-field');
        document.getElementById('price_error').textContent = '';
    });
    
    document.getElementById('quantity').addEventListener('input', function() {
        this.classList.remove('invalid-field');
        document.getElementById('quantity_error').textContent = '';
    });
    
    // Edit form real-time validation
    document.getElementById('edit_item_code').addEventListener('input', function() {
        this.classList.remove('invalid-field');
        document.getElementById('edit_item_code_error').textContent = '';
    });
    
    document.getElementById('edit_title').addEventListener('input', function() {
        this.classList.remove('invalid-field');
        document.getElementById('edit_title_error').textContent = '';
    });
    
    document.getElementById('edit_price').addEventListener('input', function() {
        this.classList.remove('invalid-field');
        document.getElementById('edit_price_error').textContent = '';
    });
    
    document.getElementById('edit_quantity').addEventListener('input', function() {
        this.classList.remove('invalid-field');
        document.getElementById('edit_quantity_error').textContent = '';
    });
    
    // Image URL real-time validation
    document.getElementById('image_url').addEventListener('input', function() {
        this.classList.remove('invalid-field');
        document.getElementById('image_url_error').textContent = '';
    });
    
    document.getElementById('edit_image_url').addEventListener('input', function() {
        this.classList.remove('invalid-field');
        document.getElementById('edit_image_url_error').textContent = '';
    });
});