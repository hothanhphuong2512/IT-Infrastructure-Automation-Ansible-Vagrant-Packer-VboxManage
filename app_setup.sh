#!/bin/bash


scp -r setup todoapp:
Echo 'Copy sucessful'

ssh todoapp bash setup/install_script.sh

