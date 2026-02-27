import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quantum_parking_flutter/core/utils/snackbar_service.dart';
import 'package:quantum_parking_flutter/features/setup/data/datasources/business_remote_datasource.dart';
import 'package:quantum_parking_flutter/features/setup/presentation/bloc/setup_bloc.dart';
import 'package:quantum_parking_flutter/features/setup/presentation/bloc/setup_event.dart';
import 'package:auto_route/auto_route.dart';
import 'package:quantum_parking_flutter/features/setup/data/datasources/setup_local_datasource.dart';
import 'package:quantum_parking_flutter/features/setup/presentation/bloc/setup_state.dart';
import 'package:quantum_parking_flutter/injection/injection.dart';
import 'package:quantum_parking_flutter/features/setup/presentation/widgets/setup_form.dart';
import 'package:quantum_parking_flutter/core/utils/custom_scroll_behaviour.dart';
import 'package:quantum_parking_flutter/l10n/app_localizations.dart';

@RoutePage()
class SetupPage extends StatelessWidget {
  const SetupPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    
    return BlocProvider(
      create: (context) => SetupBloc(
        localDatasource: getIt.get<SetupLocalDatasource>(),
        businessRemoteDatasource: getIt.get<BusinessRemoteDatasource>(),
      )..add(SetupStarted()),
      child: BlocListener<SetupBloc, SetupState>(
        listener: (context, state) {
          if (state is SetupSuccess && state.setup != null) {
            if (state.isFromSave) {
              SnackbarService.instance.showSuccessSnackbar(
                message: l10n.setupSavedSuccess,
              );
            }
          } else if (state is SetupError) {
            SnackbarService.instance.showErrorSnackbar(
              message: state.message,
            );
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(l10n.setup),
          ),
          body: ScrollConfiguration(
            behavior: NoGlowScrollBehaviour(),
            child: const SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: SetupForm(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

