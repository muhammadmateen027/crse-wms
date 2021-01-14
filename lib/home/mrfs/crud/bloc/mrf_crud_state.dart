part of 'mrf_crud_bloc.dart';

@immutable
abstract class MrfCrudState {
  const MrfCrudState();

  List<Object> get props => [];
}

class MrfCrudInitial extends MrfCrudState {}

class MrfCrudLoading extends MrfCrudState {}

class MrfCrudFailure extends MrfCrudState {
  final String error;
  const MrfCrudFailure({@required this.error});
  @override
  List<Object> get props => [error];
}
class MrfDeleteSuccess extends MrfCrudState {}

class ScannedSuccessState extends MrfCrudState {
  final int reqId;
  const ScannedSuccessState({@required this.reqId});
  @override
  List<Object> get props => [reqId];
}

class StockDeleteSuccess extends MrfCrudState {}

class MRFSavedState extends MrfCrudState {}

class LocationLoaded extends MrfCrudState {
  final List<Location> locations;
  const LocationLoaded({@required this.locations});
  @override
  List<Object> get props => [locations];
}

class BoqLoaded extends MrfCrudState {
  final List<BOQ> boqs;
  const BoqLoaded({@required this.boqs});
  @override
  List<Object> get props => [boqs];
}

class StockDetailLoadedState extends MrfCrudState {
  final StockDetail stockDetail;
  const StockDetailLoadedState({@required this.stockDetail});
  @override
  List<Object> get props => [stockDetail];
}
class StockListLoaded extends MrfCrudState {
  final List<StockInfo> stockList;
  const StockListLoaded({@required this.stockList});
  @override
  List<Object> get props => [stockList];
}

class StockSavedSuccessState extends MrfCrudState {}