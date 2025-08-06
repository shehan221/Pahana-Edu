package com.bookstore.model;

public class Item {
    
    private int itemId;
    private String itemCode;
    private String title;
    private String author;
    private String category;
    private double price;
    private int quantity;
    private String description;
    private String publisher;
    private String isbn;
    private boolean isActive;
    
    // Default constructor
    public Item() {
    }
    
    // Constructor with essential parameters
    public Item(String itemCode, String title, String author, String category, double price, int quantity) {
        this.itemCode = itemCode;
        this.title = title;
        this.author = author;
        this.category = category;
        this.price = price;
        this.quantity = quantity;
        this.isActive = true;
    }
    
    // Constructor with all parameters
    public Item(int itemId, String itemCode, String title, String author, String category, 
               double price, int quantity, String description, String publisher, String isbn, boolean isActive) {
        this.itemId = itemId;
        this.itemCode = itemCode;
        this.title = title;
        this.author = author;
        this.category = category;
        this.price = price;
        this.quantity = quantity;
        this.description = description;
        this.publisher = publisher;
        this.isbn = isbn;
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
    
    public double getPrice() {
        return price;
    }
    
    public void setPrice(double price) {
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
    
    public String getIsbn() {
        return isbn;
    }
    
    public void setIsbn(String isbn) {
        this.isbn = isbn;
    }
    
    public boolean isActive() {
        return isActive;
    }
    
    public void setActive(boolean isActive) {
        this.isActive = isActive;
    }
    
    // Business methods
    public boolean isInStock() {
        return quantity > 0;
    }
    
    public void reduceQuantity(int amount) {
        if (quantity >= amount) {
            this.quantity -= amount;
        }
    }
    
    public void addQuantity(int amount) {
        this.quantity += amount;
    }
    
    public double getTotalValue() {
        return price * quantity;
    }
    
    // toString method for debugging
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
                ", isbn='" + isbn + '\'' +
                ", isActive=" + isActive +
                '}';
    }
    
    // equals method for comparison
    @Override
    public boolean equals(Object obj) {
        if (this == obj) return true;
        if (obj == null || getClass() != obj.getClass()) return false;
        Item item = (Item) obj;
        return itemId == item.itemId;
    }
    
    // hashCode method
    @Override
    public int hashCode() {
        return Integer.hashCode(itemId);
    }
}