FROM amazonlinux:2

# `shadow-utils` `procps` には基本的なコマンドが多く含まれています
RUN yum install -y sudo shadow-utils procps wget
RUN yum install -y openssh-server openssh-clients
RUN yum install -y which crontabs

# easy_install を使うためです
RUN wget https://bootstrap.pypa.io/ez_setup.py -O - | sudo python

# SSH の設定
RUN systemctl enable sshd.service
RUN echo "PasswordAuthentication no" >> /etc/ssh/sshd_config
COPY ./al2local_rsa.pub /home/ec2-user/.ssh/id_rsa.pub
RUN cat /home/ec2-user/.ssh/id_rsa.pub >> /home/ec2-user/.ssh/authorized_keys

# no password で sudo を可能にします
RUN useradd ec2-user
RUN echo "ec2-user ALL=NOPASSWD: ALL" >> /etc/sudoers

CMD /sbin/init
