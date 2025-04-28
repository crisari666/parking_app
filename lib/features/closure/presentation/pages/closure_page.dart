import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quantum_parking_flutter/features/closure/presentation/bloc/closure_bloc.dart';
import 'package:intl/intl.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:quantum_parking_flutter/features/closure/presentation/bloc/closure_event.dart';
import 'package:quantum_parking_flutter/features/closure/presentation/bloc/closure_state.dart';

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
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            l10n.dailySummary,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            '${l10n.date}: ${DateFormat('MMM dd, yyyy').format(state.closure.date)}',
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${l10n.totalVehicles}: ${state.closure.totalVehicles}',
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${l10n.totalCars}: ${state.closure.vehiclesByType['car'] ?? 0}',
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${l10n.totalMotorcycles}: ${state.closure.vehiclesByType['motorcycle'] ?? 0}',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            l10n.financialSummary,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            '${l10n.totalSales}: \$${state.closure.totalIncome.toStringAsFixed(2)}',
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${l10n.totalDiscounts}: \$0.00',
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${l10n.netSales}: \$${state.closure.totalIncome.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
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