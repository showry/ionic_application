FROM ubuntu:14.04
MAINTAINER Samhitha
RUN apt-get update && apt-get install -y wget
RUN cd /opt && wget http://nodejs.org/dist/v0.10.32/node-v0.10.32-linux-x64.tar.gz && \
     tar zxf node-v0.10.32-linux-x64.tar.gz && \
     rm node-v0.10.32-linux-x64.tar.gz && \
     mv "node-v0.10.32-linux-x64" "node"
RUN cd /opt && wget http://dl.google.com/android/android-sdk_r23.0.2-linux.tgz && \
     tar xzf android-sdk_r23.0.2-linux.tgz && \
     rm android-sdk_r23.0.2-linux.tgz && \
     mv "android-sdk-linux" "android-sdk"
RUN cd /etc/apt/sources.list.d && \
     echo "deb http://old-releases.ubuntu.com/ubuntu/ raring main restricted universe multiverse" >ia32-libs-raring.list
RUN dpkg --add-architecture i386
RUN apt-get update
#RUN apt-get install ia32-libs
RUN apt-get install -qq -y libc6:i386 libgcc1:i386 libstdc++6:i386 libz1:i386
RUN cd /opt && \
     chown root:root "android-sdk" -R && \
     chmod 777 "android-sdk" -R
RUN echo "export PATH=\$PATH:/opt/android-sdk/tools" >> ".profile"
RUN echo "export PATH=\$PATH:/opt/android-sdk/platform-tools" >> ".profile"
RUN echo "export PATH=\$PATH:/opt/node/bin" >> ".profile"
ENV PATH=$PATH:/opt/android-sdk/tools
ENV PATH=$PATH:/opt/android-sdk/platform-tools
ENV PATH=$PATH:/opt/node/bin
RUN apt-get -qq -y install default-jdk ant
RUN export JAVA_HOME="$(find /usr -type l -name 'default-java')"
RUN echo "export JAVA_HOME=$JAVA_HOME" >> ".profile"
RUN npm install -g ionic
RUN npm install -g cordova
RUN echo y | android update sdk --all --no-ui --filter platform-tools,tools,build-tools-23.0.1,android-23
#,addon-google_apis_x86-google-23,extra-android-support,extra-android-m2repository,extra-google-m2repository,sys-img-x86-android-23
RUN apt-get install -y git unzip
EXPOSE 8100 35729
VOLUME /workspace
COPY entrypoint.sh /
RUN chmod +x /*.sh
