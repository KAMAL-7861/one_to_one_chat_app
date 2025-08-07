import 'package:chat_app/core/usecases/usecase.dart';
import 'package:dartz/dartz.dart';

import '../../features/auth/data/repositories/chat_repositry.dart';
import '../../features/auth/domain/entities/message_entity.dart';
import '../error/failure.dart';


class GetMessages implements UseCase<Stream<List<MessageEntity>>, String> {
  final ChatRepository repository;

  GetMessages(this.repository);

  @override
  Future<Either<Failure, Stream<List<MessageEntity>>>> call(String chatId) async {
    try {
      final stream = repository.getMessages(chatId);
      return Right(stream);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
