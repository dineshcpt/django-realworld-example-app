FROM centos:8
LABEL maintainer "DINESH"
RUN yum -y update
RUN yum -y groupinstall "Development Tools"
RUN yum -y install openssl-devel bzip2-devel libffi-devel
RUN yum -y install wget
RUN wget https://www.python.org/ftp/python/3.8.3/Python-3.8.3.tgz
RUN tar xvf Python-3.8.3.tgz
RUN cd /Python-3.8*/ && \
    ./configure --enable-optimizations && \
    make altinstall
RUN curl https://packages.microsoft.com/config/rhel/8/prod.repo > /etc/yum.repos.d/mssql-release.repo
RUN yum remove unixODBC-utf16 unixODBC-utf16-devel
RUN ACCEPT_EULA=Y yum install msodbcsql17 -y
RUN ACCEPT_EULA=Y yum install mssql-tools -y
RUN echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bash_profile
RUN echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bashrc
RUN source ~/.bashrc
RUN yum install unixODBC-devel -y

COPY ./requirements.txt /usr/src/app/requirements.txt
COPY ./app/ /usr/src/app
WORKDIR /usr/src/app
RUN pip3.8 install --no-cache-dir -r requirements.txt
EXPOSE 8000
CMD ["python3.8", "manage.py", "runserver", "0.0.0.0:8000"]
