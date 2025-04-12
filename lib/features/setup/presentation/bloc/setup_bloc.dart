import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/datasources/setup_local_datasource.dart';
import '../../data/models/business_setup_model.dart';
import 'setup_event.dart';

// States
abstract class SetupState extends Equatable {
  const SetupState();

  @override
  List<Object> get props => [];
}

class SetupInitial extends SetupState {}

class SetupLoading extends SetupState {}

class SetupSuccess extends SetupState {
  final BusinessSetupModel? setup;
  
  const SetupSuccess([this.setup]);

  @override
  List<Object> get props => [if (setup != null) setup!];
}

class SetupError extends SetupState {
  final String message;

  const SetupError(this.message);

  @override
  List<Object> get props => [message];
}

// Bloc
class SetupBloc extends Bloc<SetupEvent, SetupState> {
  final SetupLocalDatasource localDatasource;
  String _businessName = '';
  String _businessBrand = '';
  double _carHourCost = 0.0;
  double _motorcycleHourCost = 0.0;
  double _carMonthlyCost = 0.0;
  double _motorcycleMonthlyCost = 0.0;

  SetupBloc({required this.localDatasource}) : super(SetupInitial()) {
    // Load initial data
    on<SetupStarted>((event, emit) async {
      emit(SetupLoading());
      try {
        final setup = await localDatasource.getSetup();
        if (setup != null) {
          _businessName = setup.businessName;
          _businessBrand = setup.businessBrand;
          _carHourCost = setup.carHourCost;
          _motorcycleHourCost = setup.motorcycleHourCost;
          _carMonthlyCost = setup.carMonthlyCost;
          _motorcycleMonthlyCost = setup.motorcycleMonthlyCost;
          emit(SetupSuccess(setup));
        } else {
          emit(SetupSuccess());
        }
      } catch (e) {
        emit(SetupError(e.toString()));
      }
    });

    on<BusinessNameChanged>((event, emit) {
      _businessName = event.name;
    });

    on<BusinessBrandChanged>((event, emit) {
      _businessBrand = event.brand;
    });

    on<CarHourCostChanged>((event, emit) {
      _carHourCost = double.tryParse(event.cost) ?? 0.0;
    });

    on<MotorcycleHourCostChanged>((event, emit) {
      _motorcycleHourCost = double.tryParse(event.cost) ?? 0.0;
    });

    on<CarMonthlyCostChanged>((event, emit) {
      _carMonthlyCost = double.tryParse(event.cost) ?? 0.0;
    });

    on<MotorcycleMonthlyCostChanged>((event, emit) {
      _motorcycleMonthlyCost = double.tryParse(event.cost) ?? 0.0;
    });

    on<SetupSubmitted>((event, emit) async {
      emit(SetupLoading());
      try {
        final setup = BusinessSetupModel(
          businessName: _businessName,
          businessBrand: _businessBrand,
          carHourCost: _carHourCost,
          motorcycleHourCost: _motorcycleHourCost,
          carMonthlyCost: _carMonthlyCost,
          motorcycleMonthlyCost: _motorcycleMonthlyCost
        );
        await localDatasource.saveSetup(setup);
        emit(SetupSuccess(setup));
      } catch (e) {
        emit(SetupError(e.toString()));
      }
    });
  }
} 