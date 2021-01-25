# Display the version of kubectl.
`kubectl version`

# Show all pods in the default namespace.
kubectl get pods

# Show all pods in a specific namespace.
kubectl get pods -n <namespace>

# Show detailed information about a specific pod.
kubectl describe pod <pod-name>

# Create a deployment from a YAML file.
kubectl create -f <deployment.yaml>

# Update a deployment with a new YAML file.
kubectl apply -f <deployment.yaml>

# Delete a deployment by name.
kubectl delete deployment <deployment-name>

# Scale a deployment to a specific number of replicas.
kubectl scale deployment <deployment-name> --replicas=<num-replicas>

# Create a service from a YAML file.
kubectl create -f <service.yaml>

# Delete a service by name.
kubectl delete service <service-name>

# Show all services in the default namespace.
kubectl get services

# Show all services in a specific namespace.
kubectl get services -n <namespace>

# Expose a deployment as a service.
kubectl expose deployment <deployment-name> --type=<service-type> --port=<service-port>

# Show all pods with their associated node.
kubectl get pods -o wide

# Show logs for a specific pod.
kubectl logs <pod-name>

# Show logs for a specific container within a pod.
kubectl logs <pod-name> -c <container-name>

# Show the CPU and memory usage for all pods in the default namespace.
kubectl top pods

# Show the CPU and memory usage for all pods in a specific namespace.
kubectl top pods -n <namespace>

# Copy files to/from a pod.
kubectl cp <src-path> <dest-path> <pod-name>:<dest-path>

# Create a secret from a YAML file.
kubectl create -f <secret.yaml>

# Delete a secret by name.
kubectl delete secret <secret-name>

# Show all secrets in the default namespace.
kubectl get secrets

# Show all secrets in a specific namespace.
kubectl get secrets -n <namespace>

# Create a config map from a YAML file.
kubectl create -f <configmap.yaml>

# Delete a config map by name.
kubectl delete configmap <configmap-name>

# Show all config maps in the default namespace.
kubectl get configmaps

# Show all config maps in a specific namespace.
kubectl get configmaps -n <namespace>

# Open a shell inside a specific pod.
kubectl exec -it <pod-name> -- /bin/bash

# List all available API resources.
kubectl api-resources

# Describe a specific API resource.
kubectl api-resources <resource-name>

# Show all nodes in the cluster.
kubectl get nodes

# Drain a node to gracefully remove it from the cluster.
kubectl drain <node-name>

# Uncordon a previously drained node.
kubectl uncordon <node-name>

# Label a node with a specific key and value.
kubectl label nodes <node-name> <key>=<value>

# Show all namespaces in the cluster.
kubectl get namespaces

# Create a new namespace.
kubectl create namespace <namespace-name>

# Delete a namespace by name.
kubectl delete namespace <namespace-name>

# Set the default namespace for future kubectl commands.
kubectl config set-context --current --namespace=<namespace-name>

# Rollout a new version of a deployment.
kubectl rollout restart deployment <deployment-name>

# Rollout a previous version of a deployment.
kubectl rollout undo deployment <deployment-name>

# Show the status of a deployment rollout.
kubectl rollout status deployment <deployment-name>

# Show the history of a deployment rollout.
kubectl rollout history deployment <deployment-name>

# Pause a deployment rollout.
kubectl rollout pause deployment <deployment-name>

# Resume a paused deployment rollout.
kubectl rollout resume deployment
