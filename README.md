# NFT-Based Financial Asset Management Smart Contract

A comprehensive smart contract system for tokenizing real-world assets, managing fractional ownership, and enabling collateralized lending against NFT holdings. This contract implements advanced features including time-locked power-ups for NFT enhancement.

## Features

### Core Functionality
- NFT minting and management
- Asset tokenization
- Fractional ownership distribution
- Collateralized lending
- Time-locked power-up system

### Token Management
- Mint new NFTs with associated metadata URIs
- Transfer ownership of tokens
- Query token ownership and metadata
- Track total token supply

### Fractional Ownership
- Create shares for any tokenized asset
- Transfer shares between users
- Track share balances per user
- Manage fractional ownership distribution

### Lending System
- Create collateralized loans using NFTs
- Configure loan parameters:
  - Loan amount
  - Interest rate
  - Duration
  - Collateral requirements
- Loan repayment functionality
- Lending pool management

### Power-up System
The contract features a unique power-up system that allows NFT owners to create temporary enhancements for their tokens:

- **Types of Power-ups:**
  1. Yield Boost (Type 1)
  2. Collateral Boost (Type 2)
  3. Governance Boost (Type 3)

- **Power-up Parameters:**
  - Multiplier range: 100-300%
  - Customizable duration
  - Time-locked activation
  - Status tracking

## Administrative Features

- Contract owner controls
- Toggleable lending functionality
- Error handling system
- Read-only query functions

## Error Codes

- `u100`: Owner-only operation failed
- `u101`: Not token owner
- `u102`: Invalid amount
- `u103`: Token already exists
- `u104`: Token not found
- `u105`: Lending disabled
- `u106`: Loan not found
- `u107`: Not loan borrower
- `u108`: Invalid power-up type
- `u109`: Invalid multiplier range
- `u110`: Power-up not found
- `u111`: Power-up expired/inactive

## Technical Implementation

### Data Structures

```clarity
;; Primary Mappings
(define-map balances principal uint)
(define-map token-owners uint principal)
(define-map token-uris uint (string-ascii 256))

;; Lending Pool Structure
{
    collateral-amount: uint,
    loan-amount: uint,
    interest-rate: uint,
    duration: uint,
    borrower: principal
}

;; Power-up Structure
{
    power-type: uint,
    multiplier: uint,
    activation-height: uint,
    duration: uint,
    is-active: bool
}
```

## Usage Examples

### Creating and Managing NFTs
```clarity
;; Mint a new NFT
(mint u1 "https://example.com/metadata/1")

;; Transfer an NFT
(transfer u1 'SP2J6ZY48GV1EZ5V2V5RB9MP66SW86PYKKNRV9EJ7)
```

### Setting Up Fractional Ownership
```clarity
;; Create shares for a token
(create-shares u1 u1000)

;; Transfer shares to another user
(transfer-shares 'SP2J6ZY48GV1EZ5V2V5RB9MP66SW86PYKKNRV9EJ7 u100)
```

### Creating a Loan
```clarity
;; Create a loan using an NFT as collateral
(create-loan u1 u50000 u5 u30)

;; Repay an existing loan
(repay-loan u1)
```

### Managing Power-ups
```clarity
;; Create a yield boost power-up
(create-power-up u1 POWER_UP_YIELD_BOOST u150 u100)

;; Check power-up status
(get-power-up-status u1)
```

## Security Considerations

1. Owner-only access controls for critical functions
2. Asset ownership verification before operations
3. Balance checks for transfers
4. Validation of power-up parameters
5. Time-locked mechanisms for power-up duration
6. Lending pool safety checks

## Development Notes

- Built for the Clarity smart contract language
- Designed for the Stacks blockchain ecosystem
- Implements best practices for NFT and DeFi contracts
- Extensible architecture for future enhancements

## Future Enhancements

1. Multi-token collateral support
2. Advanced governance features
3. Additional power-up types
4. Secondary market functionality
5. Enhanced metadata management

## Contributing

Contributions are welcome! Please follow these steps:
1. Fork the repository
2. Create a feature branch
3. Commit changes
4. Submit pull request

## License

This project is licensed under the MIT License.

## Disclaimer

This smart contract is provided as-is. Users should conduct their own security audit before deployment. The developers are not responsible for any losses incurred through the use of this contract.

