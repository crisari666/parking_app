import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quantum_parking_flutter/features/records/presentation/bloc/records_bloc.dart';
import 'package:auto_route/auto_route.dart';
import 'package:quantum_parking_flutter/features/records/presentation/bloc/records_event.dart';
import 'package:quantum_parking_flutter/features/records/presentation/bloc/records_state.dart';
import 'package:quantum_parking_flutter/features/records/presentation/widgets/records_list.dart';
import 'package:quantum_parking_flutter/injection/injection.dart';
import 'package:quantum_parking_flutter/l10n/app_localizations_context.dart';

@RoutePage()
class RecordsPage extends StatelessWidget {
  const RecordsPage({super.key});

  @override
  Widget build(BuildContext context) {
    if(!getIt.isRegistered<RecordsBloc>()) {
      getIt.registerSingleton<RecordsBloc>(RecordsBloc(
        vehicleRepository: getIt(),
      ));
    } 
    final recordsBloc = getIt.get<RecordsBloc>();
    return BlocProvider.value(
      value: recordsBloc..add(LoadRecordsRequested()),
      child: Scaffold(
        appBar: AppBar(
          title: Text(context.loc.vehicleRecords),
        ),
        body: BlocConsumer<RecordsBloc, RecordsState>(
          listener: (context, state) {
            // if (state is RecordsInitial) {
            // }
          },
          buildWhen: (previous, current) => previous.status != current.status,
          builder: (context, state) {
            if (state.status == RecordsStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state.logs.isNotEmpty) {
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: context.loc.searchByPlateNumber,
                        border: const OutlineInputBorder(),
                        prefixIcon: const Icon(Icons.search),
                      ),
                      onChanged: (value) {
                        context.read<RecordsBloc>().add(SearchPlateNumberChanged(value));
                      },
                    ),
                  ),
                  const Expanded(
                    child: RecordsList(),
                  ),
                ],
              );
            } else if (state.errorMessage != null) {
              return Center(
                child: Text(
                  state.errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              );
            }
            return Center(
              child: Text(context.loc.noRecordsAvailable),
            );
          },
        ),
      )
    );

    
  }
} 