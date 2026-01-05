#!/bin/bash

if [ $# -eq 0 ]; then
  echo "Uso: $0 usuario"
  exit 1
fi

user=$1

# Agrega usuario nuevo
sudo adduser $1
sudo mkdir /home/$user/.ssh
sudo touch /home/$user/.ssh/authorized_keys
sudo chown -R $user: /home/$user/.ssh
sudo chmod -R 600 /home/$user/.ssh

# Agrega personalizacion
echo "# General shortcut aliases" >> /home/$user/.bashrc.custom
echo "alias ls='ls -lh --color=auto'" >> /home/$user/.bashrc.custom
echo "alias cd..='cd ..'" >> /home/$user/.bashrc.custom
echo "alias chwww='sudo chown www-data:www-data -R /var/www/'" >> /home/$user/.bashrc.custom
echo "alias cdl='cd /var/log'" >> /home/$user/.bashrc.custom
echo "alias cdla='cd /var/log/apache2'" >> /home/$user/.bashrc.custom
echo "alias cdw='cd /var/www'" >> /home/$user/.bashrc.custom
echo "alias cdena='cd /etc/apache2/sites-enabled'" >> /home/$user/.bashrc.custom
echo "alias cdava='cd /etc/apache2/sites-available'" >> /home/$user/.bashrc.custom

echo "# Custom commands" >> /home/$user/.bashrc
echo "if [ -f ~/.bashrc.custom ]; then" >> /home/$user/.bashrc
echo "    . ~/.bashrc.custom" >> /home/$user/.bashrc
echo "fi" >> /home/$user/.bashrc
