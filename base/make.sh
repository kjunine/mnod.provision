#!/usr/bin/env bash
rm package.box
vagrant up --no-provision
vagrant provision
vagrant status
vagrant package
vagrant box add -f mnod/base package.box
