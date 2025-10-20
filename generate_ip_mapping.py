import argparse
import json
import xml.etree.ElementTree as ET
from typing import Dict


def build_ip_mapping(manifest_path: str) -> Dict[str, str]:
    """
    Extract hostname to IPv4 mappings from the CloudLab manifest and normalize host casing.
    """
    tree = ET.parse(manifest_path)
    root = tree.getroot()
    namespace = {'geni': 'http://www.geni.net/resources/rspec/3'}
    mapping: Dict[str, str] = {}

    for host in root.findall(".//geni:host", namespace):
        hostname = host.get("name")
        ipv4 = host.get("ipv4")
        if not hostname or not ipv4:
            continue

        normalized_hostname = hostname.lower()
        mapping[normalized_hostname] = ipv4

    if not mapping:
        raise ValueError(f"No host entries located in manifest '{manifest_path}'.")

    # Return mapping sorted by hostname for deterministic output.
    return dict(sorted(mapping.items(), key=lambda item: item[0]))


def write_mapping_file(mapping: Dict[str, str], output_path: str) -> None:
    with open(output_path, "w", encoding="utf-8") as fh:
        json.dump(mapping, fh, indent=4)
        fh.write("\n")


def main() -> None:
    parser = argparse.ArgumentParser(
        description="Generate a hostname to IPv4 mapping from a CloudLab manifest."
    )
    parser.add_argument(
        "-m",
        "--manifest",
        default="manifest.xml",
        help="Path to the manifest XML file (default: manifest.xml)",
    )
    parser.add_argument(
        "-o",
        "--output",
        default="ip_mapping.json",
        help="Destination file for the generated mapping (default: ip_mapping.json)",
    )

    args = parser.parse_args()

    mapping = build_ip_mapping(args.manifest)
    write_mapping_file(mapping, args.output)


if __name__ == "__main__":
    main()
