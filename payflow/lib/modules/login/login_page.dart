import 'package:flutter/material.dart';

import '../../shared/themes/app_colors.dart';
import '../../shared/themes/app_images.dart';
import '../../shared/themes/app_text_styles.dart';
import '../../shared/widgets/social_login/social_login_button.dart';
import 'login_controller.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final controller = LoginController();
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SizedBox(
        height: size.height,
        width: size.width,
        child: Stack(
          children: [
            Container(
              width: size.width,
              height: size.height * 0.36,
              color: AppColors.primary,
            ),
            Positioned(
              top: 40,
              left: 0,
              right: 0,
              child: Image.asset(
                AppImages.person,
                width: 208,
                height: 373,
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: size.height * 0.10,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(AppImages.logomini),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 70, right: 70, top: 30),
                    child: Text(
                      'Organize seus boletos em um só lugar',
                      textAlign: TextAlign.center,
                      style: TextStyles.titleHome,
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 40, right: 40, top: 40),
                    child: SocialLoginButton(
                      onTap: controller.googleSignIn,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
