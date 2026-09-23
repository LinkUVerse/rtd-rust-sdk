# 2026-09 上游 Rust SDK 迁移补充

基线：`MystenLabs/sui-rust-sdk` 的 `788907487b40bc341bd90ee26428c4098fc1e515`。在此仓库的 `feature/rtd-sdk-refresh` 分支操作；原 `run-rename.sh`、`run-rename-patch1.sh` 保留为历史说明，不再直接执行。

## 与旧脚本相比新增的处理

- 遍历所有 UTF-8 文本源码和配置，而不是只改 `.rs/.toml/.md/.yaml/.json/.proto`。包括 GraphQL、测试预期、Makefile、CI、生成的 Rust 文本。
- 递归重命名带品牌的目录和文件，包括新出现的 GraphQL 宏包、protobuf 文件及 `*.fds.bin` 文件名。
- 对 `MystenLabs/mystenlabs` 优先按组织名处理；保护 `suitable` 等普通英语词，避免机械替换破坏正文。
- 对源码中的长 Base64/Base64URL 字符串做保护；随机编码数据可能恰巧含有 `SUI`，替换会破坏 Passkey/BCS 测试向量。
- `*.fds.bin` 是 protobuf 二进制描述符，不能只改文件名。必须从重命名后的 `.proto` 重新生成，使反射包名为 `rtd.*`。
- Bech32 私钥样本的校验和绑定 HRP，`suiprivkey` 不能简单替换前缀；固定样本已按 `rtdprivkey` 重新计算校验和。zkLogin 上游固定证明包含已签名/Base64 编码的 issuer 与 kid，因此测试用 JWK 键仍需匹配原始证明；它们是不可机械改写的历史测试样本，不是 RTD 默认服务地址。
- 原 `rollback.sh` 包含 `git reset --hard` 和 `git clean -fd`，不用于本次迁移。使用 Git 分支审阅或回退。

## 可重现操作

```bash
python3 fork-instruct-sdk/refresh-current-upstream.py
cargo run -p proto-build
cargo fmt --all
cargo fmt --all -- --check
cargo build --workspace --all-features
cargo test --workspace --all-features --no-run
cargo test --workspace --all-features --exclude integration-tests
```

`proto-build` 的改动检测不覆盖尚未暂存的全新生成文件，所以必须检查 `crates/rtd-rpc/src/proto` 的新增文件、删除文件及 `*.fds.bin` 反射包名。完整工作区编译和测试分别核验。`integration-tests` 需要本地主链 `rtd` 可执行文件，待主链 fork 后运行；不能计作已通过。

当前本地结果：`cargo build --workspace --all-features`、`cargo test --workspace --all-features --no-run`、`cargo test --workspace --all-features --exclude integration-tests`、`cargo fmt --all -- --check` 均通过；`rtd.rpc.v2` 和 `rtd.rpc.v2alpha` 的二进制描述符已重新生成并核对包名。全量测试若不排除 `integration-tests`，会因尚无主链 `rtd` 可执行文件而失败，这部分需要主项目 fork 后再验收。固定 zkLogin 证明中的上游 issuer/kid 仅保留于测试样本，正式 RTD 服务地址未由这些样本推定。
