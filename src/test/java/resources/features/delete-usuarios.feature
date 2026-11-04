Feature: Eliminar usuario (DELETE /usuarios/{_id})

Background:
  * url baseUrl
  * def crearUsuario = read('classpath:resources/helpers/crear-usuario.feature')

@positivo
Scenario: Eliminar un usuario existente
  * def creado = call crearUsuario
  * def idUsuario = creado.idUsuario

  Given path 'usuarios', idUsuario
  When method delete
  Then status 200
  And match response.message == 'Registro excluído com sucesso'

  Given path 'usuarios', idUsuario
  When method get
  Then status 400
  And match response.message == 'Usuário não encontrado'

@negativo
Scenario: Eliminar un ID que no existe
  Given path 'usuarios', 'idQueNoExiste123'
  When method delete
  Then status 200
  And match response.message == 'Nenhum registro excluído'
