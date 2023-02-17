alias g='git'
alias k='kdev'
alias t='terraform'
alias kprod='kubectl --kubeconfig=$HOME/.kube/config.prod'
alias kdev='kubectl --namespace=stm-api-dev --kubeconfig=$HOME/.kube/config.dev'
alias kint='kubectl --kubeconfig=$HOME/.kube/config.int'

eval "$(/opt/homebrew/bin/brew shellenv)"
