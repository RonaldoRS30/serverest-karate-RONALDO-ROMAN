Feature: Listar usuarios (GET /usuarios)

Background:
  * url baseUrl
  * def usuarioSchema = read('classpath:resources/request/usuario-schema.json')
  * def crearUsuario = read('classpath:resources/helpers/crear-usuario.feature')

@positivo
Scenario: Listar todos los usuarios correctamente
  Given path 'usuarios'
  When method get
  Then status 200
  And match response.quantidade == '#number'
  And match response.usuarios == '#[]'
  And match response.quantidade == response.usuarios.length
  And match each response.usuarios == usuarioSchema

@positivo
Scenario: Filtrar usuarios por email
  * def creado = call crearUsuario
  * def idUsuario = creado.idUsuario
  * def cuerpo = creado.cuerpoUsuario

  Given path 'usuarios'
  And param email = cuerpo.email
  When method get
  Then status 200
  And match response.quantidade == 1
  And match response.usuarios[0] == usuarioSchema
  And match response.usuarios[0]._id == idUsuario
  And match response.usuarios[0].email == cuerpo.email

@positivo
Scenario: Un filtro sin coincidencias devuelve lista vacía
  Given path 'usuarios'
  And param email = 'no_existe_zzz@test.com'
  When method get
  Then status 200
  And match response.quantidade == 0
  And match response.usuarios == []

@negativo
Scenario: Rechaza filtrar por un email con formato inválido
  Given path 'usuarios'
  And param email = 'no-es-email'
  When method get
  Then status 400
  And match response == '#object'
  And match response.email == 'email deve ser um email válido'

@negativo
Scenario: Filtrar por un _id inexistente no devuelve error
  # Un _id inválido no responde 400: la API lo trata como filtro sin coincidencias
  Given path 'usuarios'
  And param _id = 'abc'
  When method get
  Then status 200
  And match response.quantidade == 0
  And match response.usuarios == []
