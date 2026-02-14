# SeaBook - Plataforma de Préstamos Bibliotecarios en AWS

# **1.Descripción del Proyecto**:
SeaBook es una plataforma digital peruana diseñada para gestionar el préstamo de libros en el sistema de bibliotecas universitarias de la UTP (Universidad Tecnológica del Perú). Este proyecto 
representa una transformación completa de su arquitectura monolítica original a una moderna, escalable, segura y resiliente en Amazon Web Services (AWS), siguiendo las mejores prácticas 
de Infraestructura como Código (IaC).El objetivo principal es garantizar la continuidad del servicio y una experiencia de usuario óptima para más de 150,000 alumnos en 15 campus a nivel nacional, especialmente 
durante picos de alta demanda.

# **2. La Problemática de SeaBook**:
  La situación original:
  + Arquitectura monolítica: Un único servidor de aplicación y una sola base de datos.
  + Problemas de rendimiento: Caídas frecuentes y tiempos de respuesta de más de 2 minutos durante inicios de semestre, matrículas y exámenes.
  + Falta de escalabilidad: Incapacidad para manejar miles de solicitudes concurrentes.
  + Sin tolerancia a fallos: Un punto único de fallo que afectaba la disponibilidad del servicio. 

  Nuestra solución: Una arquitectura moderna en AWS que aborda estos problemas mediante la implementación de alta disponibilidad, escalado automático, seguridad robusta y un pipeline de despliegue automatizado.

## **3. Arquitectura en AWS**:
   El diseño se organiza en 14 pasos lógicos, cada uno asociado a un atributo de calidad y servicios de AWS específicos. El corazón del diseño se encuentra en la tabla conceptual que guía la implementación.
   A continuación, se presenta el flujo de alto nivel de la arquitectura:

| Atributo de Calidad | Paso | Servicios AWS | Función Principal |
| :--- | :--- | :--- | :--- |
| **Rendimiento** | 1. Entrada | `Route 53`, `Global Accelerator` | Enrutamiento inteligente por latencia y "autopista privada" para baja latencia. |
| **Seguridad** | 2-4. Filtro, Control, Red | `Shield`, `WAF`, `Cognito`, `API Gateway`, `Secrets Manager`, `VPC` | Protección DDoS, rate limiting, autenticación, y red privada aislada. |
| **Resiliencia** | 5. Reparto | `ALB` + `Health Checks` | Balanceo de carga y desvío automático de tráfico en <5s si un nodo falla. |
| **Escalabilidad**| 6. Cómputo | `EC2` (en `EKS`), `Auto Scaling Groups` | Escalado horizontal automático basado en el uso de CPU. |
| **Disponibilidad**| 7. Orquestación | `Amazon EKS` (Kubernetes), `HPA` | Orquestación de contenedores y auto-escalado de pods al 80% de uso de CPU. |
| **Mantenibilidad**| 8. Interconexión | `App Mesh`, `Service Discovery` | Comunicación segura y dinámica entre microservicios. |
| **Rendimiento** | 9. Rapidez | `ElastiCache (Redis)`, `OpenSearch` | Caché de datos y búsquedas de texto completo de alto rendimiento. |
| **Fiabilidad** | 10. Persistencia | `Aurora Serverless v2`, `Multi-AZ` | Base de datos SQL escalable, ACID-compliant y con réplicas en múltiples zonas. |
| **Resiliencia** | 11. Mensajería | `SQS (FIFO)`, `DLQ` | Cola de mensajes FIFO para garantizar el orden y la integridad de las transacciones. |
| **Rendimiento** | 12. Acción Asíncrona | `Lambda`, `SNS` | Procesamiento asíncrono (generación de PDFs, notificaciones) para no bloquear la app. |
| **Auditabilidad** | 13. Auditoría | `CloudTrail`, `S3 Object Lock` | Registro inmutable de todas las acciones para cumplimiento y forense. |
| **Observabilidad**| 14. Vigilancia | `CloudWatch`, `X-Ray` | Monitoreo, alertas y trazabilidad end-to-end con Correlation IDs. |
| **Desplegabilidad**| 15. Despliegue | `CodePipeline`, `CodeDeploy`, `Terraform` | CI/CD con despliegues Blue/Green y rollback automático en <5min. |

## **Comandos de ejecución**:
+ Antes de nada, activamos nuestra cuenta en aws y los IAM para en la terminal ejecutar el "aws configure sso"
+ Se selecciona un usuario, en nuestro caso usamos "Seabook"
+ Seguimos los pasos, y ya tenemos activado el aws

Para los archivos terraform, tenemos lo siguiente:
 + Inicialización:
```bash
terraform init
terraform update
```
  Gestión de entornos:

El proyecto utiliza la función terraform.workspace :para los recursos, así que se va a crear el usuario a trabajar
```bash
terraform workspace new dev (ejemplo)
```
Si ya existe más de uno entonces se escoje cual
```bash
terraform workspace select dev
```
Planificación: Se visualiza la sintaxis del código para asegurar que no hayan errores de esta misma
```bash
terraform plan
```
Despliegue: Para la creación de los servicios
```bash
terraform apply
```
+ Limpieza opcional: Al acabar, se pueden borrar todo lo creado
```bash
terraform destroy
```
## Consideraciones:
## Resultados


- Anton Figueroa, Raul
- Chavez Segura, Cristhoper
- Rivera Chamorro, Kristel 
- Saldaña Ylquimiche, Oliver
- Velasquez Avalos, Marycielo
