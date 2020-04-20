#!/bin/bash

eksctl create cluster -f cluster.yaml

aws eks update-kubeconfig --name capstone-ming 