FROM ubuntu:18.04

ARG DEFAULT_DIR=/gdb
WORKDIR $DEFAULT_DIR

# install dependency packages
RUN apt-get update && apt-get install -y --no-install-recommends \
    make \
    wget \
    libsqlite3-dev \
    sqlite3 \
    pkg-config \ 
    libpq-dev \
    python3-distutils \
    python3-dev \
    software-properties-common
RUN add-apt-repository ppa:ubuntugis/ppa && apt-get update
RUN apt-get install -y gdal-bin

# download source code
RUN wget http://download.osgeo.org/proj/proj-6.1.0.tar.gz && wget https://github.com/Esri/file-geodatabase-api/raw/master/FileGDB_API_1.5.1/FileGDB_API_1_5_1-64gcc51.tar.gz && wget https://github.com/OSGeo/gdal/releases/download/v3.0.1/gdal-3.0.1.tar.gz

# decompress everything
RUN tar xvf proj-6.1.0.tar.gz && tar xvf FileGDB_API_1_5_1-64gcc51.tar.gz && tar xvf gdal-3.0.1.tar.gz

# install proj 6
WORKDIR $DEFAULT_DIR/proj-6.1.0
RUN ./configure && make -j8 && make install

# install FileGDB
WORKDIR $DEFAULT_DIR/FileGDB_API-64gcc51/samples
RUN export LD_INCLUDE_PATH=$DEFAULT_DIR/FileGDB_API-64gcc51/include && \
    export LD_LIBRARY_PATH=$DEFAULT_DIR/FileGDB_API-64gcc51/lib && \
    make
RUN cp ../lib/* /usr/local/lib &&

#install GDAL 
WORKDIR $DEFAULT_DIR/gdal-3.0.1
RUN ./configure --with-python \
    --with-geos --with-geotiff --with-jpeg --with-png --with-expat --with-libkml --with-xerces-c \
    --with-fgdb=$DEFAULT_DIR/FileGDB_API-64gcc51 \
    --with-openjpeg --with-pg \
    --with-curl --with-spatialite && \
    make -j8 && \
    make install
RUN cp /usr/local/lib/lib* /usr/lib/

# cleanup
WORKDIR $DEFAULT_DIR
RUN rm -rf *
RUN apt-get -y autoremove && apt-get autoclean


