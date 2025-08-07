import 'package:chat_app/core/usecases/usecase.dart';
import 'package:dartz/dartz.dart';

import '../../features/auth/data/repositories/chat_repositry.dart';
import '../../features/auth/domain/entities/chat_entity.dart';
import '../error/failure.dart';


class GetChats implements UseCase<Stream<List<ChatEntity>>, String> {
  final ChatRepository repository;

  GetChats(this.repository);

  @override
  Future<Either<Failure, Stream<List<ChatEntity>>>> call(String uid) async {
    try {
      final stream = repository.getChats(uid);
      return Right(stream);
    } catch (e) {
      // Replace with more detailed failure handling if needed
      return Left(ServerFailure(e.toString()));
    }
  }
}
