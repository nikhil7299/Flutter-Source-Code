import 'package:flutter/material.dart';

class AuthConstants {
  static const String appName = "flutter.fury";
  static const String appSubName = "Some dummy text over here";
  static const Color deepPurple = Colors.deepPurple;
  static const Color lightPurple = Color.fromARGB(255, 180, 151, 230);
}

// VALIDATORS
extension EmailValidator on String {
  bool isValidEmail() {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(this);
  }
}

extension PasswordValidator on String {
  bool isValidPassword() {
    return RegExp(
            r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$')
        .hasMatch(this);
  }
}

// Root - AUTH - VIEW
class AuthView extends StatelessWidget {
  const AuthView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.deepPurple,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                const Text(
                  AuthConstants.appName,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 60,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  AuthConstants.appSubName,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white70, fontSize: 20),
                ),
                const SizedBox(height: 80),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  width: double.infinity,
                  height: 500,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: Colors.white),
                  child: const TabBarView(
                    children: [
                      SignInView(),
                      SignUpView(),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.all(1),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25)),
                  child: TabBar(
                    labelColor: Colors.white,
                    dividerColor: Colors.transparent,
                    indicatorColor: Colors.transparent,
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicator: BoxDecoration(
                      border: Border.all(
                        color: AuthConstants.deepPurple,
                        width: 2,
                      ),
                      color: AuthConstants.lightPurple,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    tabs: const [
                      Tab(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Icon(Icons.person),
                            Text(
                              "Login",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                      Tab(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Icon(Icons.person),
                            Text(
                              "SignUp",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// SIGN - IN VIEW
class SignInView extends StatefulWidget {
  const SignInView({super.key});

  @override
  State<SignInView> createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
  late final TextEditingController emailController;

  late final TextEditingController passwordController;
  late bool isPasswordObscured;
  late bool showSuffix;

  @override
  void initState() {
    emailController = TextEditingController();
    passwordController = TextEditingController();
    emailController.addListener(() {
      setState(() {});
    });
    passwordController.addListener(() {
      setState(() {});
    });
    isPasswordObscured = true;
    showSuffix = false;
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // "SignIn view rendered"

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      children: [
        const SizedBox(height: 25),
        TextFormField(
          enableInteractiveSelection: true,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (input) => input!.isValidEmail() || input.isEmpty
              ? null
              : "Please enter a valid email address",
          style: const TextStyle(color: AuthConstants.deepPurple),
          onChanged: (_) {},
          onTapOutside: (event) =>
              FocusManager.instance.primaryFocus?.unfocus(),
          controller: emailController,
          cursorColor: AuthConstants.deepPurple,
          decoration: InputDecoration(
            suffixIcon: emailController.text.isEmpty
                ? null
                : IconButton(
                    icon: const Icon(Icons.cancel_outlined),
                    onPressed: emailController.clear,
                    color: AuthConstants.lightPurple,
                    iconSize: 20,
                  ),
            labelText: "Email",
            floatingLabelStyle:
                const TextStyle(color: AuthConstants.deepPurple, fontSize: 25),
            labelStyle:
                const TextStyle(fontSize: 20, color: AuthConstants.lightPurple),
            hintText: "Enter Email",
            hintStyle: const TextStyle(color: AuthConstants.lightPurple),
            focusColor: AuthConstants.deepPurple,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: AuthConstants.deepPurple,
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: AuthConstants.deepPurple,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AuthConstants.deepPurple),
            ),
            enabled: true,
          ),
        ),
        const SizedBox(height: 20),
        TextFormField(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          onTapOutside: (event) =>
              FocusManager.instance.primaryFocus?.unfocus(),
          validator: (input) => input!.isValidPassword() || input.isEmpty
              ? null
              : "Password must be of size 8 or more with atleast one uppercase, one lowercase, one digit and one special character.",
          style: const TextStyle(color: Colors.deepPurple),
          onTap: () {},
          controller: passwordController,
          obscureText: isPasswordObscured,
          cursorColor: Colors.deepPurple,
          decoration: InputDecoration(
            errorMaxLines: 3,
            suffixIcon: passwordController.text.isEmpty
                ? null
                : IconButton(
                    iconSize: 20,
                    color: AuthConstants.lightPurple,
                    icon: Icon(isPasswordObscured
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined),
                    onPressed: () {
                      setState(() {
                        isPasswordObscured = !isPasswordObscured;
                      });
                    },
                  ),
            labelText: "Password",
            floatingLabelStyle:
                const TextStyle(color: Colors.deepPurple, fontSize: 25),
            labelStyle: const TextStyle(
                fontSize: 20, color: Color.fromARGB(255, 180, 151, 230)),
            hintText: "Enter Password",
            hintStyle:
                const TextStyle(color: Color.fromARGB(255, 180, 151, 230)),
            focusColor: Colors.deepPurple,
            enabled: true,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: Colors.deepPurple,
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: Colors.deepPurple,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.deepPurple),
            ),
          ),
        ),
        Container(
          alignment: Alignment.bottomRight,
          child: TextButton(
            onPressed: () {},
            child: const Text(
              "Forgot Password?",
              style: TextStyle(color: Colors.grey),
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 15),
          alignment: Alignment.center,
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              fixedSize: const Size(360, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              "Login",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
          ),
        ),
        const SizedBox(height: 25),
        const Text(
          "-------- Sign in with Google or Facebook --------",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 13, color: Colors.grey),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.zero,
                    tapTargetSize: MaterialTapTargetSize.padded,
                    fixedSize: const Size.fromHeight(60),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    )),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(
                      Icons.gpp_good_sharp,
                      size: 25,
                    ),
                    Text(
                      "Google",
                      style: TextStyle(fontSize: 20, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.zero,
                    tapTargetSize: MaterialTapTargetSize.padded,
                    fixedSize: const Size.fromHeight(60),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    )),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(
                      Icons.facebook_outlined,
                      size: 25,
                    ),
                    Text(
                      "Facebook",
                      style: TextStyle(fontSize: 20, color: Colors.grey),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Don't have an account? "),
            Text(
              " > Swipe to SignUp",
              style: TextStyle(color: Colors.deepPurple),
            ),
          ],
        )
      ],
    );
  }
}

