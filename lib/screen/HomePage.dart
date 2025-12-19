
import 'package:flutter/material.dart';
import 'package:weather_forecast/data/models/City.dart';
import 'package:weather_forecast/data/models/Constants.dart';
import 'package:weather_forecast/screen/MainPage.dart';


class MyHome extends StatelessWidget {
  const MyHome({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Constants myConstants = Constants();

    return Scaffold(
      body: Container(
        height: size.height,
        width: size.width,
        color: myConstants.primaryColor.withOpacity(.5),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset("assets/get-started.png"),
              const SizedBox(height: 30,),
              GestureDetector(
                onTap: (){
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MainPage(),));
                },
                child: Container(
                  height: 50,
                  width: size.width * 0.7,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    color: myConstants.secondaryColor,
                  ),
                  child: const Center(
                    child: Text("Bắt Đầu", style: TextStyle(color: Colors.white, fontSize: 24),),
                  ),
                ),
              )
            ],
          ),
        )
      )

    );
  }
}
