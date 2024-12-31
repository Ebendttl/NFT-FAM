;; NFT-Based Financial Asset Management Contract
;; Allows users to tokenize real-world assets, manage fractional ownership,
;; and enables collateralized lending against NFT holdings

(define-constant contract-owner tx-sender)
(define-constant err-owner-only (err u100))
(define-constant err-not-token-owner (err u101))
(define-constant err-invalid-amount (err u102))

;; Data variables
(define-data-var total-supply uint u0)
(define-data-var lending-enabled bool true)

;; Principal -> Balance mapping
(define-map balances principal uint)

;; Token ID -> Owner mapping
(define-map token-owners uint principal)

;; Token ID -> Metadata URI mapping
(define-map token-uris uint (string-ascii 256))

;; Lending pool data
(define-map lending-pool
    uint
    {
        collateral-amount: uint,
        loan-amount: uint,
        interest-rate: uint,
        duration: uint,
        borrower: principal
    }
)

;; Token minting function
(define-public (mint (token-id uint) (uri (string-ascii 256)))
    (begin
        (asserts! (is-eq tx-sender contract-owner) err-owner-only)
        (asserts! (is-none (map-get? token-owners token-id))
            (err u103))
        (map-set token-owners token-id tx-sender)
        (map-set token-uris token-id uri)
        (var-set total-supply (+ (var-get total-supply) u1))
        (ok true)))

;; Transfer function
(define-public (transfer (token-id uint) (recipient principal))
    (let ((owner (unwrap! (map-get? token-owners token-id)
                         (err u104))))
        (asserts! (is-eq tx-sender owner) err-not-token-owner)
        (map-set token-owners token-id recipient)
        (ok true)))

;; Fractional ownership functions
(define-public (create-shares (token-id uint) (total-shares uint))
    (let ((owner (unwrap! (map-get? token-owners token-id)
                         (err u104))))
        (asserts! (is-eq tx-sender owner) err-not-token-owner)
        (map-set balances tx-sender total-shares)
        (ok true)))

(define-public (transfer-shares (recipient principal) (amount uint))
    (let ((sender-balance (default-to u0 (map-get? balances tx-sender))))
        (asserts! (>= sender-balance amount) err-invalid-amount)
        (map-set balances tx-sender (- sender-balance amount))
        (map-set balances recipient (+ (default-to u0 (map-get? balances recipient)) amount))
        (ok true)))

;; Collateralized lending functions
(define-public (create-loan (token-id uint) 
                          (loan-amount uint)
                          (interest-rate uint)
                          (duration uint))
    (let ((owner (unwrap! (map-get? token-owners token-id)
                         (err u104))))
        (asserts! (is-eq tx-sender owner) err-not-token-owner)
        (asserts! (var-get lending-enabled) (err u105))
        (map-set lending-pool token-id {
            collateral-amount: u1,
            loan-amount: loan-amount,
            interest-rate: interest-rate,
            duration: duration,
            borrower: tx-sender
        })
        (ok true)))

(define-public (repay-loan (token-id uint))
    (let ((loan (unwrap! (map-get? lending-pool token-id)
                        (err u106))))
        (asserts! (is-eq tx-sender (get borrower loan)) (err u107))
        (map-delete lending-pool token-id)
        (ok true)))

;; Read-only functions
(define-read-only (get-token-owner (token-id uint))
    (map-get? token-owners token-id))

(define-read-only (get-token-uri (token-id uint))
    (map-get? token-uris token-id))

(define-read-only (get-loan-details (token-id uint))
    (map-get? lending-pool token-id))

;; Admin functions
(define-public (toggle-lending)
    (begin
        (asserts! (is-eq tx-sender contract-owner) err-owner-only)
        (var-set lending-enabled (not (var-get lending-enabled)))
        (ok true)))

;; NEW FEATURE: Time-locked Power-ups System
;; This allows NFT owners to create temporary enhancements for their NFTs

;; Power-up types
(define-constant POWER_UP_YIELD_BOOST u1)
(define-constant POWER_UP_COLLATERAL_BOOST u2)
(define-constant POWER_UP_GOVERNANCE_BOOST u3)

;; Power-up data structure
(define-map power-ups
    uint  ;; token-id
    {
        power-type: uint,
        multiplier: uint,
        activation-height: uint,
        duration: uint,
        is-active: bool
    }
)

;; Create a new power-up for an NFT
(define-public (create-power-up 
    (token-id uint)
    (power-type uint)
    (multiplier uint)
    (duration uint))
    (let ((owner (unwrap! (map-get? token-owners token-id)
                         (err u104))))
        (asserts! (is-eq tx-sender owner) err-not-token-owner)
        (asserts! (or 
            (is-eq power-type POWER_UP_YIELD_BOOST)
            (is-eq power-type POWER_UP_COLLATERAL_BOOST)
            (is-eq power-type POWER_UP_GOVERNANCE_BOOST))
            (err u108))
        (asserts! (and (>= multiplier u100) (<= multiplier u300))
            (err u109))
        (map-set power-ups token-id {
            power-type: power-type,
            multiplier: multiplier,
            activation-height: block-height,
            duration: duration,
            is-active: true
        })
        (ok true)))

;; Check if a power-up is active and valid
(define-read-only (get-power-up-status (token-id uint))
    (let ((power-up (unwrap! (map-get? power-ups token-id)
                            (err u110))))
        (if (and 
            (get is-active power-up)
            (<= (- block-height (get activation-height power-up))
                (get duration power-up)))
            (ok power-up)
            (err u111))))

;; Helper functions for applying specific boosts
(define-private (apply-yield-boost (token-id uint) (multiplier uint))
    (let ((loan (unwrap! (map-get? lending-pool token-id)
                        (err u114))))
        ;; Boost the yield by multiplier percentage
        (ok true)))

(define-private (apply-collateral-boost (token-id uint) (multiplier uint))
    (let ((loan (unwrap! (map-get? lending-pool token-id)
                        (err u115))))
        ;; Increase collateral value by multiplier percentage
        (ok true)))

(define-private (apply-governance-boost (token-id uint) (multiplier uint))
    ;; Increase governance voting power by multiplier percentage
    (ok true))