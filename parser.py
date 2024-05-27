import xml.etree.ElementTree as ET


def get_hostnames_from_xml(f):

    tree = ET.parse(f)
    root = tree.getroot()
    hostnames = set()

    for node in root.findall(".//{http://www.geni.net/resources/rspec/3}login"):
        hostnames.add(node.get("hostname"))

    return list(hostnames)



f = 'manifest.xml'

hostnames = get_hostnames_from_xml(f)
print(hostnames)