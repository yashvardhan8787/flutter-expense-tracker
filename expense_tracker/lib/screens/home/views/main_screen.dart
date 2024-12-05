import 'dart:math';
import 'package:expense_repository/expense_repository.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:expense_tracker/blocs/sign_in_bloc/sign_in_bloc.dart';
import 'package:expense_tracker/blocs/authentication_bloc/authentication_bloc.dart';

class MainScreen extends StatelessWidget {
  final List<Expense> expenses;

  const MainScreen(this.expenses, {super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (context, authState) {
        if (authState.status == AuthenticationStatus.authenticated) {
          final userId = authState.user?.uid;

          // Filter expenses based on authenticated user's userId
          final userExpenses = expenses.where((expense) =>
          expense.userId == userId).toList();

          // Calculate total expense
          final totalExpense = userExpenses.fold<double>(
            0,
                (sum, expense) => sum + expense.amount,
          );

          // Calculate today's expense
          final today = DateTime.now();
          final todayExpense = userExpenses.where((expense) {
            final expenseDate = expense.date;
            return expenseDate.year == today.year &&
                expenseDate.month == today.month &&
                expenseDate.day == today.day;
          }).fold<double>(
            0,
                (sum, expense) => sum + expense.amount,
          );

          // Calculate this month's expense
          final thisMonthExpense = userExpenses.where((expense) {
            final expenseDate = expense.date;
            return expenseDate.year == today.year &&
                expenseDate.month == today.month;
          }).fold<double>(
            0,
                (sum, expense) => sum + expense.amount,
          );

          // Main screen layout
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 25.0, vertical: 10),
              child: Column(
                children: [
                  // Welcome row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.yellow[700],
                                ),
                              ),
                              Icon(
                                Icons.person,
                                color: Colors.yellow[800],
                              ),
                            ],
                          ),
                          const SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Welcome!",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Theme
                                      .of(context)
                                      .colorScheme
                                      .outline,
                                ),
                              ),
                              Text(
                                authState.user?.email?.split('@')[0] ?? "User",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Theme
                                      .of(context)
                                      .colorScheme
                                      .onSurface,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      IconButton(
                        onPressed: () {
                          context.read<SignInBloc>().add(
                              const SignOutRequired());
                        },
                        icon: const Icon(Icons.logout),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Expense summary card
                  Container(
                    width: MediaQuery
                        .of(context)
                        .size
                        .width,
                    height: MediaQuery
                        .of(context)
                        .size
                        .width / 2,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Theme
                              .of(context)
                              .colorScheme
                              .primary,
                          Theme
                              .of(context)
                              .colorScheme
                              .secondary,
                          Theme
                              .of(context)
                              .colorScheme
                              .tertiary,
                        ],
                        transform: const GradientRotation(pi / 4),
                      ),
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 4,
                          color: Colors.grey.shade300,
                          offset: const Offset(5, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Total Expense',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.currency_rupee, size: 40,
                                color: Colors.white),
                            Text(
                              totalExpense.toStringAsFixed(2),
                              style: const TextStyle(
                                fontSize: 40,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        // Additional information (today's and month's expenses)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12,
                              horizontal: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildExpenseInfo('Expense Today', todayExpense),
                              _buildExpenseInfo(
                                  'Expense This Month', thisMonthExpense),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  // Transactions list header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Transactions',
                        style: TextStyle(
                          fontSize: 16,
                          color: Theme
                              .of(context)
                              .colorScheme
                              .onSurface,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: Text(
                          'View All',
                          style: TextStyle(
                            fontSize: 14,
                            color: Theme
                                .of(context)
                                .colorScheme
                                .outline,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Transactions list
                  Expanded(
                    child: ListView.builder(
                      itemCount: userExpenses.length,
                      itemBuilder: (context, int i) {
                        return _buildTransactionCard(userExpenses[i], context);
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          return Center(child: Text("Please log in to view expenses."));
        }
      },
    );
  }

// Helper methods for building UI components
  Widget _buildExpenseInfo(String title, double amount) {
    return Row(
      children: [
        Container(
          width: 25,
          height: 25,
          decoration: const BoxDecoration(
            color: Colors.white30,
            shape: BoxShape.circle,
          ),
          child: const Center(
            child: Icon(Icons.today, size: 12, color: Colors.greenAccent),
          ),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.w400,
              ),
            ),
            Row(
              children: [
                const Icon(Icons.currency_rupee, size: 14, color: Colors.white),
                Text(
                  ' ${amount.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTransactionCard(Expense expense, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Color(expense.category.color),
                          shape: BoxShape.circle,
                        ),
                      ),
                      Image.asset(
                        'assets/${expense.category.icon}.png',
                        scale: 2,
                        color: Colors.white,
                      ),
                    ],
                  ),
                  const SizedBox(width: 12),
                  Text(
                    expense.category.name,
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme
                          .of(context)
                          .colorScheme
                          .onSurface,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.currency_rupee, size: 14),
                      Text(
                        "${expense.amount}.00",
                        style: TextStyle(
                          fontSize: 14,
                          color: Theme
                              .of(context)
                              .colorScheme
                              .onSurface,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    DateFormat('dd/MM/yyyy').format(expense.date),
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme
                          .of(context)
                          .colorScheme
                          .outline,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
