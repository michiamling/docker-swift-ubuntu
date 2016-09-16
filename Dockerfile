FROM ubuntu:15.10
MAINTAINER Michael Amling <amling at amcom.at>

ENV SWIFT_BRANCH swift-3.0-GM-CANDIDATE
ENV SWIFT_VERSION 3.0-GM-CANDIDATE
ENV SWIFT_PLATFORM ubuntu1510
ENV SWIFT_PLATFORM_DOT ubuntu15.10

#https://swift.org/builds/swift-3.0-GM-CANDIDATE/ubuntu1510/swift-3.0-GM-CANDIDATE/swift-3.0-GM-CANDIDATE-ubuntu15.10.tar.gz

# Install related packages
RUN apt-get update && \
    apt-get install -y build-essential wget clang libedit-dev python2.7 python2.7-dev rsync libxml2 git && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install Swift keys
RUN wget -q -O - https://swift.org/keys/all-keys.asc | gpg --import - && \
    gpg --keyserver hkp://pool.sks-keyservers.net --refresh-keys Swift

# Install Swift Ubuntu 14.04 Snapshot
RUN SWIFT_ARCHIVE_NAME=swift-$SWIFT_VERSION-$SWIFT_PLATFORM_DOT && \
    SWIFT_URL=https://swift.org/builds/$SWIFT_BRANCH/$(echo "$SWIFT_PLATFORM" | tr -d .)/swift-$SWIFT_VERSION/$SWIFT_ARCHIVE_NAME.tar.gz && \
    wget $SWIFT_URL && \
    wget $SWIFT_URL.sig && \
    gpg --verify $SWIFT_ARCHIVE_NAME.tar.gz.sig && \
    tar -xvzf $SWIFT_ARCHIVE_NAME.tar.gz --directory / --strip-components=1 && \
    rm -rf $SWIFT_ARCHIVE_NAME* /tmp/* /var/tmp/*

# Set Swift Path
ENV PATH /usr/bin:$PATH

# Print Installed Swift Version
RUN swift --version