// ignore_for_file: use_key_in_widget_constructors, constant_identifier_names, file_names

import 'package:provider/provider.dart';
import 'package:we_detect/FitbitAPI/fitbitter.dart';
import 'package:we_detect/constants.dart';
import 'package:we_detect/provider/provider.dart';
import 'package:we_detect/route_name.dart';
import 'package:we_detect/services/authentication.dart';
import '/Models/user_information.dart';
import '/Widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:country_list_pick/country_list_pick.dart';
import 'components/buildEmail.dart';
import 'components/buildName.dart';

enum Gender {
  Male,
  Female,
}

class RegestrationPage extends StatefulWidget {
  @override
  _RegestrationPageState createState() => _RegestrationPageState();
}

class _RegestrationPageState extends State<RegestrationPage> {
  final _formKey = GlobalKey<FormState>();
  Gender _gender = Gender.Male;
  final _user = UserInformation(nationality: 'United Arab Emirates');
  final _firstNameController = TextEditingController();
  final _lastnameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _lastNameFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final _passwordConfirmFocusNode = FocusNode();
  final _auth = AuthService();
  var _isLoading = false;

  Future<bool> _sync() async {
    bool userExist;

    final currentUser =
        await _auth.signUp(_user.email, _user.password, context);
    //  final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      _user.uid = currentUser.uid;
      userExist = true;
      debugPrint(currentUser.uid);

      final fitbitUserId = await FitbitConnector.authorize(
        user: _user,
        context: context,
        clientID: Strings.fitbitClientID,
        clientSecret: Strings.fitbitClientSecret,
        redirectUri: Strings.fitbitRedirectUri,
        callbackUrlScheme: Strings.fitbitCallbackScheme,
      );
      debugPrint('*******************fitbitUserId*************************');
      debugPrint(fitbitUserId);
      debugPrint('*******************fitbitUserId*************************');

      // await FireStoreApi.createUser(widget._user);

      // Navigator.of(context).popUntil((route) => route.isFirst);
    } else {
      userExist = false;
    }

    return userExist;
  }

  void _saveForm() async {
    final isValid = _formKey.currentState!.validate();
    var provider = Provider.of<DataProvider>(context, listen: false);
    if (isValid) {
      setState(() {
        _isLoading = true;
      });
      _formKey.currentState!.save();
      _user.firstName = _firstNameController.text;
      _user.lastName = _lastnameController.text;
      if (_gender == Gender.Male) {
        _user.gender = 'Male';
        provider.gender = 'Male';
      } else {
        _user.gender = 'Female';
        provider.gender = 'Female';
      }

      FocusScope.of(context).unfocus();
      var userExist = await _sync();
      if (userExist) {
        Navigator.of(context)
            .pushNamedAndRemoveUntil(RouteName.Studies, (route) => false);
      }
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget _buildPassword() => TextFormField(
        decoration: const InputDecoration(
          labelText: 'Password',
          border: OutlineInputBorder(),
        ),
        controller: _passwordController,
        validator: (value) {
          if (value?.length as num < 7) {
            return 'Password must be at least 7 characters long';
          } else {
            return null;
          }
        },
        onSaved: (value) => setState(() => _user.password = value as String),
        textInputAction: TextInputAction.next,
        focusNode: _passwordFocusNode,
        onFieldSubmitted: (_) =>
            FocusScope.of(context).requestFocus(_passwordConfirmFocusNode),
        keyboardType: TextInputType.visiblePassword,
        obscureText: true,
      );
  Widget _buildPasswordConfirnation() => TextFormField(
        decoration: const InputDecoration(
          labelText: 'Confirm Password',
          border: OutlineInputBorder(),
        ),
        validator: (value) {
          if (value!.isEmpty) {
            return 'Must Confirm the password';
          } else if (value != _passwordController.text) {
            return 'Passwords do not match!';
          } else {
            return null;
          }
        },
        textInputAction: TextInputAction.done,
        focusNode: _passwordConfirmFocusNode,
        onFieldSubmitted: (_) => _saveForm(),
        keyboardType: TextInputType.visiblePassword,
        obscureText: true,
      );
  Widget _buildAge() => TextFormField(
        decoration: const InputDecoration(
          labelText: 'Age',
          border: OutlineInputBorder(),
        ),
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        textInputAction: TextInputAction.next,
        onFieldSubmitted: (_) =>
            FocusScope.of(context).requestFocus(_emailFocusNode),
        validator: (val) {
          if (val!.isEmpty) {
            return 'Enter your age';
          } else if (val.length > 2) {
            return 'Age can not be more then two digit';
          } else {
            return null;
          }
        },
        onChanged: (value) => setState(() => _user.age = value),
      );

  Widget buildNext() => Builder(
        builder: (context) => _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Button(
                text: 'Sign Up & Sync',
                onClicked: _saveForm,
              ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Signing Up ',
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: <Widget>[
            buildName(_firstNameController, 'First Name', context,
                _lastNameFocusNode),
            const SizedBox(height: 16),
            buildName(
                _lastnameController, 'Last Name', context, _lastNameFocusNode),
            const SizedBox(height: 16),
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Nationality',
                  ),
                ),
                CountryListPick(
                  appBar: AppBar(
                    title: const Text('Pick your country'),
                  ),
                  theme: CountryTheme(
                    isShowFlag: true,
                    isShowCode: false,
                    isDownIcon: true,
                    showEnglishName: true,
                  ),
                  onChanged: (value) => setState(() {
                    _user.nationality = value?.name! ?? 'United Arab Emirates';
                  }),
                  initialSelection: '+971',
                ),
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            Row(
              children: <Widget>[
                const Text('Gender'),
                Expanded(
                  child: ListTile(
                    title: const Text('Male'),
                    leading: Radio<Gender>(
                      activeColor: Colors.green,
                      value: Gender.Male,
                      groupValue: _gender,
                      onChanged: (value) {
                        setState(() {
                          _gender = value!;
                        });
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: ListTile(
                    title: const Text('Female'),
                    leading: Radio<Gender>(
                      activeColor: Colors.green,
                      value: Gender.Female,
                      groupValue: _gender,
                      onChanged: (value) {
                        setState(() {
                          _gender = value!;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildAge(),
            const SizedBox(height: 16),
            const SizedBox(height: 16),
            EmailInput(
              emailFocusNode: _emailFocusNode,
              passwordFocusNode: _passwordFocusNode,
              user: _user,
            ),
            // buildEmail(),
            const SizedBox(height: 16),
            _buildPassword(),
            const SizedBox(
              height: 16,
            ),
            _buildPasswordConfirnation(),
            const SizedBox(
              height: 16,
            ),
            buildNext(),
          ],
        ),
      ),
    );
  }
}
