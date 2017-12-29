## Installation instructions

In order to participate in the workshop you have to install Ubuntu
GNU/Linux as well as Anaconda and serveral tools.

### Install Ubuntu

Please install the desktop version of the GNU/Linux distribution
[Ubuntu](https://www.ubuntu.com) 16.10 or 17.10.

Tuturials:
- [Tutorial](https://tutorials.ubuntu.com/tutorial/tutorial-install-ubuntu-desktop)
- [Further installation guides](https://help.ubuntu.com/community/Installation)
- [Instruction for a dual boot
  installation](https://help.ubuntu.com/community/WindowsDualBoot) in
  case you want Windows and Ubuntu installed on the same machine

After the installation and the first log-in you migh be asked to
update the system. Please do so. As we will need the terminal
application quite often we will add it to our favorite
applications. For this click on the button icon with the nine dots
("Show Applications") and type in the search field on the top ("Type
to search ...") "Terminal". An icon name "Terminal" will be
shown. Click on that icon. The terminal icon will be now shown in the
bar on the left side. Click with the right mouse button on it and
click on "Add to Favorites" in menue that pops up. This will keep the
terminal icon in the bar to make it faster accessible.

### Anaconda

We will use [Anaconda](https://www.anaconda.com) to install further
tools. 

Open a terminal and download the installer script:

```
$  wget https://repo.continuum.io/archive/Anaconda3-5.0.1-Linux-x86_64.sh
```

Run the installer script in the terminal - this might take a moment
depending on the speed of your internet connection:

```
$  bash Anaconda3-5.0.1-Linux-x86_64.sh -b
```

### Anaconda packages

```
conda install -c bioconda bwa fastx-toolki fastqc segemehl sra-tools star samtools kallisto
```

