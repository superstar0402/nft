### How does ERC721A save gas?

ERC721A saves gas by :
- update the balance of a user once per batch mint (ownership state update is done only once with a batch minting)
- 