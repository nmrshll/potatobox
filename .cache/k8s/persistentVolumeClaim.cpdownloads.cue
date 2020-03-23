kind:       "PersistentVolumeClaim"
apiVersion: "v1"
metadata: {
    name: "pv-claim-cpdownloads"
}
spec: {
    accessModes: ["ReadWriteMany"]
    resources: {
        requests: {
            storage: "10Gi"
        }
    }
}
