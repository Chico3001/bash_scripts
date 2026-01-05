#!/bin/bash
set -e

if [ $# -eq 0 ]; then
  echo "Uso: $0 usuario"
  exit 1
fi

user="$1"
home="/home/$user"

if getent passwd "$user" > /dev/null; then
  echo "El usuario ya existe"
  exit 0
fi

# Crear usuario y agregar llaves
sudo adduser "$user"
sudo mkdir -p "$home/.ssh"
sudo curl -fsSL "https://github.com/$user.keys" -o "$home/.ssh/authorized_keys" || {
  echo "⚠️ No se pudieron obtener las llaves de GitHub"
}
sudo chown -R "$user:$user" "$home/.ssh"
sudo chmod 700 "$home/.ssh"
sudo chmod 600 "$home/.ssh/authorized_keys"

# Personalización bash
sudo tee "$home/.bashrc.custom" > /dev/null <<'EOF'
# Aliases generales
alias ls='ls -lh --color=auto'
alias cd..='cd ..'
alias chwww='sudo chown www-data:www-data -R /var/www/'
alias cdl='cd /var/log'
alias cdla='cd /var/log/apache2'
alias cdw='cd /var/www'
alias cdena='cd /etc/apache2/sites-enabled'
alias cdava='cd /etc/apache2/sites-available'
EOF

# Cargar bashrc.custom solo si no existe
if ! sudo grep -q bashrc.custom "$home/.bashrc"; then
  sudo tee -a "$home/.bashrc" > /dev/null <<'EOF'
# Cargar personalización
if [ -f ~/.bashrc.custom ]; then
  . ~/.bashrc.custom
fi
EOF
fi

sudo chown "$user:$user" "$home/.bashrc" "$home/.bashrc.custom"

echo "✅ Usuario $user creado y configurado correctamente"
