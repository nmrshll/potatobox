kind:       "Service"
apiVersion: "v1"
metadata: {
    name: "couchpotato"
    annotations: {
        "dev.okteto.com/auto-ingress": "true"
    }
}
spec: {
    selector: {
        app: "couchpotato"
    }
    type: "ClusterIP"
    ports: [{
        name: "couchpotato"
        port: 5050
    }]
}
