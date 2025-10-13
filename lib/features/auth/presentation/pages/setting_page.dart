import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routes/router.dart';
import '../../../../core/themes/colors.dart';
import '../../../../core/utils/top_snackbar.dart';
import '../../../../core/widgets/base_card.dart';
import '../../../../core/widgets/buttons/danger_button.dart';
import '../../../../core/widgets/profile_row.dart';
import '../cubit/auth_cubit.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  late final AuthCubit _authCubit;
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  var _isEdit = false;
  var _isObscure = true;

  @override
  void initState() {
    super.initState();
    _authCubit = context.read<AuthCubit>()..fetchCurrentUser();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      buildWhen: (previous, current) => current is FetchCurrentUser,
      builder: (context, state) {
        if (state is FetchCurrentUserError) {
          return Center(
            child: Text(state.message),
          );
        }

        if (state is FetchCurrentUserLoading) {
          return const Center(
            child: CircularProgressIndicator.adaptive(),
          );
        }

        if (state is FetchCurrentUserLoaded) {
          return Scaffold(
            appBar: AppBar(
              title: ProfileRow(user: state.user),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    if (_isEdit) {
                      _authCubit.updateUser(
                        name: _nameController.text,
                        email: _emailController.text,
                        password: _passwordController.text,
                      );
                    }

                    setState(() => _isEdit = !_isEdit);
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: _isEdit ? success : warning,
                  ),
                  child: Text(_isEdit ? 'Simpan' : 'Edit'),
                ),
                const SizedBox(width: 16),
              ],
            ),
            body: RefreshIndicator(
              onRefresh: _authCubit.fetchCurrentUser,
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: <Widget>[
                  const SizedBox(height: 24),
                  const Text(
                    'Pengaturan Profil',
                    style: const TextStyle(
                      color: black,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  BaseCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const Text(
                          'Informasi Pengguna',
                          style: const TextStyle(
                            color: black,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _nameController..text = state.user.name,
                          decoration: InputDecoration(
                            filled: !_isEdit,
                            fillColor: whiteQuaternary,
                            hintText: 'Masukkan nama pengguna baru',
                            labelText: 'Nama Pengguna',
                          ),
                          readOnly: !_isEdit,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _emailController..text = state.user.email,
                          decoration: InputDecoration(
                            filled: !_isEdit,
                            fillColor: whiteQuaternary,
                            hintText: 'Masukkan email baru',
                            labelText: 'Email',
                          ),
                          readOnly: !_isEdit,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _passwordController,
                          decoration: InputDecoration(
                            filled: !_isEdit,
                            fillColor: whiteQuaternary,
                            hintText: 'Masukkan kata sandi baru',
                            labelText: 'Kata Sandi',
                            suffixIcon: IconButton(
                              onPressed: () =>
                                  setState(() => _isObscure = !_isObscure),
                              icon: Icon(_isObscure
                                  ? Icons.visibility
                                  : Icons.visibility_off),
                            ),
                          ),
                          obscureText: _isObscure,
                          readOnly: !_isEdit,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Pengaturan',
                    style: const TextStyle(
                      color: black,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  BaseCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const Text(
                          'Konfigurasi Inventory',
                          style: const TextStyle(
                            color: black,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Mode Inventory',
                          style: const TextStyle(
                            color: black,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<String>(
                          onChanged: (value) {},
                          decoration: const InputDecoration(
                            hintText: 'Pilih mode inventory',
                          ),
                          items: const <DropdownMenuItem<String>>[
                            DropdownMenuItem<String>(
                              value: 'mode1',
                              child: Text('Mode 1'),
                            ),
                            DropdownMenuItem<String>(
                              value: 'mode2',
                              child: Text('Mode 2'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Mode RF',
                          style: const TextStyle(
                            color: black,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<String>(
                          onChanged: (value) {},
                          decoration: const InputDecoration(
                            hintText: 'Pilih mode RF',
                          ),
                          items: const <DropdownMenuItem<String>>[
                            DropdownMenuItem<String>(
                              value: 'mode1',
                              child: Text('Mode 1'),
                            ),
                            DropdownMenuItem<String>(
                              value: 'mode2',
                              child: Text('Mode 2'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        CheckboxListTile.adaptive(
                          onChanged: (value) {},
                          controlAffinity: ListTileControlAffinity.leading,
                          contentPadding: EdgeInsets.zero,
                          title: const Text(
                            'Read TID (hanya muncul saat mode = Normal Inventory)',
                            style: const TextStyle(
                              color: black,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          value: false,
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Item untuk Fast Model',
                          style: const TextStyle(
                            color: black,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        CheckboxListTile.adaptive(
                          onChanged: (value) {},
                          contentPadding: EdgeInsets.zero,
                          controlAffinity: ListTileControlAffinity.leading,
                          title: const Text(
                            'RSSI',
                            style: const TextStyle(
                              color: black,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          value: false,
                        ),
                        CheckboxListTile.adaptive(
                          onChanged: (value) {},
                          contentPadding: EdgeInsets.zero,
                          controlAffinity: ListTileControlAffinity.leading,
                          title: const Text(
                            'Frequency',
                            style: const TextStyle(
                              color: black,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          value: false,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  BaseCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const Text(
                          'Session & Target Behavior',
                          style: const TextStyle(
                            color: black,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Session',
                          style: const TextStyle(
                            color: black,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<String>(
                          onChanged: (value) {},
                          decoration: const InputDecoration(
                            hintText: 'Pilih session',
                          ),
                          items: const <DropdownMenuItem<String>>[
                            DropdownMenuItem<String>(
                              value: 'session1',
                              child: Text('Session 1'),
                            ),
                            DropdownMenuItem<String>(
                              value: 'session2',
                              child: Text('Session 2'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Target',
                          style: const TextStyle(
                            color: black,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<String>(
                          onChanged: (value) {},
                          decoration: const InputDecoration(
                            hintText: 'Pilih target',
                          ),
                          items: const <DropdownMenuItem<String>>[
                            DropdownMenuItem<String>(
                              value: 'target1',
                              child: Text('Target 1'),
                            ),
                            DropdownMenuItem<String>(
                              value: 'target2',
                              child: Text('Target 2'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  BlocConsumer<AuthCubit, AuthState>(
                    buildWhen: (previous, current) => current is Logout,
                    listenWhen: (previous, current) => current is Logout,
                    listener: (context, state) {
                      if (state is LogoutLoaded) {
                        TopSnackbar.successSnackbar(message: state.message);
                        context.goNamed(loginRoute);
                      }
                      if (state is LogoutError) {
                        TopSnackbar.dangerSnackbar(message: state.message);
                      }
                    },
                    builder: (context, state) {
                      if (state is LogoutLoading) {
                        return const DangerButton(
                          child: Text('Logout'),
                        );
                      }

                      return DangerButton(
                        onPressed: _authCubit.logout,
                        child: const Text('Logout'),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          );
        }

        return const SizedBox();
      },
    );
  }
}
