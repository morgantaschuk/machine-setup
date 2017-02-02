#!/bin/bash

set -euo pipefail

# For when I get a new (OICR) desktop and need to
# install all basic software
# Add mount points
# create ssh keys
# clean up the cruft (games, unused directories)


echo "SETUP~Starting setup."

#adding repository for sublime 3
sudo add-apt-repository -y ppa:webupd8team/sublime-text-3
#adding repository for chrome
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
sudo sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list'
sudo apt-get update

echo "SETUP~Installing basic stuff (vim, screen, git, aptitude, sublime 3, chrome)"
sudo apt-get install \
	vim \
	screen \
	git \
	aptitude \
	sublime-text \
	google-chrome-stable

echo "SETUP~Removing games"
sudo apt-get remove --purge gnome-mines aisleriot gnome-mahjongg gnome-sudoku
sudo apt-get autoremove

echo "SETUP~Cleaning up home directory"
rm -r Music/ Public/ Templates/ Videos examples.desktop

echo "SETUP~Make the usual directories: git, bin, Programs"
mkdir git bin Programs

echo "SETUP~Configure git editor, name and email"
git config --global core.editor "vim"
git config --global user.name "Morgan Taschuk"
git config --global user.email "morgan.taschuk@oicr.on.ca"


echo "SETUP~Mounting the H and R Drives."
sudo apt-get install cifs-utils
sudo mkdir /media/H /media/R
echo "//fileshare1.ad.oicr.on.ca/homefolders/corpusers /media/H cifs uid=mtaschuk,credentials=/home/mtaschuk/.smbcredentials,iocharset=utf8,sec=ntlm 0 0" | sudo tee --append /etc/fstab
echo "//fileshare2.ad.oicr.on.ca/oicr /media/R cifs uid=mtaschuk,credentials=/home/mtaschuk/.smbcredentials,iocharset=utf8,sec=ntlm 0 0" | sudo tee --append /etc/fstab

cat "username=mtaschuk" > ~/.smbcredentials
cat "password=" >> ~/.smbcredentials
echo "SETUP~Enter your Samba password."
vim ~/.smbcredentials
chmod 600 ~/.smbcredentials
sudo mount -a
ln -s /media/H/mtaschuk HDrive
ln -a /media/R RDrive


echo "SETUP~Setting up login to cluster hn.hpc"
ssh-keygen
cat ~/.ssh/id_rsa.pub | ssh hn.hpc.oicr.on.ca 'cat >> .ssh/authorized_keys'
echo "SETUP~Public key (copy into git repositories):"
cat ~/.ssh/id_rsa.pub

echo "SETUP~Opening browser to add keys to github. Close browser to continue." 
firefox --new-tab https://github.com/settings/keys
echo "SETUP~Opening browser to add keys to git.oicr.on.ca. Close browser to continue." 
firefox --new-tab https://git.oicr.on.ca/~mtaschuk/keys/new


echo "SETUP~Installing team messaging"
apt-get install \
	pidgin
echo "SETUP~Opening website that has IM setup instructions. Close browser to continue."
firefox --new-tab https://connect.oicr.on.ca/it/Lists/FAQ/DispForm.aspx?ID=3&Source=https%3A%2F%2Fconnect.oicr.on.ca%2Fit%2FSitePages%2FKnowledge%2520Base.aspx&ContentTypeId=0x010093843C9A0B8C4D4DA449C8E4A2344403

echo "SETUP~Install programming tools"
sudo apt install r-base-core
wget -O rstudio.deb https://download1.rstudio.org/rstudio-1.0.136-amd64.deb
sudo dpkg -i rstudio.deb && sudo apt-get install -f

sudo apt-get install gimp
