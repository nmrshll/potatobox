kind:       "Deployment"
apiVersion: "extensions/v1beta1"
metadata: {
    name: "couchpotato"
}
spec: {
    replicas: 1
    selector: {
        matchLabels: {
            app: "couchpotato"
        }
    }
    template: {
        metadata: {
            labels: {
                app: "couchpotato"
            }
        }
        spec: {
            containers: [{
                name: "couchpotato"
                ports: [{
                    containerPort: 5050
                }]
                image: "linuxserver/couchpotato"
                envFrom: [{
                    configMapRef: {
                        name: "couchpotato-config"
                    }
                }]
                volumeMounts: [{
                    name:      "volume-couchpotato-downloads"
                    mountPath: "/downloads"
                }]
            }]
            volumes: [{
                name: "volume-couchpotato-downloads"
                persistentVolumeClaim: {
                    claimName: "pv-claim-cpdownloads"
                }
            }]
        }
    }
}
