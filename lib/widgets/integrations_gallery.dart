import 'package:flutter/material.dart';

class IntegrationsGallery extends StatelessWidget {
  IntegrationsGallery({Key? key}) : super(key: key);

  final List<String> intergationNames = [
    "Apple Health",
    "Health Connect",
    "Calendar",
    "Strava",
    "Google Fit",
    "Glow",
    "Integration N"
  ];

  @override
  Widget build(BuildContext context) {
    return GridView(
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 200,
        childAspectRatio: 1,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      padding: EdgeInsets.all(15),
      children: intergationNames.map((name) {
        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage("assets/images/integration_bg.jpeg"),
                ),
              ),
              child: GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        "Will be implemented later. Stay tuned!",
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                },
                child: Container(
                  padding: EdgeInsets.all(5),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondaryContainer
                        .withAlpha(150),
                      ),
                  child: Text(
                    name,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
