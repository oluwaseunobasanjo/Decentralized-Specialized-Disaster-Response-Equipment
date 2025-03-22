;; Equipment Registration Contract
;; Records details of specialized rescue tools

(define-data-var last-id uint u0)

(define-map equipment
  { id: uint }
  {
    name: (string-ascii 100),
    type: (string-ascii 50),
    owner: principal,
    status: (string-ascii 20)
  }
)

;; Register equipment
(define-public (register
    (name (string-ascii 100))
    (type (string-ascii 50))
  )
  (let
    (
      (new-id (+ (var-get last-id) u1))
    )
    (var-set last-id new-id)

    (map-set equipment
      { id: new-id }
      {
        name: name,
        type: type,
        owner: tx-sender,
        status: "active"
      }
    )

    (ok new-id)
  )
)

;; Update equipment status
(define-public (update-status
    (equipment-id uint)
    (status (string-ascii 20))
  )
  (let
    (
      (item (unwrap! (map-get? equipment { id: equipment-id }) (err u404)))
    )
    (asserts! (is-eq tx-sender (get owner item)) (err u403))

    (map-set equipment
      { id: equipment-id }
      (merge item { status: status })
    )

    (ok true)
  )
)

;; Get equipment
(define-read-only (get-equipment (id uint))
  (map-get? equipment { id: id })
)
