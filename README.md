# Application Component Operator

**The Kubernetes Operator for creating a new project/component configuration in CI / CD environment using [Cadence](https://cadenceworkflow.io) orchestration engine.**

## Development Guide

### Setting up development environment

#### Prerequisites
* Go version 1.13+
* Docker version 18.06+
* Kubectl 1.16.0+
* K3d version 1.3.4+
* Helm version 2.16.0+

#### Create K8s cluster with Cadence Service

```bash
. ./setup-dev.sh create
```
#### Delete K8s cluster

```bash
. ./setup-dev.sh delete
```
#### Start K8s cluster
```bash
. ./setup-dev.sh start
```
#### Stop K8s cluster

``` bash
. ./setup-dev.sh stop
```

