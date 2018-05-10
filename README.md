---
fip: 1
title: FRC-001 Value Transfer Standard
author: Jonathan Yan <jonathan@fa.biz>
type: Standards Track
category: FRC
status: Draft
created: 2018-05-10
---

## Simple Summary

A standard interface for smart contract coins.


## Abstract

The following standard allows for the implementation of a standard API for coins from/to smart contracts.
This standard provides basic functionality to transfer coins, as well as interact with smart contract.


## Motivation

A standard interface allows any Coins on Fabcoin to be re-used by other applications: from wallets to decentralized exchanges.


## Specification

## Coin
### Methods

**NOTE**: Callers MUST handle `false` from `returns (bool success)`.  Callers MUST NOT assume that `false` is never returned!



``` js
function deposit(uint256 coins)  public returns (bool success);
    function depositTo(address to, uint256 coins)  public returns (bool success);
    function withdrawRequest(uint256 coins)  public returns (uint256 serialNumber);
    function withdrawConfirm(uint256 serailNumber, uint256 coins)  public returns (bool success);
    function withdrawCancel(uint256 serailNumber)  public returns (bool success);
```


#### deposit

Transfers `_coins` amount of Coins from sender to address contract, and MUST fire the `DepositEvent` event.

``` js
function deposit(uint256 _coins)  public returns (bool success)
```


#### depositTo

Transfers `_coins` amount of Coins from sender to `_to` address , and MUST fire the `DepositEvent` event.

``` js
function depositTo(address _to, uint256 _coins)  public returns (bool success)
```


#### withdrawRequest

Withdraw request `_coins` amount of Coins from contract, return smart contract serial number.

``` js
function withdrawRequest(uint256 _coins)  public returns (uint256 serialNumber)
```

#### withdrawConfirm

Withdraw confirm `_serialNumber` smart contract transaction serial number with `_coins` amount of Coins from contract, and MUST fire the `WithdrawConfirmEvent` event.

``` js
function withdrawConfirm(uint256 _serailNumber, uint256 _coins)  public returns (bool success)
```

#### withdrawCancel

Withdraw cancel `_serialNUmber` smart contract transaction, and MUST fire the `WithdrawCancelEvent` event.

``` js
function withdrawCancel(uint256 _serailNumber)  public returns (bool success);
```

#### transferFrom

Transfers `_value` amount of Coins from address `_from` to address `_to`, and MUST fire the `Transfer` event.

The `transferFrom` method is used for a withdraw workflow, allowing contracts to transfer Coins on your behalf.
This can be used for example to allow a contract to transfer Coins on your behalf and/or to charge fees in sub-currencies.
The function SHOULD `throw` unless the `_from` account has deliberately authorized the sender of the message via some mechanism.

*Note* Transfers of 0 values MUST be treated as normal transfers and fire the `Transfer` event.

``` js
function transferFrom(address _from, address _to, uint256 _value) returns (bool success)
```




### Events


#### Transfer

MUST trigger when Coins are transferred, including zero value transfers.

A Coin contract which creates new Coins SHOULD trigger a Transfer event with the `_from` address set to `0x0` when Coins are created.

``` js
event Transfer(address indexed _from, address indexed _to, uint256 _value)
```



#### Approval

MUST trigger on any successful call to `approve(address _spender, uint256 _value)`.

``` js
event Approval(address indexed _owner, address indexed _spender, uint256 _value)
```



## Implementation

There are a couple of FIP401-compliant smart contract deployed on the fabcoin network.


#### Example implementations are available at
- https://github.com/jonathanyan/FIP-001/blob/master/FIP001.sol
#### Implementation of adding the force to 0 before calling "approve" again:
- https://github.com/jonathanyan/FIP-001/blob/master/FIP001.sol


## History

Historical links releated to this standard:

- Original proposal from Jonathan Yan: 
  https://github.com/jonathanyan/FIP-001




## Copyright
Copyright and related rights waived via [CC0](https://creativecommons.org/publicdomain/zero/1.0/).