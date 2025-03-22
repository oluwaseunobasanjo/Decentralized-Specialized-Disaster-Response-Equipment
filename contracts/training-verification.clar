;; Training Verification Contract
;; Validates operator qualifications

(define-data-var last-id uint u0)

(define-map certifications
  { id: uint }
  {
    operator: principal,
    equipment-type: (string-ascii 50),
    trainer: principal,
    status: (string-ascii 20)
  }
)

;; Issue certification
(define-public (issue-certification
    (operator principal)
    (equipment-type (string-ascii 50))
  )
  (let
    (
      (new-id (+ (var-get last-id) u1))
    )
    (var-set last-id new-id)

    (map-set certifications
      { id: new-id }
      {
        operator: operator,
        equipment-type: equipment-type,
        trainer: tx-sender,
        status: "active"
      }
    )

    (ok new-id)
  )
)

;; Update certification status
(define-public (update-status
    (certification-id uint)
    (status (string-ascii 20))
  )
  (let
    (
      (certification (unwrap! (map-get? certifications { id: certification-id }) (err u404)))
    )
    (asserts! (is-eq tx-sender (get trainer certification)) (err u403))

    (map-set certifications
      { id: certification-id }
      (merge certification { status: status })
    )

    (ok true)
  )
)

;; Get certification
(define-read-only (get-certification (id uint))
  (map-get? certifications { id: id })
)
