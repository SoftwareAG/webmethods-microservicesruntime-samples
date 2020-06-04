
# Canary Deployment
This sample provides templates on how canary deployment can be achieved with Istio.

## 1. Canary with 25% traffic to v1 and 75% traffic to v2

Deploy [canary rules with 25/75 split](review-canary-25-75.yaml). This deployment routes 25% of the traffic to v1 review service and 75% to v2 review service.

```
kubectl apply -f reviews-canary-25-75.yaml
```

> Browse to http://localhost/invoke/bookApp:getProductDetails?id=1 and refresh few times, observe that some responses returned with v1 and most returned with v2.

## 2. Canary rollout

Once required validation on v2 is completed, all traffic can be routed to v2. This deployment routes all traffic to v2 review service.

Deploy [canary rules with 0/100 split](reviews-canary-0-100.yaml)

```
kubectl apply -f reviews-canary-0-100.yaml
```

> Browse to http://localhost/invoke/bookApp:getProductDetails?id=1 and refresh few times, observe that all responses are returned with v2.


