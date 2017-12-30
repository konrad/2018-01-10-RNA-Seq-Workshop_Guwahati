## Installation instructions

In order to participate in the workshop you have to install Ubuntu
GNU/Linux as well as Anaconda and serveral tools.

### Hardware requirements

- x64 processor
- 8 Gb RAM
- 20 Gb disk space

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

In the following you will use the Unix Shell for the installation of
further tools. Please follow it precisely. During the workshop you
will learn how to use the Unix shell properly.

### Anaconda

We will use [Anaconda](https://www.anaconda.com) to install further
tools. 

In the code blocks below the dollar sign (´$´) indicate the command
line and must not be copied. Only copy and paste the text after it
into the terminal.

Open a terminal and download the installer script:

```
$  wget https://repo.continuum.io/archive/Anaconda3-5.0.1-Linux-x86_64.sh
```

Run the installer script in the terminal - this might take a moment
depending on the speed of your internet connection. Durint the
installation process you will be asked several questions. Instead of
`your_username` the username you have chosen before will be displayed.

```
$ bash Anaconda3-5.0.1-Linux-x86_64.sh
 
Welcome to Anaconda3 5.0.1
 
In order to continue the installation process, please review the license
agreement.
Please, press ENTER to continue
>>>
```

**Press ENTER** as indicated and then **press space key** to read the
license terms until you see the following:

```
Do you accept the license terms? [yes|no]
[no] >>>
```

**Type yes** and **press ENTER**

```
Anaconda3 will now be installed into this location:
/home/your_username/anaconda3
 
  - Press ENTER to confirm the location
  - Press CTRL-C to abort the installation
  - Or specify a different location below
 
[/home/your_username/anaconda3] >>>
```

**Press ENTER**. You should observe that now serveral packages are installed:

``` 
PREFIX=/home/your_username/anaconda3
installing: python-3.6.3-hc9025b9_1 ...
Python 3.6.3 :: Anaconda, Inc.
installing: ca-certificates-2017.08.26-h1d4fec5_0 ...
installing: conda-env-2.6.0-h36134e3_1 ...
installing: intel-openmp-2018.0.0-h15fc484_7 ...
installing: libgcc-ng-7.2.0-h7cc24e2_2 ...
[...]
``` 

After that you will be aske the following:
 
```
[...]
installation finished.
Do you wish the installer to prepend the Anaconda3 install location
to PATH in your /home/your_username/.bashrc ? [yes|no]
```

**Type yes** and **press ENTER**


You will have now in your home directory a folder called
´anaconda3´. Do not removed it!

We have changed the configuration of you shell and need to restart
it. For this close the terminal and open a new one. You should now be
able to call the command ´conda´. E.g. with the parameter `--verstion`

```
$ conda --version
```

You should get version as output:

```
conda 4.3.29
```

If you get the error

```
conda: command not found
```

The installation failed. Try copy and run the following command in the
terminal:

```
$  echo 'export PATH="/home/'$USER'/anaconda3/bin:$PATH"' >> ~/.bashrc
```

### Anaconda packages

```
conda install -c bioconda bwa fastx-toolki fastqc segemehl sra-tools star samtools kallisto
```

