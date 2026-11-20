//! trybuild compile-fail: a malformed GraphQL document is rejected.

use rtd_graphql_macros::graphql_query;

const Q: &str = graphql_query!("query { chainIdentifier");

fn main() {
    let _ = Q;
}
