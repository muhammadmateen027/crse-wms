import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'mrf_event.dart';
part 'mrf_state.dart';

class MrfBloc extends Bloc<MrfEvent, MrfState> {
  MrfBloc() : super(MrfInitial());

  @override
  Stream<MrfState> mapEventToState(
    MrfEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}
