FROM phusion/baseimage:0.9.15
MAINTAINER Dmitry Galinsky

ADD 00_base.sh /tmp/provision/00_base.sh
ADD 10_ci_env.sh /tmp/provision/10_ci_env.sh
ADD 99_tests.sh /var/vexor/tests.sh
ADD playbooks /tmp/provision/playbooks

RUN bash /tmp/provision/00_base.sh
RUN bash /tmp/provision/10_ci_env.sh
RUN rm -rf /tmp/provision
