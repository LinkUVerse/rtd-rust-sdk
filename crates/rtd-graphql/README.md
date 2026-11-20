# rtd-graphql

[![rtd-graphql on crates.io](https://img.shields.io/crates/v/rtd-graphql)](https://crates.io/crates/rtd-graphql)
[![Documentation (latest release)](https://img.shields.io/badge/docs-latest-brightgreen)](https://docs.rs/rtd-graphql)
[![Documentation (master)](https://img.shields.io/badge/docs-master-59f)](https://linkuverse.github.io/rtd-rust-sdk/rtd_graphql/)

A Rust client for interacting with the Rtd blockchain via its GraphQL API.
Provides typed methods for querying chain state, objects, transactions,
checkpoints, epochs, executing transactions, and more. For custom queries,
the companion [`rtd-graphql-macros`](https://crates.io/crates/rtd-graphql-macros)
crate offers `#[derive(Response)]` for ergonomic, compile-time validated
response deserialization.
