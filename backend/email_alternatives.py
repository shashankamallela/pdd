"""
Alternative OTP solution using try-except with logging
This includes configuration for multiple email providers
"""

# OPTION 1: Try Gmail first, fallback to console logging
def send_otp_email(email, otp):
    """Send OTP with fallback to console if network fails"""
    try:
        msg = Message(
            subject='OTP Verification',
            recipients=[email],
            body=f'Your OTP is: {otp}'
        )
        mail.send(msg)
        print(f"✓ OTP sent to {email}")
        return True
    except Exception as e:
        print(f"✗ Email failed: {str(e)}")
        print(f"⚠️  FALLBACK: OTP for {email} is {otp}")
        print("   (In production, log this to database instead)")
        return False

# OPTION 2: Alternative - Use SendGrid (free tier available, no firewall issues)
# Uncomment below and install: pip install sendgrid
"""
from sendgrid import SendGridAPIClient
from sendgrid.helpers.mail import Mail

def send_otp_email_sendgrid(email, otp):
    try:
        message = Mail(
            from_email='noreply@yourdomain.com',  # Change this
            to_emails=email,
            subject='OTP Verification',
            plain_text_content=f'Your OTP is: {otp}'
        )
        sg = SendGridAPIClient(os.environ.get('SENDGRID_API_KEY'))
        response = sg.send(message)
        print(f"✓ OTP sent via SendGrid to {email}")
        return True
    except Exception as e:
        print(f"✗ SendGrid failed: {str(e)}")
        return False
"""

# OPTION 3: Alternative - Use AWS SES (reliable, free tier available)
# Uncomment below and install: pip install boto3
"""
import boto3

def send_otp_email_aws(email, otp):
    try:
        ses = boto3.client('ses', region_name='us-east-1')
        ses.send_email(
            Source='noreply@yourdomain.com',
            Destination={'ToAddresses': [email]},
            Message={
                'Subject': {'Data': 'OTP Verification'},
                'Body': {'Text': {'Data': f'Your OTP is: {otp}'}}
            }
        )
        print(f"✓ OTP sent via AWS SES to {email}")
        return True
    except Exception as e:
        print(f"✗ AWS SES failed: {str(e)}")
        return False
"""
