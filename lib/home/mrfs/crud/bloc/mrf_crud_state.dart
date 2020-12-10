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
