import xml.etree.ElementTree as ET


def get_hostnames_from_xml(f):

    tree = ET.parse(f)
    root = tree.getroot()
    hostnames = []

    for node in root.findall(".//{http://www.geni.net/resources/rspec/3}login"):
        hostnames.append(node.get("hostname"))
        
    # remove duplicates from the list without changing the order
    hostnames = list(dict.fromkeys(hostnames))
    

    return hostnames

def main():
    hosts = get_hostnames_from_xml('manifest.xml')
    with open('hosts.txt', 'w') as f:
        for host in hosts:
            f.write('vaibhavb@' + host + '\n')

if __name__ == "__main__":
    main()            