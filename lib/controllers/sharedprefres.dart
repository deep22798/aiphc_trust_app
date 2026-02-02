import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedprefresController extends GetxController {


  var onboard=false.obs;
  var uusername=''.obs;
  var upassword=''.obs;


@override
  void onReady() async{
    // TODO: implement onReady
    super.onReady();
    await getusernamepassword();
    await getonboarding();
  }


  Future<void> saveusernamepassword(String username,String password)async{
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('username', '${username}');
    prefs.setString('password', '$password');
    await getusernamepassword();
  }

    Future<void> getusernamepassword()async{
    final prefs = await SharedPreferences.getInstance();
    uusername.value=await prefs.getString('username')??"";
    upassword.value= await prefs.getString('password')??"";
  }

    Future<void> deleteshared()async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('username')??"";
    await prefs.remove('password')??"";
  }


  Future<void> setonboarding()async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("onboard",true);
    await getusernamepassword();
  }


  Future<void> getonboarding()async{
    final prefs = await SharedPreferences.getInstance();
    onboard.value=await prefs.getBool("onboard")??false;
  }






}