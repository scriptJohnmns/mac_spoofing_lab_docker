# 👻 MAC Spoofing Lab com Docker 🛠️

Este repositório contém um laboratório prático para demonstrar como o **MAC Spoofing** pode burlar firewalls que se baseiam apenas no endereço MAC (Camada 2). 🚧🔒

**O que você vai encontrar:**
* **`docker_attacker/`**: Container com um script Python para mudar o MAC. 🐍
* **`docker_server/`**: Servidor com SSH e firewall IPTables (filtrando por MAC). 🛡️
* **`docker_victim/`**: Vítima simples para ter o MAC "roubado". 🤫

**Tecnologias Usadas:** Python, Docker, IPTables. ✨

## Estrutura do Repositório 📁

```
.
├── docker_attacker/
│   ├── Dockerfile
│   └── mac_changer_script.py
├── docker_server/
│   ├── Dockerfile
│   └── setup_iptables.sh
├── docker_victim/
│   └── Dockerfile
└── README.md
```

## Como Rodar o Lab 🚀

1.  Garanta que o Docker esteja instalado. ✅
2.  Clone este repositório. 🧑‍💻
3.  Siga o passo a passo detalhado no nosso artigo para construir as imagens, iniciar os containers e executar o ataque. 📝
    * [**Link para o Artigo Completo**](https://scriptjohn.com.br/postagens/mac_spoofer_v1/) 🔗

## Limpeza 🧹

Para remover os containers e a rede após os testes:
```shell
docker stop docker_server docker_simple_victim docker_attacker
docker rm docker_server docker_simple_victim docker_attacker
docker network rm mac_test_net
```
Licença 📜
Este projeto está sob a Licença MIT. Veja o arquivo LICENSE para mais detalhes. 🤝
