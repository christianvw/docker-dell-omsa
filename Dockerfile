# Use CentOS 7 base image from Docker Hub
FROM centos:centos7
MAINTAINER Jose De la Rosa "https://github.com/jose-delarosa"

# Environment variables
ENV EPEL https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
ENV VERSION check_openmanage-3.7.12
ENV URL http://folk.uio.no/trondham/software/files/$VERSION.tar.gz
ENV PATH $PATH:/opt/dell/srvadmin/bin:/opt/dell/srvadmin/sbin:$VERSION
ENV USER root
# we will replace the password later with the set environment variable
ENV PASS tByxdfCCWtUGsCPvJRGWbx7p

# Do overall update and install missing packages needed for OpenManage
RUN yum clean all && \
    yum -y install $EPEL && \
    yum -y update && \
    yum -y install \
      wget \
      tar \
      perl \
      perl-Net-SNMP \
      gcc \
      wget \
      perl \
      passwd \
      which \
      tar \
      libstdc++.so.6 \
      compat-libstdc++-33.i686 \
      glibc.i686 \
      net-snmp && \
    yum clean all

# Set login credentials (we will replace the password later)
RUN echo "$USER:$PASS" | chpasswd

# Add OMSA repo. Let's use this DSU version with a known stable OMSA.
RUN wget -q -O - http://linux.dell.com/repo/hardware/DSU_17.01.00/bootstrap.cgi | bash

# Let's "install all", however we can select specific components instead
RUN yum -y install srvadmin-all && \
    yum clean all

# Get and install check_openmanage
RUN wget $URL && \
    tar zxvf $VERSION.tar.gz

# Prevent daemon helper scripts from making systemd calls
ENV SYSTEMCTL_SKIP_REDIRECT=1

# change passwords to something safe with entrypoint
COPY docker-entrypoint /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint
ENTRYPOINT ["/usr/local/bin/docker-entrypoint"]

# Restart application to ensure a clean start
CMD srvadmin-services.sh restart && tail -f /opt/dell/srvadmin/var/log/openmanage/dcsys64.xml
