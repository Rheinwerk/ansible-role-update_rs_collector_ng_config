#!/bin/bash

ansible-playbook -v test.yml -i inventory --diff $@

