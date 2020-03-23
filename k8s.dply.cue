package k8s

deployment <Name>: {
	apiVersion: *"extensions/v1beta1" | string
	kind:       "Deployment"
	metadata name: *Name | string
	spec: {
		replicas: *1 | int
		selector matchLabels app: *Name | string
		template: {
			metadata labels app: *Name | string
			spec containers: [{name: *Name | string }]
		}
	}
}
service <Name>: {
	apiVersion: *"v1" | string
	kind:       "Service"
	metadata name: *Name | string
	metadata annotations "dev.okteto.com/auto-ingress": "true"
	spec: {
		type: *"ClusterIP" | string
		selector app: *Name | string
		ports: [...{
			name: *Name | string
			port: int
		}]
	}
}
configMap <Name>: {
	apiVersion: *"v1" | string
	kind: "ConfigMap"
	metadata name: *"\(Name)-config" | string
	metadata labels app: *Name | string
}
persistentVolumeClaim <Name>: {
	apiVersion: *"v1" | string
	kind: "PersistentVolumeClaim"
	metadata name: *"pv-claim-\(Name)" | string
	spec accessModes: ["ReadWriteOnce"]
	spec resources requests storage: *"10Gi" | string
}


//////////////////




deployment couchpotato: {
	spec template spec containers: [{
		image: "linuxserver/couchpotato"
		ports: [{ containerPort: 5050 }]
		envFrom: [{ configMapRef name: "couchpotato-config" }]
		volumeMounts: [{ 
			name:  "volume-couchpotato-downloads"
			mountPath: "/downloads"
		},
//		{
//			name: "volume-couchpotato-movies"
//			mountPath: "/movies"
//		}
		]
	}]
	spec template spec volumes: [{
		name: "volume-couchpotato-downloads"
		persistentVolumeClaim claimName: "pv-claim-cpdownloads"
	},
//	{
//		name: "volume-couchpotato-movies"
//		persistentVolumeClaim claimName: "pv-claim-cpmovies"
//	}
	]
}
persistentVolumeClaim cpdownloads: {}
//  persistentVolumeClaim cpmovies: {}
configMap couchpotato data: {
	PUID: "1000"
	PGID: "1000"
	TZ: "Europe/London"
	UMASK_SET: "022"
}
service couchpotato: {
	spec ports: [{ port: 5050 }]
}


deployment transmission: {
	spec template spec containers: [{
		image: "linuxserver/transmission"
		ports: [{ containerPort: 5050 }]
		envFrom: [{ configMapRef name: "transmission-config" }]
		volumeMounts: [{ 
			name:  "volume-transmission-downloads"
			mountPath: "/downloads"
			// subPath: "data"
		},{
			name: "volume-transmission-watch"
			mountPath: "/watch"
		}]
	}]
	spec template spec volumes: [{
		name: "volume-transmission-downloads"
		persistentVolumeClaim claimName: "transmission-pv-claim"
	},{
		name: "volume-transmission-watch"
		persistentVolumeClaim claimName: "transmission-pv-claim"
	}]
}
persistentVolumeClaim transmission: {}
configMap transmission data: {
	PUID: "1000"
	PGID: "1000"
	TZ: "Europe/London"
	UMASK_SET: "022"
}
service transmission: {
	spec ports: [{ port: 9091 },{ name:"tr1", port: 51413 },{ name:"tr2", port: 51413, protocol: "UDP" }]
}












