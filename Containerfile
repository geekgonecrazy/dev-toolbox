FROM registry.fedoraproject.org/fedora:37

ENV NAME=fedora-toolbox VERSION=37
LABEL com.github.containers.toolbox="true" \
      com.redhat.component="$NAME" \
      name="$NAME" \
      version="$VERSION" \
      usage="This image is meant to be used with the toolbox command" \
      summary="Base image for creating Fedora toolbox containers" \
      maintainer="Debarshi Ray <rishi@fedoraproject.org>"

RUN dnf group install -y "C Development Tools and Libraries" "Development Tools"

COPY extra-packages /
RUN dnf -y install $(<extra-packages)
RUN rm /extra-packages

RUN dnf clean all

# Install kubectl
RUN cd /tmp && curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && \
    install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl && \
    rm kubectl

# Install aws cli
RUN cd /tmp && curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install && \
    rm -rf aws

RUN cd /tmp && curl -L "https://github.com/sigstore/cosign/releases/download/v1.13.1/cosign-1.13.1.x86_64.rpm" -o cosign.rpm && \
  rpm -ivh cosign.rpm

COPY bin/ /usr/local/bin/

# Install visual studio code
#RUN rpm --import https://packages.microsoft.com/keys/microsoft.asc && \
#    echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo && \
#    dnf check-update || exit 0 && \
#    dnf install -y code

