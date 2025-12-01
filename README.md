


# StarWars Explorer — Prueba Técnica iOS (Swift / MVVM / Clean Architecture)
## SWAPI (The Star Wars API) 

Fuente: [https://swapi.dev/](https://swapi.dev/) 
Documentación: [https://swapi.dev/documentation](https://swapi.dev/documentation) 

Este proyecto es una aplicación iOS desarrollada en **Swift 6** utilizando **SwiftUI**, arquitectura **MVVM**, concurrencia nativa (`async/await`) y principios de **Clean Architecture**.

La app consume la API pública **SWAPI** y permite visualizar personajes, su información y las películas en las que aparecen.

## Cumplimiento de los Requerimientos

A continuación se detalla cómo el proyecto cumple cada uno de los puntos solicitados en la prueba técnica:

---

###  1. Listado de todos los personajes con paginación tipo *endless*

La aplicación carga todos los personajes de SWAPI usando paginación manual, sin librerías externas, y muestra en el listado exactamente la información solicitada.

**Identificación visual del tipo de género (implementación real):**
- Para algunos personajes se añadieron avatares personalizados en los assets.
- Para el resto, la app genera dinámicamente un avatar utilizando **SF Symbols (versión beta)**.
- El avatar muestra un **borde y color dinámico según el género**:
  - **Blue** → género masculino  
  - **Pink** → género femenino  
  - **Gray** → género desconocido o no especificado  

Esto cumple con el requisito de mostrar una “foto/tipo identificativo del género” sin depender de imágenes externas para todos los personajes.

Además, el listado muestra:
- Nombre del personaje  
- Fecha de nacimiento (`BirthYear` formateado)  

Y toda la paginación funciona al estilo *endless scroll*, gestionada desde `PeopleListViewModel`.

---

###  2. Detalle del personaje mostrando películas ordenadas por fecha de estreno
Al pulsar sobre un personaje, la aplicación:
- Navega a `PersonDetailView`.
- Carga las películas asociadas mediante `GetPersonFilmsUseCase`, utilizando concurrencia con `TaskGroup`.
- Ordena las películas **cronológicamente por fecha de estreno**, tal como exige el enunciado.

**Cada película muestra:**
- Nombre de la película.
- Director.
- Fecha de estreno.

---

###  3. Funcionamiento sin conexión con los últimos datos cargados
El proyecto implementa un modo **offline** mediante el mecanismo de caché local del repositorio:

- `CachedResponse` informa si los datos provienen del caché.
- Si la API falla, la app sigue funcionando con los datos descargados previamente.
- La UI muestra `isOfflineMode = true` cuando se está utilizando información local.
- Los ViewModels están preparados para mostrar datos almacenados si no hay red.

Esto garantiza que la aplicación cumple el requisito de:

> “La app debe funcionar sin conexión a internet con los últimos datos cargados para que los miembros del equipo puedan acceder a la información en cualquier circunstancia.”

---

### Resultado

Todos los requerimientos del proyecto han sido implementados siguiendo las buenas prácticas:

- Arquitectura MVVM + Use Cases + Repositories  
- Concurrencia moderna (`async/await`, `TaskGroup`)  
- SwiftUI para toda la interfaz  
- Caché local para modo offline  
- Paginación personalizada sin librerías  
- Tests unitarios completos para ViewModels y Use Cases  


#CUESTIONARIO (a contestar por escrito en el README) 
Contestad las siguientes preguntas  una  vez **terminado  el  proyecto** en el ***README***.
- El equipo Mobile ha ganado  el  concurso y cree que la app puede ser útil para muchos fans de la franquicia, por lo que han  decidido  publicarla  en las tiendas de aplicaciones y monetizarla. Se ha optado  por  mostrar  anuncios  en la aplicación, concretamente  en  los  listados de los  personajes. Los anuncios son generados  por  un SDK  interno de la compañía al que habrá que llamar  cada  vez que necesitemos  generar un anuncio. Cada X personajes  en  los  listados se quiere  mostrar un anuncio. ¿Qué  cambios  realizarías  en  el  proyecto para cubrir  esta  necesidad? 
- Se decide crear una segunda aplicación o Widget que comparta la misma fuente de datos local de personajes ya creada. ¿Qué  cambios  ejecutarías en el proyecto?

## 1. Inserción de anuncios en el listado de personajes

El equipo quiere monetizar la app mostrando un anuncio **cada X personajes**, usando un **SDK interno** que se debe invocar de forma explícita.

### Integrar anuncios manteniendo:
- Clean Architecture  
- Testabilidad  
- Separación de capas  
- Independencia de la UI respecto al SDK  

---
###  **CAMBIOS PROPUESTOS y REALIZADOS**
- Para la prueba técnica trabajaré con anuncios falsos,sin depender de SDKs reales, utilizando **Picsum**
    que me permite generar imágenes tipo banner como si fueran anuncios reales.
### 1. Defini el modelo del anuncio (Data/Domain), solo con lo que la UI necesita: id,título,imagen(URL), etc.
```swift
Data:
struct AdDTO: Decodable {
    let title: String
    let imageURL: URL?
    let actionURL: URL?
}
Domain: 
struct AdModel: Identifiable {
    let id: UUID
    let title: String
    let imageURL: URL?
    let actionURL: URL?  //para simular un tap
}
```

### 2. Crear el Protocolo del proveedor de anuncios (Domain), esto abstrae el SDK/API real
```swift
protocol AdsProviderProtocol {
    func loadAd() async throws -> AdModel
}
```

### 3. Implementar un proveedor fake de anuncios (Data/Provider)
```swift
final class FakeAdsProvider: AdsProviderProtocol {

    func loadAd() async throws -> AdModel {
        // Aquí se llamaría al SDK interno de la compañía, de momento son fakes
        // y se adaptaria la respuesta a AdModel
    }
}
```

### 4. Crear un tipo para los elementos de la lista (Presentation).
    este tipo "PeopleListItem será el que pinte la vista, en lugar de [Person] directamente"
```swift
enum PeopleListItem: Identifiable {
    case person(Person)
    case ad(AdModel)

    var id: String {
        switch self {
        case .person(let person): return person.id
        case .ad(let ad): return ad.id.uuidString
        }
    }
}
```
### 5. Actualizar el PeopleListViewModel
    - Inyectar AdsProviderProtocol en el init
    - Añadir una propiedad addFrequency (por ejemplo cada 5 personajes)
    - Añadir almacenamiento para anuncios precargados ([In:AddModel] o similar)
    - Crear una propiedad computada listItems: [PeopleListItem]
    - método preloadAdsIfNeeded (forPage:) para ir pidiendo anuncios cuando llegan
        nuevas páginas.
        
### 6. Actualizar la vista PeopleListView
    - En lugar de iterar sobre viewModel.filteredPeople o people, iterar sobre viewModel.listItems
    - Crear una vista AdRowView para mostrar el anuncio (AdModel)
    - Mantener PersonRowView sin cambios.

### 7. Actualizar los tests del PeopleListViewModel
    - Crear MockAdsProvider que implemente AdsProviderProtocol.
    - test para:
        - se insertan un .ad cada X personajes.
        - el ViewModel sigue funcionando incluso si el proveedor de anuncios falla.
    

## 2. Segunda app o Widget que comparta la misma fuente de datos local

### Los objetivos serían:
- Reutilizar al máximo la lógica de dominio y datos.
- Evitar duplicar código (repositorios, modelos, mapeos).
- Permitir que app principal y widget vean los mismos datos locales.
---
###  **CAMBIOS PROPUESTOS**

### 1. Crear un módulo independiente, extrayendo la lógica de dominio + data, hay dos formas de hacerlo 
- Con Swift Package o un framework interno 

- Este módulo contendría:
Modelos de dominio: Person, Film, BirthYear, etc.

Protocolos de repositorio: PeopleRepositoryProtocol, FilmsRepositoryProtocol

Use Cases: LoadPeoplePageUseCase, GetPersonFilmsUseCase, etc.

Lógica de mapeo DTO → dominio.

Lógica de caché local (por ejemplo, un PeopleLocalDataSource).
- La app principal y el widget se enlazarían contra este módulo y reutilizarían exactamente el mismo código.

### 2. Diseñar una fuente de datos local compartida

Para que la app principal y el widget usen los mismos personajes sin duplicar nada, lo ideal es que ambos accedan exactamente al mismo archivo o base de datos.

Dependiendo del método de persistencia:

**Si se usa base de datos (Core Data / SwiftData):**
- Se crea el contenedor de persistencia dentro del módulo compartido.
- Se activa un **App Group**, y tanto la app como el widget apuntan al mismo archivo de la base de datos.
- El `PeopleRepository` puede leer y escribir ahí, y cuando no hay conexión usará esos datos como caché.

**Si se usa fichero local (JSON / plist / ..):**
- El fichero se guarda dentro del **App Group**.
- Se expone un `PeopleLocalDataSourceProtocol` que se encarga de leer/escribir ese fichero.
- Tanto la app como el widget acceden a la misma ruta, así los datos están siempre sincronizados.

### 3. Repositorios adaptados a cada proceso, pero apuntando a la misma fuente física
- En la app -> red + caché, el repositorio podría:
        - Descargar de la API.
        - Guardar en local.
        - Servir al ViewModel.
- En el widget -> solo lectura desde caché:
        - El repositorio podría solo ser de lectura y usar únicamente un localDataSource para evitar llamadas a red costosas
        - El widget solo mostraría datos ya cacheados por la app principal
        

###  **RESUMEN**

#### **Anuncios en la lista de personajes**
- Crear un `AdsProviderProtocol` como capa de abstracción del SDK interno de anuncios.
- Modificar el ViewModel para exponer una lista heterogénea `PeopleListItem` (persona o anuncio).
- Insertar un anuncio cada *X* personajes en la capa de presentación, manteniendo el código desacoplado, testeable y siguiendo MVVM + Clean Architecture.

---

#### **Segunda app o Widget con la misma fuente de datos**
- Extraer el dominio y la capa de datos a un módulo compartido (Swift Package o framework interno).
- Guardar la base de datos o fichero local dentro de un **App Group**, lo que permite que distintos targets compartan el mismo almacenamiento.
- Mantener repositorios que apunten al mismo origen de datos, pero con comportamiento adaptado:
  - App principal → lectura y escritura.
  - Widget → lectura (sin llamadas de red).

## Autora

Grace Toapanta
Desarrolladora iOS – SwiftUI/UIKit
📧 gracetoa29@gmail.com

💼 LinkedIn
https://www.linkedin.com/in/grace-toa/

Repositorios
https://github.com/GraceToa
https://github.com/GraceToa/StarWarsApp

