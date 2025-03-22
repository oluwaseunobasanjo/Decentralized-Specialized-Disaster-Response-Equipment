;; Deployment Tracking Contract
;; Monitors equipment location during emergencies

(define-data-var last-id uint u0)

(define-map deployments
  { id: uint }
  {
    equipment-id: uint,
    location: (string-ascii 100),
    deployed-by: principal,
    status: (string-ascii 20)
  }
)

;; Deploy equipment
(define-public (deploy
    (equipment-id uint)
    (location (string-ascii 100))
  )
  (let
    (
      (new-id (+ (var-get last-id) u1))
    )
    (var-set last-id new-id)

    (map-set deployments
      { id: new-id }
      {
        equipment-id: equipment-id,
        location: location,
        deployed-by: tx-sender,
        status: "deployed"
      }
    )

    (ok new-id)
  )
)

;; Update deployment status
(define-public (update-status
    (deployment-id uint)
    (status (string-ascii 20))
  )
  (let
    (
      (deployment (unwrap! (map-get? deployments { id: deployment-id }) (err u404)))
    )
    (asserts! (is-eq tx-sender (get deployed-by deployment)) (err u403))

    (map-set deployments
      { id: deployment-id }
      (merge deployment { status: status })
    )

    (ok true)
  )
)

;; Get deployment
(define-read-only (get-deployment (id uint))
  (map-get? deployments { id: id })
)
