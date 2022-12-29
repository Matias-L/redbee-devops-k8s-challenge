# Redbee Challenge - Simpsons Quotes API - Matias

![homer-console](simpsons-quotes/images/homer-simpson.gif)

# Pre-requisitos

a- Disponer de una cuenta en [Azure](https://portal.azure.com)

b- Instalar y configurar la [CLI de Azure](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli)

c- [Configurar una entidad de servicio.](https://learn.microsoft.com/es-es/azure/developer/terraform/authenticate-to-azure?tabs=bash#create-a-service-principal). Tomar nota de la _APP ID_ y _APP PASSWORD_.

d- Instalar terraform >=1.0. (Opcional: Instalar [tfenv](https://github.com/tfutils/tfenv) para administrar distintas versiones de terraform )

e- Instalar [Kubectl](https://kubernetes.io/docs/tasks/tools/) 

f- Opcional: Instalar [Lens](https://k8slens.dev/)

# Procedimiento

## Creación de infraestructura

1. Clonar el repositorio. 
2. Ubicarse sobre el directorio _terraform_
3. Inicializar el state con `terraform init`
4. Copiar el archivo `terraform.tfvars.example` en el mismo directorio con el nombre `terraform.tfvars`. Sobre el mismo, reemplazar los campos `<service_principal_app_id>` y `<service_principal_password>` con los valores de `APP_ID` y `APP_PASSWORD` obtenidos en el pre-requisito *c*.
5. Levantar la infraestructura con el comando `terraform apply`. Se nos mostrará un detalle de los recursos a levantar. Si está todo el orden, confirmar escribiendo `yes` cuando se nos solicite.

## Configuración kubernetes

Una vez creado el cluster en Azure, procedemos a conectarnos para luego crear los recursos sobre el mismo.

1. Nos logueamos a la cli de Azure con el comando `az login`
2. Obtenemos las credenciales para el cluster levantado previamente con el comando `az aks get-credentials --resource-group k8s-rg --name k8stest`  (Nota: En caso de administrar mutiples cluster, se recomienda utilizar la opción `-f <path_to_file>` y luego setear el contexto exportando la variable de entorno KUBECONFIG sobre ese archivo)
3. Para verificar que la conexión se realizó correctamente, ejecutamos el comando `kubectl cluster-info  `
4. Creamos el namespace sobre el cual se levantarán los recursos con el comando `kubectl create namespace simpsons-quotes-ns`
5. Instalamos el Nginx Ingress Controller ejecutando `kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.5.1/deploy/static/provider/cloud/deploy.yaml`
6. Nos ubicamos sobre el directorio *k8s* y levantamos los recursos de kubernetes aplicando el archivo ubicado allí con el comando `kubectl apply -f manifest.yaml`.
7. Una vez aplicado, esperamos un minuto hasta que inicializen los pods. Luego, obtenemos la IP del load balancer sobre el cual podemos hacer queries con `kubectl get ing --namespace simpsons-quotes-ns`

## Uso de la aplicación 

<IP_ADDR> se refiere a la IP obtenida en el punto *7*:

```bash
# Ver frases
curl "http://<IP_ADDR>/quotes" -s

# Consultar API Docs (desde el navegador)
http://<IP_ADDR>/docs
```