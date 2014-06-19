FROM dmexe/vexor-trusty:latest
MAINTAINER Dmitry Galinsky

RUN /etc/my_init.d/00_regen_ssh_host_keys.sh

ADD base.sh /tmp/provision/base.sh
ADD playbooks /tmp/provision/playbooks
RUN bash /tmp/provision/base.sh
RUN rm -rf /tmp/provision
