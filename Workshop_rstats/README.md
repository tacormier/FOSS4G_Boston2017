# Geo with R? Yes we Can!
### Tina A. Cormier
<br>

## Pre-workshop Instructions: :heavy_check_mark:
<br>
To cut down on setup during our short time together, please do the following **prior to the workshop**:  

1. *Download* and *install* VirtualBox and *download* and *unzip* OSGeo-Live using the links found on the [OSGeo-Live website](https://live.osgeo.org/en/quickstart/virtualization_quickstart.html).  
    * OSGeo live took about 30-35 minutes to download for me with decent speeds, so please don't wait until the workshop to download (when speeds are expected to be slower with everyone hitting the network at the same time).  
  
    * You do not need to set up your virtual machine. We will do that together and make some custom tweaks to the settings for a better experience!

 2. Download the [workshop data](https://drive.google.com/open?id=0B4DQJSUPD0brVktPSXZFcmx2MEU) into a folder on your machine called `R_workshop`. You should now have a directory structure like `/[your_path]/R_workshop/data/`. You should also have a directory structure like `/[your_path]/R_workshop/code/` that contains the code in this repository.
<br>

## It's Workshop Day: :clap:

##### Getting Started
###### VB setup
1. Start the VirtualBox application and click on the New button to create a new VM, and then Next.
2. Enter a name such as OSGeo-Live, and choose Linux as the “Operating system”, and Ubuntu as the “Version”.
3. In the next screen set the memory to *at least* 1024 MB (or more if your host computer has more than 4GB). On my 16GB machine, I chose 8192 MB. More than that hosed my computer.
4. Continue to the next screen and choose “Use existing hard disk” . Now click on the button (a folder icon) to browse to where you saved the OSGeo-Live vmdk-file. Select this file, press Next and Create.
5. Once the VM is created, click on the Settings button. In the “General” section, go to the Advanced tab, and click to select “bidirectional" for shared clipboard (this doesn't really work but it makes me feel better to choose it).
6. Go to the “Display” section and increase video memory to 32 or 64 MB.
7. In the “Shared Folders” section, click the “Add folder” (green + icon on the right), browse to your workshop "data" directory, and add it. Also select Auto-mount.
8. Now boot up the VM by clicking the Start (green arrow) button.

###### The remainder of the instructions are to be run from within the VM.

9. Under menu (bottom left button) -> Preferences -> Monitor Settings, you can adjust display resolution to better fit your monitor. Be careful not to make it too large that the menu bar goes off your screen - it's a pain to get it back. Use the "Apply" button to test different settings before choosing one to save. Alt+F1 will get you back to the menu if you lose it off the screen, but just don't do that.
10. Add yourself to the vboxsf group so that the shared folders (defined above) are accessible. Open terminal and enter the following command 

  ``` sudo usermod -a -G vboxsf user ``` 

11. Above, we defined a Shared Folder path on the host system and named it “R_workshop” in the VM Settings. The shared folder will appear in the file system under /media/sf_GIS/. To mount this folder in the user’s home directory, enter the following two commands into terminal (make sure you are in `/home/user/` (type `pwd`) first: 

  ```mkdir R_workshop``` 

  ```sudo mount -t vboxsf -o uid=user,rw GIS /home/user/R_workshop``` 
  
  *Note* that the mount command will need to be run each time you log in to the VM. 

12. Change directories into R_workshop (`cd R_workshop`). You should have two folders there: code and data. CD into the code directory and run the following commands:

`chmod 777 VM_setup.sh`

`./VM_setup.sh`

13. Go to https://www.rstudio.com/products/rstudio/download/#download and download the version named: **RStudio 1.0.153 - Ubuntu 16.04+/Debian 9+ (64-bit)**.



