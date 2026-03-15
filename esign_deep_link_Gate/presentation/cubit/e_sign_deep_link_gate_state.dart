part of 'e_sign_deep_link_gate_cubit.dart';

class ESignDeepLinkGateState extends Equatable {
  final bool isLoading;
  final Document? document;
  final AppFailure? failure;

  const ESignDeepLinkGateState._({
    required this.isLoading,
    this.document,
    this.failure,
  });

  const ESignDeepLinkGateState.loading() : this._(isLoading: true);

  const ESignDeepLinkGateState.success(Document document)
    : this._(isLoading: false, document: document);

  const ESignDeepLinkGateState.failure(AppFailure failure)
    : this._(isLoading: false, failure: failure);

  @override
  List<Object?> get props => [isLoading, document, failure];
}
