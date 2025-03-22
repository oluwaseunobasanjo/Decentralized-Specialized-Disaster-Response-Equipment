;; Maintenance Scheduling Contract
;; Manages regular testing and upkeep

(define-data-var last-id uint u0)

(define-map maintenance
  { id: uint }
  {
    equipment-id: uint,
    technician: principal,
    status: (string-ascii 20)
  }
)

;; Schedule maintenance
(define-public (schedule
    (equipment-id uint)
  )
  (let
    (
      (new-id (+ (var-get last-id) u1))
    )
    (var-set last-id new-id)

    (map-set maintenance
      { id: new-id }
      {
        equipment-id: equipment-id,
        technician: tx-sender,
        status: "scheduled"
      }
    )

    (ok new-id)
  )
)

;; Complete maintenance
(define-public (complete
    (maintenance-id uint)
  )
  (let
    (
      (maintenance-record (unwrap! (map-get? maintenance { id: maintenance-id }) (err u404)))
    )
    (asserts! (is-eq tx-sender (get technician maintenance-record)) (err u403))

    (map-set maintenance
      { id: maintenance-id }
      (merge maintenance-record { status: "completed" })
    )

    (ok true)
  )
)

;; Get maintenance record
(define-read-only (get-maintenance (id uint))
  (map-get? maintenance { id: id })
)
