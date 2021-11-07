FROM docker.io/mailserver/docker-mailserver:10.2.0 as mailserver

COPY ./mailserver/entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

# ___---*** Begin example-sender ***---___ 
FROM ubuntu:21.10 as example-sender

# The reason to install ssmtp is described in README.md file
RUN apt update && apt install -y ssmtp bsd-mailx

COPY ./example-sender/revaliases /etc/ssmtp/revaliases
COPY ./example-sender/ssmtp.conf /etc/ssmtp/ssmtp.conf

COPY ./example-sender/wait-for-it.sh /wait-for-it.sh
COPY ./example-sender/entrypoint.sh /entrypoint.sh

# Change from mail description, so when an email is recevied from
# UI is show from: Example Sender <example-sender@example.com>
RUN chfn -f 'Example Sender' root


ENTRYPOINT ["/entrypoint.sh"]

