#!/usr/bin/python3

import subprocess
import argparse

# Usando argparser para obter argumentos de linha de comando do usr
def get_arguments():
    parser = argparse.ArgumentParser(
    prog='MAC CHANGER V1',
    description='Script que altera o MAC address do Linux'
)

    parser.add_argument('-i', '--interface',
                        type=str,
                        dest='interface',
                        help='Nome da Interface de rede',
                        required=True
                        )
    parser.add_argument('-m', '--mac',
                        type=str,
                        dest='new_mac',
                        help='Novo MAC Address',
                        required=True
                        )
    
    return parser.parse_args() # Aqui e processado a linha de comando


# Funcao principal para alterar MAC usando subprocess em lista
def change_mac(interface, new_mac):
    print(f"[+] Alterando MAC address da interface {interface} para {new_mac}")
    subprocess.call(["ifconfig", interface,"down"])
    subprocess.call(["ifconfig", interface,"hw","ether", new_mac])
    subprocess.call(["ifconfig",interface,"up"])

if __name__=="__main__":

    args = get_arguments()

    change_mac(args.interface, args.new_mac)


