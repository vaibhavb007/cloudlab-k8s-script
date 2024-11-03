import xml.etree.ElementTree as ET

def parse_xml(file_path):
    # Parse the XML file
    tree = ET.parse(file_path)
    root = tree.getroot()

    # Check if namespaces are used
    namespaces = {'ns': root.tag.split('}')[0].strip('{')} if '}' in root.tag else {}

    # Iterate over each 'host' element and extract 'name' and 'ipv4' attributes
    for host in root.findall('.//ns:host', namespaces):
        hostname = host.get('name', 'N/A')
        ipv4_address = host.get('ipv4', 'N/A')
        
        print(f"Host Name: {hostname}, IPv4 Address: {ipv4_address}")

# Path to your XML file
file_path = 'manifest.xml'

# Call the function with the path to your XML file
parse_xml(file_path)