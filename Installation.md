## Installation instructions

In order to participate in the workshop you have to install Ubuntu
GNU/Linux as well as Anaconda and several tools. Ubuntu is an
operating system that has to be installed intead or in parallel to the
operating system that is currently installed on you laptop
(e.g. Windows). 

### Hardware requirements

- x64 processor
- 8 Gb RAM
- 40 Gb disk space

### Install Ubuntu

Please install the desktop version of the GNU/Linux
distribution [Ubuntu](https://www.ubuntu.com) 16.10 or 17.10. For this
visit the [download page](https://www.ubuntu.com/download/desktop).

Tutorials:
- [Tutorial](https://tutorials.ubuntu.com/tutorial/tutorial-install-ubuntu-desktop)
- [Further installation guides](https://help.ubuntu.com/community/Installation)
- [Instruction for a dual boot
  installation](https://help.ubuntu.com/community/WindowsDualBoot) in
  case you want Windows and Ubuntu installed on the same machine

After the installation and the first log-in you might be asked to
update the system. Please do so. As we will need the terminal
application quite often we will add it to our favorite
applications. For this click on the button icon with the nine dots
("Show Applications") and type in the search field on the top ("Type
to search ...") "Terminal". An icon name "Terminal" will be
shown. Click on that icon. The terminal icon will be now shown in the
bar on the left side. Click with the right mouse button on it and
click on "Add to Favorites" in menu that pops up. This will keep the
terminal icon in the bar to make it faster accessible.

In the following you will use the Unix Shell for the installation of
further tools. Please follow it precisely. During the workshop you
will learn how to use the Unix shell properly.

### Install Anaconda

We will use [Anaconda](https://www.anaconda.com) to install further
tools. 

In the code blocks below the dollar sign (`$`) indicates the command
line and must not be copied. Only copy and paste the text after it
into the terminal.

Open a terminal and write

```
$  wget https://repo.continuum.io/archive/Anaconda3-5.0.1-Linux-x86_64.sh
```

and **press Enter** to download the installer script.

Now you need to run the installer script in the terminal - this might
take a moment depending on the speed of your internet
connection. During the installation process you will be asked several
questions. Instead of `your_username` the username you have chosen
before during the installation of Ubuntu will be displayed. Write 

```
$ bash Anaconda3-5.0.1-Linux-x86_64.sh
 ```

and **press Enter**. The installer will greet you.

 
``` 
Welcome to Anaconda3 5.0.1
 
In order to continue the installation process, please review the license
agreement.
Please, press ENTER to continue
>>>
```

**Press ENTER** as requested and then **press the space key** to read
the license terms until you see the following:

```
Do you accept the license terms? [yes|no]
[no] >>>
```

**Type yes** and **press ENTER**. You will be asked for the location
of the installation.

```
Anaconda3 will now be installed into this location:
/home/your_username/anaconda3
 
  - Press ENTER to confirm the location
  - Press CTRL-C to abort the installation
  - Or specify a different location below
 
[/home/your_username/anaconda3] >>>
```

**Press ENTER**. You should observe that now several packages are
installed:

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

After that you will be asked the following:
 
```
[...]
installation finished.
Do you wish the installer to prepend the Anaconda3 install location
to PATH in your /home/your_username/.bashrc ? [yes|no]
```

**Type yes** and **press ENTER**.

You will have now a folder called ´anaconda3´ in your home
directory. Do not removed it as it contains you Anaconda installation.

During the installation process you have changed the configuration of
your shell (the file `.bashrc`) and due to this you need to restart
the terminal. For this close the terminal application and open a new
instance by clicking on the terminal icon. You should now be able to
call the command `conda`. E.g. with the parameter `--version`

```
$ conda --version
```

You should get version as output:

```
conda 4.3.30
```

If you get the error

```
conda: command not found
```

something went wrong. Try copy and run the following command in the
terminal 

```
$  echo 'export PATH="/home/'$USER'/anaconda3/bin:$PATH"' >> ~/.bashrc
```

and open a new terminal after that. There run `conda --version ` again.

In the worst case remove the `anaconda3` folder 

```
rm -rf ~/anaconda3
```

and start the installation again.

### Install some tools as Anaconda packages

Now we need to install some tools. Open a terminal and enter

```
$ conda install -c bioconda bwa fastx_toolkit fastqc segemehl \
                   sra-tools star samtools kallisto bioconductor-deseq2 \
				   cutadapt bedtools
```

**Press Enter**

Conda will present you a list of packages that will be install, up-
and downgraded.

```
Proceed ([y]/n)?
```

**Type y** and **press Enter**.

Please test if the tool are install by typing the following command in
the terminal and press ENTER.

```
$ fastqc -c
```

```
$ bwa
```

```
$ fastq_quality_trimmer
```

```
$ segemehl
```

```
$ STAR --version
```

```
$ samtools --version
```

```
$ bedtools --version
```

```
$ kallisto version
```

```
$ cutadapt --version
```

```
$ R --version
```

### Install READemption

In order to
install [READemption](https://pythonhosted.org/READemption/) open a
terminal, write 

```
$ pip install reademption
```

and **press ENTER**.

You can test READemption by opening a new terminal, typing

```
$ reademption -v
```

and **pressing ENTER**.


### Install Integrated Genome Browser (IGB)

To visually insprect genomes and mapped we will use the [Integrated
Genome Browser](http://bioviz.org/igb/).

Open a terminal, write

```
$ wget http://bioviz.org/igb/releases/current/IGB_unix_current.sh
```

and **press ENTER**.

Then write 

```
$ bash IGB_unix_current.sh
```

and **press ENTER**. Then follow the instruction of the graphical
installer. After that you should have an IGV icon on you desktop. The
folder `IGV` in your home directory contains the software and must not
be deleted! You run IGB by clicking on the icon. Alternatively type

```
$ bash ~/IGB/IntegratedGenomeBrowser
```

and **press ENTER**.

### Install Integrative Genomics Viewer 

We will also use the alternative genome
browser
[Integrative Genomics Viewer](http://software.broadinstitute.org/software/igv/).

Open a terminal, write

```
$ wget http://data.broadinstitute.org/igv/projects/downloads/2.4/IGV_2.4.5.zip
```

and **press ENTER**.

Then write 

```
$ unzip IGV_2.4.5.zip
```

and **press ENTER**.

To run it type

```
$ bash ~/IGV_2.4.5/igv.sh
```

and **press ENTER**.
