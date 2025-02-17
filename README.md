# Menshen port on the OpenNIC platform
This projects consists on the port of [Menshen](https://github.com/multitenancy-project/menshen), an hardware library for an High-Speed Programmable Packet-Processing Pipeline, on AMD's [OpenNIC](https://github.com/Xilinx/open-nic-shell) platform, which is an open-source FPGA-based NIC.

You can read Menshen's paper and learn about the project [here](isolation.quest).

The porting consists in the development of an OpenNIC 250MHz user plugin box (see OpenNIC's architecture) that wraps Menshen's pipeline inside. The project also comes with the testbenches to verify that all of the pipeline features properly work.
## Directory structure
 ```sh
menshen-open-nic/
├── src/                        # OpenNIC user plugin template, accordingly patched for the architecture of Menshen
├── p4s/                        # Source files for our tests, written in the P4 language
├── tbs/                        # Unit tests for Menshen by itself
├── open-nic-shell-patches/     # diff patches for modifying the OpenNIC environment to insert the Menshen pipeline
├── open-nic-tbs/               # Tests the complete component
├── menshen-open-nic.sh         # Script for project generation
└── open-nic-integration.tcl    # TCL build file to include Menshen inside OpenNIC's 250MHz box
```
## Building
The build process consists on running a script that will clone the OpenNIC and Menshen repositories and patch the files necessary for building and testing the component on the OpenNIC platform.
1. Clone the repo and enter the folder you just cloned
   ```sh
   git clone https://github.com/AlessandroVacca/menshen-open-nic.git && cd menshen-open-nic
   ```
2. We used [Xilinx Application 1151 CAM](https://www.xilinx.com/member/forms/download/design-license.html?cid=154257&filename=xapp1151_Param_CAM.zip). 
   After downloading it and placing it in the "menshen-open-nic/" folder, run the following commands:
   ```sh
   unzip xapp1151_Param_CAM.zip
   cp -r xapp1151_cam_v1_1/src/vhdl ./xilinx_cam
   patch -p0 --ignore-whitespace -i cam.patch
   ```
3. Give to the script the necessary permissions
   ```sh
   chmod +x menshen-open-nic.sh
   ```
4. Run the script
   ```sh
   ./menshen-open-nic.sh
   ```
5. In order to include the component inside OpenNIC you will need to build with this command, using Vivado 2022.1
   ```sh
   cd path/to/menshen-open-nic/open-nic-shell/script
   vivado -mode tcl -source build.tcl -tclargs -board au55c -user_plugin ../../src
   ```
## Sidenotes
The port has only been built and tested on an Alveo U55C board, therefore support on other Alveo boards isn't guaranteed.
## Authors
 - *[Francesco Colabene](https://github.com/FrancescoColabene)*
 - *[Francesco Tranquillo](https://github.com/FrancioT)*
 - *[Alessandro Vacca](https://github.com/AlessandroVacca)*
