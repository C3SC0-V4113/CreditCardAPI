# Backend (CreditCardAPI)
## Descripción
Esta es una API para manejar el estado de cuenta de una tarjeta de crédito, incluyendo detalles de movimientos, cálculos de cuota mínima, intereses bonificables, y el saldo disponible.

## Requisitos del Sistema
- .NET Core 8
- SQL Server

## Instalación
Clonar el Repositorio
```bash
git clone https://github.com/C3SC0-V4113/CreditCardAPI.git
cd CreditCardAPI
```

## Configurar la Base de Datos

1. Ejecutar el script database.sql para crear las tablas necesarias y agregar datos de prueba.

Tambien puedes clonar la base de datos usando el comando update-database para obtener las migraciones realizadas

## Configurar appsettings.json

Asegúrate de que tu appsettings.json tenga la cadena de conexión correcta a tu base de datos SQL Server:
```json
{
  "ConnectionStrings": {
    	"DefaultConnection": "Server=your_server;Database=CreditCardDB;User Id=your_user;Password=your_password;"
  }
}
```
Si usas autenticación con Windows cambiala por esto
```json
{
  "ConnectionStrings": {
    	"DefaultConnection": "Server=your_server;Database=CreditCardDB;Trusted_Connection=True;"
  }
}
```

## Restaurar Dependencias e Iniciar la API

```bash
dotnet restore
dotnet run
```

## Opcional
Swagger está instalado en la solución, se abre automaticamente al ejecutar el porgrama en la ruta

https://localhost:7167/swagger/index.html
