part of 'mrf_crud_bloc.dart';

@immutable
abstract class MrfCrudEvent {
  const MrfCrudEvent();

  List<Object> get props => [];
}

class FetchBOQ extends MrfCrudEvent {}

class FetchLocation extends MrfCrudEvent {}

class FetchStockList extends MrfCrudEvent {}

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
  final String description;

  const SaveMrfEvent({
    @required this.boq,
    @required this.pickupLocation,
    @required this.dropOffLocation,
    @required this.description,
  });

  @override
  List<Object> get props => [boq, pickupLocation, dropOffLocation, description];
}

class GetStockDetailEvent extends MrfCrudEvent {
  final String id;

  const GetStockDetailEvent({@required this.id});

  @override
  List<Object> get props => [id];
}

class AddStockToMrf extends MrfCrudEvent {
  final String id;
  final String stockId;
  final String quantity;
  final String remarks;

  const AddStockToMrf({
    @required this.id,
    @required this.stockId,
    @required this.quantity,
    @required this.remarks,
  });

  @override
  List<Object> get props => [id, stockId, quantity, remarks];
}

class DeleteStockEvent extends MrfCrudEvent {
  final String stockId;
  final String reqId;

  const DeleteStockEvent({@required this.stockId, @required this.reqId, });

  @override
  List<Object> get props => [stockId, reqId];
}

class UpdateMrfEvent extends MrfCrudEvent {
  final String reqId;
  final Location pickupLocation;
  final Location dropOffLocation;
  final String description;

  const UpdateMrfEvent({
    @required this.reqId,
    @required this.pickupLocation,
    @required this.dropOffLocation,
    @required this.description,
  });

  @override
  List<Object> get props => [reqId, pickupLocation, dropOffLocation, description];
}
