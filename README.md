## Hash Based List

This is a simple Smart Contract to implement a list based on a hashed namespace and IDs. The list is designed to have a low gas cost, making it efficient for storing and retrieving data.

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

### Default Anvil Test Chain

``` bash
anvil --accounts $ACCOUNT_NUMBER --mnemonic $MNEMONIC --hardfork $HARDFORK --port $PORT --chain-id $CHAIN_ID --config-out $ANVIL_CONFIG_OUT
```

### Help

```shell
$ forge --help
$ anvil --help
$ cast --help
```
