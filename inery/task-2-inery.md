# Make your own currency and transfer to someone

**Detail** :
Task 2 of the Inery testnet faucet requires that task 1 was successfully done.
Now your challenge is to create your own cryptocurrency on the Inery testnet blockchain via inery.token contract/account.
Choose original symbol name and maximum supply for currency and execute create action (cline push action inery.token create '["account", "30000..000 TKN", "creating my first tokens"]'. After that, you will have to issue some amount with your account to activate that tokens.
Your tokens should be ready for transfer, send some tokens to 10 different accounts including the Inery account.

# GUIDE FOR TASK 2

## Get token contract

```
cline get code inery.token -c token.wasm -a token.abi --wasm
```

output :

>code hash: ac6fb455ea0a66a42fa9bc9aef61cfaf18109346795142194fe3b167dea3a97c
>saving wasm to token.wasm saving abi to token.abi

wasm and abi for token contract are saved in token.wasm and token.abi files

## UNLOCK WALLET 

```
cline wallet unlock -n <name wallet>
```

input your wallet password 

## SET CODE AND ABI 

### set code

```
cline set code <account> token.wasm
```

### set abi

```
cline set abi <account> token.abi
```

## USE TOKEN CONTRACT

### create currencie

```
cline push action inery.token create '["<AccountName>", "<Supply CurrencyCode>"], "<token description>"' -p <AccountName>
```

* example 

```
cline push action inery.token create '["genznodes", "1000.0000 TEST"], "Create my first token"' -p genznodes
```
i generate token with symbol TEST and 1000TEST supply

### Issuer token

```
cline push action inery.token issue '["<YourAccountName>", "<Supply CurrencyCode>", "detail"]' -p <AccountName>
```

remove the amount you want which can be transferred to several inery accounts

### Transfer

```
cline push action inery.token transfer '["<AccountName>", "<account receive", "<Amount CurrencyCode>", "<memo>"]' -p <AccountName>
```

* Example 
```
cline push action inery.token transfer '["genznodes", "inery", "1.0000 TEST", "Here Is 1 TEST for you"]' -p genznodes
```
Transfer to inery account

### Note 

you must transfer to inery account **inery**

## CHECK BALANCE 

```
cline get currency balance <account> <account> <symbol_token>
```

## Submit Task 

Done for task 2 

I'll Update for task 3

---
### Example Complete Task 
![IMAGE COMPLETE](https://user-images.githubusercontent.com/94878333/195879817-7347ff5f-bce1-498d-b71c-3714ee071bab.png)
