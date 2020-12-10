part of 'mrf_crud_bloc.dart';

@immutable
abstract class MrfCrudEvent {
  const MrfCrudEvent();

  List<Object> get props => [];
}

class DeleteMrfEvent extends MrfCrudEvent {
  final int mrfId;
  const DeleteMrfEvent({@required this.mrfId});
  @override
  List<Object> get props => [mrfId];
}
