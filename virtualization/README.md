# Віртуалізація - завдання

## Task 1 (✦)
1. Install VirtualBox on your computer.
    - Встановив VirtualBox за офіційною інстукцією: https://www.virtualbox.org/wiki/Linux_Downloads
2. Download the Ubuntu Server ISO image.
    - Завантажив Ubuntu Server iso за посиланням: https://ubuntu.com/download/server
3. Create a virtual machine in VirtualBox using the Ubuntu Server image.
    - Створив віртуальну машину: 
4. Forward a port (e.g., 2222 on your host) to port 22 (SSH) of the virtual machine.
    - Переадресував порт 2222 на хості на порт 22 на віртуальній машині
5. Connect to the virtual machine via SSH from the host machine (e.g., using PuTTY or Windows CLI).
- Піключився через ssh:
    
6. Log in to the system and create a file in your home directory (e.g., task1.txt) with the following content:
Hello from the Ubuntu Server!
    - Через підключення через ssh використав nano для створення файлу з вмістом:

        ```shell
        nazar@usrv:~$ nano task1.txt
        nazar@usrv:~$ cat task1.txt 
        Hello from the Ubuntu Server!
        ```

## Task 2 (✦✦)
1. Install Vagrant.
    - Встановив Vagrant за офіційною інстукцією за посиланням: https://developer.hashicorp.com/vagrant/install#linux

    ```shell
    nazar@hackathon:~$ vagrant --version
    Vagrant 2.4.9
    ```
2. Write a Vagrantfile to create a virtual machine based on Ubuntu Server.
    - Створив

3. Configure Vagrant to automatically forward port 2222 to port 22 on the virtual machine.
4. Run vagrant up to create and launch the virtual machine.
5. Use vagrant ssh to log in to the virtual machine.
6. Inside the VM, create a file named vagrant_task.txt in the home directory with the following content:
This VM was created by Vagrant!