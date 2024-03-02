import 'package:mudarribe_trainee/services/payment_service.dart';
import 'package:mudarribe_trainee/views/authentication/forgot_password/forgot_password_controller.dart';
import 'package:mudarribe_trainee/views/authentication/signin/signin_controller.dart';
import 'package:mudarribe_trainee/views/authentication/signup/signup_controller.dart';
import 'package:mudarribe_trainee/views/splash/splash_controller.dart';
import 'package:mudarribe_trainee/views/trainee_profile/saved/saved_controller.dart';
import 'package:mudarribe_trainee/views/trainer/event_checkout/event_checkout_controller.dart';
import 'package:mudarribe_trainee/views/trainee_profile/profile/profile_controller.dart';
import 'package:mudarribe_trainee/views/trainer/packages_checkout/package_checkout_controller.dart';

SplashController splashController = SplashController.instance;
SignUpController signUpController = SignUpController.instance;
SignInController signInController = SignInController.instance;
SavedController savedController = SavedController.instance;
// HomeController homeController = HomeController.instance;
ForgotPasswordContoller forgotPasswordContoller =
    ForgotPasswordContoller.instance;
EventcheckoutController eventcheckoutController =
    EventcheckoutController.instance;
ProfileController profileController = ProfileController.instance;
Packagecheckoutcontroller packagecheckoutController =
    Packagecheckoutcontroller.instance;
PaymentService paymentService = PaymentService.instance;
