import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quantum_parking_flutter/features/closure/presentation/bloc/closure_bloc.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:quantum_parking_flutter/features/closure/presentation/bloc/closure_event.dart';
import 'package:quantum_parking_flutter/features/closure/presentation/bloc/closure_state.dart';
import 'package:quantum_parking_flutter/features/closure/presentation/widgets/daily_summary_card.dart';
import 'package:quantum_parking_flutter/features/closure/presentation/widgets/financial_summary_card.dart';

@RoutePage()
class ClosurePage extends StatelessWidget {
  const ClosurePage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    context.read<ClosureBloc>().add(GenerateDailyClosureRequested());
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.dailyClosure),
      ),
      body: BlocBuilder<ClosureBloc, ClosureState>(
        builder: (context, state) {
          if (state is ClosureLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ClosureSuccess) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  DailySummaryCard(closure: state.closure, l10n: l10n),
                  const SizedBox(height: 16),
                  FinancialSummaryCard(closure: state.closure, l10n: l10n),
                ],
              ),
            );
          } else if (state is ClosureError) {
            return Center(
              child: Text(
                state.message,
                style: const TextStyle(color: Colors.red),
              ),
            );
          }
          return Center(
            child: Text(l10n.noData),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<ClosureBloc>().add(GenerateDailyClosureRequested());
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }
} 