import 'package:flutter/material.dart'; 

class HomeScreenButton extends StatelessWidget {
  final String text; 
  final double minWidth; 
  final void Function(BuildContext) onPressed; 
  const HomeScreenButton(
    { 
      required this.text, 
      required this.minWidth, 
      required this.onPressed, 
      Key? key 
    }
  ) : super(key: key);

  @override
  Widget build(BuildContext context) => 
    TextButton (
      onPressed: () => onPressed(context), 
      child: ConstrainedBox(
        constraints: BoxConstraints(minWidth: minWidth),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(10.0)), 
            color: Theme.of(context).dialogBackgroundColor, 
          ), 
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(text, textAlign: TextAlign.center, textScaleFactor: 2.5),
          ) 
        ),
      )
    ); 
}
