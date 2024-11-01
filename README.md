# ESDC

**Evolutionary System Design Converger**
The Evolutionary System Design Converger (ESDC) is a holistic spacecraft mission and system design tool aimed at accelerating Phase 0/A studies by leveraging heuristics and evolutionary algorithms. This tool automates the complex process of spacecraft design, addressing the large set of initial unknowns and intricate system interdependencies inherent to this task​​ to achieve optimal S/C design.

# Installation Guide

Welcome to the installation guide for ESDC. This document will help you set up and run the software on your machine.

## Prerequisites

Before you begin, ensure you have met the following requirements:

- You have a Windows, macOS or Linux machine.
- You have a working internet connection.
- You have installed [GNU Octave](https://www.gnu.org/software/octave/) version 8.2. or above.
- You have installed the relevant IO package for GNU Octave.
- You have installed Java Runtime Environment on your system to use .jar files.

## Install GNU Octave

If you haven't already, install GNU Octave by following the instructions on the [GNU Octave website](https://www.gnu.org/software/octave/download.html).

### Install the IO Package for XML functionality

Open GNU Octave and run the following command to install the IO package [GNU Octave package install](https://docs.octave.org/interpreter/Installing-and-Removing-Packages.html):

	pkg install -forge io
   
### Enabling xmlread with Xerces Java Library

To parse an XML file using the xmlread function, you need to add the Xerces Java library to your java_path. Octave does not ship with a Xerces library, so you must download and add the required .jar files.	

### Download the Xerces Java library
 from [Xerces](https://xerces.apache.org/mirrors.cgi). For example use [Xerces2 Java 2.12.2](https://dlcdn.apache.org//xerces/j/binaries/Xerces-J-bin.2.12.2.zip). The relevant .jar files are 'xercesImpl.jar' and 'xml-apis.jar'


## Installation

Follow these steps to install **[Your Software Name]**:

### Clone the Repository

Clone the repository to your local machine using Git:

```bash
git clone https://github.com/aerospaceresearch/ESDC.git
```

Or simply visit the [ESDC GitHub repository](https://github.com/aerospaceresearch/ESDC).


## Run the software

### Preparation
The following steps are necessary for preparing GNU Octave to run the ESDC software.

#### Activate IO
Always load the IO package before using the software by running:

	pkg load io

Add the downloaded \`.jar\` files to your Java path in Octave:

#### Add java path from Java Xerces
Replace /path/to/xerces-2_11_0/ with the actual path to the downloaded .jar files on your system.

On a UNIX System
```bash
javaaddpath("/path/to/xerces-2_11_0/xercesImpl.jar");
javaaddpath("/path/to/xerces-2_11_0/xml-apis.jar");
```

On a Windows System
```bash
javaaddpath("C:\\path\\to\\xerces-2_11_0\\xercesImpl.jar");
javaaddpath("C:\\path\\to\\xerces-2_11_0\\xml-apis.jar");
```
Use double backslashes (\\) to escape them properly in this syntax.

If you use UNIX notation you will get the following error
```bash
error: javaaddpath: CLSPATH does not exist
```

If you get the following error
```bash
error: unable to find Java Runtime Environment
```
install JRE on your system. 

Once you installed JRE on a Windows machine do add it to the environment variables:
```bash
C:\Program Files\Java\jre1.8.0_431\bin 
```

#### (Optional) Automate preparation
Automate this by adding the respective commands to your `.octave.rc`

### Execution
Launch the ESDC software by running in the repository root folder:

```octave
octave ESDC.m
```

The software will automatically use inputs provided within the files `Input/ESDC_Input.xml` and `Input/ESDC_Simulation_parameters.xml`. Adapt these accordingly.

### (Optional) Development in VS Code
The following extensions make development in VS Code effective and convenient:
- Octave Debugger
- Octave Language

## License

```
MIT License

Copyright (c) 2024 AerospaceResearch

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
