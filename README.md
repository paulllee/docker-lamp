# Docker Compose Development Environment for Lyquix

This is the Docker LAMP Environment for Lyquix that will streamline the development cycle.

Tech Stack: Ubuntu-18.04(+), Apache-latest, MySQL-5.7(+), PHP-7.2(+)

Included technologies: SRDB-latest and phpMyAdmin-latest

# Before You Start

If you are using websites that were previously set up on your local, make sure to create a backup of **ALL** databases. 

I recommend a *clean install* for all the websites.

# Prerequisites

1. Open **Turn Windows features on and off**:
   - Enable HYPER-V
   - Enable Virtual Machine Platform
   - Enable Windows Subsystem for Linux

2. Restart the computer.

3. Open Windows Terminal (PowerShell or CMD) and run `wsl --set-default-version 2` to set future WSL installations to Version 2.

4. Install [Ubuntu](https://www.microsoft.com/store/productId/9PDXGNCFSCZV) from the **Microsoft Store** regardless of the version.
   - Open up the application and wait a few minutes.
   - Once a prompt appears, input the following:
     - Enter new UNIX username: `ubuntu`
     - New password: `ubuntu`
     - Retype new password: `ubuntu`

5. **Important:** Double check and make sure you are on WSL Version 2 and that it is set as default.
     - To check, Open Windows Terminal (PowerShell or CMD) and run `wsl -l -v`
       - Run `wsl --set-version Ubuntu 2` if Ubuntu is not on Version 2
       - Run `wsl --set-default Ubuntu` if Ubuntu doesn't have an asterisk next to it

6. Run the following commands in your Linux command line to download and setup your WSL2 environment!

```
cd
curl https://raw.githubusercontent.com/paulllee/docker-lamp/main/bin/wsl2/setup.sh > setup.sh
sudo bash setup.sh
```

7. Install [Docker Desktop on Windows](https://desktop.docker.com/win/main/amd64/Docker%20Desktop%20Installer.exe) (make sure you enable WSL2 Backend during the installation, you can do it later in Settings as well)

8. In the Settings, make sure these are enabled:
   - General -> `Use the WSL 2 based engine`
   - Resources -> WSL Integration -> `Enable integration with my default WSL distro`
     - You can also enable any distros under `Enable integration with additional distros:`

# Installation and How to Run

1. Run the following commands in your Linux command line to download and run the website setup script!

```
cd
curl https://raw.githubusercontent.com/paulllee/docker-lamp/main/bin/wsl2/website-setup.sh > website-setup.sh
sudo bash website-setup.sh
```

2. To build and run the container, run `cd /home/ubuntu/docker-lamp/DOMAIN_NAME` (change DOMAIN_NAME to the domain you just set up, ex: lyquix) and then run `sudo docker-compose up -d`

**IMPORTANT:** The very first build of a container will take at least 350 seconds but future builds will take only seconds since they cache the build steps from the first time.

**IMPORTANT:** AFTER the image is built and the container has started *WordPress* sites need an extra few steps detailed below:

1. Go to SRDB ([localhost:3001](http://localhost:3001/)) and change all instances of the url for dev for the test url and protocol
for example (do these separately)
   - dev.domain.com → localhost
   - https://localhost → http://localhost

You can now use the Docker Desktop GUI in Windows to stop and start containers in the `Containers` tab. You **MUST** run one container at a time.

To access the site, it is pointed to: [localhost](http://localhost/)

To access SRDB, it is pointed to: [localhost:3001](http://localhost:3001/)

To access phpMyAdmin, it is pointed to: [localhost:3002](http://localhost:3001/)

**IMPORTANT:** MySQL root, database name, user name, and database password are defaulted to `ubuntu`

# Issues

For any questions or issues, just plop them into the `Issues` tab!

# License

Distributed under the GNU General Public License v3.0. See LICENSE for more information.
