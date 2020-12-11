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