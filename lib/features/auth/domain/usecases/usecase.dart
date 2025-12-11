/// Interface base para todos os casos de uso da aplicação.
/// 
/// Define um contrato simples onde cada caso de uso recebe um parâmetro
/// (`Input`) e retorna um resultado assíncrono (`Output`).
/// 
/// Essa abstração ajuda a manter a arquitetura desacoplada, permitindo
/// que a camada de domínio não dependa de implementações concretas.
///
/// [Output] Resultado retornado pelo caso de uso.
/// [Input] Tipo dos parâmetros necessários para executá-lo.
abstract class UseCase<Output, Input> {
  Future<Output> call(Input params);
}

