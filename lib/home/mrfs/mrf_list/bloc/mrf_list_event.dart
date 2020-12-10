part of 'mrf_list_bloc.dart';

@immutable
abstract class MrfListEvent {
  const MrfListEvent();

  List<Object> get props => [];
}

class FetchMRFs extends MrfListEvent{}