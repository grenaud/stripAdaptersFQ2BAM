#include ../makefile.defs
SHELL := /bin/bash

all: fastq2bam

CXX      = g++
BAMTOOLS = bamtools/
LIBGAB   = libgab/

CXXFLAGS  = -lm -O3 -Wall -I${LIBGAB} -I${LIBGAB}VCFparser/ -I${LIBGAB}/gzstream/ -I${BAMTOOLS}/include/ -c
LDFLAGS  = ${BAMTOOLS}/lib/libbamtools.a -lz

libgab/utils.h:
	rm -rf libgab/
	git clone --recursive https://github.com/grenaud/libgab.git


libgab/utils.o: bamtools/lib/libbamtools.so  libgab/utils.h
	make -C libgab

bamtools/src/api/BamAlignment.h:
	rm -rf bamtools/
	git clone --recursive https://github.com/pezmaster31/bamtools.git


bamtools/lib/libbamtools.so: bamtools/src/api/BamAlignment.h
	cd bamtools/ && mkdir -p build/  && cd build/ && cmake .. && make && cd ../..


fastq2bam.o:	fastq2bam.cpp libgab/utils.o bamtools/lib/libbamtools.so
	${CXX} ${CXXFLAGS} fastq2bam.cpp

fastq2bam:	fastq2bam.o ${LIBGAB}/utils.o ${LIBGAB}/PutProgramInHeader.o ${LIBGAB}/gzstream/gzstream.o ${LIBGAB}/FastQObj.o  ${LIBGAB}/FastQParser.o
	${CXX} -o $@ $^ $(LDFLAGS)


clean :
	rm -f *.o fastq2bam

.PHONY: all
