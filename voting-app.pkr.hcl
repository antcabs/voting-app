packer {
  required_plugins {
    docker = {
      version = ">= 1.0.8"
      source  = "github.com/hashicorp/docker"
    }
    ansible = {
      version = ">= 1.1.0"
      source  = "github.com/hashicorp/ansible"
    }
  }
}

# ─────────────────────────────────────────────
# Source : conteneur Docker temporaire (= "VM")
# ─────────────────────────────────────────────
source "docker" "voting_app" {
  # Image de base Ubuntu, comme une vraie VM Ansible
  image  = "ubuntu:22.04"
  commit = true

  # Méta-données Docker inscrites dans l'image finale
  changes = [
    "WORKDIR /app/azure-vote",
    "EXPOSE 80",
    "ENV FLASK_APP=main.py",
    "ENV REDIS=redis",
    "CMD [\"flask\", \"run\", \"--host=0.0.0.0\", \"--port=80\"]"
  ]
}

# ─────────────────────────────────────────────
# Build
# ─────────────────────────────────────────────
build {
  name    = "voting-app"
  sources = ["source.docker.voting_app"]

  # 1. Pré-requis système + Ansible dans le conteneur
  #    ansible-local s'exécute DANS le conteneur, pas besoin
  #    d'Ansible installé sur l'hôte Windows.
  provisioner "shell" {
    inline = [
      "apt-get update -qq",
      "apt-get install -y -qq python3 python3-pip",
      "pip3 install ansible",
      "mkdir -p /tmp/packer-ansible"
    ]
  }

  # 2. Copier les sources de l'app dans le staging directory
  #    Le playbook fait src: './azure-vote' → il cherche ce dossier
  #    dans le répertoire du playbook (/tmp/packer-ansible/).
  provisioner "file" {
    source      = "./azure-vote"
    destination = "/tmp/packer-ansible/azure-vote"
  }

  # 3. ansible-local : exécute le playbook depuis l'intérieur du conteneur.
  #    - inventory_file : mappe le host 'default' → localhost
  #    - role_paths     : charge le dossier roles/ depuis l'hôte
  #    - staging_directory : répertoire de travail dans le conteneur
  provisioner "ansible-local" {
    playbook_file     = "./playbook.yml"
    inventory_file    = "./hosts.ini"
    role_paths        = ["./roles"]
    staging_directory = "/tmp/packer-ansible"
  }

  # 3. Tagger l'image résultante
  post-processor "docker-tag" {
    repository = "voting-app"
    tags       = ["latest"]
  }
}
