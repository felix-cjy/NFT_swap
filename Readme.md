## Foundry

**Foundry is a blazing fast, portable and modular toolkit for Ethereum application development written in Rust.**

Foundry consists of:

- **Forge**: Ethereum testing framework (like Truffle, Hardhat and DappTools).
- **Cast**: Swiss army knife for interacting with EVM smart contracts, sending transactions and getting chain data.
- **Anvil**: Local Ethereum node, akin to Ganache, Hardhat Network.
- **Chisel**: Fast, utilitarian, and verbose solidity REPL.

## Documentation

https://book.getfoundry.sh/

## Usage

### Build

```shell
$ forge build
```

### Test

```shell
$ forge test
```

### Format

```shell
$ forge fmt
```

### Gas Snapshots

```shell
$ forge snapshot
```

### Anvil

```shell
$ anvil
```

### Deploy

```shell
$ forge script script/Counter.s.sol:CounterScript --rpc-url <your_rpc_url> --private-key <your_private_key>
```

### Cast

```shell
$ cast <subcommand>
```

### Help

```shell
$ forge --help
$ anvil --help
$ cast --help
```

## TinTin 训练营

学号 135

【学员手册】https://attractive-spade-1e3.notion.site/3c55c15d535c43f7a236183af40cf76b?pvs=4
课前学习资料：https://attractive-spade-1e3.notion.site/dff0bb9eaf7645e2b684c99f4e97c3a2?pvs=4

1. 它首先检查是否设置了 `FOUNDRY_BIN` 环境变量。
2. 如果没有设置，它会尝试在 PATH 中查找 `forge`。
3. 如果还是找不到，它会使用一个默认路径（`$(HOME)/.foundry/bin`）。
4. 用户可以通过设置 `FOUNDRY_BIN` 环境变量来指定自定义路径。

使用方法：

1. 对于大多数用户，如果 Foundry 工具在 PATH 中，他们不需要做任何特殊设置就可以使用这个 Makefile。

2. 对于像您这样有自定义安装路径的用户，可以在运行 make 命令之前设置环境变量：

   ```bash
   export FOUNDRY_BIN=/c/Users/UserName/.foundry/bin
   make build
   ```

   或者在同一行中设置：

   ```bash
   FOUNDRY_BIN=/c/Users/UserName/.foundry/bin make build
   ```

3. 您可以将这个环境变量设置添加到您的 shell 配置文件中（如 `.bashrc` 或 `.bash_profile`），这样就不需要每次都手动设置。

如果您遇到权限问题，可能需要给 Makefile 添加执行权限：

```bash
chmod +x Makefile
```
