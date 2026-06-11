# OTP Email Troubleshooting Guide

## Problem Identified
**Root Cause:** Network/firewall is blocking Gmail's SMTP connections on ports 465 and 587.
- Error: `[WinError 10060] Connection timeout`
- This typically happens on corporate/school networks or with strict ISP firewalls

## Code Fixes Applied ✓
1. ✓ Removed duplicate code in `/signup` route
2. ✓ Changed SMTP config from port 465 (SSL) → port 587 (TLS)
3. ✓ Added environment variable support for credentials
4. ✓ Added timeout configuration

## Next Steps - Choose ONE:

### Option A: Fix Gmail Account Settings (RECOMMENDED FIRST)
1. **Enable App Password:**
   - Go to https://myaccount.google.com/security
   - Enable 2-Factor Authentication (if not already enabled)
   - Find "App passwords" section
   - Select "Mail" and "Windows Computer"
   - Copy the 16-character password
   - Update `.env` file with this password instead of your Gmail password

2. **Enable "Less secure app access":**
   - Go to https://myaccount.google.com/security
   - Scroll to "Less secure app access"
   - Toggle ON

### Option B: Use Alternative Email Service (If Option A doesn't work)
**SendGrid (Free tier - 100 emails/day):**
```bash
pip install sendgrid
```
- Sign up at https://sendgrid.com
- Get API key
- Update code to use sendgrid (see email_alternatives.py)

**Mailgun (Free tier - 5000 emails/month):**
```bash
pip install mailgun-sdk
```
- Sign up at https://mailgun.com
- Use their SMTP configuration

### Option C: Check Network/Firewall
```powershell
# Test connection to Gmail
Test-NetConnection -ComputerName smtp.gmail.com -Port 587
```
If this fails, contact your network administrator to unblock SMTP ports.

## Files Updated:
- `app.py` - Fixed signup route and SMTP config
- `.env` - Created with credentials
- `requirements.txt` - Added python-dotenv
- `test_mail.py` - Email testing script
- `email_alternatives.py` - Alternative solutions

## Quick Test After Fixing:
```bash
python test_mail.py
```

Expected output:
```
✓ Email sent successfully!
```
