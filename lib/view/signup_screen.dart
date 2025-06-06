import 'package:flutter/material.dart';
import '../res/widgets/signup_form.dart';
import 'package:lecsens/res/widgets/copyright_footer.dart';
import 'package:lecsens/viewModel/auth_view_model.dart';
import 'package:provider/provider.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignupScreen> {
  @override
  Widget build(BuildContext context) {
    final authviewmodel = Provider.of<AuthViewModel>(context);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Signup', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Image.asset('lib/res/images/lecsens_logo.png'),
            const SizedBox(height: 20),
            SignupForm(authviewmodel: authviewmodel),
          ],
        ),
      ),
      bottomNavigationBar: const CopyrightFooter(),
    );
  }
}
