import 'package:budget_app/view_model.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

bool isLoading = true;

class ExpenseViewMobile extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModelProvider = ref.watch(viewModel);
    final deviceWidth = MediaQuery.of(context).size.width;
    int totalExpense = 0;
    int totalIncome = 0;
    void calculate() {
      for (int i = 0; i < viewModelProvider.expenseAmount.length; i++) {
        totalExpense =
            totalExpense + int.parse(viewModelProvider.expenseAmount[i]);
      }
      for (int i = 0; i < viewModelProvider.incomeAmount.length; i++) {
        totalIncome =
            totalIncome + int.parse(viewModelProvider.incomeAmount[i]);
      }
    }

    calculate();

    int budgetLef = totalIncome - totalExpense;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white, size: 30),
          backgroundColor: Colors.black,
        ),
        drawer: Drawer(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DrawerHeader(
                  padding: EdgeInsets.only(bottom: 20),
                  child: Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(width: 1, color: Colors.black)),
                    child: CircleAvatar(
                      radius: 180,
                      backgroundColor: Colors.white,
                      child: Image(
                        height: 100,
                        image: AssetImage(
                          'assets/logo.png',
                        ),
                        filterQuality: FilterQuality.high,
                      ),
                    ),
                  )),
              SizedBox(
                height: 10,
              ),
              MaterialButton(
                onPressed: () async {
                  await viewModelProvider.logOut();
                },
                child: Text(
                  'Logout',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
                color: Colors.black,
                height: 50,
                minWidth: 200,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                elevation: 20,
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                      onPressed: () async => await launchUrl(Uri.parse('')),
                      icon: SvgPicture.asset(
                        'assets/instagram.svg',
                        color: Colors.black,
                        width: 35,
                      )),
                  IconButton(
                      onPressed: () async => await launchUrl(Uri.parse('')),
                      icon: SvgPicture.asset(
                        'assets/twitter.svg',
                        color: Colors.black,
                        width: 35,
                      ))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
