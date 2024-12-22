
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

final _firebase = FirebaseAuth.instance;

class AuthScreen extends StatefulWidget{
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() {
    // TODO: implement createState
   
   return _AuthScreenState();

  }

}

class _AuthScreenState extends State<AuthScreen>{
  final _form = GlobalKey<FormState>();
  var _isLogin = true;
  var _enteredemail = '';
  var _enteredpassword = '';

  void _submit() async {
 final isValid = _form.currentState!.validate();

 if(!isValid){
  return;
 }


    _form.currentState!.save();
   try{
    if(_isLogin) {
     final UserCredentials =  _firebase.signInWithEmailAndPassword(
      email: _enteredemail,
     password: _enteredpassword
     );
     print(UserCredentials);

    }
    else{
    
          final UserCredential = await _firebase.createUserWithEmailAndPassword(
      email: _enteredemail,
       password: _enteredpassword
       );
       print(UserCredential);
      }
  }
      on FirebaseAuthException catch(error){
   if(error.code == 'email-already-in-use'){
    
     
   }
   ScaffoldMessenger.of(context).clearSnackBars();
   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(
      error.message ?? 'authentication failed'
      ),
      ),
      );
      }
   
    }
   
   

   @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(
                  top:30,
                  bottom: 20,
                  left:20,
                  right:20,
                ),
                width: 200,
                child: Image.asset('assets/images/chat.png'),
                  
              ),
              Card(
                margin: EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Form(
                      key: _form,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Email Address',

                            ),
                            keyboardType: TextInputType.emailAddress,
                            autocorrect: false,
                            textCapitalization: TextCapitalization.none,
                            validator: (value) {
                              if(value == null ||
                               value.trim().isEmpty ||
                                !value.contains('@')){
                               return 'Please enter a valid email address';
                              }

                              return null;
                            },
                            onSaved:(value){
                                     _enteredemail = value!;
                            } ,

                          ),
                           TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Password',

                            ),
                            keyboardType: TextInputType.emailAddress,
                            obscureText: true,
                            validator: (value){
                              if(value == null ||
                               value.trim().length<6
                               ){
                               return 'Password must be atleast 6 character long';
                              }
                              return null;
                            },
                            onSaved:(value){
                                     _enteredpassword = value!;
                            } ,
                          ),
                          const SizedBox(height:12),
                          ElevatedButton(
                            onPressed: _submit,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context)
                              .colorScheme
                              .primaryContainer,
                            ),
                             child: Text(_isLogin ? 'Login' : 'Signup'),

                             ),
                             TextButton(
                              onPressed: () {
                              setState(() {
                                _isLogin = !_isLogin;
                              });

                              },
                               child: Text(_isLogin
                                ? 'Create an account' 
                                : 'already have an account')
                               ),
                        ],
                      )
                      ),
                  )
                ),
              ),
            ],
          ),
        ),
      ),
    );

  }

  }