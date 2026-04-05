package model;
import java.sql.Timestamp;

public class User{
	private int userId;
	private String firstName;
	private String lastName;
	private String email;
	private String phoneNumber;
	private String passwordHash;
	private String verificationToken;
	private Boolean verifiedStatus;
	private String govId;
	private Timestamp createdAt;
	
	public User() {}
	
	public User(int userId, String Fname,String Lname, String email, String phoneNumber,
            String passwordHash, String verificationToken,
            boolean verifiedStatus, String govId, Timestamp createdAt) {
		this.userId = userId;
		this.firstName = Fname;
		this.lastName = Lname;
		this.email = email;
		this.phoneNumber = phoneNumber;
		this.passwordHash = passwordHash;
		this.verificationToken = verificationToken;
		this.verifiedStatus = verifiedStatus;
		this.govId = govId;
		this.createdAt = createdAt;
	}
	
	public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
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

    public String getPhoneNumber() {
        return phoneNumber;
    }

    public void setPhoneNumber(String phoneNumber) {
        this.phoneNumber = phoneNumber;
    }

    public String getPasswordHash() {
        return passwordHash;
    }

    public void setPasswordHash(String passwordHash) {
        this.passwordHash = passwordHash;
    }

    public String getVerificationToken() {
        return verificationToken;
    }

    public void setVerificationToken(String verificationToken) {
        this.verificationToken = verificationToken;
    }

    public boolean isVerifiedStatus() {
        return verifiedStatus;
    }

    public void setVerifiedStatus(boolean verifiedStatus) {
        this.verifiedStatus = verifiedStatus;
    }

    public String getGovId() {
        return govId;
    }

    public void setGovId(String govId) {
        this.govId = govId;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
}