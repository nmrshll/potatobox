kind:       "ConfigMap"
apiVersion: "v1"
metadata: {
    name: "couchpotato-config"
    labels: {
        app: "couchpotato"
    }
}
data: {
    PUID:      "1000"
    PGID:      "1000"
    TZ:        "Europe/London"
    UMASK_SET: "022"
}
