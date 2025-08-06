package com.bookstore.model;

public class Customer {
    
    private int customerId;
    private String accountNumber;
    private String name;
    private String address;
    private String telephoneNumber;
    private String email;
    private double totalPurchases;
    private boolean isActive;
    
    // Default constructor
    public Customer() {
    }
    
    // Constructor with all parameters
    public Customer(String accountNumber, String name, String address, String telephoneNumber, String email) {
        this.accountNumber = accountNumber;
        this.name = name;
        this.address = address;
        this.telephoneNumber = telephoneNumber;
        this.email = email;
        this.totalPurchases = 0.0;
        this.isActive = true;
    }
    
    // Constructor with ID (for database retrieval)
    public Customer(int customerId, String accountNumber, String name, String address, String telephoneNumber, String email, double totalPurchases, boolean isActive) {
        this.customerId = customerId;
        this.accountNumber = accountNumber;
        this.name = name;
        this.address = address;
        this.telephoneNumber = telephoneNumber;
        this.email = email;
        this.totalPurchases = totalPurchases;
        this.isActive = isActive;
    }
    
    // Getters and Setters
    public int getCustomerId() {
        return customerId;
    }
    
    public void setCustomerId(int customerId) {
        this.customerId = customerId;
    }
    
    public String getAccountNumber() {
        return accountNumber;
    }
    
    public void setAccountNumber(String accountNumber) {
        this.accountNumber = accountNumber;
    }
    
    public String getName() {
        return name;
    }
    
    public void setName(String name) {
        this.name = name;
    }
    
    public String getAddress() {
        return address;
    }
    
    public void setAddress(String address) {
        this.address = address;
    }
    
    public String getTelephoneNumber() {
        return telephoneNumber;
    }
    
    public void setTelephoneNumber(String telephoneNumber) {
        this.telephoneNumber = telephoneNumber;
    }
    
    public String getEmail() {
        return email;
    }
    
    public void setEmail(String email) {
        this.email = email;
    }
    
    public double getTotalPurchases() {
        return totalPurchases;
    }
    
    public void setTotalPurchases(double totalPurchases) {
        this.totalPurchases = totalPurchases;
    }
    
    public boolean isActive() {
        return isActive;
    }
    
    public void setActive(boolean isActive) {
        this.isActive = isActive;
    }
    
    // Business method to add purchase amount
    public void addPurchase(double amount) {
        this.totalPurchases += amount;
    }
    
    // toString method for debugging
    @Override
    public String toString() {
        return "Customer{" +
                "customerId=" + customerId +
                ", accountNumber='" + accountNumber + '\'' +
                ", name='" + name + '\'' +
                ", address='" + address + '\'' +
                ", telephoneNumber='" + telephoneNumber + '\'' +
                ", email='" + email + '\'' +
                ", totalPurchases=" + totalPurchases +
                ", isActive=" + isActive +
                '}';
    }
    
    // equals method for comparison
    @Override
    public boolean equals(Object obj) {
        if (this == obj) return true;
        if (obj == null || getClass() != obj.getClass()) return false;
        Customer customer = (Customer) obj;
        return customerId == customer.customerId;
    }
    
    // hashCode method
    @Override
    public int hashCode() {
        return Integer.hashCode(customerId);
    }
}