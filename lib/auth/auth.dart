import 'package:bookhive/auth/database_helper.dart';
import 'package:bookhive/auth/validators.dart';
import 'package:bookhive/models/user_model.dart';
import 'package:bookhive/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/theme_manager.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<StatefulWidget> createState() => _LoginState();

}

class _LoginState extends State<Login> {

  bool isLoginTrue = false;
  bool isPasswordVisible = false;
  final formKey = GlobalKey<FormState>();
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final db = DatabaseHelper();

  login()async{
   // Users? usrDetails = await db.getUser(usrName.text);
    var res = await db.authenticate(Users(usrName: userNameController.text, password: passwordController.text));
    if(res == true){
      //If result is correct then go to profile or home
      if(!mounted)return;
      Navigator.push(context, MaterialPageRoute(builder: (context)=> HomePage()));
    }else{
      //Otherwise show the error message
      setState(() {
        isLoginTrue = true;
      });
    }
  }


  @override
  Widget build(BuildContext context) {

    final currentTheme = Theme.of(context);


    return Scaffold(
      appBar: null,
      body: Center(
        child: Padding(padding: EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
            child:SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 100,),
                  Image.asset('assets/images/logo.png',
                  width: 200,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(height: 20,),
                  Text("Welcome Back!",style: currentTheme.textTheme.titleLarge,),
                  const SizedBox(height: 20,),
                  TextFormField(
                    controller: userNameController,
                    validator: Validators.validateUserName,
                    decoration: const InputDecoration(
                        labelText: 'Username',
                        prefixIcon: Icon(Icons.person),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        )
                    ),
                  ),
                  const SizedBox(height: 20,),
                  TextFormField(
                    controller: passwordController,
                    validator: Validators.validatePassword,
                    obscureText: !isPasswordVisible,
                    obscuringCharacter: '*',
                    decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.password,),
                        suffixIcon: IconButton(
                          icon: Icon(isPasswordVisible ? Icons.visibility:Icons.visibility_off,),
                          onPressed: ()
                          {
                            setState((){
                              isPasswordVisible  =  !isPasswordVisible;
                            });
              
                          },),
                        labelText: 'Password',
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        )
                    ),
                  ),
                  const SizedBox(height: 30,),
                  ElevatedButton(
                    onPressed: ()  {
                      if(formKey.currentState!.validate()){
                        login();
                      }
                    },
                    child: Text('Login',
                      style: TextStyle(
                          color: currentTheme.brightness == Brightness.dark ?Colors.white :Colors.white,
                      ),
                    ),
              
                  ),
                  TextButton(
                      onPressed: () async {
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const SignUp()),);
                      },
                      child: Text("Don't have an Account? SignUp",
                        style: currentTheme.textTheme.bodyMedium?.
                        copyWith(
                          color: currentTheme.primaryColor,
                        ),
                      )),
                  TextButton(
                      onPressed: (){
                        Provider.of<ThemeManager>(context, listen: false).toggleTheme();
                      }, child: Text("Toggle Theme",style: currentTheme.textTheme.titleSmall,))
                ],
              ),
            ) ),
        ),
      )
    );
  }
}


class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<StatefulWidget> createState() => _SignUpState();

}

class _SignUpState extends State<SignUp>{
  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;
  final formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();


  final db = DatabaseHelper();
  signUp()async{
    var res = await db.createUser(
        Users(
            fullName: nameController.text,
            email: emailController.text,
            usrName: userNameController.text,
            password: passwordController.text)
    );
    if(res>0){
      if(!mounted)return;
      Navigator.push(context, MaterialPageRoute(builder: (context)=> const Login()));
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentTheme = Theme.of(context);


    return Scaffold(
      appBar: null,
      body: Center(
        child: Padding(padding: EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
            child:SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 50,),
                  Image.asset('assets/images/logo.png',
                  width: 200,
                  height: 200,
                  fit: BoxFit.cover,
                  ),
                  const SizedBox(height: 20,),
                  Text('Register Create your Account',style: currentTheme.textTheme.titleLarge,),
                  const SizedBox(height: 20,),
                  TextFormField(
                    controller: nameController,
                    validator: Validators.validateName,
                    decoration: const InputDecoration(
                        labelText: 'Full Name',
                        prefixIcon: Icon(Icons.person),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        )
                    ),
                  ),
                  const SizedBox(height: 20,),
                  TextFormField(
                    controller: userNameController,
                    validator: Validators.validateName,
                    decoration: const InputDecoration(
                        labelText: 'username',
                        prefixIcon: Icon(Icons.person),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        )
                    ),
                  ),
                  const SizedBox(height: 20,),
                  TextFormField(
                    controller: emailController,
                    validator: Validators.validateEmail,
                    decoration: const InputDecoration(
                        labelText: 'Email',
                        prefixIcon: Icon(Icons.email),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        )
                    ),
                  ),
                  const SizedBox(height: 20,),
                  TextFormField(
                    controller: passwordController,
                    validator: Validators.validatePassword,
                    obscureText: !isPasswordVisible,
                    obscuringCharacter: '*',
                    decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.password,),
                        suffixIcon: IconButton(
                          icon: Icon(isPasswordVisible ? Icons.visibility:Icons.visibility_off),
                          onPressed: ()
                          {
                            setState((){
                              isPasswordVisible  =  !isPasswordVisible;
                            });
              
                          },),
                        labelText: 'Password',
                        //prefixIcon: Icon(Icons.remove_red_eye_sharp),
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        )
                    ),
                  ),
                  const SizedBox(height: 20,),
                  TextFormField(
                    controller: confirmPasswordController,
                    validator: (value) => Validators.validateConfirmPassword(value, passwordController.text),
                    obscureText: !isConfirmPasswordVisible,
                    obscuringCharacter: '*',
                    decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.password,),
                        suffixIcon: IconButton(
                          icon: Icon(isConfirmPasswordVisible ? Icons.visibility:Icons.visibility_off),
                          onPressed: ()
                          {
                            setState((){
                              isConfirmPasswordVisible  =  !isConfirmPasswordVisible;
                            });
              
                          },),
                        labelText: 'Confirm Password',
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        )
                    ),
                  ),
                  const SizedBox(height: 30,),
                  ElevatedButton(
                    onPressed: ()  {
                      if(formKey.currentState!.validate()){
                        signUp();
                      }

                      //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> const Login()));
                    },
                    child: Text('Sign Up',
                      style: TextStyle(
                          color: currentTheme.brightness == Brightness.dark ?Colors.white :Colors.white,
              
                      ),
                    ),
              
                  ),
                  TextButton(
                      onPressed: () async {
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Login()),);
                      },
                      child: Text("Already have an Account? Login",
                        style: currentTheme.textTheme.bodyMedium?.
                        copyWith(
                          color: currentTheme.primaryColor,
                        ),
                      ))
                ],
              ),
            ) ),
        ),
      ),
    );
  }
}