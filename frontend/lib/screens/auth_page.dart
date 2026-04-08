import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/main.dart';
import 'package:frontend/providers/auth_provider.dart';
import 'package:frontend/widgets/log_in.dart';
import 'package:frontend/widgets/sign_up.dart';
class AuthPage extends ConsumerStatefulWidget {
  const AuthPage({super.key});

  @override
  ConsumerState<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends ConsumerState<AuthPage> {

  @override
  Widget build(BuildContext context) {
    final isSelected = ref.watch(selectionProvider);
    
    return Scaffold(
      appBar: AppBar(
      backgroundColor: secondary,
      elevation: 0, 
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Text(
          "KanBan App",
          style: TextStyle(
            color: primary, 
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
      ),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: primary
        ),
        child: LayoutBuilder(
          builder: (context,contrain){
            bool isMobile=contrain.maxWidth<821;
            return SingleChildScrollView(
              child:ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: contrain.maxHeight
                ),
                child:  IntrinsicHeight(
                  child:Flex(
                    direction: isMobile?Axis.vertical:Axis.horizontal,
                    children: [
                      Flexible(
                        flex: isMobile?1:1,
                        fit: isMobile ? FlexFit.tight : FlexFit.tight,
                        child: Column(

                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(height: isMobile?100:30,),
                            SizedBox(
                              child: Text("Master the art of flow.", style: TextStyle(color: secondary,fontSize:isMobile?18: 22 ),),
                            ),
                            Padding(
                              padding: EdgeInsetsGeometry.symmetric(horizontal: 24),
                              child: Text("Stop Starting. Start Finishing...", style: TextStyle(color: secondary,fontSize:isMobile?64: 72 ),),
                              ),
                            SizedBox(height: isMobile?45:30,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                  style:ElevatedButton.styleFrom(
                                    backgroundColor: isSelected=="LogIn"?secondary:primary,
                                    side: BorderSide(
                                      color: secondary,
                                      width: 1.2
                                    ),
                                    elevation: 3
                                  ),
                                  onPressed: ()=>{
                                
                                      ref.read(selectionProvider.notifier).setSelection("LogIn")
                                  
                                  }, 
                                  child: Padding(
                                    padding: EdgeInsetsGeometry.all(10),
                                    child: Text("LogIn",style:  TextStyle(color: isSelected=="LogIn"?primary:secondary  ,fontSize: isMobile?12:20,letterSpacing: 1.1),)
                                    )
                                  ),
                                SizedBox(width: 10,),
                                ElevatedButton(
                                  style:ElevatedButton.styleFrom(
                                    backgroundColor: isSelected=="SignUp"?secondary:primary,
                                    side: BorderSide(
                                      color: secondary,
                                      width: 1.2
                                    ),
                                    elevation: 3
                                  ),
                                  onPressed: ()=>{
                                    ref.read(selectionProvider.notifier).setSelection("SignUp")
                                  }, 
                                  child: Padding(
                                    padding: EdgeInsetsGeometry.all(10),
                                    child: Text("SignUp",style:  TextStyle(color: isSelected=="SignUp"?primary:secondary ,fontSize: isMobile?12:20,letterSpacing: 1.1),)
                                    )
                                  ),
                              ],
                            ),
                            SizedBox(height: isMobile?100:0,),
                          ],
                        )
                        ),
                      Flexible(
                          flex: isMobile?1:1,
                          fit: isMobile?FlexFit.loose:FlexFit.tight,
                          child: Center(
                            child:Padding(
                              padding: EdgeInsetsGeometry.all(25),
                              child: SizedBox(
                                width: 500,
                                child: isSelected=="LogIn"?LogIn():SignUp(),
                              ),
                              ),
                          ),
                          )
                    ],
                  ),
                )
              )
            );
          }
        ),
      ),
    );
  }
}



