import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:idara_esign/core/networking/networking.dart';
import 'package:idara_esign/core/services/logger_service.dart';
import 'package:idara_esign/features/document/domain/entities/document.dart';
import 'package:idara_esign/features/document/domain/usecases/get_document.dart';

part 'e_sign_deep_link_gate_state.dart';

class ESignDeepLinkGateCubit extends Cubit<ESignDeepLinkGateState> {
  ESignDeepLinkGateCubit(this._getDocumentUseCase)
    : super(const ESignDeepLinkGateState.loading());

  final GetDocumentUseCase _getDocumentUseCase;

  Future<void> load({required String documentId, required bool isGuest}) async {
    AppLog.i(
      '[ESignDeepLinkGateCubit] load: documentId=$documentId, isGuest=$isGuest',
    );
    emit(const ESignDeepLinkGateState.loading());

    final result = await _getDocumentUseCase(
      GetDocumentParams(documentId: documentId, isGuest: isGuest),
    );

    result.fold(
      (failure) => emit(ESignDeepLinkGateState.failure(failure)),
      (document) => emit(ESignDeepLinkGateState.success(document)),
    );
  }
}
