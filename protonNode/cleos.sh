#!/bin/bash
################################################################################
# Proton tools 
#
#
# Created by CryptoLions.io
#
# https://github.com/ProtonProtocol/proton.start 
#
###############################################################################

NODEOSBINDIR="/usr/bin"

WALLETHOST="127.0.0.1"
NODEHOST="127.0.0.1"
NODEPORT="8888"
WALLETPORT="3000"



$NODEOSBINDIR/cleos -u http://$NODEHOST:$NODEPORT --wallet-url http://$WALLETHOST:$WALLETPORT "$@"

