//! trybuild compile-fail: at least one GraphQL source is required.

use rtd_graphql_macros::graphql_query;

const Q: &str = graphql_query!();

fn main() {
    let _ = Q;
}
