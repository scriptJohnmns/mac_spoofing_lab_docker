# docker_server/Dockerfile
FROM ubuntu:latest

# Define variáveis de ambiente para o usuário
ARG USER_NAME=docker_server
ARG USER_UID=1001
ARG USER_GID=1001

# Evita que o apt faça perguntas interativas durante a instalação
ENV DEBIAN_FRONTEND=noninteractive

# Atualiza a lista de pacotes e instala as ferramentas necessárias:
# - net-tools, iproute2, curl: Ferramentas de rede básicas
# - iptables: Para o firewall
# - python3, sudo: Para o script de iptables e permissões
# - openssh-server: O servidor SSH que vamos proteger
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    net-tools \
    iproute2 \
    iptables \
    python3 \
    sudo \
    curl \
    openssh-server \
    && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Cria o grupo e o usuário não-root 'docker_server'
# Este será o usuário que você usará para tentar logar via SSH
# O usuário é adicionado ao grupo 'sudo' e configurado para não pedir senha
RUN groupadd -g ${USER_GID} ${USER_NAME} && \
    useradd -u ${USER_UID} -g ${USER_GID} -m -s /bin/bash ${USER_NAME} && \
    echo "${USER_NAME} ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/${USER_NAME} && \
    chmod 0440 /etc/sudoers.d/${USER_NAME}

# Configurações do Servidor SSH:
# - PermitRootLogin yes: Permite que o root faça login (apenas para teste!)
# - PasswordAuthentication yes: Permite login por senha (mais fácil para o teste)
# - UsePAM no: Desabilita PAM para simplificar, já que não temos um sistema PAM completo.
# - StrictModes no: Evita problemas de permissão com chaves SSH se houver.
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config && \
    sed -i 's/UsePAM yes/UsePAM no/' /etc/ssh/sshd_config && \
    sed -i 's/#StrictModes yes/StrictModes no/' /etc/ssh/sshd_config

# ---- NOVA LINHA DE CORREÇÃO: Cria o diretório /var/run/sshd explicitamente ----
# Alguns sistemas esperam /var/run/sshd e não apenas /run/sshd (que é um link simbólico)
RUN mkdir -p /var/run/sshd

# Define uma senha para o usuário 'docker_server' (para o teste de SSH)
RUN echo "${USER_NAME}:senha123" | chpasswd

# Define o diretório de trabalho padrão para o usuário.
WORKDIR /home/${USER_NAME}

# Copia o script de configuração do IPTables para dentro do container
COPY setup_iptables.sh .
# Garante que o script seja executável
RUN chmod +x setup_iptables.sh

# Gera as chaves SSH do host (essencial para o sshd iniciar)
RUN ssh-keygen -A

# Expõe a porta 22 (SSH)
EXPOSE 22

# O SSHD e o script de IPTables precisam de privilégios de root para funcionar corretamente.
USER root

# ---- NOVA LINHA CMD PARA INICIAR SSHD DE FORMA MAIS ROBUSTA ----
# Garante que o script de iptables seja executado E que o sshd seja o processo principal.
# O 'sh -c' é mais flexível aqui.
CMD ["/bin/sh", "-c", "/home/docker_server/setup_iptables.sh && /usr/sbin/sshd -D"]
