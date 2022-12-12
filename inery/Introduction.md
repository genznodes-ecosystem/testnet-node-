# Inery Lite & Master Node

## What is Lite node
Lite nodes are peers in the network that don't validate blocks. They help network function by making a copy of the ledger and listening to all newly created blocks. Actions they can take include, but are not limited to: pushing transactions, reading ledger,interacting with blockchain... Architecturally speaking, they are same as Master nodes except the fact that they are not privileged to sign and create blocks.

## What is Master Node
Master nodes are capable of creating, validating and signing blocks. Another name for them is producer nodes. Block producing is what the process of finding next block in the chain is called. Master nodes have permission to sign and validate new blocks. Producers are queued into the schedule pool, and only those currently in the pool are able to create and sign block at given time. Every produced block that is finalized and added to the blockchain equates to single unpaid block distributed to its creator. After meeting the threshold production time, producer will be allowed to claim their reward ( unpaid blocks amount ).

Reference : https://docs.inery.io/docs/category/introduction
