import 'package:chat_app/core/usecases/usecase.dart';
import 'package:chat_app/features/auth/domain/entities/message_entity.dart';
import 'package:dartz/dartz.dart';

import '../../features/auth/data/repositories/chat_repositry.dart';
import '../error/failure.dart';

class SendMessage implements UseCase<void, SendMessageParams> {
  final ChatRepository repository;

  SendMessage(this.repository);

  @override
  Future<Either<Failure, void>> call(SendMessageParams params) async {
    try {
      await repository.sendMessage(params.chatId as MessageEntity,);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
