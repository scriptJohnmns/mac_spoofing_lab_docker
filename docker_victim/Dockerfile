# docker_victim/Dockerfile
FROM ubuntu:latest

# Instala um pacote básico para que o container não saia imediatamente
# E ferramentas de rede para debugging se precisar
RUN apt-get update && apt-get install -y iputils-ping net-tools && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Comando que mantém o container rodando indefinidamente pois não tem nenhum serviço em exec.
CMD ["tail", "-f", "/dev/null"]
