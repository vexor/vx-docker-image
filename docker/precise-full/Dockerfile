FROM dmexe/vexor-precise:latest
MAINTAINER Dmitry Galinsky

ADD base.sh /tmp/provision/base.sh
ADD playbooks /tmp/provision/playbooks
RUN bash /tmp/provision/base.sh
RUN rm -rf /tmp/provision

#ENTRYPOINT ["/sbin/init", "--startup-event", "dockerboot"]
