import argparse
import json
import xml.etree.ElementTree as ET
from typing import Dict, List, Tuple

NS = {"geni": "http://www.geni.net/resources/rspec/3"}


def _format_mac(raw: str) -> str:
    if not raw or len(raw) != 12:
        return raw
    return ":".join(raw[i:i + 2] for i in range(0, 12, 2)).lower()


def _interface_owner(client_id: str) -> str:
    return client_id.split(":", 1)[0] if ":" in client_id else client_id


def build_interface_mapping(manifest_path: str) -> Dict[str, dict]:
    tree = ET.parse(manifest_path)
    root = tree.getroot()

    iface_lookup: Dict[str, Tuple[str, str]] = {}
    nodes: Dict[str, dict] = {}

    for node in root.findall("geni:node", NS):
        node_id = node.get("client_id")
        if not node_id:
            continue

        host_el = node.find("geni:host", NS)
        login_el = node.find("geni:services/geni:login", NS)
        control = {
            "hostname": login_el.get("hostname") if login_el is not None else None,
            "ipv4": host_el.get("ipv4") if host_el is not None else None,
            "fqdn": host_el.get("name") if host_el is not None else None,
        }

        interfaces: List[dict] = []
        for iface in node.findall("geni:interface", NS):
            iface_id = iface.get("client_id")
            ip_el = iface.find("geni:ip", NS)
            ip = ip_el.get("address") if ip_el is not None else None
            netmask = ip_el.get("netmask") if ip_el is not None else None
            entry = {
                "id": iface_id,
                "mac": _format_mac(iface.get("mac_address", "")),
                "ip": ip,
                "netmask": netmask,
                "link": None,
                "vlan": None,
                "peer_node": None,
                "peer_interface": None,
                "peer_ip": None,
            }
            interfaces.append(entry)
            if iface_id and ip is not None:
                iface_lookup[iface_id] = (node_id, ip)

        nodes[node_id] = {"control": control, "interfaces": interfaces}

    for link in root.findall("geni:link", NS):
        link_id = link.get("client_id")
        vlan = link.get("vlantag")
        endpoints = [ref.get("client_id") for ref in link.findall("geni:interface_ref", NS)]
        if len(endpoints) != 2:
            continue
        a, b = endpoints
        for self_id, peer_id in ((a, b), (b, a)):
            owner = _interface_owner(self_id)
            node_entry = nodes.get(owner)
            if not node_entry:
                continue
            for iface in node_entry["interfaces"]:
                if iface["id"] == self_id:
                    iface["link"] = link_id
                    iface["vlan"] = vlan
                    peer_owner, peer_ip = iface_lookup.get(peer_id, (None, None))
                    iface["peer_node"] = peer_owner
                    iface["peer_interface"] = peer_id
                    iface["peer_ip"] = peer_ip
                    break

    for entry in nodes.values():
        entry["interfaces"].sort(key=lambda i: i["id"] or "")

    return dict(sorted(nodes.items(), key=lambda kv: (len(kv[0]), kv[0])))


def main() -> None:
    parser = argparse.ArgumentParser(
        description="Generate a per-node network interface mapping from a CloudLab manifest."
    )
    parser.add_argument(
        "-m", "--manifest", default="manifest.xml",
        help="Path to the manifest XML file (default: manifest.xml)",
    )
    parser.add_argument(
        "-o", "--output", default="interface_mapping.json",
        help="Destination file for the generated mapping (default: interface_mapping.json)",
    )
    args = parser.parse_args()

    mapping = build_interface_mapping(args.manifest)
    with open(args.output, "w", encoding="utf-8") as fh:
        json.dump(mapping, fh, indent=4)
        fh.write("\n")


if __name__ == "__main__":
    main()
