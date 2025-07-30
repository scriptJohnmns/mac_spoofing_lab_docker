#!/bin/bash
# docker_vuln/setup_iptables.sh

echo "Configurando IPTables para o servidor docker_vuln (SSH)..."

# 1. Limpa todas as regras de firewall existentes (ESSENCIAL PARA GARANTIR UM ESTADO LIMPO)
sudo iptables -F         # Limpa todas as regras das cadeias padrão
sudo iptables -X         # Deleta cadeias não-padrão
sudo iptables -Z         # Zera os contadores de pacotes/bytes

# 2. Permite o tráfego de loopback (comunicação interna do próprio container)
sudo iptables -A INPUT -i lo -j ACCEPT

# 3. Permite o tráfego ICMP (ping) para que você possa testar a conectividade básica
sudo iptables -A INPUT -p icmp -j ACCEPT

# --- REGRA CRUCIAL: Define qual MAC tem permissão para acessar o SSH ---
# Este MAC deve ser o MAC da sua futura máquina 'docker_legit'.
MAC_DA_MAQUINA_LEGITIMA="02:42:0A:0A:00:03" # <-- DEFINA O MAC DA SUA 'docker_legit' AQUI!

echo "MAC permitido para acesso SSH na porta 22: $MAC_DA_MAQUINA_LEGITIMA"

# 4. Permite acesso SSH (porta 22) APENAS se a origem do pacote for o MAC_DA_MAQUINA_LEGITIMA
sudo iptables -A INPUT -p tcp --dport 22 -m mac --mac-source "$MAC_DA_MAQUINA_LEGITIMA" -j ACCEPT

# 5. Permite conexões já estabelecidas (essencial para que as respostas do SSH voltem)
sudo iptables -A INPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT

# 6. REGRA DE BLOQUEIO PADRÃO: Bloqueia TODO o resto do tráfego TCP na porta 22
# Qualquer outro MAC, ou tráfego não explicitamente permitido, será DROPPADO aqui.
sudo iptables -A INPUT -p tcp --dport 22 -j DROP

echo "IPTables configurado com sucesso."

# O 'exec "$@"' no CMD do Dockerfile garante que o sshd seja o processo principal.
# Este script apenas configura e sai.
exec "$@"
