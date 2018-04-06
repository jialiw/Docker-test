#Download base image ubuntu 16.04
FROM ubuntu:16.04

# Update Ubuntu Software repository
# Install FreeSurfer dependencies
# Download v6.0.0 and untar to /opt
RUN apt-get update \
	&& apt-get -y install --no-install-recommends ubuntu-desktop \
	&& apt-get -y install tcsh csh tar wget libgomp1 libglu1-mesa libfreetype6 libxrender1 libfontconfig1 perl-modules bc \
	&& apt-get update \
	&& apt-get -y install libglib2.0-0 libsm6 libxt6 libxss1 libxft2 libjpeg62 \
	&& wget -N -qO- ftp://surfer.nmr.mgh.harvard.edu/pub/dist/freesurfer/6.0.0/freesurfer-Linux-centos6_x86_64-stable-pub-v6.0.0.tar.gz | tar -xzv -C /opt \
	&& mkdir /output 

RUN apt-get update && apt-get -y install iputils-ping
RUN apt-get install -y x11vnc xvfb

# Configure license
COPY license /opt/freesurfer/license.txt

RUN apt-get install -y x11vnc xvfb
RUN mkdir ~/.vnc

RUN x11vnc -storepasswd 1234 ~/.vnc/passwd

# Configure basic freesurfer ENV 
ENV OS Linux
#ENV FS_OVERRIDE 0
#ENV FIX_VERTEX_AREA=
ENV SUBJECTS_DIR /output
ENV FSF_OUTPUT_FORMAT nii.gz
ENV MNI_DIR /opt/freesurfer/mni
ENV LOCAL_DIR /opt/freesurfer/local
ENV FREESURFER_HOME /opt/freesurfer
ENV FSFAST_HOME /opt/freesurfer/fsfast
ENV MINC_BIN_DIR /opt/freesurfer/mni/bin
ENV MINC_LIB_DIR /opt/freesurfer/mni/lib
ENV MNI_DATAPATH /opt/freesurfer/mni/data
ENV FUNCTIONALS_DIR /opt/freesurfer/sessions
ENV FMRI_ANALYSIS_DIR /opt/freesurfer/fsfast
ENV PERL5LIB /opt/freesurfer/mni/share/perl5
ENV MNI_PERL5LIB /opt/freesurfer/mni/share/perl5
ENV PATH /opt/freesurfer/bin:/opt/freesurfer/fsfast/bin:/opt/freesurfer/tktools:/opt/fsl/bin:/opt/freesurfer/mni/bin:/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/sbin:/bin

# Configure bashrc to source FreeSurferEnv.sh
RUN /bin/bash -c ' echo -e "source $FREESURFER_HOME/FreeSurferEnv.sh &>/dev/null" >> /root/.bashrc '

CMD bash


