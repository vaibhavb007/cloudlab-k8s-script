import argparse
import xml.etree.ElementTree as ET


def get_hostnames_from_xml(f):
    ns = {'geni': 'http://www.geni.net/resources/rspec/3'}
    tree = ET.parse(f)
    root = tree.getroot()
    hostnames = []
    for node in root.findall(".//geni:login", ns):
        hostnames.append(node.get("hostname"))
    hostnames = list(dict.fromkeys(hostnames))
    return hostnames


def generate_hosts(manifest, username):
    hosts = get_hostnames_from_xml(manifest)
    lines = [f"{username}@{host}" for host in hosts]
    data = "\r\n".join(lines) + "\r\n" if lines else ""
    with open('hosts.txt', 'wb') as fh:
        fh.write(data.encode('utf-8'))


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Generate hosts.txt entries from a CloudLab manifest.')
    parser.add_argument('-m', '--manifest', default='manifest.xml',
                        help='Path to the manifest XML file (default: manifest.xml)')
    parser.add_argument('-u', '--username', required=True,
                        help='CloudLab username to prepend to each host entry')
    args = parser.parse_args()
    generate_hosts(args.manifest, args.username)
