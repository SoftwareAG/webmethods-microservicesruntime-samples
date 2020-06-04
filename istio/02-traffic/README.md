
# Sample to display using Istio for fault-tolerance

This sample describes, how Istio sidecar can help for fault-tolerance without requiring any changes in the App.

## 1. Route traffic through Istio

Create a virtual service through Istio
```
kubectl apply -f details-virtualservice.yaml
```

## 2. Deploy details service update that throws errors
Open [template](details-bad-release.yaml) that deploys bad version of the product. Environment variable **SERVICE_VERSION** is set as *sleep-on-odd-calls*. This variable ensures that for every alternate call, response to the caller is delayed by 30 seconds with an error. 

```
kubectl apply -f details-bad-release.yaml
```

> Browse to http://localhost/invoke/bookApp:getProductDetails?id=1 - details call returns after 30 seconds with an error for every alternate call.

## 3. Update virtual service with timeout

[Template](details-virtualservice-timeout.yaml) would allow service to timeout after 5 seconds. It will throw 500 error code to the caller after 5 seconds.

```
kubectl apply -f details-virtualservice-timeout.yaml
```

> Browse to http://localhost/invoke/bookApp:getProductDetails?id=1 - details call times out after 5 seconds with 500 error for every alternate call.

## 4. Update virtual service with retry

[Template](details-virtualservice-retry.yaml) will retry execution of the service after 30 seconds instead of throwing an error back to the caller.

```
kubectl apply -f details-virtualservice-retry.yaml
```

> Browse to http://localhost/invoke/bookApp:getProductDetails?id=1 - details call times out and then automatically retries for every alternate call. i.e. no error is thrown back to the caller.

## 5. Cleanup 

Perform steps below to cleanup and reset the environment for other samples to execute correctly.
```
kubectl delete -f details-bad-release.yaml
kubectl delete -f details-virtualservice-timeout.yaml
kubectl delete -f details-virtualservice-retry.yaml
```

## 6. Refresh the environment

Go back to 01-deploy folder and re-apply templates. 

```
kubectl apply -f bookinfo-v1.yaml
```

Browse to http://localhost/invoke/bookApp:getProductDetails?id=1, do few refresh and make sure response is flowing back normal.
