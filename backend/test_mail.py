"""Test script to verify mail configuration"""
import os
from dotenv import load_dotenv
from flask import Flask
from flask_mail import Mail, Message

load_dotenv()

app = Flask(__name__)

# GMAIL SMTP CONFIGURATION
app.config['MAIL_SERVER'] = 'smtp.gmail.com'
app.config['MAIL_PORT'] = 587
app.config['MAIL_USERNAME'] = os.getenv('MAIL_USERNAME')
app.config['MAIL_PASSWORD'] = os.getenv('MAIL_PASSWORD')
app.config['MAIL_USE_TLS'] = True
app.config['MAIL_USE_SSL'] = False
app.config['MAIL_DEFAULT_SENDER'] = os.getenv('MAIL_USERNAME')
app.config['MAIL_TIMEOUT'] = 20

mail = Mail(app)

def test_email():
    try:
        with app.app_context():
            msg = Message(
                subject='Test OTP Email',
                recipients=['shashankamallela94@gmail.com'],
                body='This is a test OTP: 1234'
            )
            mail.send(msg)
            print("✓ Email sent successfully!")
            return True
    except Exception as e:
        print(f"✗ Email sending failed: {str(e)}")
        print(f"\nDebug Info:")
        print(f"  Mail Server: {app.config['MAIL_SERVER']}")
        print(f"  Mail Port: {app.config['MAIL_PORT']}")
        print(f"  Username: {app.config['MAIL_USERNAME']}")
        print(f"  Use SSL: {app.config['MAIL_USE_SSL']}")
        return False

if __name__ == '__main__':
    test_email()
