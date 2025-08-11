package com.bookstore.model;

public class Feedback {
    private Integer userId; // Nullable for guests
    private String name;
    private String email;
    private String feedbackType;
    private int rating;
    private String subject;
    private String message;
    private String contactPreference;

    public Integer getUserId() {
        return userId;
    }
    public void setUserId(Integer userId) {
        this.userId = userId;
    }
    public String getName() {
        return name;
    }
    public void setName(String name) {
        this.name = name;
    }
    public String getEmail() {
        return email;
    }
    public void setEmail(String email) {
        this.email = email;
    }
    public String getFeedbackType() {
        return feedbackType;
    }
    public void setFeedbackType(String feedbackType) {
        this.feedbackType = feedbackType;
    }
    public int getRating() {
        return rating;
    }
    public void setRating(int rating) {
        this.rating = rating;
    }
    public String getSubject() {
        return subject;
    }
    public void setSubject(String subject) {
        this.subject = subject;
    }
    public String getMessage() {
        return message;
    }
    public void setMessage(String message) {
        this.message = message;
    }
    public String getContactPreference() {
        return contactPreference;
    }
    public void setContactPreference(String contactPreference) {
        this.contactPreference = contactPreference;
    }
}
