FROM ubuntu:16.04
MAINTAINER Onur Yukselen <onur.yukselen@umassmed.edu>

ENV PATH="/bin:/sbin:/usr/bin/samtools-1.9:/usr/bin/sratoolkit.2.10.7-ubuntu64/bin:${PATH}"

RUN apt-get update
RUN apt-get -y upgrade
RUN apt-get dist-upgrade
RUN apt-get -y install unzip libsqlite3-dev libbz2-dev libssl-dev python python-dev  liblzma-dev \
    python-pip git libxml2-dev software-properties-common wget tree vim sed make libncurses5-dev libncursesw5-dev\
    subversion g++ gcc gfortran libcurl4-openssl-dev curl zlib1g-dev build-essential libffi-dev  python-lzo \
    libxml-libxml-perl jq

### SRA-toolkit
RUN mkdir -p /data /project /nl /share
RUN cd /usr/bin && wget https://ftp-trace.ncbi.nlm.nih.gov/sra/sdk/2.10.7/sratoolkit.2.10.7-ubuntu64.tar.gz && \ 
    tar -xvzf sratoolkit.2.10.7-ubuntu64.tar.gz 

     
### S3CMD
RUN apt-get -y upgrade
RUN apt-get -y install python-setuptools
RUN pip install python-dateutil==2.2
RUN cd /usr/bin && wget http://netix.dl.sourceforge.net/project/s3tools/s3cmd/1.6.0/s3cmd-1.6.0.tar.gz && \
    tar xvfz s3cmd-1.6.0.tar.gz && cd s3cmd-1.6.0 && python setup.py install
RUN apt-get -y autoremove

### Samtools
RUN cd /usr/bin && wget https://github.com/samtools/samtools/releases/download/1.9/samtools-1.9.tar.bz2 && \
    tar -vxjf samtools-1.9.tar.bz2 && cd samtools-1.9 && make

### AWS CLI
RUN pip install awscli==1.16.170

### gcloud gsutils
RUN curl https://dl.google.com/dl/cloudsdk/release/google-cloud-sdk.tar.gz > /tmp/google-cloud-sdk.tar.gz
RUN mkdir -p /usr/local/gcloud \
  && tar -C /usr/local/gcloud -xvf /tmp/google-cloud-sdk.tar.gz \
  && /usr/local/gcloud/google-cloud-sdk/install.sh
ENV PATH $PATH:/usr/local/gcloud/google-cloud-sdk/bin

RUN echo "DONE!"
