# dev-mailserver

Running a mailserver for testing mail during development.
The main purposes of a dev mailserver are to be able to:
* send/receive email via SMTP and IMAP services (container mailserver)
* read email using an UI that allow show HTML and attachments (container roundcube)
* send email to a remote SMTP server (container example-sender)

## Start up
```bash
docker-compose up --build
```

## Read email
To read email connect using your preffered browser to:
http://localhost:8000

Login: user@example.com
Password: password

## How it works
There are three containers each one has one specific role.

### mailserver
Container that use as a base (docker-mailserver)[https://github.com/docker-mailserver/docker-mailserver] in order to:
* SMTP daemon: send and receive email
* IMAP daemon: read email from UI (container roundcube)
Others services are disable using environment variables (see also (docker-mailserver example)[https://github.com/docker-mailserver/docker-mailserver#examples]) ).

Two users are created when docker container start:
* user@example.com: account that receive email. The password for this account is: password
* example-sender@example.com: account that send email, from container example-sender. The password for this account is: password

### UI - roundcube
(Roundcube)[https://roundcube.net/] is a browser-based multilingual IMAP client with an application-like user interface.
The reason to use roundcube over the alternatives, such as (squirrel)[https://squirrelmail.org/], are:
* easy to use via browser
* (available image in dockerhub)[https://hub.docker.com/r/roundcube/roundcubemail/]
* easy to configure, just two environment variables

In this project roundcube connect via IMAP to mailserver.

### example-sender
Starting from Ubuntu image is created a container that send an email from example-sender@example.com to user@example.com every 30 seconds, sending email is done in entrypoint.sh.

In order to send email is used (SSMTP)[https://salsa.debian.org/debian/ssmtp] a program that send mail via the departmental mailhub, using different protocol.
In this project departmental mailhub is mailserver container via SMTP.

This project use SSMTP instead of sendmail because it is already configured a mailserver so it is not required to start also a mail daemon in example-sender.
The flow to send email is:
                            ┌───────────────────────┐
                            │ MAILSERVER CONTAINER  │
┌───────┐    ┌───────┐      │ ┌────────┐            │
│ mailx ├────► SSMTP ├──────┼─►SMTP    │            │
└───────┘    └───────┘      │ └────────┘            │
                            │                       │
                            └───────────────────────┘

* (mailx)[https://en.wikipedia.org/wiki/Mailx]: is just a "Front End" for sending an email, it prepare the request to mail user agent configured in the server
* SSMTP: called by Operating System receive the request prepared from mailx and connect via SMTP to mailserver container
* Mailserver container: receive request from SSMTP, validate credential and deliver the email

