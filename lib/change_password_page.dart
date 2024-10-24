import 'package:flutter/material.dart';
import 'package:molibi_app/widget/molibi_label.dart';
import 'package:molibi_app/widget/molibi_primary_button.dart';
import 'package:molibi_app/widget/molibi_text_field.dart';

class ChangePasswordPage extends StatelessWidget {
  const ChangePasswordPage({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Change Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      flex: 4,
                      child: MolibiLabel(label: "Old Password"),
                    ),
                    Expanded(
                      flex: 6,
                      child: MolibiTextField(obscureText:true),
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      flex: 4,
                      child: MolibiLabel(label: "New Password"),
                    ),
                    Expanded(
                      flex: 6,
                      child: MolibiTextField(obscureText:true),
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      flex: 4,
                      child: MolibiLabel(label: "Confirm New Password"),
                    ),
                    Expanded(
                      flex: 6,
                      child: MolibiTextField(obscureText:true),
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: MolibiPrimaryButton(
                    onPressed: () {
                    },
                    label:('Change Password'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
