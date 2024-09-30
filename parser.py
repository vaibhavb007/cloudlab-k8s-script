import xml.etree.ElementTree as ET


def get_hostnames_from_xml(f):

    tree = ET.parse(f)
    root = tree.getroot()
    hostnames = set()

    for node in root.findall(".//{http://www.geni.net/resources/rspec/3}login"):
        hostnames.add(node.get("hostname"))

    return list(hostnames)

def main():
    hosts = get_hostnames_from_xml('manifest.xml')
    with open('hosts.txt', 'w') as f:
        for host in hosts:
            f.write('vaibhavb@' + host + '\n')

if __name__ == "__main__":
    main()            