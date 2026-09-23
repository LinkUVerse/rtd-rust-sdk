#!/usr/bin/env python3
"""Rebrand the current sui-rust-sdk checkout in place, without touching history.

The original run-rename.sh only covered a few extensions and file names.  This
script covers Rust sources, protobufs, generated text, fixtures, manifests,
workflows and path components.  Binary protobuf descriptors are regenerated
with `cargo run -p proto-build` after this step; they are never byte-edited.
"""

from __future__ import annotations

import re
import subprocess
from pathlib import Path


ROOT = Path(__file__).resolve().parent.parent
EXCLUDED = {".git", "target", "fork-instruct-sdk"}
BINARY_SUFFIXES = {".bin", ".bcs", ".chk", ".png", ".jpg", ".jpeg", ".webp", ".wasm", ".pdf"}
ENCODED_LITERAL = re.compile(r'''(?P<q>["'])(?P<data>[A-Za-z0-9_+\-/]{80,}={0,2})(?P=q)''')


def replace_brand(value: str) -> str:
    # Bech32 checksum commits to its HRP.  Recompute the pinned vector once;
    # replacing only its text prefix would create an invalid private key.
    value = value.replace(
        "suiprivkey1qzdlfxn2qa2lj5uprl8pyhexs02sg2wrhdy7qaq50cqgnffw4c2477kg9h3",
        "rtdprivkey1qzdlfxn2qa2lj5uprl8pyhexs02sg2wrhdy7qaq50cqgnffw4c247cdptmr",
    )
    value = value.replace(
        "rtdprivkey1qzdlfxn2qa2lj5uprl8pyhexs02sg2wrhdy7qaq50cqgnffw4c2477kg9h3",
        "rtdprivkey1qzdlfxn2qa2lj5uprl8pyhexs02sg2wrhdy7qaq50cqgnffw4c247cdptmr",
    )
    # Longest names first.  The earlier SDK used these package/URL spellings.
    value = value.replace("MystenLabs", "LinkUVerse")
    value = value.replace("mystenlabs", "linkuverse")
    value = value.replace("Mysten", "LinkU")
    value = value.replace("mysten", "linku")
    value = value.replace("SUI", "RTD")
    value = re.sub(r"Sui(?!t(?:e|able|ability|s)?\b)", "Rtd", value)
    value = value.replace("notsui", "notrtd")  # Invalid-HRP test value is still chain-branded.
    # Avoid corrupting ordinary English words such as pursuit and suitable.
    value = re.sub(r"(?<![A-Za-z])sui(?!t(?:e|able|ability|s)?\b|cid|ng\b)", "rtd", value)
    return value


def replace_line(line: str) -> str:
    # A long encoded literal inside a Rust source line is still data, not
    # prose.  In particular, a Passkey fixture happened to contain "SUI"
    # coincidentally; editing those bytes made BCS decoding fail.
    protected: dict[str, str] = {}

    def stash(match: re.Match[str]) -> str:
        marker = f"__ENCODED_LITERAL_{len(protected)}__"
        protected[marker] = match.group(0)
        return marker

    out = ENCODED_LITERAL.sub(stash, line)
    out = replace_brand(out)
    for marker, literal in protected.items():
        out = out.replace(marker, literal)
    return out


def main() -> None:
    if subprocess.check_output(["git", "-C", str(ROOT), "rev-parse", "--show-toplevel"], text=True).strip() != str(ROOT):
        raise SystemExit("Run only inside the SDK checkout")
    if not (ROOT / "crates/sui-sdk-types/Cargo.toml").exists() and not (ROOT / "crates/rtd-sdk-types/Cargo.toml").exists():
        raise SystemExit("Unexpected SDK layout")

    edited = 0
    files = sorted((p for p in ROOT.rglob("*") if p.is_file() and not EXCLUDED.intersection(p.relative_to(ROOT).parts)))
    for path in files:
        if path.suffix.lower() in BINARY_SUFFIXES:
            continue
        raw = path.read_bytes()
        if b"\0" in raw:
            continue
        try:
            old = raw.decode("utf-8")
        except UnicodeDecodeError:
            continue
        new = "".join(
            line if len(line.strip()) > 256 and re.fullmatch(r"[A-Za-z0-9+/=]+", line.strip())
            else replace_line(line)
            for line in old.splitlines(keepends=True)
        )
        if new != old:
            path.write_bytes(new.encode("utf-8"))
            edited += 1

    renamed = 0
    paths = sorted((p for p in ROOT.rglob("*") if not EXCLUDED.intersection(p.relative_to(ROOT).parts)), key=lambda p: (len(p.relative_to(ROOT).parts), str(p)), reverse=True)
    for path in paths:
        if not path.exists():
            continue
        name = replace_brand(path.name)
        if name == path.name:
            continue
        destination = path.with_name(name)
        if destination.exists():
            raise SystemExit(f"Path collision: {path} -> {destination}")
        path.rename(destination)
        renamed += 1

    # These pinned zkLogin proofs contain signed/base64-encoded issuer and
    # key-id claims from the upstream regression fixture.  Their JWK lookup
    # keys must match the immutable proof, not a renamed display string.
    zk_test = ROOT / "crates/rtd-crypto/src/zklogin/tests.rs"
    if zk_test.is_file():
        content = zk_test.read_text()
        content = content.replace("https://oauth.rtd.io", "https://oauth.sui.io")
        content = content.replace("https://jwt-tester.linkuverse.com", "https://jwt-tester.mystenlabs.com")
        content = content.replace("rtd-key-id", "sui-key-id")
        zk_test.write_text(content)

    print(f"Rebranded {edited} UTF-8 files and renamed {renamed} paths")
    print("Next: regenerate protobuf bindings/descriptors, then cargo build --workspace --all-features")


if __name__ == "__main__":
    main()
