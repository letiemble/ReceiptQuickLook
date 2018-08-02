#!/bin/bash

rm -Rf ~/Library/QuickLook/ReceiptQuickLook.qlgenerator
cp -R Build/Products/Debug/ReceiptQuickLook.qlgenerator ~/Library/QuickLook/
qlmanage -r
#qlmanage -p $1

