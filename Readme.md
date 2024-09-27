## Foundry

```bash
$ forge test --gas-report
[⠆] Compiling...
No files changed, compilation skipped

Ran 4 tests for test/NFTswapTest.t.sol:NFTswapTest
[PASS] testList() (gas: 261632)
[PASS] testPurchase() (gas: 353766)
[PASS] testRevoke() (gas: 307612)
[PASS] testUpdate() (gas: 297348)
Suite result: ok. 4 passed; 0 failed; 0 skipped; finished in 6.22ms (12.30ms CPU time)

Ran 1 test for test/NFTswapIntegration.t.sol:NFTswapIntegrationTest
[PASS] testFullFlow() (gas: 698294)
Suite result: ok. 1 passed; 0 failed; 0 skipped; finished in 8.90ms (5.03ms CPU time)| src/NFTswap.sol:NFTswap contract |                 |        |        |        |
     |
|----------------------------------|-----------------|--------|--------|--------|---------|
| Deployment Cost                  | Deployment Size |        |        |        |
     |
| 618040                           | 2647            |        |        |        |
     |
| Function Name                    | min             | avg    | median | max    | # calls |
| list                             | 91462           | 105712 | 108562 | 108562 | 6
     |
| orders                           | 787             | 787    | 787    | 787    | 2
     |
| purchase                         | 24218           | 63754  | 66385  | 98030  | 4
     |
| revoke                           | 62230           | 62230  | 62230  | 62230  | 1
     |
| update                           | 24510           | 33058  | 37333  | 37333  | 3
     |


| test/FLX.sol:FLX contract |                 |       |        |       |         |
|---------------------------|-----------------|-------|--------|-------|---------|
| Deployment Cost           | Deployment Size |       |        |       |         |
| 1081022                   | 4995            |       |        |       |         |
| Function Name             | min             | avg   | median | max   | # calls |
| approve                   | 48695           | 48695 | 48695  | 48695 | 6       |
| getApproved               | 4826            | 4826  | 4826   | 4826  | 6       |
| mint                      | 76113           | 90363 | 93213  | 93213 | 6       |
| ownerOf                   | 624             | 1714  | 2624   | 2624  | 11      |




Ran 2 test suites in 31.89ms (15.12ms CPU time): 5 tests passed, 0 failed, 0 skipped
(5 total tests)

```

### Build

```shell
$ forge build
```

### Test

```shell
$ forge test
```

### Gas Snapshots

```shell
$ forge snapshot
```

### Anvil

```shell
$ anvil
```
