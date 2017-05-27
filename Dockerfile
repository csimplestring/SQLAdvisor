FROM ubuntu:16.04

RUN apt-get update && apt-get install -y \
	git \
	cmake libaio-dev libffi-dev libglib2.0-dev g++ \
	lsb-release \
	wget 

RUN wget https://repo.percona.com/apt/percona-release_0.1-4.$(lsb_release -sc)_all.deb 

RUN	dpkg -i percona-release_0.1-4.$(lsb_release -sc)_all.deb 

RUN apt-get update && apt-get install -y libperconaserverclient18.1-dev

WORKDIR /code

COPY . /code

RUN cmake -DBUILD_CONFIG=mysql_release -DCMAKE_BUILD_TYPE=debug -DCMAKE_INSTALL_PREFIX=/usr/local/sqlparser ./ 
RUN	make && make install

WORKDIR /code/sqladvisor/

RUN cmake -DCMAKE_BUILD_TYPE=debug ./ 
RUN	make
RUN mv sqladvisor /usr/local/bin
RUN cd / \
	rm -rf /code

CMD ['sqladvisor']