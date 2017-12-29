## Installation instructions

In order to participate in the workshop you have to setup a laptop in
the following ma

### Install Ubuntu

Please install the desktop version of the GNU/Linux distribution
[Ubuntu](https://www.ubuntu.com) 16.10 or 17.10.

Tuturials:
- [Tutorial](https://tutorials.ubuntu.com/tutorial/tutorial-install-ubuntu-desktop)
- [Further installation guides](https://help.ubuntu.com/community/Installation)
- [https://help.ubuntu.com/community/WindowsDualBoot](Instruction for a dual boot installation) in case you want Windows and Ubuntu installed on the same machine

### Anaconda

We will use (Anaconda)[https://www.anaconda.com] to install further
tools. 

Open a terminal and download the installer script:

```
$  wget https://repo.continuum.io/archive/Anaconda3-5.0.1-Linux-x86_64.sh
```

### Anaconda packages

```
conda install -c bioconda bwa fastx-toolki fastqc segemehl sra-tools star samtools kallisto
```

