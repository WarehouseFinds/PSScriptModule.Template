#-------------------------------------------------------------------------------------------------------------
# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License. See https://go.microsoft.com/fwlink/?linkid=2090316 for license information.
#-------------------------------------------------------------------------------------------------------------

# Use 'latest' for the newest stable PowerShell or 'lts-ubuntu-22.04' for long-term support
# Options: latest, preview, lts-ubuntu-22.04
FROM mcr.microsoft.com/powershell:lts-ubuntu-22.04

# Avoid warnings by switching to noninteractive
ENV DEBIAN_FRONTEND=noninteractive

# Configure apt and install packages
RUN apt-get update \
    && apt-get -y upgrade \
    && apt-get -y install --no-install-recommends apt-utils 2>&1 \
    #
    # Verify git, process tools, lsb-release (common in install instructions for CLIs) installed
    && apt-get -y install --no-install-recommends git procps lsb-release \
    #
    # Install additional dependencies for PowerShell Editor Services
    && apt-get -y install --no-install-recommends \
        ca-certificates \
        libicu70 \
        libssl3 \
    #
    # Clean up
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*

# Update CA certificates
RUN update-ca-certificates

# Switch back to dialog for any ad-hoc use of apt-get
ENV DEBIAN_FRONTEND=dialog