Feature: Eliminar usuario (DELETE /usuarios/{_id})

Background:
  # URL base definida en karate-config.js
  * url baseUrl
  # Feature reutilizable: crea un usuario y devuelve idUsuario y cuerpoUsuario
  * def crearUsuario = read('classpath:helpers/crear-usuario.feature')

@positivo
Scenario: Eliminar un usuario existente
  * def creado = call crearUsuario
  * def idUsuario = creado.idUsuario

  Given path 'usuarios', idUsuario
  When method delete
  Then status 200
  # El mensaje significa: "Registro eliminado con éxito"
  And match response.message == 'Registro excluído com sucesso'

  # Confirmamos que ya no existe
  Given path 'usuarios', idUsuario
  When method get
  Then status 400
  # El mensaje significa: "Usuario no encontrado"
  And match response.message == 'Usuário não encontrado'

@negativo
Scenario: Eliminar un ID que no existe
  Given path 'usuarios', 'idQueNoExiste123'
  When method delete
  Then status 200
  # El mensaje significa: "Ningún registro eliminado"
  And match response.message == 'Nenhum registro excluído'
