Feature: Buscar usuario por ID (GET /usuarios/{_id})

Background:
  # URL base definida en karate-config.js
  * url baseUrl
  # Esquema JSON de un usuario
  * def usuarioSchema = read('classpath:schemas/usuario-schema.json')
  # Feature reutilizable: crea un usuario y devuelve idUsuario y cuerpoUsuario
  * def crearUsuario = read('classpath:helpers/crear-usuario.feature')

@positivo
Scenario: Buscar un usuario existente por su ID
  * def creado = call crearUsuario
  * def idUsuario = creado.idUsuario
  * def cuerpo = creado.cuerpoUsuario

  Given path 'usuarios', idUsuario
  When method get
  Then status 200
  # Validamos la estructura contra el esquema
  And match response == usuarioSchema
  # Validamos que sea el mismo usuario que creamos
  And match response._id == idUsuario
  And match response.email == cuerpo.email
  And match response.nome == cuerpo.nome

@negativo
Scenario: Buscar un usuario con un ID que no existe
  Given path 'usuarios', 'idQueNoExiste123'
  When method get
  # 400 significa "Petición incorrecta"
  Then status 400
  # El mensaje significa: "Usuario no encontrado"
  And match response == { message: 'Usuário não encontrado' }
