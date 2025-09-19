# 🔐 Guía Completa de Configuración de Credenciales

## 📋 Resumen de Credenciales Necesarias

Necesitarás configurar credenciales para:
- ✅ **Azure** (Service Principal)
- ✅ **GitHub** (Secrets)
- ✅ **Power BI** (Service Principal)
- ✅ **Microsoft Teams** (Webhook)
- ✅ **SQL Server** (Credenciales de admin)

---

## 🔵 1. CREDENCIALES DE AZURE

### Paso 1: Crear Service Principal en Azure

#### 1.1 Abrir Azure Cloud Shell
1. Ve a [portal.azure.com](https://portal.azure.com)
2. Haz clic en el ícono de **Cloud Shell** (>_) en la barra superior
3. Selecciona **PowerShell** si te pregunta

#### 1.2 Crear el Service Principal
```powershell
# Crear Service Principal
$sp = az ad sp create-for-rbac --name "MoviesAnalytics-SP" --role "Contributor" --scopes "/subscriptions/TU_SUBSCRIPTION_ID"

# El comando anterior te dará una salida como esta:
{
  "appId": "12345678-1234-1234-1234-123456789012",
  "displayName": "MoviesAnalytics-SP",
  "password": "tu-password-secreto",
  "tenant": "87654321-4321-4321-4321-210987654321"
}
```

#### 1.3 Obtener tu Subscription ID
```powershell
# Obtener Subscription ID
az account show --query id --output tsv
```

#### 1.4 Guardar las Credenciales de Azure
**✅ TUS CREDENCIALES DE AZURE:**
- `AZURE_CLIENT_ID` = `81d652a7-94b4-4d3d-b6f1-b470328589c`
- `AZURE_CLIENT_SECRET` = `Vn18Q~h4KEcvMKPUdOexmDF80A7veDh_CJB3GdAz`  
- `AZURE_TENANT_ID` = `b6b466ee-4c8d-4011-b9fc-fbdc-f82ac90a`
- `AZURE_SUBSCRIPTION_ID` = `b6dc0966-d07c-4b7d-9ccc-ecf393c7caf2`

---

## 🟢 2. CREDENCIALES DE GITHUB

### Paso 1: Configurar GitHub Secrets

#### 2.1 Ir a tu Repositorio
1. Ve a tu repositorio en GitHub
2. Haz clic en **Settings** (Configuración)
3. En el menú lateral, haz clic en **Secrets and variables** > **Actions**

#### 2.2 Agregar Secrets de Azure
Haz clic en **New repository secret** para cada uno:

```
Nombre: AZURE_CLIENT_ID
Valor: 81d652a7-94b4-4d3d-b6f1-b470328589c

Nombre: AZURE_CLIENT_SECRET  
Valor: Vn18Q~h4KEcvMKPUdOexmDF80A7veDh_CJB3GdAz

Nombre: AZURE_TENANT_ID
Valor: b6b466ee-4c8d-4011-b9fc-fbdc-f82ac90a

Nombre: AZURE_SUBSCRIPTION_ID
Valor: b6dc0966-d07c-4b7d-9ccc-ecf393c7caf2
```

---

## 🔴 3. CREDENCIALES DE POWER BI

### Paso 1: Registrar Aplicación en Azure AD

#### 3.1 Ir a Azure Active Directory
1. En [portal.azure.com](https://portal.azure.com)
2. Busca **"Azure Active Directory"**
3. Haz clic en **App registrations** (Registros de aplicaciones)
4. Haz clic en **New registration** (Nuevo registro)

#### 3.2 Configurar la Aplicación
```
Nombre: MoviesAnalytics-PowerBI
Supported account types: Accounts in this organizational directory only
Redirect URI: (déjalo vacío por ahora)
```

#### 3.3 Obtener Credenciales de la App
✅ **TUS CREDENCIALES DE POWER BI:**
- **POWERBI_CLIENT_ID** = `4211a6a2-3acf-455b-a64e-e0b6976b8fbb`
- **POWERBI_TENANT_ID** = `b6b466ee-468d-4011-b9fc-fbdcf82ac90a`

#### 3.4 Crear Client Secret
✅ **CLIENT SECRET CREADO:**
- **POWERBI_CLIENT_SECRET** = `a12cfcb5-22db-47bc-ab56-1f52c50dfbd0`

### Paso 2: Configurar Permisos de Power BI

#### 3.5 Agregar Permisos API
1. Ve a **API permissions**
2. Haz clic en **Add a permission**
3. Selecciona **Power BI Service**
4. Selecciona **Delegated permissions**
5. Marca estas opciones:
   - `Dataset.ReadWrite.All`
   - `Report.ReadWrite.All`
   - `Workspace.ReadWrite.All`
6. Haz clic en **Add permissions**
7. Haz clic en **Grant admin consent** (Conceder consentimiento de administrador)

### Paso 3: Configurar Power BI Service

#### 3.6 Habilitar Service Principal en Power BI
1. Ve a [app.powerbi.com](https://app.powerbi.com)
2. Haz clic en el ícono de configuración ⚙️
3. Selecciona **Admin portal**
4. Ve a **Tenant settings**
5. Busca **"Allow service principals to use Power BI APIs"**
6. **Habilítalo** y agrega tu Service Principal

#### 3.7 Crear Workspace
1. En Power BI, haz clic en **Workspaces**
2. Haz clic en **Create a workspace**
3. Nombre: `Movies-Analytics-Production`
4. Copia el **Workspace ID** de la URL → `POWERBI_WORKSPACE_ID`

### Paso 4: Agregar Secrets de Power BI a GitHub
```
Nombre: POWERBI_CLIENT_ID
Valor: 4211a6a2-3acf-455b-a64e-e0b6976b8fbb

Nombre: POWERBI_CLIENT_SECRET
Valor: a12cfcb5-22db-47bc-ab56-1f52c50dfbd0

Nombre: POWERBI_TENANT_ID
Valor: b6b466ee-468d-4011-b9fc-fbdcf82ac90a

Nombre: POWERBI_WORKSPACE_ID
Valor: 96714fad-710b-4226-9a83-9330f4d58525
```

---

## 🟡 4. CREDENCIALES DE SQL SERVER

### Paso 1: Definir Credenciales de Admin

#### 4.1 Crear Credenciales Seguras
Elige credenciales fuertes:
```
Usuario: moviesadmin
Contraseña: [Genera una contraseña fuerte con al menos 12 caracteres, mayúsculas, minúsculas, números y símbolos]
```

#### 4.2 Agregar a GitHub Secrets
```
Nombre: SQL_ADMIN_USERNAME
Valor: moviesadmin

Nombre: SQL_ADMIN_PASSWORD
Valor: [tu contraseña fuerte]
```

---

## 🟣 5. WEBHOOK DE MICROSOFT TEAMS (OPCIONAL)

### Paso 1: Crear Webhook en Teams

#### 5.1 Configurar Canal de Teams
1. Abre Microsoft Teams
2. Ve al canal donde quieres recibir notificaciones
3. Haz clic en **...** (más opciones) junto al nombre del canal
4. Selecciona **Connectors**

#### 5.2 Configurar Incoming Webhook
1. Busca **"Incoming Webhook"**
2. Haz clic en **Configure**
3. Nombre: "Movies Analytics Notifications"
4. Sube una imagen (opcional)
5. Haz clic en **Create**
6. **Copia la URL del webhook** → `TEAMS_WEBHOOK_URL`

#### 5.3 Agregar a GitHub Secrets
```
Nombre: TEAMS_WEBHOOK_URL
Valor: [URL del webhook que copiaste]
```

---

## 📊 6. VERIFICACIÓN FINAL

### Lista de Verificación de Secrets en GitHub

Ve a tu repositorio → Settings → Secrets and variables → Actions

Deberías tener estos 9 secrets:

```
✅ AZURE_CLIENT_ID
✅ AZURE_CLIENT_SECRET  
✅ AZURE_TENANT_ID
✅ AZURE_SUBSCRIPTION_ID
✅ POWERBI_CLIENT_ID
✅ POWERBI_CLIENT_SECRET
✅ POWERBI_TENANT_ID
✅ POWERBI_WORKSPACE_ID
✅ SQL_ADMIN_USERNAME
✅ SQL_ADMIN_PASSWORD
✅ TEAMS_WEBHOOK_URL (opcional)
```

---

## 🚀 7. COMANDOS PARA VERIFICAR CREDENCIALES

### Verificar Azure CLI
```powershell
# Verificar que estás logueado
az account show

# Verificar que el Service Principal funciona
az login --service-principal -u $AZURE_CLIENT_ID -p $AZURE_CLIENT_SECRET --tenant $AZURE_TENANT_ID
```

### Verificar Power BI
```powershell
# Instalar módulo de Power BI
Install-Module -Name MicrosoftPowerBIMgmt -Force

# Conectar con Service Principal
$securePassword = ConvertTo-SecureString $POWERBI_CLIENT_SECRET -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential($POWERBI_CLIENT_ID, $securePassword)
Connect-PowerBIServiceAccount -ServicePrincipal -Credential $credential -TenantId $POWERBI_TENANT_ID
```

---

## ⚠️ NOTAS IMPORTANTES

### Seguridad
- **NUNCA** compartas estas credenciales
- **NUNCA** las subas al código fuente
- Usa solo GitHub Secrets para almacenarlas
- Rota las credenciales cada 6 meses

### Permisos Mínimos
- El Service Principal de Azure necesita rol **Contributor** en la subscription
- El Service Principal de Power BI necesita permisos de **Admin** en el workspace
- Las credenciales de SQL son para el admin de la base de datos

### Troubleshooting
Si algo no funciona:
1. Verifica que todos los secrets estén configurados correctamente
2. Asegúrate de que los Service Principals tengan los permisos correctos
3. Revisa los logs de GitHub Actions para errores específicos

---

## 🎯 PRÓXIMO PASO

Una vez que tengas todas las credenciales configuradas:

1. **Sube el código a GitHub**:
```bash
git add .
git commit -m "Initial Movies Analytics Platform setup"
git push origin main
```

2. **Los workflows se ejecutarán automáticamente** y crearán toda la infraestructura

3. **Monitorea el progreso** en la pestaña **Actions** de tu repositorio

¡Ya tienes todo listo para desplegar tu plataforma de análisis de películas! 🎬🚀