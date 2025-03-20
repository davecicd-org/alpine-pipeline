# alpine-pipeline
#### Deploing to EKS using a multi-stage pipeline with github actions 
Before we begin, make sure you have the following set up:

✅ GitHub Repository for storing your application code
✅ Docker Hub Account to store your Docker images
✅ Kubernetes Cluster (EKS, Minikube, or any other cluster)
✅ ArgoCD Installed on Kubernetes for GitOps-based deployments


### 1. Install Argocd on k8s (EKS)
### For Mac - Install Argo CLI 
brew install argocd
![alt text](<screenshots/Screenshot 2025-03-18 at 6.27.50 PM.png>)

# Install Argo CD to the cluster
kubectl create namespace argocd
![alt text](<screenshots/Screenshot 2025-03-18 at 6.29.57 PM.png>)
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
![alt text](<screenshots/Screenshot 2025-03-18 at 6.31.48 PM.png>)
k get pods -n argocd
![alt text](<screenshots/Screenshot 2025-03-18 at 6.34.09 PM.png>)

# The password is auto-generated, we can get it with:
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
passwd:QGWlYV90ZJXd98s8

# to expose service using LoadBalancer and to retrieve passwd and log in 
kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}' > /dev/null 2>&1 
export argo_url=$(kubectl get svc -n argocd | grep argocd-server | awk '{print $4}' | grep -v none)
echo "argo_url: http://$argo_url/"
echo username: "admin"
echo password: $(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)
![alt text](<screenshotsScreenshot 2025-03-18 at 6.36.32 PM.png>)

# Use url provided to access argocd ui
![alt text](<screenshots/Screenshot 2025-03-18 at 6.39.10 PM.png>)

### To log into argocd through command line  instead of ui
argocd login --username admin --password (password)--insecure
![alt text](<Screenshot 2025-03-18 at 6.46.43 PM.png>)

### To log into argocd thriugh command line to connect it with the ui so you can deploy from git with argo from CLI instead of ui
argocd login 127.0.0.1:8080 --username admin --password (insert-here) --insecure <loadbalancer_ip>


### 2. Setup github secrets 
Go to GitHub Repository → Settings → Secrets and Variables → Actions → New repository secret
Add the following secrets:
Secret Name           Value
DOCKER_USERNAME       DOCKER_PASSWORD
Your Docker Hub username
Your Docker Hub password or access token

### 3. Create dockerfile
./dockerfile 
![alt text](<Screenshot 2025-03-18 at 9.30.02 PM.png>)

### 4. Create gitworkflow file 
![alt text](<Screenshot 2025-03-18 at 9.34.45 PM.png>)
Explanation:
	•	Job 1 (build): Builds the Docker image from the Dockerfile.
	•	Job 2 (push): Pushes the image to Docker Hub.
	•	Job 3 (update-manifests): Updates the Kubernetes manifests in the GitOps repository to reference the new image tag.
	•	GitHub Secrets: You’ll need to add DOCKER_USERNAME and DOCKER_PASSWORD as secrets in your GitHub repository for Docker Hub login.


### 4. Create K8s deployment files

test test



