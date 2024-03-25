import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:starwarsproj_flutter/controller/login_controller.dart';

class LoginPage extends StatelessWidget{
  const LoginPage({super.key});
  
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());

    return Scaffold(
      body: Center(
        child: 
        Obx(() => 
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "Login",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              FractionallySizedBox(
                widthFactor: 0.5,
                child: Card(
                  shadowColor: Colors.black,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                        children: [
                          TextField(
                            onChanged: (e) => controller.setUsername(e),
                            decoration: InputDecoration(
                              labelText: "Username",
                              icon: const Icon(Icons.people),
                              errorText: controller.validateUsername ? "Username cannot be empty" : null,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: TextField(
                              obscureText: !controller.passwordVisible,
                              onChanged: (e) => controller.setPassword(e),
                              decoration: InputDecoration(
                                labelText: "Password",
                                icon: const Icon(Icons.lock),
                                errorText: controller.validatePassword ? "Password cannot be empty" : null,
                                suffixIcon: Padding(
                                  padding: const EdgeInsets.only(top: 15.0),
                                  child: IconButton(
                                    onPressed: () => controller.togglePasswordVisible(), 
                                    icon: Icon(controller.passwordVisible ? Icons.visibility : Icons.visibility_off)
                                  ),
                                ),
                              ),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: controller.isLoginDisabled ? null : () {
                              controller.login();
                            },
                            child: controller.isLoading ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator()
                            ) : const Text("Login"),
                            
                          ),
                        ],
                      )
                  ),
                ),
              ),
              if(controller.isError)
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: Text(
                    controller.error,
                    style: const TextStyle(color: Colors.red),
                  )
                )
            ],
          ),
        )
      )
    );
  }
}