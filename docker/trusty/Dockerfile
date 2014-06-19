FROM phusion/baseimage:0.9.10
MAINTAINER Dmitry Galinsky

ADD base.sh /tmp/provision/base.sh
RUN bash /tmp/provision/base.sh
RUN rm -rf /tmp/provision

#ENTRYPOINT ["/sbin/init", "--startup-event", "dockerboot"]
