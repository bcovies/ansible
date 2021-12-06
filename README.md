# ansible
### Repositório para armazenamento de instalação para máquina host.

Há dois OS que podem ser utilizados até então. 

# Centos 8 Stream
Instala:

    - Vagrant com plugin install vagrant-vbguest
    - Virtualbox
    - Nginx
    - Named
    - SSL para nginx 


Selecione o Ip do DNS do seu servidor: 
```
ansible/centos_8_stream/roles/basic/tasks/main.yml
```    

```
- name: "[WORKAROUND (CENTOS 8)]: Altera o DNS da máquina"
   shell: echo "nameserver 192.168.1.200" > /etc/resolv.conf; echo "nameserver 192.168.1.254" >> /etc/resolv.conf;  chattr +i /etc/resolv.conf;

```
Altere as configurações de SSL e locations do NGINX
```    
ansible/centos_8_stream/roles/config/files
```
Para executar as configurações do nginx  (SSL e Locations) utilize somente esse arquivo ao invés do ```provisioning.yml```

```
ansible/centos_8_stream/certificados-nginx.yml
```

Altere as configurações do NAMED EM:

```
ansible/centos_8_stream/roles/named/files
```

# Ubuntu 20.04

Para o ubuntu, basta verificar o arquivo /etc/netplan/xxxx
Adicionar o próprio servidor como nameservers e aplicar patch com netplan apply