import 'package:flutter_test/flutter_test.dart';
import 'package:wallet_tracker/features/expenses/domain/entities/expense.dart';
import 'package:wallet_tracker/features/expenses/domain/repositories/expense_repository.dart';
import 'package:wallet_tracker/features/transaction/domain/entities/transaction.dart';
import 'package:wallet_tracker/features/transaction/domain/repositories/transaction_repository.dart';
import 'package:wallet_tracker/main.dart';

void main() {
  testWidgets('Wallet dashboard smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      MyApp(
        expenseRepository: _FakeExpenseRepository(),
        transactionRepository: _FakeTransactionRepository(),
      ),
    );
    await tester.pump();

    expect(find.text('Walet Tracker'), findsOneWidget);
    expect(find.text('Dashboard zoom'), findsOneWidget);
    expect(find.text('Quick Actions'), findsOneWidget);
  });
}

class _FakeExpenseRepository implements ExpenseRepository {
  @override
  Future<List<Expense>> getExpenses() async => const [];

  @override
  Future<Expense> addExpense(Expense expense) async => expense;

  @override
  Future<Expense> updateExpense(Expense expense) async => expense;

  @override
  Future<void> deleteExpense(String id) async {}
}

class _FakeTransactionRepository implements TransactionRepository {
  @override
  Future<List<TransactionEntity>> getTransactions() async => const [];

  @override
  Future<void> addTransaction(TransactionEntity transaction) async {}

  @override
  Future<void> deleteTransaction(String id) async {}

  @override
  Future<void> editTransaction(TransactionEntity transaction) async {}

  @override
  Future<void> togglePaymentStatus(String id) async {}
}
