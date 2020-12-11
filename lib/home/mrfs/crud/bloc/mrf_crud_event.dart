part of 'mrf_crud_bloc.dart';

@immutable
abstract class MrfCrudEvent {
  const MrfCrudEvent();

  List<Object> get props => [];
}

class FetchBOQ extends MrfCrudEvent {}

class FetchLocation extends MrfCrudEvent {}

class DeleteMrfEvent extends MrfCrudEvent {
  final int mrfId;

  const DeleteMrfEvent({@required this.mrfId});

  @override
  List<Object> get props => [mrfId];
}

class SaveMrfEvent extends MrfCrudEvent {
  final BOQ boq;
  final Location pickupLocation;
  final Location dropOffLocation;
  final String comment;

  const SaveMrfEvent({
    @required this.boq,
    @required this.pickupLocation,
    @required this.dropOffLocation,
    @required this.comment,
  });

  @override
  List<Object> get props => [boq, pickupLocation, dropOffLocation, comment];
}
