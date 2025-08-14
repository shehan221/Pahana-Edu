
    function openEditModal(id, code, title, author, category, price, quantity, publisher, image_url, description) {
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
        document.getElementById('editModal').style.display = 'none';
    }

    window.onclick = function(event) {
        var modal = document.getElementById('editModal');
        if (event.target == modal) {
            closeEditModal();
        }
    }