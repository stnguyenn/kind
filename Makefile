
CF=config.yml

IC=nginx.yml
IC_URL=https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/static/provider/kind/deploy.yaml
# kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/static/provider/kind/deploy.yaml

EX=ingress.yml
EX_URL=https://kind.sigs.k8s.io/examples/ingress/usage.yaml
# kubectl apply -f https://kind.sigs.k8s.io/examples/ingress/usage.yaml

default:
	@echo 👋 

c_ic:
	@curl -o $(IC) $(IC_URL)

c_ex: 
	@curl -o $(EX) $(EX_URL)

rm_kind:
	@kind delete cluster

kind: rm_kind
	@kind create cluster --config=$(CF)

rm_nginx: 
	@kubectl delete -f $(IC)

nginx: 
	@kubectl apply -f $(IC)

wait_ic:
	@kubectl wait --namespace ingress-nginx \
		--for=condition=ready pod \
		--selector=app.kubernetes.io/component=controller \
		--timeout=90s

get_igr:
	@kubectl apply -f $(EX)

try_igr:
	@curl localhost/foo
	@curl localhost/bar

