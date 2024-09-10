import os
import paramiko
from paramiko import Ed25519Key
import parser

username = "vaibhavb"
key_path = "/home/vpb/.ssh/id_ed25519"
private_key = Ed25519Key(filename=key_path)

def getClient(hostname) -> paramiko.SSHClient :
    client = paramiko.SSHClient()
    client.set_missing_host_key_policy(paramiko.AutoAddPolicy())
    client.connect(hostname, username = username, pkey=private_key)

    return client


def main():
    hosts = parser.get_hostnames_from_xml('manifest.xml')
    
    for host in hosts:
        client = getClient(host)
        print(host)

        _, stdout, stderr = client.exec_command("bash /proj/krios-PG0/cloudlab-k8s-script/miniconda-install.sh")
        output = stdout.read().decode('utf-8')
        error = stderr.read().decode('utf-8')

        print("miniconda done", output, error)

        _, stdout, stderr = client.exec_command("conda init")

        _, stdout, stderr = client.exec_command("bash /proj/krios-PG0/cloudlab-k8s-script/install-go.sh")
        output = stdout.read().decode('utf-8')
        error = stderr.read().decode('utf-8')

        print("go done", output, error)

        _, stdout, stderr = client.exec_command("bash /proj/krios-PG0/cloudlab-k8s-script/install-docker.sh")
        output = stdout.read().decode('utf-8')
        error = stderr.read().decode('utf-8')

        print("docker done", output, error)

        _, stdout, stderr = client.exec_command("bash /proj/krios-PG0/cloudlab-k8s-script/install-k8s.sh")
        output = stdout.read().decode('utf-8')
        error = stderr.read().decode('utf-8')

        print("k8s done", output, error)

        # print(output, error)


    

if __name__ == "__main__":
    main()