# OTRS Group Vulnerability Disclosure Policy

We take the security of our systems seriously, and we value the security community.
The disclosure of security vulnerabilities helps us ensure the security and privacy of our users.

## Guidelines

We require that all researchers:

- Respect the rules. Operate within the rules set forth by the OTRS
Security Team, or speak up if in strong disagreement with the rules.
- Respect privacy. Make a good faith effort not to access or destroy
another user's data. Avoid degradation of user experience, disruption to
production systems, and destruction of data.
- Be patient. Make a good faith effort to clarify and support on
arising questions. Keep information about any vulnerabilities you’ve
discovered confidential between yourself and OTRS Group until we
resolved the issue with a public OTRS Group Security Announcement (typically
within 90 days)
- Do no harm. Act for the common good through the prompt reporting of
all found vulnerabilities. Never willfully exploit others without their
permission.
- Use the communication channel below to report vulnerability
information to us. Do not use personal emails, social media accounts, or
other private connections to contact a member of a security team in
regards to vulnerabilities or any program related issues, unless you
have been instructed to do so.

If you follow these guidelines when reporting an issue to us, we commit to:
- Not pursue or support any legal action related to your research;
- Work with you to understand and resolve the issue quickly (including
an initial confirmation of your report within 1 week of submission);
- Recognize your contribution on our Security Researcher Hall of Fame,
if you are the first to report the issue and we make a code or
configuration change based on the issue.

## Scope

- OTRS and Features created by the OTRS Group
- Managed OTRS and automation tools created and operated by the OTRS Group
- ((otrs)) Community Edition and features created by the OTRS Group

### Out of scope
Any services hosted by 3rd party providers and services are excluded
from scope. These services include OTRS instances hosted by external
parties and forks of the ((otrs)) Community Edition.


## Supported Versions

The following versions of OTRS or ((OTRS)) Community Edition are currently being supported with security updates.
Older versions are not supported and have known vulnerabilities.

| Version | Supported          | Known vulnerabilities   |
| ------- | ------------------ |------------------------ |
| 7.x     | :white_check_mark: |:x:                      |
| 6.x     | :white_check_mark: |:x:                      |
| 5.x     | :white_check_mark: |:x:                      |
| < 5.x   | :x:                |:bomb:                   |

## How to report a security vulnerability?
If you believe you’ve found a security vulnerability in one of our
products or platforms please send it to us by emailing
security@otrs.org. Please include the following details with your report:

- Description of the location and potential impact of the vulnerability;
- A detailed description of the steps required to reproduce the
vulnerability (POC scripts, screenshots, and compressed screen captures
are all helpful to us); and
- Your name/pseudonym for recognition in our Hall of Fame. If you prefer
to remain anonymous, we encourage them to submit under a pseudonym.

If you’d like to encrypt the information, please use our PGP Key:
2048R/9C227C6B 2011-03-21 [expires at: 2020-11-16]
GPG Fingerprint E330 4608 DA6E 34B7 1551 C244 7F9E 44E9 9C22 7C6B
