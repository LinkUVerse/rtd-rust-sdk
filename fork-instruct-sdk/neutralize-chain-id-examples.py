#!/usr/bin/env python3
"""Replace upstream network IDs in documentation and extraction-only tests."""

from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
CHANGES = (
    (
        "crates/rtd-graphql/src/client/chain.rs",
        'Get the chain identifier (e.g., "35834a8a" for mainnet).',
        "Get the connected network's chain identifier (its genesis checkpoint digest).",
        1,
    ),
    (
        "crates/rtd-graphql-macros/tests/extraction_test.rs",
        '"4c78adac"',
        '"test-chain-identifier"',
        7,
    ),
)


def main() -> None:
    for relative_path, old, new, expected_count in CHANGES:
        path = ROOT / relative_path
        source = path.read_text()
        count = source.count(old)
        if count == 0 and source.count(new) == expected_count:
            continue
        if count != expected_count:
            raise SystemExit(f"Unexpected upstream chain ID examples in {relative_path}: {count}")
        path.write_text(source.replace(old, new))
    print("Chain ID examples contain no upstream network constants")


if __name__ == "__main__":
    main()
