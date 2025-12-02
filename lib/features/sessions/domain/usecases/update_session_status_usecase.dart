import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:soulware_app/features/sessions/presentation/sessions.dart';

final updateSessionStatusUseCaseProvider =
    Provider<UpdateSessionStatusUseCase>((ref) {
  return UpdateSessionStatusUseCase(ref);
});

class UpdateSessionStatusUseCase {
  final Ref ref;

  UpdateSessionStatusUseCase(this.ref);

  Future<void> call({
    required int id,
    required String status,
  }) async {
    final repo = ref.read(sessionsRepositoryProvider);
    await repo.updateSessionStatus(id, status);
  }
}
