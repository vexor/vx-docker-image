FROM vexor/trusty:1.0.1
MAINTAINER Dmitry Galinsky

ADD base.sh /tmp/provision/base.sh
ADD playbooks /tmp/provision/playbooks
RUN bash /tmp/provision/base.sh
RUN rm -rf /tmp/provision
