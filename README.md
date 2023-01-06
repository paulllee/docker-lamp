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

5. **Important:** Double check and make sure you are on WSL Version 2.
     - To check, Open Windows Terminal (PowerShell or CMD) and run `wsl -l -v`
       - Run `wsl --set-version Ubuntu-18.04 2` if Ubuntu 18.04 is not on Version 2
       - Run `wsl --set-version Ubuntu-20.04 2` if Ubuntu 20.04 is not on Version 2
       - Run `wsl --set-version Ubuntu-22.04 2` if Ubuntu 22.04 is not on Version 2

The main site is pointed to localhost:80 or just localhost
