part of 'mrf_list_bloc.dart';

@immutable
abstract class MrfListState {
  const MrfListState();

  List<Object> get props => [];
}

class MrfListInitial extends MrfListState {}

class MrfListLoading extends MrfListState {}

class EmptyMrfListState extends MrfListState {}

class MrfLoadState extends MrfListState {
  final List<MrfData> mrfList;
  const MrfLoadState({@required this.mrfList});
  @override
  List<Object> get props => [mrfList];
}

class MrfListFailure extends MrfListState {
  final String error;
  const MrfListFailure({@required this.error});
  @override
  List<Object> get props => [error];
}