// SIGN-UP VIEW

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  late final TextEditingController nameController;

  late final TextEditingController emailController;

  late final TextEditingController passwordController;
  late bool isPassObscured;

  final signUpFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    isPassObscured = true;
    nameController = TextEditingController();
    passwordController = TextEditingController();
    emailController = TextEditingController();
    nameController.addListener(() {
      setState(() {});
    });
    passwordController.addListener(() {
      setState(() {});
    });
    emailController.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      children: [
        const SizedBox(height: 25),
        TextFormField(
          enableInteractiveSelection: true,
          onTapOutside: (event) =>
              FocusManager.instance.primaryFocus?.unfocus(),
          controller: nameController,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (input) => input!.split(" ").length > 1 || input.isEmpty
              ? null
              : "Please enter your full name",
          onChanged: (_) {},
          cursorColor: AuthConstants.deepPurple,
          decoration: InputDecoration(
            suffixIcon: nameController.text.isEmpty
                ? null
                : IconButton(
                    icon: const Icon(Icons.cancel_outlined),
                    onPressed: nameController.clear,
                    color: AuthConstants.lightPurple,
                    iconSize: 20,
                  ),
            labelText: "Name",
            floatingLabelStyle:
                const TextStyle(color: AuthConstants.deepPurple, fontSize: 25),
            labelStyle:
                const TextStyle(fontSize: 20, color: AuthConstants.lightPurple),
            hintText: "Enter your Full Name",
            hintStyle: const TextStyle(color: AuthConstants.lightPurple),
            focusColor: AuthConstants.deepPurple,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: AuthConstants.deepPurple,
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: AuthConstants.deepPurple,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AuthConstants.deepPurple),
            ),
            enabled: true,
          ),
        ),
        const SizedBox(height: 20),
        TextFormField(
          enableInteractiveSelection: true,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (input) => input!.isValidEmail() || input.isEmpty
              ? null
              : "Please enter a valid email address",
          style: const TextStyle(color: AuthConstants.deepPurple),
          onTap: () {
            // print("email field ");
          },
          onChanged: (_) {},
          onTapOutside: (event) =>
              FocusManager.instance.primaryFocus?.unfocus(),
          controller: emailController,
          cursorColor: AuthConstants.deepPurple,
          decoration: InputDecoration(
            suffixIcon: emailController.text.isEmpty
                ? null
                : IconButton(
                    icon: const Icon(Icons.cancel_outlined),
                    onPressed: emailController.clear,
                    color: AuthConstants.lightPurple,
                    iconSize: 20,
                  ),
            labelText: "Email",
            floatingLabelStyle:
                const TextStyle(color: AuthConstants.deepPurple, fontSize: 25),
            labelStyle:
                const TextStyle(fontSize: 20, color: AuthConstants.lightPurple),
            hintText: "Enter Email",
            hintStyle: const TextStyle(color: AuthConstants.lightPurple),
            focusColor: AuthConstants.deepPurple,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: AuthConstants.deepPurple,
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: AuthConstants.deepPurple,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AuthConstants.deepPurple),
            ),
            enabled: true,
          ),
        ),
        const SizedBox(height: 20),
        TextFormField(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          onTapOutside: (event) =>
              FocusManager.instance.primaryFocus?.unfocus(),
          validator: (input) => input!.isValidPassword() || input.isEmpty
              ? null
              : "Password must be of size 8 or more with atleast one uppercase, one lowercase, one digit and one special character.",
          style: const TextStyle(color: Colors.deepPurple),
          onTap: () {},
          controller: passwordController,
          obscureText: isPassObscured,
          cursorColor: Colors.deepPurple,
          decoration: InputDecoration(
            errorMaxLines: 3,
            suffixIcon: passwordController.text.isEmpty
                ? null
                : IconButton(
                    iconSize: 20,
                    color: AuthConstants.lightPurple,
                    icon: Icon(isPassObscured
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined),
                    onPressed: () {
                      setState(() {
                        isPassObscured = !isPassObscured;
                      });
                    },
                  ),
            labelText: "Password",
            floatingLabelStyle:
                const TextStyle(color: Colors.deepPurple, fontSize: 25),
            labelStyle: const TextStyle(
                fontSize: 20, color: Color.fromARGB(255, 180, 151, 230)),
            hintText: "Enter Password",
            hintStyle:
                const TextStyle(color: Color.fromARGB(255, 180, 151, 230)),
            focusColor: Colors.deepPurple,
            enabled: true,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: Colors.deepPurple,
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: Colors.deepPurple,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.deepPurple),
            ),
          ),
        ),
        const SizedBox(height: 50),
        ElevatedButton(
          onPressed: () {
            if (signUpFormKey.currentState!.validate()) {
              // signUpUser();
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurple,
            fixedSize: const Size(360, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: const Text(
            "SignUp",
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ),
        const SizedBox(height: 30),
        const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Already have an account? "),
            Text(
              " Swipe to SignIn <",
              style: TextStyle(color: Colors.deepPurple),
            ),
          ],
        )
      ],
    );
  }
}
