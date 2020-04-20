#!/bin/bash

# create a new kubernetes cluster using eksctl
eksctl create cluster -f cluster.yaml

# update the config file
sudo aws eks update-kubeconfig --name capstone --region us-west-2