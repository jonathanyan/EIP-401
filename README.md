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

The following standard allows for the implementation of a standard API for coins within smart contracts.
This standard provides basic functionality to transfer coins, as well as allow Coins to be approved so they can be spent by another on-chain third party.


## Motivation

A standard interface allows any Coins on Ethereum to be re-used by other applications: from wallets to decentralized exchanges.


## Specification

## Coin
### Methods

**NOTE**: Callers MUST handle `false` from `returns (bool success)`.  Callers MUST NOT assume that `false` is never returned!


#### name

Returns the name of the Coin - e.g. `"MyCoin"`.

OPTIONAL - This method can be used to improve usability,
but interfaces and other contracts MUST NOT expect these values to be present.


``` js
function name() view returns (string name)
```


#### symbol

Returns the symbol of the Coin. E.g. "HIX".

OPTIONAL - This method can be used to improve usability,
but interfaces and other contracts MUST NOT expect these values to be present.

``` js
function symbol() view returns (string symbol)
```



#### decimals

Returns the number of decimals the Coin uses - e.g. `8`, means to divide the Coin amount by `100000000` to get its user representation.

OPTIONAL - This method can be used to improve usability,
but interfaces and other contracts MUST NOT expect these values to be present.

``` js
function decimals() view returns (uint8 decimals)
```


#### totalSupply

Returns the total Coin supply.

``` js
function totalSupply() view returns (uint256 totalSupply)
```



#### balanceOf

Returns the account balance of another account with address `_owner`.

``` js
function balanceOf(address _owner) view returns (uint256 balance)
```



#### transfer

Transfers `_value` amount of Coins to address `_to`, and MUST fire the `Transfer` event.
The function SHOULD `throw` if the `_from` account balance does not have enough Coins to spend.

*Note* Transfers of 0 values MUST be treated as normal transfers and fire the `Transfer` event.

``` js
function transfer(address _to, uint256 _value) returns (bool success)
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



#### approve

Allows `_spender` to withdraw from your account multiple times, up to the `_value` amount. If this function is called again it overwrites the current allowance with `_value`.

**NOTE**: To prevent attack vectors like the one [described here](https://docs.google.com/document/d/1YLPtQxZu1UAvO9cZ1O2RPXBbT0mooh4DYKjA_jp-RLM/) and discussed [here](https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729),
clients SHOULD make sure to create user interfaces in such a way that they set the allowance first to `0` before setting it to another value for the same spender.
THOUGH The contract itself shouldn't enforce it, to allow backwards compatibility with contracts deployed before

``` js
function approve(address _spender, uint256 _value) returns (bool success)
```


#### allowance

Returns the amount which `_spender` is still allowed to withdraw from `_owner`.

``` js
function allowance(address _owner, address _spender) view returns (uint256 remaining)
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
- https://github.com/jonathanyan/FIP-001

#### Implementation of adding the force to 0 before calling "approve" again:
- https://github.com/jonathanyan/FIP-001


## History

Historical links releated to this standard:

- Original proposal from Jonathan Yan: 
  https://github.com/jonathanyan/FIP-001




## Copyright
Copyright and related rights waived via [CC0](https://creativecommons.org/publicdomain/zero/1.0/).