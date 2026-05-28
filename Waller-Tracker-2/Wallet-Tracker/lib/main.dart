import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'features/dashboard/dashboard.dart';
import 'features/expenses/data/datasources/expense_remote_datasource.dart';
import 'features/expenses/data/repositories/expense_repository_impl.dart';
import 'features/expenses/domain/repositories/expense_repository.dart';
import 'features/expenses/presentation/bloc/expense_bloc.dart';
import 'features/expenses/presentation/bloc/expense_event.dart';
import 'features/transaction/data/datasources/transaction_local_datasource.dart';
import 'features/transaction/data/repositories/transaction_repository_impl.dart';
import 'features/transaction/domain/repositories/transaction_repository.dart';
import 'features/transaction/presentation/bloc/transaction_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  final ExpenseRepository? expenseRepository;
  final TransactionRepository? transactionRepository;

  const MyApp({super.key, this.expenseRepository, this.transactionRepository});

  @override
  Widget build(BuildContext context) {
    final expenses =
        expenseRepository ??
        ExpenseRepositoryImpl(remoteDataSource: ExpenseRemoteDataSourceImpl());
    final transactions =
        transactionRepository ??
        TransactionRepositoryImpl(
          localDataSource: TransactionLocalDataSourceImpl(),
        );

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) =>
              ExpenseBloc(repository: expenses)..add(LoadExpensesEvent()),
        ),
        BlocProvider(create: (_) => TransactionBloc(repository: transactions)),
      ],
      child: MaterialApp(
        title: 'Wallet Tracker',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF9333EA),
            brightness: Brightness.light,
          ),
          useMaterial3: true,
        ),
        home: const DashboardPage(),
      ),
    );
  }
}
