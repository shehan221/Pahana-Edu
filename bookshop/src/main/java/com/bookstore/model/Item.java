package com.bookstore.model;

import java.io.Serializable;
import java.math.BigDecimal;

public class Item implements Serializable {
    private static final long serialVersionUID = 1L;
    
    private int itemId;
    private String itemCode;
    private String title;
    private String author;
    private String category;
    private BigDecimal price;
    private int quantity;
    private String description;
    private String publisher;
    private String imageUrl;
    private boolean isActive;
    
    // Default constructor
    public Item() {}
    
    // Constructor with all fields
    public Item(int itemId, String itemCode, String title, String author, String category,
                BigDecimal price, int quantity, String description, String publisher,
                String imageUrl, boolean isActive) {
        this.itemId = itemId;
        this.itemCode = itemCode;
        this.title = title;
        this.author = author;
        this.category = category;
        this.price = price;
        this.quantity = quantity;
        this.description = description;
        this.publisher = publisher;
        this.imageUrl = imageUrl;
        this.isActive = isActive;
    }
    
    // Constructor without itemId (for new items)
    public Item(String itemCode, String title, String author, String category,
                BigDecimal price, int quantity, String description, String publisher,
                String imageUrl, boolean isActive) {
        this.itemCode = itemCode;
        this.title = title;
        this.author = author;
        this.category = category;
        this.price = price;
        this.quantity = quantity;
        this.description = description;
        this.publisher = publisher;
        this.imageUrl = imageUrl;
        this.isActive = isActive;
    }
    
    // Getters and Setters
    public int getItemId() {
        return itemId;
    }
    
    public void setItemId(int itemId) {
        this.itemId = itemId;
    }
    
    public String getItemCode() {
        return itemCode;
    }
    
    public void setItemCode(String itemCode) {
        this.itemCode = itemCode;
    }
    
    public String getTitle() {
        return title;
    }
    
    public void setTitle(String title) {
        this.title = title;
    }
    
    public String getAuthor() {
        return author;
    }
    
    public void setAuthor(String author) {
        this.author = author;
    }
    
    public String getCategory() {
        return category;
    }
    
    public void setCategory(String category) {
        this.category = category;
    }
    
    public BigDecimal getPrice() {
        return price;
    }
    
    public void setPrice(BigDecimal price) {
        this.price = price;
    }
    
    public int getQuantity() {
        return quantity;
    }
    
    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }
    
    public String getDescription() {
        return description;
    }
    
    public void setDescription(String description) {
        this.description = description;
    }
    
    public String getPublisher() {
        return publisher;
    }
    
    public void setPublisher(String publisher) {
        this.publisher = publisher;
    }
    
    public String getImageUrl() {
        return imageUrl;
    }
    
    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }
    
    public boolean isActive() {
        return isActive;
    }
    
    public void setActive(boolean isActive) {
        this.isActive = isActive;
    }
    
    @Override
    public String toString() {
        return "Item{" +
                "itemId=" + itemId +
                ", itemCode='" + itemCode + '\'' +
                ", title='" + title + '\'' +
                ", author='" + author + '\'' +
                ", category='" + category + '\'' +
                ", price=" + price +
                ", quantity=" + quantity +
                ", description='" + description + '\'' +
                ", publisher='" + publisher + '\'' +
                ", imageUrl='" + imageUrl + '\'' +
                ", isActive=" + isActive +
                '}';
    }
}