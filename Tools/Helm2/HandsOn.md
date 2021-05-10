helm2 install ./chart101
helm2 get manifest quoting-lemur
helm2 delete quoting-lemur
helm2 install ./chart101 --debug --dry-run