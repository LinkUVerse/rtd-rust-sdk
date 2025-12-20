# Rtd Rust Sdk

A rust sdk for integrating with the [Rtd blockchain](https://docs.rtd.io/).

## Overview

This repository contains a collection of libraries for integrating with the Rtd blockchain.

A few of the project's high-level goals are as follows:

* **Be modular** - user's should only need to pay the cost (in terms of dependencies/compilation time) for the features that they use.
* **Be light** - strive to have a minimal dependency footprint.
* **Support developers** - provide all needed types, abstractions and APIs to enable developers to build robust applications on Rtd.
* **Support wasm** - where possible, libraries should be usable in wasm environments.

## Crates

In an effort to be modular, functionality is split between a number of crates.

* [`rtd-sdk-types`](crates/rtd-sdk-types)
    [![rtd-sdk-types on crates.io](https://img.shields.io/crates/v/rtd-sdk-types)](https://crates.io/crates/rtd-sdk-types)
    [![Documentation (latest release)](https://img.shields.io/badge/docs-latest-brightgreen)](https://docs.rs/rtd-sdk-types)
    [![Documentation (master)](https://img.shields.io/badge/docs-master-59f)](https://linkulabs.github.io/rtd-rust-sdk/rtd_sdk_types/)
* [`rtd-crypto`](crates/rtd-crypto)
    [![rtd-crypto on crates.io](https://img.shields.io/crates/v/rtd-crypto)](https://crates.io/crates/rtd-crypto)
    [![Documentation (latest release)](https://img.shields.io/badge/docs-latest-brightgreen)](https://docs.rs/rtd-crypto)
    [![Documentation (master)](https://img.shields.io/badge/docs-master-59f)](https://linkulabs.github.io/rtd-rust-sdk/rtd_crypto/)
* [`rtd-rpc`](crates/rtd-rpc)
    [![rtd-rpc on crates.io](https://img.shields.io/crates/v/rtd-rpc)](https://crates.io/crates/rtd-rpc)
    [![Documentation (latest release)](https://img.shields.io/badge/docs-latest-brightgreen)](https://docs.rs/rtd-rpc)
    [![Documentation (master)](https://img.shields.io/badge/docs-master-59f)](https://linkulabs.github.io/rtd-rust-sdk/rtd_rpc/)

## License

This project is available under the terms of the [Apache 2.0 license](LICENSE).
