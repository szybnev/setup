#!/bin/bash

echo "██████╗  ██████╗ ██╗  ██╗███████╗██╗  ██╗"
echo "██╔══██╗██╔═══██╗╚██╗██╔╝██╔════╝██║ ██╔╝"
echo "██████╔╝██║   ██║ ╚███╔╝ █████╗  █████╔╝ "
echo "██╔═══╝ ██║   ██║ ██╔██╗ ██╔══╝  ██╔═██╗ "
echo "██║     ╚██████╔╝██╔╝ ██╗███████╗██║  ██╗"
echo "╚═╝      ╚═════╝ ╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝"
echo
echo "Created by Zybnev Sergey | https://t.me/poxek"
echo 

echo "Install prerequirements..."
sudo apt update &> /dev/null; sudo apt install -y git curl wget &> /dev/null;

if ! command -v go &> /dev/null; then
    echo "Go is not installed. Installing..."

    wget https://golang.org/dl/go1.22.1.linux-amd64.tar.gz

    sudo tar -C /usr/local -xzf go*.linux-amd64.tar.gz

    rm go*.linux-amd64.tar.gz

    echo -e '\n\n\nexport PATH=$PATH:/usr/local/go/bin\nexport PATH="$PATH:$HOME/go/bin"' >> ~/.zshrc

    source ~/.zshrc

    echo -e "Go has been installed successfully: $(go version)\nStarting install..."
else
    echo "Starting install..."
fi

echo "Install deps..."
sudo apt-get install -y libpcap-dev &> /dev/null

echo "Installing tools..."
go install github.com/projectdiscovery/nuclei/v3/cmd/nuclei@latest
go install github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest
go install github.com/projectdiscovery/katana/cmd/katana@latest
go install github.com/projectdiscovery/httpx/cmd/httpx@latest
go install github.com/projectdiscovery/naabu/v2/cmd/naabu@latest
go install github.com/projectdiscovery/interactsh/cmd/interactsh-client@latest
go install github.com/projectdiscovery/dnsx/cmd/dnsx@latest
go install github.com/projectdiscovery/shuffledns/cmd/shuffledns@latest
go install github.com/projectdiscovery/notify/cmd/notify@latest

echo "Install nuclei templates"
cd ~
git clone https://github.com/projectdiscovery/nuclei-templates
git clone https://github.com/projectdiscovery/fuzzing-templates

echo "Add cron jobs for updating fuzzing & nuclei templates"
## Define the cron job command to check for
update_nuclei_templates="0 */12 * * * cd ~/nuclei-templates && git pull"
update_fuzzing_templates="0 */12 * * * cd ~/fuzzing-templates && git pull"

## Check if the cron job1 exists in the crontab
if crontab -l | grep -qF "$update_nuclei_templates"; then
    echo "The cron job1 exists in the crontab."
else
    echo -e "$update_nuclei_templates\n$update_fuzzing_templates" | crontab -
    echo "Cron joba added."
fi

clear
echo "Thx for using script! tg@poxek"
