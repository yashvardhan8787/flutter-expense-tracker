import 'dart:math';
import 'package:expense_repository/expense_repository.dart';
import 'package:expense_tracker/screens/add_expense/blocs/create_categorybloc/create_category_bloc.dart';
import 'package:expense_tracker/screens/add_expense/blocs/get_categories_bloc/get_categories_bloc.dart';
import 'package:expense_tracker/screens/add_expense/views/add_expense.dart';
import 'package:expense_tracker/screens/home/blocs/get_expenses_bloc/get_expenses_bloc.dart';
import 'package:expense_tracker/screens/home/views/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../add_expense/blocs/create_expensebloc/create_expense_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Color selectedItem = Colors.blue;
  Color unselectedItem = Colors.grey;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetExpensesBloc, GetExpensesState>(
        builder: (context, state) {
          if(state is GetExpensesSuccess) {
            return Scaffold(
               floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
                floatingActionButton: FloatingActionButton(
                  onPressed: () async {
                    Expense? newExpense = await Navigator.push(
                      context,
                      MaterialPageRoute<Expense>(
                        builder: (BuildContext context) => MultiBlocProvider(
                          providers: [
                            BlocProvider(
                              create: (context) => CreateCategoryBloc(FirebaseExpenseRepo()),
                            ),
                            BlocProvider(
                              create: (context) => GetCategoriesBloc(FirebaseExpenseRepo())..add(GetCategories()),
                            ),
                            BlocProvider(
                              create: (context) => CreateExpenseBloc(FirebaseExpenseRepo()),
                            ),
                          ],
                          child: const AddExpense(),
                        ),
                      ),
                    );

                    if(newExpense != null) {
                      setState(() {
                        state.expenses.insert(0, newExpense);
                      });
                    }
                  },
                  shape: const CircleBorder(),
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            Theme.of(context).colorScheme.tertiary,
                            Theme.of(context).colorScheme.secondary,
                            Theme.of(context).colorScheme.primary,
                          ],
                          transform: const GradientRotation(pi / 4),
                        )),
                    child: const Icon(Icons.add),
                  ),
                ),
                body:MainScreen(state.expenses)
                    );
          } else {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        }
    );
  }
}