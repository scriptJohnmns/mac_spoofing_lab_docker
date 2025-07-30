# docker_attack/Dockerfile
# Usa a imagem base do Ubuntu na versão 'rolling'
FROM ubuntu

# Define variáveis de ambiente para o usuário
ARG USER_NAME=docker_attacker
ARG USER_UID=1001
ARG USER_GID=1001

# Evita que o apt faça perguntas interativas durante a instalação
ENV DEBIAN_FRONTEND=noninteractive

# Atualiza a lista de pacotes e instala as ferramentas CLI que você precisa
# Inclui 'sudo' para o usuário não-root poder executar comandos como root
# ADICIONADO: arp-scan, nmap (para descoberta de rede) e openssh-client (para SSH)
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    htop \
    curl \
    git \
    sudo \
    python3 \
    python3-pip \
    net-tools \
    iproute2 \
    arp-scan \
    nmap \
    openssh-client \
    && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Cria o grupo e o usuário não-root com os IDs especificados
# Adiciona o usuário ao grupo 'sudo' e configura para não pedir senha ao usar sudo
RUN groupadd -g ${USER_GID} ${USER_NAME} && \
    useradd -u ${USER_UID} -g ${USER_GID} -m -s /bin/bash ${USER_NAME} && \
    echo "${USER_NAME} ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/${USER_NAME} && \
    chmod 0440 /etc/sudoers.d/${USER_NAME}

# Define o diretório de trabalho padrão para o usuário não-root
WORKDIR /home/${USER_NAME}

# Copia o script MAC changer para o diretório de trabalho do usuário
# Certifique-se de que seu script Python esteja no mesmo diretório que este Dockerfile
COPY mac_changer_script.py .

# Troca para o usuário não-root.
USER ${USER_NAME}

# Comando padrão que será executado quando o contêiner iniciar sem um comando específico.
# Isso te dá acesso direto ao shell Bash do 'meuusuario'.
CMD ["bash"]
