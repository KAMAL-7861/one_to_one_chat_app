import 'package:dartz/dartz.dart';
import '../../features/auth/domain/entities/message_entity.dart';
import '../error/failure.dart';

abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}


class NoParams {
  const NoParams();
}
class SendMessageParams {
  final String chatId;
  final MessageEntity message;

  SendMessageParams({required this.chatId, required this.message});
}
