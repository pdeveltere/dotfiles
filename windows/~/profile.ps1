Set-Alias -Name k -Value kubectl
Set-Alias -Name g -Value git

Function kdev {
    kubectl --kubeconfig="C:\Users\Pieter\.kube\config.dev" @args
}
Function kprod {
    kubectl --kubeconfig="C:\Users\Pieter\.kube\config.prod" @args
}
