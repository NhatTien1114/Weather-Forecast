import 'package:flutter/material.dart';
import 'package:weather_forecast/data/models/City.dart';
import 'package:weather_forecast/data/models/Constants.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Constants myConstants = Constants();
    List<City> cities = City.citiesList
        .where((city) => city.isDefault == false)
        .toList();
    List<City> selectedCities = City.selectedCities();
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(selectedCities.length.toString() + " thành phố đã chọn"),
        backgroundColor: myConstants.primaryColor,
        centerTitle: true,
      ),
      body: ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: cities.length,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.only(left: 10, top: 20, right: 10),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            height: size.height * 0.08,
            width: size.width,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              color: myConstants.secondaryColor.withOpacity(.6),
              border: cities[index].isSelected == true
                  ? Border.all(
                      color: myConstants.primaryColor.withOpacity(.6),
                      width: 2,
                    )
                  : Border.all(color: Colors.white),
              boxShadow: [
                BoxShadow(
                  color: myConstants.primaryColor.withOpacity(.2),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      cities[index].isSelected = !cities[index].isSelected;
                    });
                  },
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: cities[index].isSelected == true ? myConstants.primaryColor : Colors.transparent,
                      border: Border.all(color: myConstants.primaryColor, width: 2),
                    ),
                    child: cities[index].isSelected == true
                        ? Image.asset("assets/checked.png")
                        : Image.asset("assets/unchecked.png"),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  cities[index].city,
                  style: TextStyle(
                    fontSize: 20,
                    color: cities[index].isSelected == true
                        ? Colors.white
                        : Colors.black54,
                  ),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: myConstants.secondaryColor,
        child: const Icon(Icons.pin_drop, color: Colors.white, size: 30,),
        onPressed: (){
          print("${selectedCities.length} thành phố đã chọn");
        },
      ),
    );
  }
}
