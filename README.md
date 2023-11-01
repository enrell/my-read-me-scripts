# my-read-me-scripts
This repository stores installation scripts for the My-Read-Me project, providing additional features and settings, including Docker installation on various Linux distributions, currently supporting Ubuntu.

## Objective
The purpose of this repository is to provide scripts that facilitate the installation and configuration of the My-Read-Me project and its necessary dependencies, such as Docker, in different Linux distribution-based environments.

## Available Scripts

- **`ubuntu.sh`**: Installs Docker and performs additional configurations in the Ubuntu environment.
  
  This script carries out the following steps:
  - Source list update
  - Repository mirrors configuration
  - Docker and Docker Compose installation
  - Configuration of Docker's rootless environment
  - Addition of environment variables to the .bashrc file

## Usage

To use the available scripts in this repository, you can download and execute them directly using `curl`. For example, to run the `ubuntu.sh` script in Ubuntu:
```bash
curl -o- https://raw.githubusercontent.com/enrell/my-read-me-scripts/main/ubuntu.sh | bash
