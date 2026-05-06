package service;

import java.util.Properties;

import javax.mail.*;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;


public class EmailService {
	private final String senderEmail = "lendr.services@gmail.com";
    private final String senderPassword = "zxsz vjry vznl lidy";

    public boolean sendVerificationEmail(String recipientEmail, String firstName, String verificationLink) {
        String host = "smtp.gmail.com";
        String port = "587";

        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", host);
        props.put("mail.smtp.port", port);

        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(senderEmail, senderPassword);
            }
        });

        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(senderEmail));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(recipientEmail));
            message.setSubject("Verify your email address");

            String htmlContent =
                    "<h2>Email Verification</h2>" +
                    "<p>Hello " + firstName + ",</p>" +
                    "<p>Thank you for signing up.</p>" +
                    "<p>Please click the link below to verify your email:</p>" +
                    "<p><a href='" + verificationLink + "'>Verify My Account</a></p>" +
                    "<br>" +
                    "<p>If you did not create this account, please ignore this email.</p>";

            message.setContent(htmlContent, "text/html; charset=utf-8");

            Transport.send(message);
            return true;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public boolean sendBookingRequestEmail(model.User owner, model.User renter, model.Listing listing, String startDate, String endDate) {
		String host = "smtp.gmail.com";
		String port = "587";
		
		Properties props = new Properties();
		props.put("mail.smtp.auth", "true");
		props.put("mail.smtp.starttls.enable", "true");
		props.put("mail.smtp.host", host);
		props.put("mail.smtp.port", port);
		
		Session session = Session.getInstance(props, new Authenticator() {
			@Override
			protected PasswordAuthentication getPasswordAuthentication() {
				return new PasswordAuthentication(senderEmail, senderPassword);
			}
		});
		
		try {
			Message message = new MimeMessage(session);
			message.setFrom(new InternetAddress(senderEmail));
			message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(owner.getEmail()));
			message.setSubject("New booking request for " + listing.getTitle());
			
			String renterName = renter != null
			? renter.getFirstName() + " " + renter.getLastName()
			: "A renter";
			
			String htmlContent =
			"<h2>New Booking Request</h2>" +
			"<p>Hello " + owner.getFirstName() + ",</p>" +
			"<p>" + renterName + " requested to book your listing:</p>" +
			"<p><strong>" + listing.getTitle() + "</strong></p>" +
			"<p>Start date: " + startDate + "</p>" +
			"<p>End date: " + endDate + "</p>" +
			"<p>Log in and go to Settings &gt; Rental Requests to accept or deny this request.</p>";
			
			message.setContent(htmlContent, "text/html; charset=utf-8");
			
			Transport.send(message);
			return true;
		
		} catch (Exception e) {
			e.printStackTrace();
			return false;
		}
	}
    

    public boolean sendBookingDecisionEmail(model.User renter, model.Booking booking, String decision) {
		String host = "smtp.gmail.com";
		String port = "587";
		
		Properties props = new Properties();
		props.put("mail.smtp.auth", "true");
		props.put("mail.smtp.starttls.enable", "true");
		props.put("mail.smtp.host", host);
		props.put("mail.smtp.port", port);
		
		Session session = Session.getInstance(props, new Authenticator() {
			@Override
			protected PasswordAuthentication getPasswordAuthentication() {
				return new PasswordAuthentication(senderEmail, senderPassword);
			}
		});
		
		try {
			Message message = new MimeMessage(session);
			message.setFrom(new InternetAddress(senderEmail));
			message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(renter.getEmail()));
			
			String subjectDecision = "confirmed".equals(decision) ? "accepted" : "denied";
			message.setSubject("Your booking request was " + subjectDecision);
			
			String htmlContent =
			"<h2>Booking Request Update</h2>" +
			"<p>Hello " + renter.getFirstName() + ",</p>" +
			"<p>Your booking request for <strong>" + booking.getListingTitle() + "</strong> was " +
			subjectDecision + ".</p>" +
			"<p>Start: " + booking.getStartTime() + "</p>" +
			"<p>End: " + booking.getEndTime() + "</p>";
			
			message.setContent(htmlContent, "text/html; charset=utf-8");
			
			Transport.send(message);
			return true;
		
		} catch (Exception e) {
			e.printStackTrace();
			return false;
		}
	}

    
}



