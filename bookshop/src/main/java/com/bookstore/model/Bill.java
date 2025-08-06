package com.bookstore.model;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class Bill {
    
    private int billId;
    private String billNumber;
    private int customerId;
    private String customerName;
    private String customerAddress;
    private String customerPhone;
    private LocalDateTime billDate;
    private double subtotal;
    private double taxAmount;
    private double discount;
    private double totalAmount;
    private String paymentMethod;
    private String status;
    private List<BillItem> billItems;
    
    // Inner class for bill items
    public static class BillItem {
        private int itemId;
        private String itemCode;
        private String itemTitle;
        private String author;
        private double unitPrice;
        private int quantity;
        private double totalPrice;
        
        // Constructor
        public BillItem(int itemId, String itemCode, String itemTitle, String author, 
                       double unitPrice, int quantity) {
            this.itemId = itemId;
            this.itemCode = itemCode;
            this.itemTitle = itemTitle;
            this.author = author;
            this.unitPrice = unitPrice;
            this.quantity = quantity;
            this.totalPrice = unitPrice * quantity;
        }
        
        // Getters and Setters
        public int getItemId() { return itemId; }
        public void setItemId(int itemId) { this.itemId = itemId; }
        
        public String getItemCode() { return itemCode; }
        public void setItemCode(String itemCode) { this.itemCode = itemCode; }
        
        public String getItemTitle() { return itemTitle; }
        public void setItemTitle(String itemTitle) { this.itemTitle = itemTitle; }
        
        public String getAuthor() { return author; }
        public void setAuthor(String author) { this.author = author; }
        
        public double getUnitPrice() { return unitPrice; }
        public void setUnitPrice(double unitPrice) { 
            this.unitPrice = unitPrice;
            this.totalPrice = unitPrice * quantity;
        }
        
        public int getQuantity() { return quantity; }
        public void setQuantity(int quantity) { 
            this.quantity = quantity;
            this.totalPrice = unitPrice * quantity;
        }
        
        public double getTotalPrice() { return totalPrice; }
        public void setTotalPrice(double totalPrice) { this.totalPrice = totalPrice; }
    }
    
    // Default constructor
    public Bill() {
        this.billItems = new ArrayList<>();
        this.billDate = LocalDateTime.now();
        this.status = "PENDING";
    }
    
    // Constructor with customer info
    public Bill(int customerId, String customerName, String customerAddress, String customerPhone) {
        this();
        this.customerId = customerId;
        this.customerName = customerName;
        this.customerAddress = customerAddress;
        this.customerPhone = customerPhone;
        this.generateBillNumber();
    }
    
    // Getters and Setters
    public int getBillId() {
        return billId;
    }
    
    public void setBillId(int billId) {
        this.billId = billId;
    }
    
    public String getBillNumber() {
        return billNumber;
    }
    
    public void setBillNumber(String billNumber) {
        this.billNumber = billNumber;
    }
    
    public int getCustomerId() {
        return customerId;
    }
    
    public void setCustomerId(int customerId) {
        this.customerId = customerId;
    }
    
    public String getCustomerName() {
        return customerName;
    }
    
    public void setCustomerName(String customerName) {
        this.customerName = customerName;
    }
    
    public String getCustomerAddress() {
        return customerAddress;
    }
    
    public void setCustomerAddress(String customerAddress) {
        this.customerAddress = customerAddress;
    }
    
    public String getCustomerPhone() {
        return customerPhone;
    }
    
    public void setCustomerPhone(String customerPhone) {
        this.customerPhone = customerPhone;
    }
    
    public LocalDateTime getBillDate() {
        return billDate;
    }
    
    public void setBillDate(LocalDateTime billDate) {
        this.billDate = billDate;
    }
    
    public double getSubtotal() {
        return subtotal;
    }
    
    public void setSubtotal(double subtotal) {
        this.subtotal = subtotal;
    }
    
    public double getTaxAmount() {
        return taxAmount;
    }
    
    public void setTaxAmount(double taxAmount) {
        this.taxAmount = taxAmount;
    }
    
    public double getDiscount() {
        return discount;
    }
    
    public void setDiscount(double discount) {
        this.discount = discount;
    }
    
    public double getTotalAmount() {
        return totalAmount;
    }
    
    public void setTotalAmount(double totalAmount) {
        this.totalAmount = totalAmount;
    }
    
    public String getPaymentMethod() {
        return paymentMethod;
    }
    
    public void setPaymentMethod(String paymentMethod) {
        this.paymentMethod = paymentMethod;
    }
    
    public String getStatus() {
        return status;
    }
    
    public void setStatus(String status) {
        this.status = status;
    }
    
    public List<BillItem> getBillItems() {
        return billItems;
    }
    
    public void setBillItems(List<BillItem> billItems) {
        this.billItems = billItems;
    }
    
    // Business methods
    public void addItem(Item item, int quantity) {
        BillItem billItem = new BillItem(item.getItemId(), item.getItemCode(), 
                                       item.getTitle(), item.getAuthor(), 
                                       item.getPrice(), quantity);
        this.billItems.add(billItem);
        calculateTotals();
    }
    
    public void removeItem(int itemId) {
        billItems.removeIf(item -> item.getItemId() == itemId);
        calculateTotals();
    }
    
    public void calculateTotals() {
        this.subtotal = billItems.stream()
                                .mapToDouble(BillItem::getTotalPrice)
                                .sum();
        
        // Calculate tax (assuming 10% tax rate)
        this.taxAmount = subtotal * 0.10;
        
        // Calculate final total
        this.totalAmount = subtotal + taxAmount - discount;
    }
    
    public void applyDiscount(double discountAmount) {
        this.discount = discountAmount;
        calculateTotals();
    }
    
    private void generateBillNumber() {
        this.billNumber = "BILL-" + System.currentTimeMillis();
    }
    
    public int getTotalItems() {
        return billItems.stream().mapToInt(BillItem::getQuantity).sum();
    }
    
    // toString method for debugging
    @Override
    public String toString() {
        return "Bill{" +
                "billId=" + billId +
                ", billNumber='" + billNumber + '\'' +
                ", customerId=" + customerId +
                ", customerName='" + customerName + '\'' +
                ", billDate=" + billDate +
                ", subtotal=" + subtotal +
                ", taxAmount=" + taxAmount +
                ", discount=" + discount +
                ", totalAmount=" + totalAmount +
                ", status='" + status + '\'' +
                ", itemCount=" + billItems.size() +
                '}';
    }
}